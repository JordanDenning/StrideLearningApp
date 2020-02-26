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
    var user: User!
    var taskDictionary = [String: Message]()
    var ref = Database.database().reference().child("to-do-items")
    var cellCount = Int()
    let tableView = UITableView()
    var weekUpToDate = Bool ()
    var weekStart = 3
    let today = Date()
    let calendar = Calendar(identifier: .gregorian)
    var components = DateComponents()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(tableView)
        
        setupTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        ref = ref.child(uid)
        
        
        fetchTasks()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTableView(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
    
    func fetchTasks() {
        var count = 0
        for week in weeks{
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
        let label = UILabel()
        label.text = days[section].description
        label.backgroundColor = UIColor(r: 16, g: 153, b: 255)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == UITableViewCell.EditingStyle.delete
        {
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
            toDoItem.ref?.removeValue()
            if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark
            {
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
            }
            tableView.reloadData()
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
                ref.child(oldWeek).child(item.day).child(item.name).setValue(item.toAnyObject())
            }
        }
    }
}


