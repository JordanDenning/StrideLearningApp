//
//  NewMessageController.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 1/20/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate  {
    
    let cellId = "cellId"
    
    var users = [User]()
    var filtered = [User]()
    var searchActive : Bool = false
    
    var messagesController: MessagesController?
    var searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        navigationItem.title = "Contacts"
        
        fetchUser()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        configureSearchController()
    }
    
    func fetchUser() {
        Database.database().reference().child("users").queryOrdered(byChild: "name").observe(.childAdded, with: { (snapshot) in
            //queryOrdered sorts alphabetically/lexilogically
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                user.id = snapshot.key
                
                //if you use this setter, your app will crash if your class properties don't exactly match up with the firebase dictionary keys
                self.users.append(user)
                
                //this will crash because of background thread, so lets use dispatch_async to fix
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                
                //                user.name = dictionary["name"]
            }
            
        }, withCancel: nil)
    }
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
    }

    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive){
            return filtered.count
        }

        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let user: User
        if(searchActive){
            user = filtered[indexPath.row]
        }
        else{
            user = users[indexPath.row]
        }
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(searchActive){
            searchController.dismiss(animated: true, completion: nil)
            dismiss(animated: true) {
                print("Dismiss completed")
                let user: User
                user = self.filtered[indexPath.row]
                //get the user you tap on
                self.messagesController?.showChatControllerForUser(user)
            }
        }
        else{
            dismiss(animated: true) {
                print("Dismiss completed")
                let user: User
                if(self.searchActive){
                    user = self.filtered[indexPath.row]
                }
                else{
                    user = self.users[indexPath.row]
                }
                //get the user you tap on
                self.messagesController?.showChatControllerForUser(user)
            }
        }
    
    }
    
    //MARK: SearchResultsController
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        filtered.removeAll()
        tableView.reloadData()
        //reloads OG data instead of filtered
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchActive {
            searchActive = true
            tableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        
        filtered = users.filter({ (text) -> Bool in
            let name: NSString = text.name! as NSString
            let nameRange = name.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return nameRange.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
            // display text saying no results found
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }


}
