//
//  TabBarController.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 1/29/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import UIKit
import Firebase

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    var ref = Database.database().reference().child("to-do-items")
    var user: User?
    var studentControllers: [UIViewController] = []
    var mentorControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        ref = ref.child(uid)
        
        let profileVC = ProfileController()

        profileVC.navigationItem.title = "Profile"

        let messagesVC = MessagesController()
        messagesVC.navigationItem.title = "Messages"
        
        
        let plannerVC = PlannerOverallController()
        plannerVC.title = "Planner"
    

        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile-1"), tag: 0)
        messagesVC.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(named: "message-1"), tag: 0)
        plannerVC.tabBarItem = UITabBarItem(title: "Planner", image: UIImage(named:"planner-1"), tag: 2)
        //tabBar.tintColor = .white
        
        //tab bar color
        UITabBar.appearance().barTintColor = .white
        tabBar.unselectedItemTintColor = UIColor(r:170, g:170, b:170)
        tabBar.tintColor = UIColor(r: 16, g: 153, b: 255)
        
        let controllers = [profileVC, messagesVC, plannerVC]

        viewControllers = controllers
        
        selectedIndex = 1

    }
}
