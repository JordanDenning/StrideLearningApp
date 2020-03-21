//
//  MentorStudentView.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 3/4/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MentorStudentView: UIView, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate  {

    
    var tableView = UITableView()
    let cellId = "cellId"
    var ref = Database.database().reference().child("users")
    var userRef = Database.database().reference().child("users")
    var students = [Student]()
    var filtered = [Student]()
    var searchActive : Bool = false
    var searchController = UISearchController()
    var plannerOverall: PlannerOverallController?
    let tableViewHeight = CGFloat(integerLiteral: 30)
    var user: User?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        addSubview(tableView)
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        ref = ref.child(uid)
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        self.tableView.addGestureRecognizer(longPressGesture)
        
        setup()
        configureSearchController()
        fetchStudents(ref)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        //removes empty table cells
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    func setup() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fetchStudents(_ ref: DatabaseReference) {
        ref.child("students").queryOrdered(byChild: "name").observe(.value, with: { (snapshot) in
            //queryOrdered sorts alphabetically/lexilogically
            var newStudents: [Student] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let student = Student(snapshot: snapshot) {
                    newStudents.append(student)
                }
            }
            self.students = newStudents
            self.tableView.reloadData()
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
    
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: p)
        if indexPath == nil {
            print("Long press on table view, not row.")
        } else if longPressGesture.state == UIGestureRecognizer.State.began {
            let alert=UIAlertController(title: "Remove Student", message: "Are you sure you want to remove this student?", preferredStyle: UIAlertController.Style.alert)
            //create a UIAlertAction object for the button
            let okAction=UIAlertAction(title: "Remove", style: .destructive, handler: {action in
                var student: Student
                if (self.searchActive){
                    student = self.filtered[indexPath!.row]
                    self.searchController.searchBar.text = ""
                    self.searchController.dismiss(animated: true, completion: nil)
                } else{
                   student = self.students[indexPath!.row]
                }
                
                self.userRef.child(student.ID!).child("mentor").setValue("No Current Mentor")
                student.ref?.removeValue()
               
                if self.tableView.cellForRow(at: indexPath!)?.accessoryType == UITableViewCell.AccessoryType.checkmark
                {
                    self.tableView.cellForRow(at: indexPath!)?.accessoryType = UITableViewCell.AccessoryType.none
                }
                self.tableView.reloadData()
            })
            let cancelAction=UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {action in
                
                //dismiss alert
            })
           
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            plannerOverall!.present(alert, animated: true, completion: nil)
            return
            
        }
    }
    
    //MARK: TableView
    
    //number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noResultsView()
        
        if (students.count > 0)
        {
            noStudentsLabel.isHidden = true
            if(searchActive){
                return filtered.count
            }
                
            else if(searchController.searchBar.text! == ""){
                return students.count
            }
        }
        
        else {
            noStudentsLabel.isHidden = false
            tableView.backgroundView = noStudentsLabel
            tableView.separatorStyle = .none
            print("empty list")
        }
            
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let user: Student
        if(searchActive){
            user = filtered[indexPath.row]
        }
        else{
            user = students[indexPath.row]
        }
        cell.textLabel?.text = user.name?.description
        cell.detailTextLabel?.text = user.grade! + ", " + user.school!
        
        
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let uid: String
        if(searchActive){
            uid = filtered[indexPath.row].ID!.description
        } else {
            uid = students[indexPath.row].ID!.description
        }
        tableView.deselectRow(at: indexPath, animated: true)
        showPlannerControllerForUser(uid)
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
        
        filtered = students.filter({ (text) -> Bool in
            let name: NSString = text.name! as NSString
            let school: NSString = text.school! as NSString
            let grade: NSString = text.grade! as NSString
            let nameRange = name.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            let schoolRange = school.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            let gradeRange = grade.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return nameRange.location != NSNotFound || schoolRange.location != NSNotFound || gradeRange.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
            // display text saying no results found
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    lazy var noStudentsLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        label.text = "You have not added any students yet"
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
    
    func showPlannerControllerForUser(_ uid: String) {
        ref.child("student").setValue(uid)
        let collectionController = MentorCollectionView()
        if(searchActive) {
            searchController.dismiss(animated: false) {
                self.plannerOverall!.navigationController?.pushViewController(collectionController, animated: true)
            }
        }
        else{
            self.plannerOverall!.navigationController?.pushViewController(collectionController, animated: true)
        }
    }
    
    
}

