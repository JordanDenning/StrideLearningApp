//
//  Student.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 3/5/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import Foundation
import Firebase

class Student: NSObject {
    
    let ref: DatabaseReference?
    var name: String?
    var ID: String?
    var grade: String?
    var school: String?
    var profileImageUrl: String?
    
    init(name: String, ID: String, grade: String, school: String, profileImageUrl: String) {
        self.ref = nil
        self.name = name
        self.ID = ID
        self.grade = grade
        self.school = school
        self.profileImageUrl = profileImageUrl
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let ID = value["ID"] as? String,
            let grade = value["grade"] as? String,
            let school = value["school"] as? String,
            let profileImageUrl = value["profileImageUrl"] as? String else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.name = name
        self.ID = ID
        self.grade = grade
        self.school = school
        self.profileImageUrl = profileImageUrl
    
}
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "ID": ID,
            "grade": grade,
            "school": school,
            "profileImageUrl": profileImageUrl
        ]
    }
    
}
