
import Firebase
import FirebaseDatabase
import UIKit
import Whisper

class MessageController {
    
    static var shared = MessageController()
    let firebaseController = FirebaseController()
    
    var messages = [Message]() {
        didSet {
            NotificationCenter.default.post(name: .messagesUpdated, object: nil)
        }
    }
    
    let rootRef = Database.database().reference()
    var messagesRef: DatabaseReference {
        return rootRef.child("messages")
    }
    
    //1
    func checkForDuplicates(in messages: [Message]) {
        if self.messages.count == messages.count {
            print("No new messages")
            return
        }
    }
    
    var userMessagesQuery: DatabaseQuery? {
        guard let currentUser = UserController.shared.currentUser else { return nil }
        if currentUser.isBroker {
            return messagesRef.queryOrdered(byChild: Keys.brokerId).queryEqual(toValue: currentUser.identifier)
        } else {
            return messagesRef.queryOrdered(byChild: Keys.userId).queryEqual(toValue: currentUser.identifier)
        }
    }
    
    func loadInitialMessages() {
        guard let query = userMessagesQuery else { return }
        firebaseController.getData(with: query) { result in
            switch result {
            case .failure:
                break
            case .success(let json):
                let messages: [Message] = json.flatMap({ (key, value) -> Message? in
                    guard let value = value as? JSONObject else { return nil }
                    return Message(jsonDictionary: value)
                })
                self.messages = messages
            }
            self.subscribeToMessages()
        }
    }
    
    func subscribeToMessages() {
        guard let query = userMessagesQuery else { return }
        query.observe(DataEventType.childAdded, with: { snapshot in
            guard let snapshotJSON = snapshot.value as? JSONObject,
                let newMessage = Message(jsonDictionary: snapshotJSON) else { return }
            self.messages.append(newMessage)
        })
    }
    
    func saveMessage(with text: String, brokerId: String, userId: String) {
        guard let currentUser = UserController.shared.currentUser else { return }
        
        let newMessage = Message(text: text, brokerId: brokerId, userId: userId, ownerId: currentUser.identifier)
        let newMessageRef = messagesRef.childByAutoId()
        newMessageRef.updateChildValues(newMessage.jsonObject())
    }
    
}
