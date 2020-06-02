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
    
    var headerTitle: [String] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V", "W", "X", "Y", "Z"]
    var users: [[User]] = [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
    var filtered: [[User]] = [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
    
    var ref = Database.database().reference().child("users")
    var currentRef: DatabaseReference?
    var searchActive : Bool = false
    var noResults: Bool = false
    var studentsAdded = false
    var mentorName: String?
    var mentorId: String?
    
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
        mentorId = uid
        
        currentRef = ref.child(uid)
        
        currentRef?.child("name").observe(.value, with: { (snapshot) in
        
            if let name = snapshot.value as? String {
                self.mentorName = name
                }
            }, withCancel: nil)
            
        fetchUsers()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        configureSearchController()
    }
    
    func fetchUsers() {
        var count = 0
        Database.database().reference().child("users").queryOrdered(byChild: "name").observe(.childAdded, with: { (snapshot) in
            //queryOrdered sorts alphabetically/lexilogically
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                let letter = user.name?.prefix(1)
                user.id = snapshot.key
                
                if user.type == "student" {
                    switch letter {
                    case "A":
                        count = 0
                    case "B":
                        count = 1
                    case "C":
                        count = 2
                    case "D":
                        count = 3
                    case "E":
                        count = 4
                    case "F":
                        count = 5
                    case "G":
                        count = 6
                    case "H":
                        count = 7
                    case "I":
                        count = 8
                    case "J":
                        count = 9
                    case "K":
                        count = 10
                    case "L":
                        count = 11
                    case "M":
                        count = 12
                    case "N":
                        count = 13
                    case "O":
                        count = 14
                    case "P":
                        count = 15
                    case "Q":
                        count = 16
                    case "R":
                        count = 17
                    case "S":
                        count = 18
                    case "T":
                        count = 19
                    case "U":
                        count = 20
                    case "V":
                        count = 21
                    case "W":
                        count = 22
                    case "X":
                        count = 23
                    case "Y":
                        count = 24
                    case "Z":
                        count = 25
                    default:
                        count = 0
                    }
                    
                    
                    //if you use this setter, your app will crash if your class properties don't exactly match up with the firebase dictionary keys
                    self.users[count].append(user)
                    self.studentsAdded = true
                    
                    //this will crash because of background thread, so lets use dispatch_async to fix
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                }
            }
            
        }, withCancel: nil)
        
        if !studentsAdded {
            self.noStudentsLabel.isHidden = studentsAdded
            tableView.backgroundView = noStudentsLabel
            tableView.separatorStyle = .none
        }

        
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
        if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.sectionHeaderHeight))
            view.backgroundColor = UIColor(r: 16, g: 153, b: 255)
            
            let label = UILabel(frame: CGRect(x: 12, y: 0, width: Int(tableView.frame.size.width), height: Int(tableViewHeight)))
            label.text = headerTitle[section].description
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.textAlignment = NSTextAlignment.left
            
            //drop shadow for section headers
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.5
            view.layer.shadowOffset = .zero
            view.layer.shadowRadius = 3
            
            view.addSubview(label)
            
            return view
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
            return tableViewHeight
        } else {
            return CGFloat.leastNonzeroMagnitude
        }
    }
    
    //number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
       return headerTitle.count
    }
    
    //number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        noResultsView()
        if(searchActive && searchController.searchBar.text != "") {
            return filtered[section].count
        } else {
            return users[section].count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let user: User
        if(searchActive && searchController.searchBar.text != ""){
            user = filtered[indexPath.section][indexPath.row]
        }
        else{
            user = users[indexPath.section][indexPath.row]
        }
        cell.textLabel?.text = user.name
        
        cell.detailTextLabel?.text = user.grade! + ", " + user.school!
        
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(searchActive && searchController.searchBar.text != ""){
            searchController.dismiss(animated: true, completion: nil)
            let user: User
            user = self.filtered[indexPath.section][indexPath.row]
            self.primaryMentorAlert(for: user)
        }
        else if(searchActive && searchController.searchBar.text == ""){
            searchController.dismiss(animated: true, completion: nil)
            let user: User
            user = self.users[indexPath.section][indexPath.row]
            self.primaryMentorAlert(for: user)
        }
        else {
            print("Dismiss completed")
            let user: User
            user = self.users[indexPath.section][indexPath.row]
            primaryMentorAlert(for: user)
        }
    }
    
    func primaryMentorAlert(for user: User){
        let studentName = user.name
        let id = user.id
        let image = user.profileImageUrl
        let grade = user.grade
        let school = user.school
        let mentorId = user.mentor?["mentorId"] as! String
        let newStudent = Student(name: studentName!, ID: id!,grade: grade!, school: school!, mentorId: mentorId, profileImageUrl: image!)
        
        let message = "Are you " + studentName! + "'s primary mentor?"
        
        let alert = UIAlertController(title: "Primary Mentor", message: message , preferredStyle: UIAlertController.Style.alert)
        
        let okAction=UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
            
            let values = ["mentorId": self.mentorId, "mentorName": self.mentorName]
            self.ref.child(id!).child("mentor").setValue(values)
            
            let itemRef = self.currentRef!.child("students").child(id!)
            itemRef.setValue(newStudent.toAnyObject())
            itemRef.child("mentorId").setValue(self.mentorId)
        
            self.dismiss(animated: true)
        })
        
        let cancelAction=UIAlertAction(title: "No", style: .cancel, handler:{ (UIAlertAction) in
                        
            let itemRef = self.currentRef!.child("students").child(id!)
            itemRef.setValue(newStudent.toAnyObject())
        
            self.dismiss(animated: true)
        })
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
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
        searchActive = false
        for letter in (0...25){
            filtered[letter].removeAll()
        }
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
        var filterResults = true
        for letter in (0...25){
            filtered[letter] = users[letter].filter({ (text) -> Bool in
                let name: NSString = text.name! as NSString
                let school: NSString = text.school! as NSString
                let grade: NSString = text.grade! as NSString
                let nameRange = name.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                let schoolRange = school.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                let gradeRange = grade.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return nameRange.location != NSNotFound || schoolRange.location != NSNotFound || gradeRange.location != NSNotFound
            })
            if(filtered[letter].count != 0){
                filterResults = false
            }
            
            self.tableView.reloadData()
        }
        
        noResults = filterResults
        noResultsView()
    }
    
    lazy var noResultsLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        label.text = "No results available"
        label.textColor = UIColor.black
        label.textAlignment = .center
        tableView.separatorStyle = .none
        
        return label
    }()
    
    lazy var noStudentsLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        label.text = "No students available"
        label.textColor = UIColor.black
        label.textAlignment = .center
        tableView.separatorStyle = .none
        label.isHidden = true
        
        return label
    }()
    
    func noResultsView() {
        if(searchController.searchBar.text! == "") {
            noResultsLabel.isHidden = true
            noStudentsLabel.isHidden = true
            tableView.separatorStyle = .singleLine
        } else if(noResults) {
            noResultsLabel.isHidden = false
            tableView.backgroundView = noResultsLabel
            tableView.separatorStyle = .none
        } else {
            noResultsLabel.isHidden = true
            tableView.backgroundView = noResultsLabel
            tableView.separatorStyle = .singleLine
        }
        
    }
    
    
}
