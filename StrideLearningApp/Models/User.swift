//
//  User.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 1/20/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import UIKit

class User: NSObject {
    var id: String?
    var name: String?
    var firstName: String?
    var lastName: String?
    var grade: String?
    var school: String?
    var email: String?
    var profileImageUrl: String?
    var type: String?
    var student: String?
    var students: [Student?]
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.grade = dictionary["grade"] as? String ?? ""
        self.school = dictionary["school"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
        self.type = dictionary["type"] as? String
        self.student = dictionary["student"] as? String
        self.students = dictionary["students"] as? [Student] ?? []
    }

}
