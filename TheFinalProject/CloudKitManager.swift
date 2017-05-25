//
//  CloudKitManager.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 5/23/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitManager {

    static func getUseriCloudId(completion: @escaping (String?) -> Void) {
        CKContainer.default().fetchUserRecordID { (recordId, error) in
            completion(recordId?.recordName)
        }
    }
    
}
