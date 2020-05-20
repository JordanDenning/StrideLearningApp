//
//  AppDelegate.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 1/18/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  let gcmMessageIDKey = "gcm.message_id"
  static var DEVICEID = String()
  var currentChatPageId = String()
    var messagesVC:MessagesController?
    var profileVC:ProfileController?
    var plannerVC:PlannerOverallController?


func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
    window = UIWindow(frame: UIScreen.main.bounds)
    
    let tabBar = TabBarController()
    window?.rootViewController = tabBar

    window?.makeKeyAndVisible()
        //previous line replace using storyboards to just use viewcontroller code for layouts, better for when working in teams. Sets first view controller to tabBarController
        
          // [START set_messaging_delegate]
            Messaging.messaging().delegate = self
    
            // [END set_messaging_delegate]
            // Register for remote notifications. This shows a permission dialog on first run, to
            // show the dialog at a more appropriate time move this registration accordingly.
            // [START register_for_notifications]
            if #available(iOS 10.0, *) {
              // For iOS 10 display notification (sent via APNS)
              UNUserNotificationCenter.current().delegate = self

              let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
              UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            } else {
              let settings: UIUserNotificationSettings =
              UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
              application.registerUserNotificationSettings(settings)
            }

            application.registerForRemoteNotifications()

            // [END register_for_notifications]
            return true
          }

    func applicationDidEnterBackground(_ application: UIApplication) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).child("notifications").observe(.value, with: { (snapshot) in
            
           if let notifications = snapshot.value as? Int {
            UIApplication.shared.applicationIconBadgeNumber = notifications
            }
            
        }, withCancel: nil)
         
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        UIApplication.shared.applicationIconBadgeNumber = 5

        completionHandler(.newData)
    }

//          // [START receive_message]
//          func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//            // If you are receiving a notification message while your app is in the background,
//            // this callback will not be fired till the user taps on the notification launching the application.
//            // TODO: Handle data of notification
//            // With swizzling disabled you must let Messaging know about the message, for Analytics
//            // Messaging.messaging().appDidReceiveMessage(userInfo)
//            // Print message ID.
//            if let messageID = userInfo[gcmMessageIDKey] {
//              print("Message ID: \(messageID)")
//            }
//
//            // Print full message.
//            print(userInfo)
//          }

          func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            // If you are receiving a notification message while your app is in the background,
            // this callback will not be fired till the user taps on the notification launching the application.
            // TODO: Handle data of notification
            // With swizzling disabled you must let Messaging know about the message, for Analytics
            // Messaging.messaging().appDidReceiveMessage(userInfo)
            // Print message ID.
            if let messageID = userInfo[gcmMessageIDKey] {
              print("Message ID: \(messageID)")
            }

            // Print full message.
            print(userInfo)

            completionHandler(UIBackgroundFetchResult.newData)
          }
          // [END receive_message]
          func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
            print("Unable to register for remote notifications: \(error.localizedDescription)")
          }

          // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
          // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
          // the FCM registration token.
          func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            print("APNs token retrieved: \(deviceToken)")
            AppDelegate.DEVICEID = deviceToken.description

            // With swizzling disabled you must set the APNs token here.
            // Messaging.messaging().apnsToken = deviceToken
          }
        }

        // [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

          // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                      willPresent notification: UNNotification,
            withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            let userInfo = notification.request.content.userInfo

            // With swizzling disabled you must let Messaging know about the message, for Analytics
            // Messaging.messaging().appDidReceiveMessage(userInfo)
            // Print message ID.
            if let messageID = userInfo[gcmMessageIDKey] {
              print("Message ID: \(messageID)")
            }
        
        guard let uid = Auth.auth().currentUser?.uid else {
                       return
                   }
                   
                   let chatroomId = userInfo["user"] as! String
        let chatroomArr = chatroomId.components(separatedBy: "_")
            var chatPartnerId = uid
        if uid == chatroomArr[0]{
            chatPartnerId = chatroomArr[1]
        } else {
            chatPartnerId = chatroomArr[0]
        }

        
                   

            // Print full message.
            print(userInfo)
            
            //if chat log is top controller, don't recieve notification, set notifications to 0 since you see it
        if self.window?.rootViewController?.topViewController is ChatLogController && chatPartnerId == currentChatPageId {
                let refNotify = Database.database().reference().child("messages").child(chatroomId).child(uid)
                refNotify.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let messageNotifications = snapshot.value as? Int else {
                    return
                }

                    let ref = Database.database().reference().child("users").child(uid).child("notifications")
                    ref.observeSingleEvent(of: .value, with:{ (snapshot) in
                    guard let overallNotifications = snapshot.value as? Int else {
                        return
                    }
                        let notifications = overallNotifications - messageNotifications
                        ref.setValue(notifications)
                    }, withCancel: nil)
                    refNotify.setValue(0)
                }, withCancel: nil)
                completionHandler([])
                
            } else if self.window?.rootViewController?.topViewController is MessagesController {
                completionHandler([])
            } else {
                //recieve when in app
                completionHandler([.alert, .badge, .sound])
            }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                      didReceive response: UNNotificationResponse,
                                      withCompletionHandler completionHandler: @escaping () -> Void) {
            let userInfo = response.notification.request.content.userInfo
            // Print message ID.
            if let messageID = userInfo[gcmMessageIDKey] {
              print("Message ID: \(messageID)")
            }
            
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            
            let chatroomId = userInfo["user"] as! String
            let chatroomArr = chatroomId.components(separatedBy: "_")
            var chatPartnerId = uid
        if uid == chatroomArr[0]{
            chatPartnerId = chatroomArr[1]
        } else {
            chatPartnerId = chatroomArr[0]
        }
            
            let refNotify = Database.database().reference().child("messages").child(chatroomId).child(uid)
            refNotify.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let messageNotifications = snapshot.value as? Int else {
                return
            }

                let ref = Database.database().reference().child("users").child(uid).child("notifications")
                ref.observeSingleEvent(of: .value, with:{ (snapshot) in
                guard let overallNotifications = snapshot.value as? Int else {
                    return
                }
                    let notifications = overallNotifications - messageNotifications
                    ref.setValue(notifications)
                }, withCancel: nil)
                refNotify.setValue(0)
            }, withCancel: nil)

        // Print full message.
        print(userInfo)

        //open notification to specific chat page
        if self.window?.rootViewController?.topViewController is ChatLogController && chatPartnerId == currentChatPageId {
            //if left in chatLogcontroller for user nothing happens
            completionHandler()
        } else {
            // else open new chat log page for user you got notification from
            let ref = Database.database().reference().child("users").child(chatPartnerId)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let user = User(dictionary: dictionary)
                user.id = chatPartnerId
                self.showChatControllerForUser(user)
                print(userInfo)

                completionHandler()
                
            }, withCancel: nil)
        }
    }
    
    func showChatControllerForUser(_ user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
            chatLogController.user = user
        if (self.window?.rootViewController?.topViewController as? NewMessageController) != nil {
            messagesVC?.dismiss(animated: true, completion: nil)
        }
        if (self.window?.rootViewController?.topViewController as? EditProfileController) != nil {
            profileVC?.dismiss(animated: true, completion: nil)
        }
        if (self.window?.rootViewController?.topViewController as? EditPasswordController) != nil {
            profileVC?.dismiss(animated: true, completion: nil)
        }
         if let alert = self.window?.rootViewController?.topViewController as? UIAlertController{
             alert.dismiss(animated: true, completion: nil)
        }
        if  let student  = self.window?.rootViewController?.topViewController as? StudentList{
            student.dismiss(animated: true, completion: nil)
        }
        if (self.window?.rootViewController?.topViewController as? MentorCollectionView) != nil {
                plannerVC?.dismiss(animated: true, completion: nil)
        }
        if (self.window?.rootViewController?.topViewController as? ChatLogController) != nil {
            messagesVC?.navigationController?.popViewController(animated: true)
        }
        if let nav = self.window?.rootViewController as? TabBarController{
                nav.selectedViewController = nav.viewControllers?[1]
                messagesVC!.showChatControllerForUser(user)
        }
    }

}
        // [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
          // [START refresh_token]
          func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
            print("Firebase registration token: \(fcmToken)")
            AppDelegate.DEVICEID = fcmToken
            
            let dataDict:[String: String] = ["token": fcmToken]
            NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
            // TODO: If necessary send token to application server.
            // Note: This callback is fired at each app startup and whenever a new token is generated.
          }
          // [END refresh_token]
    }
