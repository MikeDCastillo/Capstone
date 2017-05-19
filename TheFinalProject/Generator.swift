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
        guard let id = json["generatorID"] as? Int else { throw JSONError.keyMismatch("generatorID") }
        guard let imageURLString = json["imageUrl"] as? String else { throw JSONError.keyMismatch("imageUrl") }
        self.id = id
        self.imageURLString = imageURLString
    }
    
    func json() -> JSONObject {
        var json = JSONObject()
        json["id"] = id
        json["imageUrl"] = imageURLString
        return json
    }
    
}
