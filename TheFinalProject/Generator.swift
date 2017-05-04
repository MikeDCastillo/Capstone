//
//  Generator.swift
//  
//
//  Created by Michael Castillo on 5/3/17.
//
//

import Foundation

struct Generator: JSONInitializable, JSONExportable {

    var id: Int
    var imageURLString: String
    
    var imageURL: URL? {
        return URL(string: imageURLString)
    }
    
    init(json: JSONObject) throws {
        self.id = 1
        self.imageURLString = ""
    }
    
    func json() -> JSONObject {
        return JSONObject()
    }
    
}
