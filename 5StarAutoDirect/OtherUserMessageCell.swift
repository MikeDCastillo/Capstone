//
//  OtherUserMessageCell.swift
//  5StarAutoDirect
//
//  Created by Michael Castillo on 10/22/17.
//  Copyright © 2017 PineAPPle LLC. All rights reserved.
//

import UIKit

class OtherUserMessageCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    func update(with message: Message) {
        if let messageOwner = message.owner {
            userNameLabel.text = messageOwner.name
        }
        messageLabel.text = message.text
    }
    
}

