//
//  NetworkController+Meme.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 5/3/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import Foundation

extension NetworkController {

    //    Mobile Meme App	1FBFEC85-2884-4512-8E3E-353CA574A90A
    // http://version1.api.memegenerator.net/Generators_Select_ByPopular

    var baseURL: URL? {
        return URL(string: "http://version1.api.memegenerator.net/")
    }
    
    var generatorsURL: URL? {
        guard let baseURL = baseURL else { return nil }
        return URL(string: "\(baseURL)Generators_Select_ByPopular")
    }
}
