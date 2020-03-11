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
    var weeks = ["Last Week", "This Week", "Next Week"]
    var studentUid: String?
    var uid: String?
    var user: User?
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        
        setupCollectionConstraints()
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
}
