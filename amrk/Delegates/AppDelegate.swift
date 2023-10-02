//
//  AppDelegate.swift
//  amrk
//
//  Created by yousef on 12/08/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import MOLH
import GoogleMaps
import FirebaseMessaging
import Firebase

extension UIStoryboard {
    static let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var window: UIWindow?
    
    var rootNavigationViewController: UINavigationController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        MOLH.shared.activate(true)
        RequestBuilder.shared.updateHeader()
        GMSServices.provideAPIKey("AIzaSyC2BUJtK-VTChkYIKSfOQcOYzrO8wTdo00")
        if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self
          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization( options: authOptions, completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification     : [AnyHashable : Any]) {
        
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//          print("Message ID: \(messageID)")
//        }

        // Print full message.
        print(userInfo)

        // Change this to your preferred presentation option
        
        completionHandler([.alert, .badge, .sound])
      }

      func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  didReceive response: UNNotificationResponse,
                                  withCompletionHandler completionHandler: @escaping () -> Void) {
          
          
        let userInfo = response.notification.request.content.userInfo
          
          do {
              let jsonData = Data((userInfo[AnyHashable("gcm.notification.data")] as! String).utf8)
              
              let data = try JSONDecoder().decode(NotificationDataModel.self, from: jsonData)
              
              if let type = data.type, type == "review" {
                  if let orderId = data.orderID {
                      if let window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window {
                          let mainTabbarVC = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "MainTabbarViewController")
                          
                          let orderDetailsVC = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
                          
                          orderDetailsVC.orderId = Int(orderId) ?? 0
                          orderDetailsVC.isOpenReview = true
                          orderDetailsVC.isFromOrders = false
                          
                          let navController = UINavigationController()
                              navController.modalPresentationStyle = .fullScreen
                          
                          navController.setViewControllers([mainTabbarVC, orderDetailsVC], animated: true)
                          
                          navController.navigationBar.isHidden = true
                          
                          window.rootViewController = navController
                                   
                          
                          window.makeKeyAndVisible()
                      }
                  }
                  
              }
              
              if let orderId = data.orderID {
                  if let window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window {
                      let mainTabbarVC = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "MainTabbarViewController")
                      
                      let orderDetailsVC = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
                      
                      orderDetailsVC.orderId = Int(orderId) ?? 0
                      orderDetailsVC.isOpenReview = false
                      orderDetailsVC.isFromOrders = false
                      
                      let navController = UINavigationController()
                          navController.modalPresentationStyle = .fullScreen
                      
                      navController.setViewControllers([mainTabbarVC, orderDetailsVC], animated: true)
                      
                      navController.navigationBar.isHidden = true
                      
                      window.rootViewController = navController
                               
                      
                      window.makeKeyAndVisible()
                  }
              }
              
          } catch {
              print(error.localizedDescription)
          }

        completionHandler()
      }
}


extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "")")

        let dataDict:[String: String] = ["token": fcmToken!]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }

}
