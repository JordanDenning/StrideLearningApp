//
//  StudentList.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 3/5/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import Foundation
import Firebase

class StudentList: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate  {
    
    let cellId = "cellId"
    
    var headerTitle: [String] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V"]
    //var users: [[User]] = [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
    
    var ref = Database.database().reference().child("users")
    var currentRef: DatabaseReference?
    var users = [User]()
    var filtered = [User]()
    var searchActive : Bool = false
    
    var mentorView: MentorStudentView?
    var searchController = UISearchController()
    
    let tableViewHeight = CGFloat(integerLiteral: 30)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.barTintColor = UIColor(r:16, g:153, b:255)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        navigationItem.title = "Add Students"
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        currentRef = ref.child(uid)
        
        fetchUser()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        configureSearchController()
    }
    
    func fetchUser() {
        ref.queryOrdered(byChild: "name").observe(.childAdded, with: { (snapshot) in
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
        searchController.searchBar.barTintColor = .white
        tableView.tableHeaderView = searchController.searchBar
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: TableView
    
    //section header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.sectionHeaderHeight))
        view.backgroundColor = UIColor(r: 16, g: 153, b: 255)
        
        let label = UILabel(frame: CGRect(x: 12, y: 0, width: Int(tableView.frame.size.width), height: Int(tableViewHeight)))
        label.text = headerTitle[section].description
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = NSTextAlignment.left
        
        //indent header somehow
        
        //drop shadow for section headers
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 3
        
        view.addSubview(label)
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableViewHeight
    }
    
    //number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        //        return headerTitle.count
        return 1
    }
    
    //number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        noResultsView()
        
        if(searchActive){
            return filtered.count
        }
            
            
        else if(searchController.searchBar.text! == ""){
            return users.count
        }
            
        else {
            return 0
        }
        
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
                let studentName = user.name
                let id = user.id
                let image = user.profileImageUrl
                let newStudent = Student(name: studentName!, ID: id!, profileImageUrl: image!)
    
                let itemRef = self.currentRef!.child("students").child(id!)
    
                itemRef.setValue(newStudent.toAnyObject())
            }
        }
        else{
            dismiss(animated: true) {
                print("Dismiss completed")
                let user: User
                user = self.users[indexPath.row]
                let studentName = user.name
                let id = user.id
                let image = user.profileImageUrl
                let newStudent = Student(name: studentName!, ID: id!, profileImageUrl: image!)
                
                let itemRef = self.currentRef!.child("students").child(id!)
                
                itemRef.setValue(newStudent.toAnyObject())
            }
        }
    }
    
    //index
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return headerTitle
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
        else if(searchController.searchBar.text! == "") {
            noResultsLabel.isHidden = true
            tableView.separatorStyle = .singleLine
        }
        else {
            noResultsLabel.isHidden = false
            tableView.backgroundView = noResultsLabel
            tableView.separatorStyle = .none
        }
    }
    
    
}
