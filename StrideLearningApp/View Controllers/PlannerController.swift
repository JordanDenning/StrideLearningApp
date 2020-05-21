//
//  PlannerController.swift
//  StrideLearningApp
//
//  Created by Brittany Choy on 2/1/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import UIKit
import Firebase

class PlannerController: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    var days: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var weeks: [String] = ["last-week", "this-week", "next-week"]
    var thisWeekTasks: [[ToDoItem]] = [[],[],[],[],[],[],[]]
    var lastWeekTasks: [[ToDoItem]] = [[],[],[],[],[],[],[]]
    var nextWeekTasks: [[ToDoItem]] = [[],[],[],[],[],[],[]]
    var taskDictionary = [String: Message]()
    var ref = Database.database().reference().child("to-do-items")
    var cellCount = Int()
    let tableView = UITableView()
    var weekUpToDate = Bool ()
    var weekStart = 1
    let today = Date()
    let calendar = Calendar(identifier: .gregorian)
    var components = DateComponents()
    let tableViewHeight = CGFloat(integerLiteral: 45)
    var studentUid: String?
    var uid: String?
    var user: User?

    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(tableView)
        
        setupTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        tableView.addGestureRecognizer(longPressGesture)
        
       currentUser()
    }
    
    func currentUser(){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.user = User(dictionary: dictionary)
                if self.user?.type == "staff" {
                    self.studentUid = self.user?.student
                    self.ref = self.ref.child(self.studentUid!)
                }
                else {
                    self.ref = self.ref.child(uid)
                }
            }
            self.fetchTasks()
        }, withCancel: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTableView(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        tableView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -30).isActive = true
        tableView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5).isActive = true
        tableView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.tableFooterView = UIView()
    }
    
    func fetchTasks() {
        var count = 0
        for week in weeks {
            for day in days {
                ref.child(week).child(day).observe(.value, with: {snapshot in
                    var newItems: [ToDoItem] = []
                    switch snapshot.key {
                    case "Monday":
                        count = 0
                    case "Tuesday":
                        count = 1
                    case "Wednesday":
                        count = 2
                    case "Thursday":
                        count = 3
                    case "Friday":
                        count = 4
                    case "Saturday":
                        count = 5
                    case "Sunday":
                        count = 6
                    default:
                        count = 0
                    }
                    for child in snapshot.children {
                        if let snapshot = child as? DataSnapshot,
                            let newItem = ToDoItem(snapshot: snapshot) {
                            newItems.append(newItem)
                        }
                    }
                    
                    switch week {
                    case "last-week":
                        self.lastWeekTasks[count] = newItems
                    case "this-week":
                        self.thisWeekTasks[count] = newItems
                    case "next-week":
                        self.nextWeekTasks[count] = newItems
                    default:
                        self.thisWeekTasks[count] = newItems
                    }
                    
                    self.tableView.reloadData()
                    if (week == "next-week" && count == 6 ) {
                        self.ref.child("weekUpToDate").observe(.value, with: { (snapshot) in
                            self.weekUpToDate = snapshot.value as? Bool ?? false
                            self.components = self.calendar.dateComponents([.weekday], from: self.today)
                            if(self.components.weekday == self.weekStart && !self.weekUpToDate ){
                                self.updateWeeks()
                            }
                        }) { (error) in
                            print(error.localizedDescription)
                        }
                    }
                })
            }
           
        }
    }
    
    //number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return days.count
    }
    
    //number of table rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch cellCount {
        case 0:
            return lastWeekTasks[section].count
        case 1:
            return thisWeekTasks[section].count
        case 2:
            return nextWeekTasks[section].count
        default:
            return thisWeekTasks[section].count
        }
    }
    
    //section header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.sectionHeaderHeight))
        view.backgroundColor = UIColor(r: 16, g: 153, b: 255)
        
        let label = UILabel(frame: CGRect(x: 12, y: 0, width: tableView.frame.size.width, height: tableViewHeight))
        label.text = days[section].description
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = NSTextAlignment.left
        
        //header borders for spacing
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.white.cgColor
        
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableViewHeight
    }
    
    
    //populate table rows with tasks array
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var newItem: ToDoItem
        switch cellCount {
        case 0:
            newItem = lastWeekTasks[indexPath.section][indexPath.row]
        case 1:
            newItem = thisWeekTasks[indexPath.section][indexPath.row]
        case 2:
            newItem = nextWeekTasks[indexPath.section][indexPath.row]
        default:
            newItem = thisWeekTasks[indexPath.section][indexPath.row]
        }

        cell.textLabel?.text = newItem.name
        cell.textLabel?.numberOfLines = 0
        toggleCellCheckbox(cell, isCompleted: newItem.completed)
        
        func layoutSubviews() {
            super.layoutSubviews()
            
            contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        }
        
        return cell

    }
    
    //check off task
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        var toDoItem: ToDoItem
        switch cellCount {
        case 0:
            toDoItem = lastWeekTasks[indexPath.section][indexPath.row]
        case 1:
            toDoItem = thisWeekTasks[indexPath.section][indexPath.row]
        case 2:
            toDoItem = nextWeekTasks[indexPath.section][indexPath.row]
        default:
            toDoItem = thisWeekTasks[indexPath.section][indexPath.row]
        }
        
        let toggledCompletion = !toDoItem.completed
        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        toDoItem.ref?.updateChildValues([
            "completed": toggledCompletion
            ])
    }
    
    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
        if !isCompleted {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .checkmark
        }
    }
    
    //delete task
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: p)
        if indexPath == nil {
            print("Long press on table view, not row.")
        } else if longPressGesture.state == UIGestureRecognizer.State.began {
            let alert=UIAlertController(title: "Delete Task", message: "Are you sure you want to delete this task?", preferredStyle: UIAlertController.Style.alert)
            //create a UIAlertAction object for the button
            let okAction=UIAlertAction(title: "Delete", style: .destructive, handler: {action in
                var toDoItem: ToDoItem
                switch self.cellCount {
                case 0:
                    toDoItem = self.lastWeekTasks[(indexPath!.section)][indexPath!.row]
                case 1:
                    toDoItem = self.thisWeekTasks[indexPath!.section][indexPath!.row]
                case 2:
                    toDoItem = self.nextWeekTasks[indexPath!.section][indexPath!.row]
                default:
                    toDoItem = self.thisWeekTasks[indexPath!.section][indexPath!.row]
                }
                toDoItem.ref?.removeValue()
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
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            return
            
        }
    }
    
    func updateWeeks(){
        var count = 0
        
        lastWeekTasks = thisWeekTasks
        ref.child("last-week").removeValue()
        updateFirebaseWeek("last-week", thisWeekTasks)
        
        thisWeekTasks = nextWeekTasks
        ref.child("this-week").removeValue()
        updateFirebaseWeek("this-week", nextWeekTasks)
        
        for _ in nextWeekTasks{
            nextWeekTasks[count].removeAll()
            count += 1
        }
        ref.child("next-week").removeValue()
        ref.child("weekUpToDate").setValue(true)
        
        weekUpToDate = true
        tableView.reloadData()
    }

    func updateFirebaseWeek(_ oldWeek: String, _ newWeek: [[ToDoItem]]){
        for day in newWeek{
            for item in day{
                ref.child(oldWeek).child(item.day).child(item.key).setValue(item.toAnyObject())
            }
        }
    }
}


