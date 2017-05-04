//
//  Network.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 4/4/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit

struct NetworkController {
    
    enum NetworkError: Error {
        case jsonSerializationError
    }
    
    func buildURL(with parameters: [String: String]?, from url: URL) -> URL {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = parameters?.flatMap({ URLQueryItem(name: $0.0, value: $0.1) })
        
        guard let url = urlComponents?.url else {
            fatalError("URL? is nil")
        }
        return url
    }
    
    func performRequest(for url: URL, urlParameters: [String: String]?, completion: ((JSONObject?, Error?) -> Void)?) {
        
        let requestURL = self.buildURL(with: urlParameters, from: url)
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = "get"
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion?(nil, error)
                return
            }
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSONObject  else {
                    completion?(nil, NetworkError.jsonSerializationError)
                    return
                }
                completion?(json, nil)
            } catch {
                completion?(nil, error)
            }
        }
        dataTask.resume()
    }

}
