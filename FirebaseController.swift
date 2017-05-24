//
//  FirebaseController.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 3/5/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase

typealias JSONObject = [String: Any]

enum Result<T> {
    case success(T)
    case failure(Error)
}

typealias JSONIdentifiable = Identifiable & JSONExportable & JSONInitializable

protocol Identifiable: JSONExportable, JSONInitializable {
    var id: String { get set }
    var ref: DatabaseReference { get }
}


protocol JSONExportable {
    func json() -> JSONObject
}

protocol JSONInitializable {
    init(json: JSONObject) throws
}

enum JSONError: Error {
    case keyMismatch(String)
    case typeMismatch
}

struct FirebaseController {
    
    let rootRef = Database.database().reference()
    
    func save(at ref: DatabaseReference, json: JSONObject, completion: ((Error?) -> Void)?) {
        ref.updateChildValues(json) { error, ref in
            completion?(error)
        }
    }
    
    func delete(at ref: DatabaseReference, completion: ((Error?) -> Void)?) {
        ref.removeValue { error, ref in
            completion?(error)
        }
    }
    
    func getData(at ref: DatabaseReference, completion: ((Result<JSONObject>) -> Void)?) {
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let snap = snapshot.value as? JSONObject, snapshot.exists() {
                completion?(Result.success(snap))
            } else {
                completion?(Result.failure(JSONError.typeMismatch))
            }
        })
    }
    
    func getData(with query: DatabaseQuery, completion: ((Result<JSONObject>) -> Void)?) {
        query.observeSingleEvent(of: .value, with: { snapshot in
            if let snap = snapshot.value as? JSONObject, snapshot.exists() {
                completion?(Result.success(snap))
            } else {
                completion?(Result.failure(JSONError.typeMismatch))
            }
        })
    }
    
    func subscribe(toRef ref: DatabaseReference, completion: ((Result<JSONObject>) -> Void)?) {
        ref.observe(.value, with: { snapshot in
            if let snap = snapshot.value as? JSONObject {
                completion?(Result.success(snap))
            } else {
                completion?(Result.failure(JSONError.typeMismatch))
            }
        })
    }
    
    /*
     
     REFS
     child(String) - new reference one level deeper with that child name
     childByAutoId -> New reference with auto generated key
     
     CREATE/UPDATE
     setValue -> Saves and OVERRIDES data at the reference including all child values.
     updateChildValues -> UPDATES the data at the ref without overriding existing data or child values
     
     DELETE
     removeValue -> Deletes everything
     
     SUBSCRIPTION
     observeValue(completion (FIRDataSnapshot))
     
     
     */
}
