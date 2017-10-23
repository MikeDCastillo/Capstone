//
//  CurrentUserMessageCell.swift
//  5StarAutoDirect
//
//  Created by Michael Castillo on 10/20/17.
//  Copyright © 2017 PineAPPle LLC. All rights reserved.
//

import UIKit

class CurrentUserMessageCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    func update(with message: Message) {
        if let messageOwner = message.owner {
            userNameLabel.text = messageOwner.name
        }
        messageLabel.text = message.text
    }
    
}
