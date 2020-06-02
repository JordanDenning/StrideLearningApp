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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileVC = ProfileController()
        profileVC.navigationItem.title = "Profile"
        appDelegate.profileVC = profileVC

        let messagesVC = MessagesController()
        messagesVC.navigationItem.title = "Messages"
        appDelegate.messagesVC = messagesVC
        
        let plannerVC = PlannerOverallController()
        plannerVC.title = "Planner"
        appDelegate.profileVC = profileVC
        
        profileVC.messagesController = messagesVC
        profileVC.plannerController = plannerVC
        messagesVC.profileController = profileVC
    

        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile-1"), tag: 0)
        messagesVC.tabBarItem = UITabBarItem(title: "Messages", image: UIImage(named: "message-1"), tag: 0)
        plannerVC.tabBarItem = UITabBarItem(title: "Planner", image: UIImage(named:"planner-1"), tag: 2)
        
        //tab bar color
        UITabBar.appearance().barTintColor = .white
        tabBar.unselectedItemTintColor = UIColor(r:170, g:170, b:170)
        tabBar.tintColor = UIColor(r: 16, g: 153, b: 255)
        
        let controllers = [profileVC, messagesVC, plannerVC]

        viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
        
        selectedIndex = 1

    }
}
