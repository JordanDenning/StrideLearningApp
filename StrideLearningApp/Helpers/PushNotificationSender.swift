//
//  PushNotificationSender.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 5/14/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import UIKit

class PushNotificationSender {
    func sendPushNotification(to token: String, title: String, body: String, badge: Int, chatroomId: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body, "badge": badge],
                                           "data" : ["user" : chatroomId]
                                            ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAZqYuleQ:APA91bGrGCunCNTDzvMxd_bbZJAIeMQx8gydJcAs2vda-ud4w0CAWJdQM1uJsys6GrLwrOhvPWh0DbRwHil5PguyGLJAnZNy-iGa9404rF8J21yjdbORLJzDVX7Xq_aVSdN_DqsoO-F0", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
