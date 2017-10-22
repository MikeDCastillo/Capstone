//
//  BrokerTableViewController.swift
//  5StarAutoDirect
//
//  Created by Alex Whitlock on 6/15/17.
//  Copyright © 2017 PineAPPle LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class BrokerTableViewController: UITableViewController {
    
    var user: User? {
        return UserController.shared.currentUser
    }
    var users: [User] {
        return UserController.shared.users
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(newMessageReceived), name: .messagesUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: .usersLoaded, object: nil)
    }
    
}


// MARK: - Table view data source

extension BrokerTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserInfoTableViewCell else { return UITableViewCell() }
        let user = users[indexPath.row]
        cell.user = user
        
        return cell
    }
    
}

extension BrokerTableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .userCellToMessageVC:
            guard let indexPath = tableView.indexPathForSelectedRow, let detailVC = segue.destination as? MessagesViewController else { return }
            let selectedUser = self.users[indexPath.row]
            UserController.shared.selectedUser = selectedUser
        }
    }
    
}


//MARK: - File Private

extension BrokerTableViewController {
    
    func reload() {
        tableView.reloadData()
    }
    
    func newMessageReceived() {
        showNotificationBanner()
    }
    
}

extension BrokerTableViewController: SegueHandling {
    
    enum SegueIdentifier: String {
        case userCellToMessageVC
    }
    
}
