//
//  PlannerOverallController.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 3/5/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import UIKit
import Firebase

class PlannerOverallController: UIViewController, UICollectionViewDelegateFlowLayout,  UIPickerViewDelegate, UIPickerViewDataSource {
    var ref  = Database.database().reference()
    var userRef: DatabaseReference?
    var toDoRef: DatabaseReference?
    var user: User?
    var weekTitle = "Planner"
    let today = Date()
    let calendar = Calendar(identifier: .gregorian)
    var components = DateComponents()
    let weekStart = 1
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
        
        weekdayView.delegate = self
        weekdayView.dataSource = self
        
        weekView.delegate = self
        weekView.dataSource = self
        
        weekday = "Monday"
        week = "this-week"
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
        tabBarController?.navigationItem.leftBarButtonItem = nil
        userRef!.observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                self.user = User(dictionary: dictionary)
                if self.user?.type == "staff" {
                    self.tabBarController?.navigationItem.title = "Students"
                    self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "task_v3"), style: .plain, target: self, action: #selector(self.addNewStudent))
                    self.tabBarController?.navigationItem.rightBarButtonItem?.tintColor = .white
                    //navigation title properties
                    self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font: UIFont(name: "MarkerFelt-Thin", size: 20) ?? UIFont.systemFont(ofSize: 20)]
                }  else {
                    self.tabBarController?.navigationItem.title = self.weekTitle
                    self.navigationItem.title = self.weekTitle
                   self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "task_v3"), style: .plain, target: self, action: #selector(self.handleNewTask))
                    
                    self.components = self.calendar.dateComponents([.weekday], from: self.today)
                    if (self.components.weekday != self.weekStart){
                        self.toDoRef!.child("weekUpToDate").setValue(false)
                    }
                }
            }
            
        }, withCancel: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mentorTableView.searchController.dismiss(animated: false, completion: nil)
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
            viewContainsStudentView = false
        }
        if viewContainsMentorView {
            mentorTableView.removeFromSuperview()
            viewContainsMentorView = false
        }
    }
    
    //Set up PickerViews and their arrays
    
    let weekdayChoices = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    let weekdayView = UIPickerView(frame: CGRect(x: 0, y: 20, width: 250, height: 100))
    var weekday = String()
    
    let weekChoices = ["This Week","Next Week"]
    let weekView = UIPickerView(frame: CGRect(x: 0, y: 150, width: 250, height: 100))
    var week = String()
    var weekChoice = String()
    
    
    //Populate PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == weekdayView) {
            return weekdayChoices.count
        }
        else if (pickerView == weekView) {
            return weekChoices.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == weekdayView) {
            return weekdayChoices[row]
        }
        else if (pickerView == weekView) {
            return weekChoices[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == weekdayView) {
            if row == 0 {
                weekday = "Monday"
            } else if row == 1 {
                weekday = "Tuesday"
            } else if row == 2 {
                weekday = "Wednesday"
            } else if row == 3 {
                weekday = "Thursday"
            } else if row == 4 {
                weekday = "Friday"
            } else if row == 5 {
                weekday = "Saturday"
            } else if row == 6 {
                weekday = "Sunday"
            }
        }
        else if (pickerView == weekView) {
            if row == 0 {
                week = "this-week"
            } else if row == 1 {
                week = "next-week"
            }
        }
    }
    
    @objc func handleNewTask() {
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 270)
        
        let weekdayLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 20))
        weekdayLabel.textAlignment = .center
        weekdayLabel.font = UIFont.boldSystemFont(ofSize: weekdayLabel.font.pointSize)
        weekdayLabel.text = "Select Day"
        vc.view.addSubview(weekdayLabel)
        vc.view.addSubview(weekdayView)
        
        let weekLabel = UILabel(frame: CGRect(x: 0, y: 130, width: 250, height: 20))
        weekLabel.textAlignment = .center
        weekLabel.font = UIFont.boldSystemFont(ofSize: weekLabel.font.pointSize)
        weekLabel.text = "Select Week"
        vc.view.addSubview(weekLabel)
        vc.view.addSubview(weekView)
        
        setDefaultValue(item: weekTitle, inComponent: 0)
        
        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alert.setValue(vc, forKey: "contentViewController")
        let okAction=UIAlertAction(title: "Add Task", style: .default, handler: { (UIAlertAction) in
            
            guard let taskTextField = alert.textFields?[0],
                let task = taskTextField.text else { return }
            
            let newItem = ToDoItem(name: task,
                                   addedByUser: Auth.auth().currentUser!.uid,
                                   day: self.weekday,
                                   completed: false)
            
            let itemRef = self.toDoRef!.child(self.week).child(self.weekday).child(task)
            
            itemRef.setValue(newItem.toAnyObject())
            
            print("You selected " + self.weekday)
            print("You selected " + self.week)
            
        })
        let cancelAction=UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        okAction.isEnabled = false
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        var taskTextField = UITextField()
        alert.addTextField { (field) in
            taskTextField = field
            taskTextField.placeholder = "Add a New Task"
            
            // Observe the UITextFieldTextDidChange notification to be notified in the below block when text is changed
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: taskTextField, queue: OperationQueue.main, using:
                {_ in
                    // Being in this block means that something fired the UITextFieldTextDidChange notification.
                    
                    // Access the taskTextField and get the count of its non whitespace characters
                    let textCount = taskTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                    let textIsNotEmpty = textCount > 0
                    
                    // If the text contains non whitespace characters, enable the OK Button
                    okAction.isEnabled = textIsNotEmpty
                    
            })
            
        }
        
        present(alert, animated: true)
        
    }
    
    func setDefaultValue(item: String, inComponent: Int){
     if let indexPosition = weekChoices.firstIndex(of: item){
       weekView.selectRow(indexPosition, inComponent: inComponent, animated: true)
     }
    }
    
    @objc func addNewStudent(){
        let studentListController = StudentList()
        studentListController.mentorName = user?.name
        studentListController.mentorView = mentorTableView
        let navController = UINavigationController(rootViewController: studentListController)
        present(navController, animated: true, completion: nil)
    }
}
