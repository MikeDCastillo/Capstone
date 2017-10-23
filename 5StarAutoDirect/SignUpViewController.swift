//
//  SignUpViewController.swift
//  5StarAutoDirect
//
//  Created by Clay Mills on 6/14/17.
//  Copyright © 2017 PineAPPle LLC. All rights reserved.
//


///// fix login, right now it always goes to user home screen, even if logged in as broker the next time you login to your phone it goes to user home screen instead of user list


import UIKit
import FirebaseAuth
import FirebaseDatabase
import AVFoundation

// We may want to put the code to tell what the initial VC is in the AppDelegate, appDidFinishLaunching instead of here

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIImageView!
    @IBOutlet weak var signOutButton: UIButton!
    
    fileprivate var audioPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepSound()
        UserController.shared.subscribeToUsers()

        if let authUser = Auth.auth().currentUser {
            if authUser.email?.uppercased().contains("FIVESTARAUTODIRECT") == true {
                performSegue(withIdentifier: .pushBrokerTVC, sender: self)
            } else {
                performSegue(withIdentifier: .pushUserHomeVC, sender: self)
            }
        } // else -> Stay on sign up
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text, let phone = phoneTextField.text, let email = emailTextField.text, let password = passwordTextField.text, !name.isEmpty, !phone.isEmpty, !email.isEmpty, !password.isEmpty, password.characters.count > 6 else { presentMissingInfoAlert(); return }
        
        UserController.shared.saveUserToFirebase(name: name, phone: phone, email: email, password: password) { isBroker, error in
            // add sound to submit button
            
           guard let isBroker = isBroker, error == nil else {
                dump(error)
                // FIXME: ERROR HANDLING
                return
            }
            
            self.audioPlayer.play()
            DispatchQueue.main.async {
                if isBroker {
                    self.performSegue(withIdentifier: .pushBrokerTVC, sender: self)
                } else {
                    self.performSegue(withIdentifier: .pushUserHomeVC, sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .pushBrokerTVC:
            break
        case .pushUserHomeVC:
            let createdUser = UserController.shared.currentUser
            if let detailVC = segue.destination as? UserHomeViewController {
                detailVC.user = createdUser
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
    }
    
    func prepSound() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Ferrari", ofType: "m4a")!))
            audioPlayer.prepareToPlay()
        }
        catch {
            print(error)
        }
    }
    
    func presentMissingInfoAlert() {
        let pleaseEnterValidEmailAlertController = UIAlertController(title: "*All fields are required!", message: nil, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        pleaseEnterValidEmailAlertController.addAction(dismissAction)
        present(pleaseEnterValidEmailAlertController, animated: true, completion: nil)
    }
    // When finished uncomment out func displayPopUP (it is good code)
//    func displayPopUp() {
//        guard let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpController") as? PopUpViewController else { return }
//        self.addChildViewController(popUpVC)
//        popUpVC.view.frame = self.view.frame
//        self.view.addSubview(popUpVC.view)
//        popUpVC.didMove(toParentViewController: self)
//    }
    
    
    //    func badEmail() {
    //        let pleaseEnterValidEmailAlertController = UIAlertController(title: "Please enter a valid email", message: nil, preferredStyle: .alert)
    //        let dismissAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    //        pleaseEnterValidEmailAlertController.addAction(dismissAction)
    //        present(pleaseEnterValidEmailAlertController, animated: true, completion: nil)
    //    }
    //
    //    func badPhoneNumberAC() {
    //        let badPhoneNumberAlertController = UIAlertController(title: "Please check that your phone number includes an area code and is a valid phone number", message: nil, preferredStyle: .alert)
    //        let dismissAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    //        badPhoneNumberAlertController.addAction(dismissAction)
    //        present(badPhoneNumberAlertController, animated: true, completion: nil)
    //    }
    //
    //    func badPasswordAC() {
    //        let badPasswordAlertController = UIAlertController(title: "Please enter a password", message: nil, preferredStyle: .alert)
    //        let dismissAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    //        badPasswordAlertController.addAction(dismissAction)
    //        present(badPasswordAlertController, animated: true, completion: nil)
    //    }
    //
    //    func badNameAC() {
    //        let badNameAlertController = UIAlertController(title: "Please enter first and last name", message: nil, preferredStyle: .alert)
    //        let dismissAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    //        badNameAlertController.addAction(dismissAction)
    //        present(badNameAlertController, animated: true, completion: nil)
    //    }
    
    
    // keyboard under text fields
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        scrollView.setContentOffset(CGPoint(x:0, y:190), animated: true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
    }
    
}


extension SignUpViewController: SegueHandling {
    
    enum SegueIdentifier: String {
        case pushUserHomeVC
        case pushBrokerTVC
    }
    
}
