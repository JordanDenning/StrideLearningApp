//
//  Constants.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 1/18/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import Foundation
import Firebase

struct Constants
{
    struct refs {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("chats")
    }
}
