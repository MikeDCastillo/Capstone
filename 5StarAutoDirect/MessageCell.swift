//
//  OtherUserMessageCell.swift
//  5StarAutoDirect
//
//  Created by Michael Castillo on 10/20/17.
//  Copyright © 2017 PineAPPle LLC. All rights reserved.
//

import Foundation

// 3
class MessageCell: UICollectionViewCell {
    
    // MARK: - Outlets / Properties
    
    @IBOutlet weak var otherUserMessageLabel: UILabel!
    @IBOutlet weak var currentUserMessageLabel: UILabel!
    
    // MARK: - Life - Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerXibFiles()
    }
    
}


// MARK: - Fileprivate

extension MessageCell {
    
    fileprivate func registerXibFiles() {
        tableView.register(UINib(nibName: "OtherUserMessageCell", bundle: nil), forCellReuseIdentifier: "otherUserMessageCell")
        tableView.register(UINib(nibName: "CurrentUserMessageCell", bundle: nil), forCellReuseIdentifier: "currentUserMessageCell")
    }
    
}
