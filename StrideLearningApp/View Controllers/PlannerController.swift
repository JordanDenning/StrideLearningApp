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

    let image = UIImage(named: "new_message_icon")

    var tasks = ["Finish math homework", "Write essay"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Planner"
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))

        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewTask))
    }

    //MARK: TableView DataSource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row]
        return cell

    }

    @objc func handleNewTask() {

        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a New Task"
        }

        let action = UIAlertAction(title: "Add Task", style: .default) { (action) in
            
            let newTaskField = alert.textFields![0]
            self.tasks.append(newTaskField.text!)
            print(self.tasks)
            self.tableView.reloadData()

        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }

    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }

}
