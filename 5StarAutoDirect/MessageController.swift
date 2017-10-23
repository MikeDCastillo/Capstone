
import Firebase
import FirebaseDatabase
import UIKit
import Whisper

class MessageController {
    
    // MARK: - Static
    
    static var shared = MessageController()
    
    
    // MARK: - Internal
    
    let rootRef = Database.database().reference()
    var messages = [Message]() {
        didSet {
            guard shouldFireNotification else { return }
            NotificationCenter.default.post(name: .messagesUpdated, object: nil)
        }
    }
    var currentMessages: [Message] {
        guard let currentUser = UserController.shared.currentUser else { return [] }
        if currentUser.isBroker {
            guard let selectedUser = UserController.shared.selectedUser else { return [] }
            return messages.filter { $0.customerId == selectedUser.identifier }.sorted(by: { $0.createdAt < $1.createdAt })
        } else {
            return messages.sorted(by: { $0.createdAt < $1.createdAt })
        }
    }

    
    // MARK: - Private
    
    fileprivate let firebaseController = FirebaseController()
    fileprivate var hasLoadedMessages = false
    fileprivate var shouldFireNotification = false
    fileprivate var messagesRef: DatabaseReference {
        return rootRef.child("messages")
    }
    
    fileprivate var userMessagesQuery: DatabaseQuery? {
        guard let currentUser = UserController.shared.currentUser else { return nil }
        if currentUser.isBroker {
            return messagesRef.queryOrderedByValue()
        } else {
            return messagesRef.queryOrdered(byChild: Keys.customerId).queryEqual(toValue: currentUser.identifier)
        }
    }
    
    func loadInitialMessages() {
        guard !hasLoadedMessages else { return }
        hasLoadedMessages = true
        guard let query = userMessagesQuery else { return }
        firebaseController.getData(with: query) { result in
            switch result {
            case .success(let json):
                let messages: [Message] = json.flatMap({ (key, value) -> Message? in
                    guard let value = value as? JSONObject else { return nil }
                    return Message(jsonDictionary: value)
                })
                self.messages = messages
            case .failure:
                break
            }
            self.subscribeToMessages()
        }
    }
    
    func subscribeToMessages() {
        guard let query = userMessagesQuery else { return }
        shouldFireNotification = true
        query.observe(DataEventType.childAdded, with: { snapshot in
            guard let snapshotJSON = snapshot.value as? JSONObject,
                let newMessage = Message(jsonDictionary: snapshotJSON) else { return }
            guard !self.messages.contains(newMessage) else { return }
            self.messages.append(newMessage)
        })
    }
    
    func saveMessage(with text: String, customerId: String) {
        guard let currentUser = UserController.shared.currentUser else { return }
        
        let newMessageRef = messagesRef.childByAutoId()
        let newMessage = Message(id: newMessageRef.key, text: text, customerId: customerId, ownerId: currentUser.identifier)
        newMessageRef.updateChildValues(newMessage.jsonObject())
    }
    
}
