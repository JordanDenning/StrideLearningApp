//
//  Message.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 1/20/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    
    var chatroomId: String?
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    var toName: String?
    
    init(dictionary: [String: Any]) {
        self.chatroomId = dictionary["chatroomId"] as? String
        self.fromId = dictionary["fromId"] as? String
        self.text = dictionary["text"] as? String
        self.toId = dictionary["toId"] as? String
        self.toName = dictionary["toName"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
    }
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
    
}
