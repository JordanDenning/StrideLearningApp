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

    var tasks: [ToDoItem] = []
    var user: User!
    var taskDictionary = [String: Message]()
    let ref = Database.database().reference().child("to-do-items")

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        let uid = Auth.auth().currentUser!.uid
        let query = ref.queryOrdered(byChild: "addedByUser").queryEqual(toValue: uid)
        query.observe(.value) {(snapshot: DataSnapshot) in
            var newItems: [ToDoItem] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let newItem = ToDoItem(snapshot: snapshot) {
                    newItems.append(newItem)
                }
            }
            self.tasks = newItems
            self.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Planner"
        self.tabBarController?.navigationItem.leftBarButtonItem = nil

        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(handleNewTask))
        
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: false)
        }
        let uid = Auth.auth().currentUser!.uid
        let query = ref.queryOrdered(byChild: "addedByUser").queryEqual(toValue: uid)
        query.observe(.value) {(snapshot: DataSnapshot) in
            var newItems: [ToDoItem] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let newItem = ToDoItem(snapshot: snapshot) {
                    newItems.append(newItem)
                }
            }
            self.tasks = newItems
            self.tableView.reloadData()
        }
    }
    
    //number of table rows

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    //populate table rows with tasks array

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let newItem = tasks[indexPath.row]
        cell.textLabel?.text = newItem.name
        return cell

    }
    
    //check off task
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let toDoItem = tasks[indexPath.row]
        let toggledCompletion = !toDoItem.completed
        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        toDoItem.ref?.updateChildValues([
            "completed": toggledCompletion
            ])
    }
    
    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
        if !isCompleted {
            cell.accessoryType = .none
            cell.textLabel?.textColor = .black
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = .gray
        }
    }
    
    //delete task
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if editingStyle == UITableViewCell.EditingStyle.delete
        {
            let toDoItem = tasks[indexPath.row]
            toDoItem.ref?.removeValue()
            if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark
            {
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
                    cell.textLabel?.textColor = .black
            }
            tableView.reloadData()
        }
    }

    @objc func handleNewTask() {

        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a New Task"
        }

        let addAction = UIAlertAction(title: "Add Task", style: .default) { (action) in
            
            guard let textField = alert.textFields?.first,
                let text = textField.text else { return }
            
            let newItem = ToDoItem(name: text,
                                   addedByUser: Auth.auth().currentUser!.uid,
                                   completed: false)
            
            let itemRef = self.ref.child(text.lowercased())
            
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
