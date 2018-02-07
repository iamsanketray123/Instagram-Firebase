//
//  AppDelegate.swift
//  Instagram Firebase
//
//  Created by Sanket  Ray on 18/01/18.
//  Copyright © 2018 Sanket  Ray. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        window = UIWindow()
        window?.rootViewController = MainTabBarController()
        attemptRegisterForNotification(application: application)
        return true
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("registerd for notifications", deviceToken)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Registered with fcm token", fcmToken)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    private func attemptRegisterForNotification(application : UIApplication) {
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        let options : UNAuthorizationOptions = [.alert,.badge,.sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, err) in
            if let err = err {
                print("failed to reqeuest auth:", err)
                return
            }
            if granted {
                print("Successfully granted Auth")
            } else {
                print("Auth denied")
            }
        }
        application.registerForRemoteNotifications()
    }

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        if let followerId = userInfo["followerId"] as? String {
//        I want to push the UserProfileController for followerId somehow
            let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
            userProfileController.userId = followerId
            
//        Now we need to display the follower's user profile
            if let mainTabBarController = window?.rootViewController as? MainTabBarController {
                
                mainTabBarController.selectedIndex = 0
                mainTabBarController.presentedViewController?.dismiss(animated: true, completion: nil)
                
                if let homeNavigationContrller = mainTabBarController.viewControllers?.first as? UINavigationController {
                    homeNavigationContrller.pushViewController(userProfileController, animated: true)
                }
            }
        }
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

