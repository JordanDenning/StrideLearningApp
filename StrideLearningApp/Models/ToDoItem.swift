//
//  ToDoItem.swift
//  StrideLearningApp
//
//  Created by Brittany Choy on 2/9/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import Foundation
import Firebase

struct ToDoItem {
    
    let ref: DatabaseReference?
    let key: String
    let name: String
    let addedByUser: String
    let day: String
    var completed: Bool
    var priority: Int
    
    init(name: String, addedByUser: String, day: String, completed: Bool, key: String = "", priority: Int) {
        self.ref = nil
        self.key = key
        self.name = name
        self.addedByUser = addedByUser
        self.day = day
        self.completed = completed
        self.priority = priority
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let addedByUser = value["addedByUser"] as? String,
            let day = value["day"] as? String,
            let priority = value["priority"] as? Int,
            let completed = value["completed"] as? Bool else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.name = name
        self.addedByUser = addedByUser
        self.day = day
        self.priority = priority
        self.completed = completed
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "addedByUser": addedByUser,
            "day": day,
            "priority": priority,
            "completed": completed
        ]
    }
}
