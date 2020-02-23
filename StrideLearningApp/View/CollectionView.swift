//
//  CollectionView.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 2/17/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import UIKit
import Firebase

class CollectionView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var ref = Database.database().reference().child("to-do-items")
    var weeks = ["Last Week", "This Week", "Next Week"]
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        ref = ref.child(uid)
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(PlannerController.self, forCellWithReuseIdentifier: "cell")
        setupCollectionConstraints()
    }
    
        override func viewWillAppear(_ animated: Bool) {
            self.tabBarController?.navigationItem.title = "Planner"
            self.tabBarController?.navigationItem.leftBarButtonItem = nil
    
            self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(handleNewTask))
    
//            if let index = self.tableView.indexPathForSelectedRow {
//                self.tableView.deselectRow(at: index, animated: false)
//            }
//            do we need this?
        }
    
    func setupCollectionConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PlannerController
        let cellCount = indexPath.row
        
        cell?.cellCount = cellCount
        

        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: collectionView.frame.size.width-24, height: collectionView.frame.size.height-180)
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
        
        var weekTextField = UITextField()
        alert.addTextField { (field) in
            weekTextField = field
            weekTextField.placeholder = "Week"
        }


        let addAction = UIAlertAction(title: "Add Task", style: .default) { (action) in

            guard let taskTextField = alert.textFields?[0],
                let task = taskTextField.text else { return }

            guard let dayTextField = alert.textFields?[1],
            let weekday = dayTextField.text else { return }
            
            guard let weekTextField = alert.textFields?[2],
                let week = weekTextField.text else { return }

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

            let itemRef = self.ref.child(week).child(weekday).child(task)

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