//
//  ViewController.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 1/20/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import UIKit
import Firebase
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


class MessagesController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    let cellId = "cellId"
    var searchController = UISearchController()
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    var filtered = [Message]()
    var searchActive : Bool = false
    var profileController: ProfileController?
    let image = UIImage(named: "message_v3")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        definesPresentationContext = true
        
        //navigation bar color
        let navBackgroundImage = UIImage(named:"navBarSmall")?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
        self.navigationController?.navigationBar.setBackgroundImage(navBackgroundImage,
                                                                    for: .default)

        //navigation title properties
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font: UIFont(name: "MarkerFelt-Thin", size: 20) ?? UIFont.systemFont(ofSize: 20)]

        //navigation button items
        self.navigationController?.navigationBar.tintColor = .white
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
        configureSearchController()
        
        observeUserMessages()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //removes empty table cells
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchController.dismiss(animated: false, completion: nil)
        
        
    }
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.barTintColor = UIColor.white
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func observeUserMessages() {
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let chatroomId = snapshot.key
            let ref = Database.database().reference().child("user-messages").child(uid).child(chatroomId)
                    ref.observe(.childAdded, with: { (snapshot) in
                        let messageId = snapshot.key
                        ref.child("seeMessages").observeSingleEvent(of: .value, with: {(snapshot) in
                            if let seeMessages = snapshot.value as? String {
                                if seeMessages == "yes" {
                                    self.fetchMessageWithMessageId(messageId, chatroomId: chatroomId)
                                }
                        }
                    }, withCancel: nil)
                }, withCancel: nil)
        }, withCancel: nil)
    }
    
    fileprivate func fetchMessageWithMessageId(_ messageId: String, chatroomId: String) {
        let messagesReference = Database.database().reference().child("messages").child(chatroomId).child(messageId)
        
        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)
                
                if let chatPartnerId = message.chatPartnerId() {
                    self.messagesDictionary[chatPartnerId] = message
                }
                self.attemptReloadOfTable()
            }
        }, withCancel: nil)
    }
    
    fileprivate func attemptReloadOfTable() {
        self.timer?.invalidate()
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    var timer: Timer?
    
    @objc func handleReloadTable() {
        self.messages = Array(self.messagesDictionary.values)
        self.messages.sort(by: { (message1, message2) -> Bool in
            
            return message1.timestamp?.int32Value > message2.timestamp?.int32Value
        })
        
        //this will crash because of background thread, so lets call this on dispatch_async main thread
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
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
        
        filtered = messages.filter({ (text) -> Bool in
            let name: NSString = text.toName! as NSString
            let msg: NSString = text.text! as NSString
            let nameRange = name.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            let msgRange = msg.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return nameRange.location != NSNotFound || msgRange.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
            // display text saying no results found
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    func createSpinnerView() {
        let child = SpinnerViewController()
        
        // add the spinner view controller
        addChild(child)
        child.view.frame = view.safeAreaLayoutGuide.layoutFrame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        // wait 0.8 seconds to simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            // then remove the spinner view controller
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->
        Int {
            
        noResultsView()

        if (messages.count > 0) {
            
            noMessagesLabel.isHidden = true
            if(searchActive) {
                return filtered.count
            }
            else if(searchController.searchBar.text! == "") {
                return messages.count;
            }
        }
            
        else {
            createSpinnerView()
            noMessagesLabel.isHidden = false
            tableView.backgroundView = noMessagesLabel
            tableView.separatorStyle = .none
            print("empty list")
        }
            
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let message: Message
        if(searchActive){
            message = filtered[indexPath.row]
        } else {
            message = messages[indexPath.row];
        }
        
        cell.message = message
        
        let uid = Auth.auth().currentUser?.uid

        let messagesReference = Database.database().reference().child("messages").child(message.chatroomId!).child(uid!)

        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in

            if let messages = snapshot.value as? Int {
                if messages == 0 {
                    cell.newMessageDot.isHidden = true
                } else {
                    cell.newMessageDot.isHidden = false
                }
               }
           }, withCancel: nil)

        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message: Message
        if(searchActive){
            message = filtered[indexPath.row]
        } else {
            message = messages[indexPath.row];
        }
        
        let chatroomId = message.chatroomId!
        updateNotifications(chatroomId)
        
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = User(dictionary: dictionary)
            user.id = chatPartnerId
            self.showChatControllerForUser(user)
            
        }, withCancel: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var message: Message
            guard let uid = Auth.auth().currentUser?.uid else {
                       return
                   }
            if (self.searchActive){
                message = self.filtered[indexPath.row]
                let chatPartnerId = message.chatPartnerId()!
                let chatroomId = message.chatroomId!
                self.filtered.remove(at: indexPath.row)
                self.messagesDictionary.removeValue(forKey: chatPartnerId)
                Database.database().reference().child("user-messages").child(uid).child(chatroomId).child("seeMessages").setValue("no")
                self.updateNotifications(chatroomId)
                self.searchController.searchBar.text = ""
                self.searchController.dismiss(animated: true, completion: nil)
            } else{
               message = self.messages[indexPath.row]
                let chatPartnerId = message.chatPartnerId()!
                let chatroomId = message.chatroomId!
                self.messages.remove(at: indexPath.row)
                self.messagesDictionary.removeValue(forKey: chatPartnerId)
                Database.database().reference().child("user-messages").child(uid).child(chatroomId).child("seeMessages").setValue("no")
                self.updateNotifications(chatroomId)
            }

            self.tableView.reloadData()
        }
    }
    
    func updateNotifications(_ chatroomId: String){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let refNotify = Database.database().reference().child("messages").child(chatroomId).child(uid)
        refNotify.observeSingleEvent(of: .value, with: { (snapshot) in
        guard let messageNotifications = snapshot.value as? Int else {
            return
        }

            let ref = Database.database().reference().child("users").child(uid).child("notifications")
            ref.observeSingleEvent(of: .value, with:{ (snapshot) in
            guard let overallNotifications = snapshot.value as? Int else {
                return
            }
                let notifications = overallNotifications - messageNotifications
                ref.setValue(notifications)
            }, withCancel: nil)
            refNotify.setValue(0){
                (error:Error?, ref:DatabaseReference) in
                if let error = error {
                    print("Data could not be saved: \(error).")
                } else {
                    print("Data saved successfully!")
                }
            }
            
        }, withCancel: nil)
    }
    
    @objc func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            observeUserMessages()
        }
    }
    
    
    func showChatControllerForUser(_ user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        searchController.searchBar.text = ""
        if(searchActive) {
            searchController.dismiss(animated: false) {
                self.navigationController?.pushViewController(chatLogController, animated: true)
            }
        }
        else{
            navigationController?.pushViewController(chatLogController, animated: true)
        }
    }
    
    lazy var noMessagesLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        label.text = "You have not messaged anyone yet"
        label.textColor = UIColor.black
        label.textAlignment = .center
        tableView.separatorStyle = .none
        
        return label
    }()
    
    lazy var noResultsLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        label.text = "No results available"
        label.textColor = UIColor.black
        label.textAlignment = .center
        tableView.separatorStyle = .none
        
        return label
    }()
    
    func noResultsView() {
        if(searchActive) {
            noResultsLabel.isHidden = true
            tableView.separatorStyle = .singleLine
        }
        else if(searchController.searchBar.text == "") {
            noResultsLabel.isHidden = true
            tableView.separatorStyle = .singleLine
        }
        else {
            noResultsLabel.isHidden = false
            tableView.backgroundView = noResultsLabel
            tableView.separatorStyle = .none
            print("no results")
        }
    }
    
    @objc func handleLogout() {

        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }

        let loginController = LoginController()
        loginController.modalPresentationStyle = .fullScreen
        let registerType = RegisterType()
        loginController.messagesController = self
        loginController.profileController = profileController
        registerType.messagesController = self
        present(loginController, animated: true, completion: nil)
    }
    
}

class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    override func loadView() {
        view = UIView()
        view.frame = CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height)
        view.backgroundColor = UIColor.white
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .black
        spinner.startAnimating()
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

