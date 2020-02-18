//
//  PlannerController.swift
//  StrideLearningApp
//
//  Created by Brittany Choy on 2/1/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import UIKit
import Firebase

class PlannerController: UITableViewController {
    var days: [String] = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
    var tasks: [[ToDoItem]] = [[],[],[],[],[],[],[]]
    var user: User!
    var taskDictionary = [String: Message]()
    var ref = Database.database().reference().child("to-do-items")

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        ref = ref.child(uid)
        
        fetchTasks()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Planner"
        self.tabBarController?.navigationItem.leftBarButtonItem = nil

        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(handleNewTask))
        
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: false)
        }
    }
    
    func fetchTasks() {
        var count = 0
        for day in days {
            ref.child(day).observe(.value, with: {snapshot in
                var newItems: [ToDoItem] = []
                print("KEY:", snapshot.key)
                switch snapshot.key {
                case "monday":
                    count = 0
                case "tuesday":
                    count = 1
                case "wednesday":
                    count = 2
                case "thursday":
                    count = 3
                case "friday":
                    count = 4
                case "saturday":
                    count = 5
                case "sunday":
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
                self.tasks[count] = newItems
                self.tableView.reloadData()

            })
        }
    }
    
    //number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tasks.count
    }
    //number of table rows

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks[section].count
    }
    
    //section header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = days[section].description
        label.backgroundColor = UIColor(r: 16, g: 153, b: 255)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    //populate table rows with tasks array

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let newItem = tasks[indexPath.section][indexPath.row]

        cell.textLabel?.text = newItem.name
        return cell

    }
    
    //check off task
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let toDoItem = tasks[indexPath.section][indexPath.row]
//        let toDoItem = tasks[indexPath.row]
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == UITableViewCell.EditingStyle.delete
        {
            let toDoItem = tasks[indexPath.section][indexPath.row]
            toDoItem.ref?.removeValue()
            if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark
            {
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
            }
            tableView.reloadData()
        }
    }

    @objc func handleNewTask() {

        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: .alert)
        
        var taskTextField = UITextField()
        alert.addTextField { (field) in
            taskTextField = field
            taskTextField.placeholder = "Add a New Task"
        }
        
        var dayTextField = UITextField()
        alert.addTextField { (field) in
            dayTextField = field
            dayTextField.placeholder = "Day to do"
        }
        

        let addAction = UIAlertAction(title: "Add Task", style: .default) { (action) in
            
            guard let taskTextField = alert.textFields?[0],
                let task = taskTextField.text else { return }
            
            guard let dayTextField = alert.textFields?[1],
            let weekday = dayTextField.text else { return }
            
            var day = Int()
            
            switch weekday {
            case "monday":
                day = 0
            case "tuesday":
                day = 1
            case "wednesday":
                day = 2
            case "thursday":
                day = 3
            case "friday":
                day = 4
            case "saturday":
                day = 5
            case "sunday":
                day = 6
            default:
                day = 0
            }
            
            let newItem = ToDoItem(name: task,
                                   addedByUser: Auth.auth().currentUser!.uid,
                                   day: day,
                                   completed: false)
            
            let itemRef = self.ref.child(weekday).child(task)
            
            itemRef.setValue(newItem.toAnyObject())

        }
        
        let cancelAction=UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {action in
            //dismiss alert
        })
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

}
