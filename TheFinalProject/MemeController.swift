//
//  MemeController.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 3/27/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit

struct MemeController: Controller {
    
    static let shared = MemeController()
    
    var memes = [Meme]()
    
    func getMeme(forDate date: Date = Date(), completion: (Meme?) -> Void)   {
    
    }
    
    func loadMeme() {}
    
    func deleteMeme() {}
    
}
