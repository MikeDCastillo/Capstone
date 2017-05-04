//
//  FacebookAPIController.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 5/2/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

//import Foundation
//import FBSDKLoginKit
//
//struct FacebookAPIController {
//
//    struct MyProfileRequest: GraphRequestProtocol {
//        struct Response: GraphResponseProtocol {
//            init(rawResponse: Any?) {
//                // Decode JSON from rawResponse into other properties here.
//            }
//        }
//        
//        let parameters: [String: Any]? = ["fields": "name id", ]
//        let graphPath = "/me"
//        var accessToken = AccessToken.current
//        var httpMethod: GraphRequestHTTPMethod = .GET
//        var apiVersion: GraphAPIVersion = .defaultVersion
//    }
//    
//    
//    let connection = GraphRequestConnection()
//    
//    func getUserinfoFromFacebook(){
//    connection.add(MyProfileRequest()) { response, result in
//    switch result {
//    case .success(let response):
//    print("Custom Graph Request Succeeded: \(response)")
//    print("My facebook id is \(response.dictionaryValue?["id"])")
//    print("My name is \(response.dictionaryValue?["name"])")
//    case .failed(let error):
//    print("Custom Graph Request Failed: \(error)")
//    }
//    }
//    connection.start()
//    }
//}
