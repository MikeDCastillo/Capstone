//
//  MemeAPIAccess.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 4/2/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit

struct MemeAPIAccess {
    static func getNewMemeURL(completion: (URL?) -> Void) {
        let url = URL(string: "https://s-media-cache-ak0.pinimg.com/236x/bb/ac/93/bbac93ffdca79525829ddd0b9bc06b55.jpg")
        completion(url)
        //FIXME: - no banging
    }
    
}
