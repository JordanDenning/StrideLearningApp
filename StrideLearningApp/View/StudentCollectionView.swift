//
//  StudentCollectionView.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 2/17/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import UIKit
import Firebase

class StudentCollectionView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var ref = Database.database().reference().child("to-do-items")
    var weeks = ["Last Week", "This Week", "Next Week"]
    let today = Date()
    let calendar = Calendar(identifier: .gregorian)
    var components = DateComponents()
    let weekStart = 3
    var studentUid: String?
    var uid: String?
    var user: User?
    var plannerController: PlannerController?
    var plannerOverall: PlannerOverallController?
    var onceOnly = false
    
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.isPagingEnabled = true
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.addSubview(collectionView)
//        view.topAnchor.constraint(equalTo:
//
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        
        setupCollectionConstraints()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(PlannerController.self, forCellWithReuseIdentifier: "cell")
        
        components = calendar.dateComponents([.weekday], from: today)
        if (components.weekday != weekStart){
            ref.child("weekUpToDate").setValue(false)
        }
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
//    func viewWillAppear(_ animated: Bool) {
//            plannerOverall!.tabBarController?.navigationItem.title = "Last Week"
//            plannerOverall!.navigationItem.title = "Last Week"
//            plannerOverall!.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(handleNewTask))
//            plannerOverall!.tabBarController?.navigationItem.leftBarButtonItem = nil
//
////            if let index = self.tableView.indexPathForSelectedRow {
////                self.tableView.deselectRow(at: index, animated: false)
////            }
////            do we need this?
//
//            guard let uid = Auth.auth().currentUser?.uid else {
//                return
//            }
//
//            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
//
//                if let dictionary = snapshot.value as? [String: AnyObject] {
//                    self.user = User(dictionary: dictionary)
//                    if self.user?.type == "mentor" {
//                        self.studentUid = self.user?.student
//                        self.ref = self.ref.child(self.studentUid!)
//                    }
//                    else {
//                        self.ref = self.ref.child(uid)
//                    }
//
//                }
//            }, withCancel: nil)
//        }
//
    func setupCollectionConstraints() {
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor).isActive = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
        if let ip = collectionView.indexPathForItem(at: center) {
            let cell = ip.row
            switch cell {
            case 0:
                plannerOverall!.tabBarController?.navigationItem.title = weeks[cell]
                plannerOverall!.navigationItem.title = weeks[cell]
                plannerOverall!.weekTitle = weeks[cell]
            case 1:
                plannerOverall!.tabBarController?.navigationItem.title = weeks[cell]
                plannerOverall!.navigationItem.title = weeks[cell]
                plannerOverall!.weekTitle = weeks[cell]
            case 2:
                plannerOverall!.tabBarController?.navigationItem.title = weeks[cell]
                plannerOverall!.navigationItem.title = weeks[cell]
                plannerOverall!.weekTitle = weeks[cell]
            default:
                plannerOverall!.tabBarController?.navigationItem.title = "Planner"
                plannerOverall!.navigationItem.title = "Planner"
                plannerOverall!.weekTitle = "Planner"
            }
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !onceOnly {
            let indexToScrollTo = IndexPath(item: 1, section: 0)
            self.collectionView.scrollToItem(at: indexToScrollTo, at: .left, animated: false)
            onceOnly = true
        }
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
       return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
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

            let itemRef = self.ref.child(week).child(weekday).child(task)

            itemRef.setValue(newItem.toAnyObject())

        }

        let cancelAction=UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {action in
            //dismiss alert
        })

        alert.addAction(addAction)
        alert.addAction(cancelAction)

        plannerOverall!.present(alert, animated: true, completion: nil)
    }
}
