import SlackTextViewController
import UIKit
import Whisper
        // TODO: - 3. slack TableViewController. create custom cells - 2 different Xibs with different reuse identifiers.
        // TODO: - 4. double check Msg subscription is working. view didLoad
        // TODO: - MessagesTableViewController - refresh data. fire off notification

class MessagesViewController: SLKTextViewController {
    
    fileprivate let firebaseController = FirebaseController()
    fileprivate let currentUserId = UserController.shared.currentUser?.identifier
    fileprivate let currentUserCellId = "currentUserMessageCell"
    fileprivate let otherUserCellId = "otherUserMessageCell"
    
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
        rightButton.setTitle(NSLocalizedString("Send", comment: ""), for: .normal)
        
        
        rightButton.isEnabled = true
        tableView.register(MessageCell.classForCoder(), forCellReuseIdentifier: currentUserCellId)
        tableView.register(MessageCell.classForCoder(), forCellReuseIdentifier: otherUserCellId)

        
        //TODO: - add in car sound everytime msg received
        //FIXME: - check if currentUser.id == message.toId is the same for notifications
     
        guard let user = currentUser else { return }
        if user.isBroker {
            if let customer = UserController.shared.selectedUser {
                navigationItem.title = customer.name
            }
        } else {
            navigationItem.title = "Chat with Broker"
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(newMessageReceived), name: .messagesUpdated, object: nil)
    }
    
    override func didPressRightButton(_ sender: Any?) {
        sendMessage()
        super.didPressRightButton(sender)
    }
    
    func newMessageReceived() {
        tableView.reloadData()
    }
    
}


// MARK: - Fileprivate

extension MessagesViewController {
    
    fileprivate func sendMessage() {
        guard let currentUser = currentUser, let selectedUser = UserController.shared.selectedUser else { return }
        var brokerId: String
        var userId: String
        if currentUser.isBroker {
            brokerId = currentUser.identifier
            userId = selectedUser.identifier
        } else {
            brokerId = selectedUser.identifier
            userId = currentUser.identifier
        }
        
        MessageController.shared.saveMessage(with: textView.text, brokerId: brokerId, userId: userId)
        textView.text = ""
    }

}


// MARK: - TableView Data Source Functions

extension MessagesViewController {
    
    func message(at indexPath: IndexPath) -> Message {
        let reverseMessages = messages
        return reverseMessages[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentUser = currentUser else { return UITableViewCell() }
        let messageAtRow = message(at: indexPath)
        let identifier = messageAtRow.ownerId == currentUser.identifier ? currentUserCellId : otherUserCellId
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MessageCell
        cell.transform = tableView.transform
        cell.update(with: messageAtRow)
        
        return cell
    }
    
}
