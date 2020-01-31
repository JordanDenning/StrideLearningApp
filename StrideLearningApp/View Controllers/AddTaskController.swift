//
//  AddTaskController.swift
//  StrideLearningApp
//
//  Created by Brittany Choy on 1/31/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import UIKit

protocol AddTask {
    func addTask(name: String)
}

class AddTaskController: UIViewController {
    
    @IBAction func addAction(_ sender: Any) {
        if nameTextField.text != "" {
            delegate?.addTask(name: nameTextField.text!)
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    
    var delegate: AddTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
