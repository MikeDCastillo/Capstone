import SlackTextViewController
import UIKit
import Whisper

class MessagesViewController: SLKTextViewController {
    
    fileprivate let firebaseController = FirebaseController()
    fileprivate let currentUserId = UserController.shared.currentUser?.identifier
    fileprivate let cellId = "messageCellId"
    
    fileprivate var messages: [Message] {
        return MessageController.shared.currentMessages
    }
    fileprivate var currentUser: User? {
        return UserController.shared.currentUser
    }
    
    override var tableView: UITableView {
        get {
            return super.tableView!
        }
    }
    
    
    // MARK: - Initialization
    
    override class func tableViewStyle(for decoder: NSCoder) -> UITableViewStyle {
        return .plain
    }
    
    func commonInit() {
        NotificationCenter.default.addObserver(self.tableView, selector: #selector(UITableView.reloadData), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = currentUser?.name
        commonInit()
        textView.placeholder = "Write your mesage"
        tableView.rowHeight = UITableViewAutomaticDimension
        rightButton.setTitle(NSLocalizedString("Send", comment: ""), for: .normal)
        
        rightButton.isEnabled = true
//        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellId)
        
        //TODO: - add in car sound everytime msg received
        //FIXME: - check if currentUser.id == message.toId is the same for notifications
     
        guard let user = currentUser else { return }
        if user.isBroker {
            if let customer = UserController.shared.selectedUser {
                navigationItem.title = customer.name
            }
        } else {
            navigationItem.title = "Chat"
        }
        
        NotificationCenter.default.addObserver(self.tableView, selector: #selector(UITableView.reloadData), name: .messagesUpdated, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func didPressRightButton(_ sender: Any?) {
        sendMessage()
        super.didPressRightButton(sender)
    }
    
}


// MARK: - Fileprivate

extension MessagesViewController {
    
    fileprivate func sendMessage() {
        guard let currentUser = currentUser, let selectedUser = UserController.shared.selectedUser else { return }
        let customerId = currentUser.isBroker ? selectedUser.identifier : currentUser.identifier
        MessageController.shared.saveMessage(with: textView.text, customerId: customerId)
    }

}


// MARK: - TableView Data Source Functions

extension MessagesViewController {
    
    func message(at indexPath: IndexPath) -> Message {
        return messages[indexPath.row]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentUser = currentUser else { return UITableViewCell() }
        let messageAtRow = message(at: indexPath)
        let isCreator = messageAtRow.ownerId == currentUser.identifier
        var messageCell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if messageCell == nil {
            messageCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
        }
        guard let cell = messageCell else { fatalError() }
        cell.textLabel?.text = isCreator ? "You" : messageAtRow.owner?.name
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        
        cell.detailTextLabel?.text = messageAtRow.text
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 20)
        cell.detailTextLabel?.numberOfLines = 0
        cell.transform = tableView.transform
        
        return cell
    }
    
}
