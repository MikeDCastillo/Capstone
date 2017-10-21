import Firebase
import FirebaseDatabase
import SlackTextViewController
import UIKit
import Whisper

   // X     // TODO: - 1. Msg Contoller. check if self.messages if it doesnt have messages. add it in
  // X      // TODO: - 2. call the load init messages    /
        // TODO: - 3. slack TableViewController. create custom cells - 2 different Xibs with different reuse identifiers.
        // TODO: - 4. double check Msg subscription is working. view didLoad
        // TODO: - MessagesTableViewController - refresh data. fire off notification

class MessageConvoViewController: SLKTextViewController {
    
    fileprivate let firebaseController = FirebaseController()
    fileprivate let currentUserId = UserController.shared.currentUser?.identifier
    
    fileprivate var messages: [Message] {
        return MessageController.shared.messages
    }
    fileprivate var currentUser: User? {
        return UserController.shared.currentUser
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = currentUser?.name
        //TODO: - add in car sound everytime msg received
        //FIXME: - check if currentUser.id == message.toId is the same for notifications
     
        guard let user = currentUser else { return }
        if user.isBroker {
            navigationItem.title = UserController.shared.
        } else {
            navigationItem.title = "Broker"
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(newMessageReceived), name: .messagesUpdated, object: nil)
    }
    
    @IBAction func sendButtonAnimationTapped(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "Send Message Tapped Image") {
            sender.setImage(#imageLiteral(resourceName: "Send Message Label"), for: .normal)
        } else {
            sender.setImage(#imageLiteral(resourceName: "Send Message Tapped Image"), for: .normal)
        }
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        handleSend()
        tableView.reloadData()
        
//        guard let toID = user?.name else { return }
//        MessageController.shared.createMessage(text: messageTextView.text, toID: toID)
//        messageTextView.text = "button was clicked"
    }
    // Mark: - TableView Data Source Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "receivedMessageCell", for: indexPath) as? MessageTableViewCell else { return UITableViewCell() }
        cell.message = messages[indexPath.row]
        return cell
    }
    
    func observeMessages() {
        let ref = Database.database().reference().child("messages")
//        ref.observe(.childAdded, with: { (snapshot) in
//            
//            if let dictionary = snapshot.value as? [String: AnyObject] {
//                //Alex code for messages
//                guard let message = Message(jsonDictionary: dictionary) else { return }
//                
//                guard let customer = self.customer else { return }
//                if message.id == customer.name {
//                    self.messages.append(message)
//                }
//                
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
//        }, withCancel: nil)
    }
    
    func newMessageReceived() {
        tableView.reloadData()
    }
    
    func handleSend() {
        // FIXME: !!!! PLEASE THIS IS AWFUL
        if messageTextView.text != "" {
            let ref = Database.database().reference().child("messages")
            
            let childRef = ref.childByAutoId()
            guard let input = messageTextView.text, let name = customer?.name else { return }
            let values: [String: Any] = ["text":input, "name": name]
            childRef.updateChildValues(values)
            messageTextView.text = ""
            tableView.reloadData()
            // or call observe func again
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        messageTextView.resignFirstResponder()
    }

    // keyboard under text View
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x:0, y:190), animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
    }
    
}


