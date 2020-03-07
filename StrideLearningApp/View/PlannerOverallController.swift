//
//  PlannerOverallController.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 3/5/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import UIKit
import Firebase

class PlannerOverallController: UIViewController, UICollectionViewDelegateFlowLayout {
    var ref  = Database.database().reference()
    var userRef: DatabaseReference?
    var toDoRef: DatabaseReference?
    var user: User?
    var weekTitle = "Planner"

    
    lazy var collectionView: StudentCollectionView = {
        let cv = StudentCollectionView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    lazy var mentorTableView: MentorStudentView = {
        let mv = MentorStudentView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        return mv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    
    func addCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func addMentorView() {
        view.addSubview(mentorTableView)
        
        mentorTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mentorTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mentorTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mentorTableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        userRef = ref.child("users").child(uid)
        toDoRef = ref.child("to-do-items").child(uid)
        
        userRef!.observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                self.user = User(dictionary: dictionary)
                
            }
            
        }, withCancel: nil)
        
        if user?.type == "mentor" {
            tabBarController?.navigationItem.title = "Students"
            tabBarController?.navigationItem.leftBarButtonItem = nil
            tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addNewStudent))
            tabBarController?.navigationItem.rightBarButtonItem?.tintColor = .white
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    
//            if let index = self.tableView.indexPathForSelectedRow {
//                self.tableView.deselectRow(at: index, animated: false)
//            }
            
            mentorTableView.plannerOverall = self
            addMentorView()
        }
        else {
            tabBarController?.navigationItem.title = weekTitle
            navigationItem.title = weekTitle
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(handleNewTask))
            tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(handleNewTask))
            tabBarController?.navigationItem.leftBarButtonItem = nil

            addCollectionView()
            collectionView.plannerOverall = self
            
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

            let newItem = ToDoItem(name: task,
                                   addedByUser: Auth.auth().currentUser!.uid,
                                   day: weekday,
                                   completed: false)

            let itemRef = self.toDoRef!.child(week).child(weekday).child(task)

            itemRef.setValue(newItem.toAnyObject())

        }

        let cancelAction=UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {action in
            //dismiss alert
        })

        alert.addAction(addAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
    
    @objc func addNewStudent(){
        let studentListController = StudentList()
        studentListController.mentorView = mentorTableView
        let navController = UINavigationController(rootViewController: studentListController)
        present(navController, animated: true, completion: nil)
    }
}
