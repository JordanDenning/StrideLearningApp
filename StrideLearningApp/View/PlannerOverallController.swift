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
    var collectionView: CollectionView?
    var viewContainsMentorView = false
    var viewContainsStudentView = false
    
    lazy var mentorTableView: MentorStudentView = {
        let mv = MentorStudentView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        return mv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        checkStudentOrMentor()
        
        definesPresentationContext = true
        
        //navigation bar color
        let navBackgroundImage = UIImage(named:"navBarSmall")?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
        self.navigationController?.navigationBar.setBackgroundImage(navBackgroundImage,
                                                                    for: .default)
        //navigation title properties
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font: UIFont(name: "MarkerFelt-Thin", size: 20) ?? UIFont.systemFont(ofSize: 20)]

        //navigation button items
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    
    func addCollectionView() {
        collectionView = CollectionView()
        collectionView!.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView!)
        
        collectionView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView!.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView!.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        collectionView!.plannerOverall = self
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
                if self.user?.type == "staff" {
                    self.navigationItem.title = "Students"
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "task_v3"), style: .plain, target: self, action: #selector(self.addNewStudent))
                }  else {
                    self.navigationItem.title = "Planner"
                    
                    let editButton = self.editButtonItem
                    
                    let updateImage  = UIImage(named: "update")
                    let updateButton   = UIBarButtonItem(image: updateImage,  style: .plain, target: self, action: #selector(self.updateWeeks))
                    
                    self.navigationItem.rightBarButtonItems = [editButton, updateButton]
                }
            }
            
        }, withCancel: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mentorTableView.searchController.dismiss(animated: false, completion: nil)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
    
        // overriding this method means we can attach custom functions to the button
        super.setEditing(editing, animated: animated)
    
        if editing {
            if let plannerController = collectionView?.plannerController {
                plannerController.moveTask(editing: editing)
            }
            collectionView?.weekControl.isUserInteractionEnabled = false
        } else {
            if let plannerController = collectionView?.plannerController {
                plannerController.moveTask(editing: editing)
            }
            collectionView?.weekControl.isUserInteractionEnabled = true
        }
    }
    
    @objc func updateWeeks(){
        let alert = UIAlertController(title: "Update Weeks", message: "Are you sure you want to update your weeks? This action cannot be undone.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Update", style: .default, handler: {action in
            if let plannerController = self.collectionView?.plannerController {
                plannerController.updateWeeks()
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)

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
                if self.user?.type == "staff" {
                    self.mentorTableView.plannerOverall = self
                    self.mentorTableView.fetchStudents(self.userRef!)
                    self.addMentorView()
                    self.viewContainsMentorView = true
                } else {
                    self.addCollectionView()
                    self.viewContainsStudentView = true
                }
                
            }
            
        }, withCancel: nil)
    }
    
    func clearView(){
        if viewContainsStudentView {
            collectionView!.removeFromSuperview()
            navigationItem.rightBarButtonItem = nil
            viewContainsStudentView = false
        }
        if viewContainsMentorView {
            mentorTableView.removeFromSuperview()
            viewContainsMentorView = false
        }
    }
    
    @objc func addNewStudent(){
        let studentListController = StudentList()
        let navController = UINavigationController(rootViewController: studentListController)
        present(navController, animated: true, completion: nil)
    }
}
