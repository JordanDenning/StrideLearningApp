//
//  PlannerController.swift
//  StrideLearningApp
//
//  Created by Brittany Choy on 2/1/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import UIKit
import Firebase

class PlannerController: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, HeightForTextView, ToggleCheckBox, EditTask {

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
    let tableViewHeight = CGFloat(integerLiteral: 50)
    var studentUid: String?
    var uid: String?
    var user: User?
    var cellId = "cellId"
    var textViewHeight = CGFloat()
    var plannerUid = String()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(tableView)
        
        setupTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskCell.self, forCellReuseIdentifier: cellId)
        tableView.estimatedRowHeight = 45.0
        
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
                    self.plannerUid = self.studentUid!
                }
                else {
                    self.plannerUid = uid
                }
                self.ref = self.ref.child(self.plannerUid)
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
        view.backgroundColor = .white
        
        let label = UILabel(frame: CGRect(x: 12, y: 0, width: tableView.frame.size.width, height: tableViewHeight))
        label.text = days[section].description
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = NSTextAlignment.left
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableViewHeight))
        button.backgroundColor = UIColor(r: 16, g: 153, b: 255)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 5
        button.layer.borderColor = UIColor.white.cgColor
        button.tag = section
        button.addTarget(self, action: #selector(addTaskToWeek(_:)), for: .touchUpInside)
        
        //header borders for spacing
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.white.cgColor
        
        view.addSubview(button)
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableViewHeight
    }
    
    //populate table rows with tasks array
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TaskCell
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

        cell.textView.text = newItem.name
        if newItem.completed {
            cell.checkMark.setBackgroundImage(UIImage(named: "done2"), for: .normal)
        } else {
            cell.checkMark.setBackgroundImage(UIImage(named: "notDone"), for: .normal)
        }

        cell.delegate = self

        return cell
    }
    
    //edit task
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        for case let textView as UITextView in cell.subviews {
            textView.text = ""
            textView.isUserInteractionEnabled = true
            textView.becomeFirstResponder()
            textView.tag = indexPath.row
            return
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var toDoItem: ToDoItem
            switch self.cellCount {
            case 0:
                toDoItem = self.lastWeekTasks[(indexPath.section)][indexPath.row]
            case 1:
                toDoItem = self.thisWeekTasks[indexPath.section][indexPath.row]
            case 2:
                toDoItem = self.nextWeekTasks[indexPath.section][indexPath.row]
            default:
                toDoItem = self.thisWeekTasks[indexPath.section][indexPath.row]
            }
            
            toDoItem.ref?.removeValue()
            
            self.tableView.reloadData()
        }
    }

    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath)
        -> CGFloat {
               return textViewHeight + 70
    }
    
    func heightOfTextView(height: CGFloat) {

           textViewHeight = height + 8
           self.tableView.beginUpdates()
           self.tableView.endUpdates()
        
    }
    
    
    @objc func addTaskToWeek(_ sender: UIButton){
        let ref = Database.database().reference().child("to-do-items").child(plannerUid)
        let newItem: ToDoItem
        let day = sender.tag
        var weekday = String()
        var week = String()
        switch day {
        case 0:
            weekday = "Monday"
        case 1:
            weekday = "Tuesday"
        case 2:
            weekday = "Wednesday"
        case 3:
            weekday = "Thursday"
        case 4:
            weekday = "Friday"
        case 5:
            weekday = "Saturday"
        case 6:
            weekday = "Sunday"
        default:
            weekday = "Monday"
        }
        
        switch self.cellCount {
        case 0:
            week = "last-week"
        case 1:
            week = "this-week"
        case 2:
            week = "next-week"
        default:
            week = "this-week"
        }
        
        newItem = ToDoItem(name: "",
                               addedByUser: Auth.auth().currentUser!.uid,
                               day: weekday,
                               completed: false)
        let itemRef = ref.child(week).child(weekday).child("new task")
        itemRef.setValue(newItem.toAnyObject())
    }
    
    func editTask(task: String, textView: UITextView) {
        let ref = Database.database().reference().child("to-do-items").child(plannerUid)
        if let indexPath = getCurrentTextViewPath(textView){
            var toDoItem: ToDoItem
            var week = String()
            switch self.cellCount {
            case 0:
                week = "last-week"
                toDoItem = self.lastWeekTasks[indexPath.section][indexPath.row]
            case 1:
                week = "this-week"
                toDoItem = self.thisWeekTasks[indexPath.section][indexPath.row]
            case 2:
                week = "next-week"
                toDoItem = self.nextWeekTasks[indexPath.section][indexPath.row]
            default:
                week = "this-week"
                toDoItem = self.thisWeekTasks[indexPath.section][indexPath.row]
            }
            
            var key = task
            key = key.replacingOccurrences(of: ".", with: " ")
            key = key.replacingOccurrences(of: "#", with: " ")
            key = key.replacingOccurrences(of: "$", with: " ")
            key = key.replacingOccurrences(of: "[", with: " ")
            key = key.replacingOccurrences(of: "]", with: " ")
            key = key.replacingOccurrences(of: "/", with: " ")
            if key.last == " "{
                key.removeLast()
            }
            
            if key == "" {
                let alert=UIAlertController(title: "Empty Task", message: "Cannot add an empty task. Please enter a task.", preferredStyle: UIAlertController.Style.alert)
                //create a UIAlertAction object for the button
                let okAction=UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: {action in

                })
                                alert.addAction(okAction)
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                return
                
            }
            
            let day = toDoItem.day
            
            let newItem = ToDoItem(name: task,
                                   addedByUser: toDoItem.addedByUser,
                                   day: day,
                                   completed: toDoItem.completed)
            
            let itemRef = ref.child(week).child(day).child(key)
            
            itemRef.setValue(newItem.toAnyObject())
            
            toDoItem.ref?.removeValue()
        }
    }
    
    
    func toggleCheckBox(_ sender: UIButton) {
        if let indexPath = getCurrentButtonPath(sender) {
        var completed = Bool()

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
            
        completed = !toDoItem.completed
        toDoItem.ref?.updateChildValues([
            "completed": completed
            ])
            
        }
    }
    
    func getCurrentButtonPath(_ sender: UIButton) -> IndexPath? {
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath: IndexPath = tableView.indexPathForRow(at: buttonPosition) {
            return indexPath
        }
        return nil
    }
    
    func getCurrentTextViewPath(_ sender: UITextView) -> IndexPath? {
           let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
           if let indexPath: IndexPath = tableView.indexPathForRow(at: buttonPosition) {
               return indexPath
           }
           return nil
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
