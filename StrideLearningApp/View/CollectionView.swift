//
//  CollectionView.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 2/17/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import UIKit
import Firebase

class CollectionView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var ref = Database.database().reference().child("to-do-items")
    var studentUid: String?
    var uid: String?
    var user: User?
    var plannerOverall: PlannerOverallController?
    var plannerController: PlannerController?
    var plannerReference: [Int:PlannerController] = [:]
    var onceOnly = false
    
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isScrollEnabled = false
        
        return cv
    }()
    
    let weekControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Last Week", "This Week", "Next Week"])
        let whiteImage = UIImage(color: .white)
        segmentedControl.selectedSegmentIndex = 1
        let screenSize = UIScreen.main.bounds.width
        segmentedControl.frame.size.width = screenSize
        segmentedControl.frame.size.height = 45
        
        if #available(iOS 13, *) {
            segmentedControl.setBackgroundImage(whiteImage, for: .normal, barMetrics: .default)
            segmentedControl.setDividerImage(whiteImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
            
            // selected option color
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(r: 16, g:153, b:255), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)], for: .selected)
            
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(r: 50, g: 50, b:50), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)], for: .normal)
            
            segmentedControl.selectedSegmentTintColor = .clear
        } else {
            // selected option color
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(r: 16, g: 153, b:255), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)], for: .selected)
            
            // color of other options
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)], for: .normal)
            
            segmentedControl.tintColor = .white
        }
        
        if UIScreen.main.sizeType == .iPhone5 {
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(r: 16, g:153, b:255), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], for: .selected)
            
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(r: 50, g: 50, b:50), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], for: .normal)
        }
                
        segmentedControl.addTarget(self, action: #selector(changeWeek), for: .valueChanged)
        
        
        return segmentedControl
    }()
    
    let buttonBar: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(r: 16, g:153, b:255)
        v.layer.cornerRadius = 2
        
        return v
    }()
    
    let topDivider: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(r: 200, g: 200, b: 200)
        v.layer.cornerRadius = 2
        
        return v
    }()
    
    let bottomDivider: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(r: 200, g: 200, b: 200)
        v.layer.cornerRadius = 2
        
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        addSubview(weekControl)
        addSubview(buttonBar)
        addSubview(topDivider)
        addSubview(bottomDivider)
        
        setupCollectionConstraints()
        setupWeekControlConstraints()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(PlannerController.self, forCellWithReuseIdentifier: "cell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupCollectionConstraints() {
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: weekControl.bottomAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
     }
    
    func setupWeekControlConstraints(){
        weekControl.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        weekControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        
        buttonBar.topAnchor.constraint(equalTo: weekControl.bottomAnchor).isActive = true
        buttonBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
        buttonBar.centerXAnchor.constraint(equalTo: weekControl.centerXAnchor).isActive = true
        buttonBar.widthAnchor.constraint(equalTo: weekControl.widthAnchor, multiplier: 1 / CGFloat(weekControl.numberOfSegments)).isActive = true
        
        topDivider.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        topDivider.widthAnchor.constraint(equalTo: weekControl.widthAnchor).isActive = true
        topDivider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        topDivider.centerXAnchor.constraint(equalTo: weekControl.centerXAnchor).isActive = true
        
        bottomDivider.topAnchor.constraint(equalTo: buttonBar.bottomAnchor).isActive = true
        bottomDivider.widthAnchor.constraint(equalTo: weekControl.widthAnchor).isActive = true
        bottomDivider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomDivider.centerXAnchor.constraint(equalTo: weekControl.centerXAnchor).isActive = true
    }
    
    @objc func changeWeek(){
        let selectedWeek = weekControl.selectedSegmentIndex
        let indexPath = IndexPath(item: selectedWeek, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        UIView.animate(withDuration: 0.3) {
            self.buttonBar.frame.origin.x = (self.weekControl.frame.width / CGFloat(self.weekControl.numberOfSegments)) * CGFloat(selectedWeek)
        }
        plannerController = plannerReference[selectedWeek]
    }
    
    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !onceOnly {
            let indexToScrollTo = IndexPath(item: 1, section: 0)
            self.collectionView.scrollToItem(at: indexToScrollTo, at: .left, animated: false)
            plannerController = plannerReference[1]
            onceOnly = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PlannerController
        let cellCount = indexPath.row

        plannerReference[cellCount] = cell
        
        if plannerController == nil {
            plannerController = cell
        }
        
        cell?.cellCount = cellCount
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
}
