//
//  ViewControllerExtension.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 5/15/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import UIKit

extension UIViewController {
    var topViewController: UIViewController? {
        return self.topViewController(currentViewController: self)
    }

    private func topViewController(currentViewController: UIViewController) -> UIViewController {
        if let tabBarController = currentViewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return self.topViewController(currentViewController: selectedViewController)
        } else if let navigationController = currentViewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return self.topViewController(currentViewController: visibleViewController)
       } else if let presentedViewController = currentViewController.presentedViewController {
            return self.topViewController(currentViewController: presentedViewController)
       } else {
            return currentViewController
        }
    }
}
