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
        checkStudentOrMentor()
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
        tabBarController?.navigationItem.leftBarButtonItem = nil
        userRef!.observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                self.user = User(dictionary: dictionary)
                if self.user?.type == "mentor" {
                    self.tabBarController?.navigationItem.title = "Students"
                    self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(self.addNewStudent))
                    self.tabBarController?.navigationItem.rightBarButtonItem?.tintColor = .white
                    self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
                }  else {
                    self.tabBarController?.navigationItem.title = self.weekTitle
                    self.navigationItem.title = self.weekTitle
                    self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(self.handleNewTask))
                    
                }
            }
            
        }, withCancel: nil)
    }
    
    func checkStudentOrMentor(){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        userRef = ref.child("users").child(uid)
        toDoRef = ref.child("to-do-items").child(uid)
        
        userRef!.observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                self.user = User(dictionary: dictionary)
                if self.user?.type == "mentor" {
                    self.mentorTableView.plannerOverall = self
                    self.mentorTableView.fetchStudents(self.userRef!)
                    self.addMentorView()
                } else {
                    self.addCollectionView()
                    self.collectionView.plannerOverall = self
                    
                }
                
            }
            
        }, withCancel: nil)
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
