//
//  NetworkController.swift
//  PracticeJournal
//
//  Created by Michael Castillo on 2/28/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//


import UIKit

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum NetworkError: Error {
    case unknown
}

typealias JSONObject = [AnyHashable: Any]
typealias JSONResultCompletion = (Result<JSONObject>) -> Void

struct Network {
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    func performRequest(for url: URL, httpMethod: HTTPMethod, urlParameters: [String: String]? = nil, body: Data? = nil, completion: JSONResultCompletion? = nil) {
        let requestURL = self.url(byAdding: urlParameters, to: url)
        var request = URLRequest(url: requestURL)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = body
        
        dump(request.url)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                dump(error.localizedDescription)
                completion?(Result.failure(error))
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? JSONObject, let jsonResponse = json {
                completion?(Result.success(jsonResponse))
            } else {
                completion?(Result.failure(NetworkError.unknown))
            }
        }
        dataTask.resume()
    }
    
    func url(byAdding parameters: [String: String]?, to url: URL) -> URL {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = parameters?.flatMap({URLQueryItem(name: $0.0, value: $0.1)})
        guard let url = components?.url else {
            fatalError("URL optional is nil")
        }
        
        return url
    }
    
}
