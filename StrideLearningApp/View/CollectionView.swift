//
//  CollectionView.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 2/17/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import UIKit
import Firebase

class CollectionView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource {
    var ref = Database.database().reference().child("to-do-items")
    var weeks = ["Last Week", "This Week", "Next Week"]
    let today = Date()
    let calendar = Calendar(identifier: .gregorian)
    var components = DateComponents()
    let weekStart = 3
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        ref = ref.child(uid)
        
        view.addSubview(collectionView)
        view.topAnchor.constraint(equalTo: )
        setupCollectionConstraints()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //fix to bottom of navigation bar
        self.navigationController?.navigationBar.isTranslucent = false
        self.edgesForExtendedLayout = []
        
        collectionView.register(PlannerController.self, forCellWithReuseIdentifier: "cell")
        
        components = calendar.dateComponents([.weekday], from: today)
        if (components.weekday != weekStart){
            ref.child("weekUpToDate").setValue(false)
        }
        
        weekdayView.delegate = self
        weekdayView.dataSource = self
        
        weekView.delegate = self
        weekView.dataSource = self
        
        weekday = "Monday"
        week = "last-week"
        
    }
    
        override func viewWillAppear(_ animated: Bool) {
            self.tabBarController?.navigationItem.title = "Last Week"
            self.tabBarController?.navigationItem.leftBarButtonItem = nil
    
            let image = UIImage(named: "task_v3")
            
            self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewTask))
            
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
        if let ip = collectionView.indexPathForItem(at: center) {
            let cell = ip.row
            switch cell {
            case 0:
                tabBarController?.navigationItem.title = weeks[cell]
            case 1:
                tabBarController?.navigationItem.title = weeks[cell]
            case 2:
                tabBarController?.navigationItem.title = weeks[cell]
            default:
                tabBarController?.navigationItem.title = "Planner"
            }
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
    
    //Set up PickerViews and their arrays
    
    let weekdayChoices = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    let weekdayView = UIPickerView(frame: CGRect(x: 0, y: 20, width: 250, height: 100))
    var weekday = String()
    
    let weekChoices = ["Last Week","This Week","Next Week"]
    let weekView = UIPickerView(frame: CGRect(x: 0, y: 150, width: 250, height: 100))
    var week = String()
    
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
                week = "last-week"
            } else if row == 1 {
                week = "this-week"
            } else if row == 2 {
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
        
        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alert.setValue(vc, forKey: "contentViewController")
        let okAction=UIAlertAction(title: "Add Task", style: .default, handler: { (UIAlertAction) in
            
            guard let taskTextField = alert.textFields?[0],
                let task = taskTextField.text else { return }
            
            let newItem = ToDoItem(name: task,
                                   addedByUser: Auth.auth().currentUser!.uid,
                                   day: self.weekday,
                                   completed: false)
            
            let itemRef = self.ref.child(self.week).child(self.weekday).child(task)
            
            itemRef.setValue(newItem.toAnyObject())
            
            print("You selected " + self.weekday)
            print("You selected " + self.week)
            
        })
        let cancelAction=UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(okAction)
        okAction.isEnabled = false
        alert.addAction(cancelAction)
        
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
        
        self.present(alert, animated: true)
    }
}
