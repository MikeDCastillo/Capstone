//
//  SettingsController.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 5/29/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import Foundation

struct SettingsController: Controller {
    
    func getAppStoreURL(completion: @escaping ((URL?) -> Void)) {
        firebaseController.getData(at: firebaseController.settingsRef) { result in
            switch result {
            case let .success(json):
                if let urlString = json[Keys.appStoreURLString] as? String, let url = URL(string: urlString) {
                    completion(url)
                } else {
                    completion(nil)
                }
            case let .failure(error):
                print(error)
                completion(nil)
            }
        }
    }
    
}
