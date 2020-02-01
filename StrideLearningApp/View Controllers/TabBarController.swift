//
//  TabBarController.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 1/29/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let profileVC = UIViewController()
        profileVC.navigationItem.title = "Profile"
        profileVC.view.backgroundColor = UIColor.orange

        let messagesVC = MessagesController()
        messagesVC.navigationItem.title = "Messages"
        
        let plannerVC = UIViewController()
        plannerVC.title = "Planner"
        plannerVC.view.backgroundColor = UIColor.cyan

        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile-1"), tag: 0)
        messagesVC.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(named: "message"), tag: 0)
        plannerVC.tabBarItem = UITabBarItem(title: "Planner", image: UIImage(named:"planner-1"), tag: 2)
        tabBar.tintColor = UIColor(r: 16, g: 153, b: 255)
        
    
        let controllers = [profileVC, messagesVC, plannerVC]
//        viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
        viewControllers = controllers
        selectedIndex = 1

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
