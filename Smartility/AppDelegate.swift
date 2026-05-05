//
//  AppDelegate.swift
//  Smartility
//
//  Created by Mani on 7/5/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import PushKit
import CallKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SWRevealViewControllerDelegate, UNUserNotificationCenterDelegate {
    
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().backItem?.title = ""        
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()
        
        requestNotificationAuthorization(application: application)
//        if let userInfo = launchOptions?[.remoteNotification] as? [AnyHashable: Any] {
//            NSLog("🥰 [UIApplication.LaunchOptionsKey.remoteNotification] applicationState: \(applicationStateString) didFinishLaunchingWithOptions for iOS9: \(userInfo)")
//            //TODO: Handle background notification
//            
//            if let aps = userInfo["aps"]  as? [String: Any] {
//                if let message = aps["alert"] as? [String: Any] {
//                    let _ = message["body"] as? String ?? "Welcome to PushNotify."
//                    let _ = message["title"] as? String ?? "Smartility"
////                    if let _ = userInfo["gcm.message_id"] as? String{
//                        print("---------> 👏 willPresent PayLoad 👏 --> 😍 \(aps)")
//                        if let push_topic = userInfo["push_topic"] as? String, push_topic == "visitor" {
//                            let visitor_name = userInfo["visitor_name"] as? String
//                            let visitor_img_url = userInfo["visitor_img_url"] as? String
//                            let visitor_cat = userInfo["visitor_cat"] as? String
//                            let Visitor_sub_cat = userInfo["visitor_sub_cat"] as? String
//                            let visitor_org = userInfo["visitor_org"] as? String
//                            let is_visitor_mask_on = userInfo["is_visitor_mask_on"] as? String
//                            let visitor_temp = userInfo["visitor_temp"] as? String
//                            let approval_user_id = userInfo["approval_user_id"] as? String
//                            let comm_id = userInfo["comm_id"] as? String
//                            let visit_id = userInfo["visit_id"] as? String
//                            let notif_sound = userInfo["notif_sound"] as? String ?? "doorbell"
//                                                      
//                            notificationSingletone.shared.payload = notificationPayloadData(notificationIdentifire: "", visitor_name: visitor_name, visitor_img_url: visitor_img_url, visitor_cat: visitor_cat, Visitor_sub_cat: Visitor_sub_cat, visitor_org: visitor_org, is_visitor_mask_on: is_visitor_mask_on, visitor_temp: visitor_temp, approval_user_id: approval_user_id, comm_id: comm_id, visit_id: visit_id, notif_sound: notif_sound)
//                            
//                            if #available(iOS 13.0, *) {
//                                guard let rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
//                                    return true
//                                }
//                                rootViewController.dismiss(animated: true) {
//                                    let controller = AppStoryboard.NotificationController.viewController(viewControllerClass: NotificationController.self)
//                                    controller.modalPresentationStyle = .fullScreen
//                                    rootViewController.present(controller, animated: true, completion: nil)
//                                }
//                            }else{
////                                window?.rootViewController?.dismiss(animated: true) {
//                                    let controller = AppStoryboard.NotificationController.viewController(viewControllerClass: NotificationController.self)
//                                    controller.modalPresentationStyle = .fullScreen
//                                    self.window?.rootViewController?.present(controller, animated: true, completion: nil)
////                                }
//                            }
//                        }
//                    }
//                }
//        }
        
//        let controller = AppStoryboard.RouteStoryBoard.viewController(viewControllerClass: RouteVC.self)
//        //            let controller = AppStoryboard.Main.viewController(viewControllerClass: WelcomViewController.self)
//        let nav_controller = UINavigationController(rootViewController: controller)
//        nav_controller.navigationBar.isHidden = true
//        self.window?.rootViewController =  nav_controller
//        self.window?.makeKeyAndVisible()
//        if let window = self.window {
//            UIView.transition(with: window, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {}, completion:
//                                { completed in
//                                })
//        }
        return true
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        UNUserNotificationCenter.current().delegate = self
        return true
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func requestNotificationAuthorization(application: UIApplication) {
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }
    
    
}






extension AppDelegate : MessagingDelegate {
    
    var applicationStateString: String {
        if UIApplication.shared.applicationState == .active {
            return "active"
        } else if UIApplication.shared.applicationState == .background {
            return "background"
        }else {
            return "inactive"
        }
    }
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Messaging.messaging().apnsToken = deviceToken as Data
    }
    
    
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        NSLog("👏 [didReceiveRegistrationToken] didRefreshRegistrationToken: 👍 ---> \(fcmToken ?? "")")
        notificationSingletone.shared.tokenStore = fcmToken ?? ""
        
        if UserDefaults.user_id != nil && UserDefaults.user_id != "" {
            let p = ["user_id": UserDefaults.user_id, "push_channel":"M", "push_sub": notificationSingletone.shared.tokenStore,"user_device_id": UIDevice.current.identifierForVendor?.uuidString ?? ""]
            print(p)
            Networking.shared.registerNotification(perams: p) { (success, error) in
                if success != nil {
                    
                }else{
                    print("failure")
                }
            }
        }
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        if UserDefaults.user_id != nil && UserDefaults.user_id != "" {
            let p = ["user_id": UserDefaults.user_id, "push_channel":"M", "push_sub": notificationSingletone.shared.tokenStore,"user_device_id": UIDevice.current.identifierForVendor?.uuidString ?? ""]        
            Networking.shared.registerNotification(perams: p) { (success, error) in
                if success != nil {
                    
                }else{
                    print("failure")
                }
            }
        }
    }
    
    // iOS9, called when presenting notification in foreground
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("🍎 --> [didReceiveRemoteNotification] applicationState: --> 🍎 \(applicationStateString) didReceiveRemoteNotification for iOS9 🍎: \(userInfo)")
            print(userInfo)
        if let aps = userInfo["aps"]  as? [String: Any] {
            if let message = aps["alert"] as? [String: Any] {
                let _ = message["body"] as? String ?? "Welcome to PushNotify."
                let _ = message["title"] as? String ?? "Smartility"
//                if let _ = userInfo["gcm.message_id"] as? String{
                    print("---------> 👏 willPresent PayLoad 👏 --> 😍 \(aps)")
                    if let push_topic = userInfo["push_topic"] as? String, push_topic == "visitor" {
                        let visitor_name = userInfo["visitor_name"] as? String
                        let visitor_img_url = userInfo["visitor_img_url"] as? String
                        let visitor_cat = userInfo["visitor_cat"] as? String
                        let Visitor_sub_cat = userInfo["visitor_sub_cat"] as? String
                        let visitor_org = userInfo["visitor_org"] as? String
                        let is_visitor_mask_on = userInfo["is_visitor_mask_on"] as? String
                        let visitor_temp = userInfo["visitor_temp"] as? String
                        let approval_user_id = userInfo["approval_user_id"] as? String
                        let comm_id = userInfo["comm_id"] as? String
                        let visit_id = userInfo["visit_id"] as? String
                        let notif_sound = userInfo["notif_sound"] as? String ?? "doorbell"
                                                    
                        notificationSingletone.shared.payload = notificationPayloadData(notificationIdentifire: "", visitor_name: visitor_name, visitor_img_url: visitor_img_url, visitor_cat: visitor_cat, Visitor_sub_cat: Visitor_sub_cat, visitor_org: visitor_org, is_visitor_mask_on: is_visitor_mask_on, visitor_temp: visitor_temp, approval_user_id: approval_user_id, comm_id: comm_id, visit_id: visit_id, notif_sound: notif_sound)
                        
                        if #available(iOS 13.0, *) {
                            guard let rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
                                return
                            }
                            rootViewController.dismiss(animated: true) {
                            let controller = AppStoryboard.NotificationController.viewController(viewControllerClass: NotificationController.self)
                            controller.modalPresentationStyle = .fullScreen
                            rootViewController.present(controller, animated: true, completion: nil)
                            }
                        }else{
//                            window?.rootViewController?.dismiss(animated: true) {
                                let controller = AppStoryboard.NotificationController.viewController(viewControllerClass: NotificationController.self)
                                controller.modalPresentationStyle = .fullScreen
                                self.window?.rootViewController?.present(controller, animated: true, completion: nil)
//                            }
                        }
                    }
                }
//            }
        }
    }
}

extension AppDelegate  {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        NSLog("👏 [didReceiveRegistrationToken] didRefreshRegistrationToken: 👍 ---> \(notification.request.content.userInfo)")
        print("---------> 😍 willPresent")
        if let userInfo = notification.request.content.userInfo as? [String : AnyHashable]{
            print(userInfo)
            if let aps = userInfo["aps"]  as? [String: Any] {
                if let message = aps["alert"] as? [String: Any] {
                    let _ = message["body"] as? String ?? "Welcome to PushNotify."
                    let _ = message["title"] as? String ?? "Smartility"
//                    if let _ = userInfo["gcm.message_id"] as? String{
                        print("---------> 👏 willPresent PayLoad 👏 --> 😍 \(aps)")
                        if let push_topic = userInfo["push_topic"] as? String, push_topic == "visitor" {
                            let visitor_name = userInfo["visitor_name"] as? String
                            let visitor_img_url = userInfo["visitor_img_url"] as? String
                            let visitor_cat = userInfo["visitor_cat"] as? String
                            let Visitor_sub_cat = userInfo["visitor_sub_cat"] as? String
                            let visitor_org = userInfo["visitor_org"] as? String
                            let is_visitor_mask_on = userInfo["is_visitor_mask_on"] as? String
                            let visitor_temp = userInfo["visitor_temp"] as? String
                            let approval_user_id = userInfo["approval_user_id"] as? String
                            let comm_id = userInfo["comm_id"] as? String
                            let visit_id = userInfo["visit_id"] as? String
                            let notif_sound = userInfo["notif_sound"] as? String ?? "doorbell"
                                                      
                            notificationSingletone.shared.payload = notificationPayloadData(notificationIdentifire: notification.request.identifier, visitor_name: visitor_name, visitor_img_url: visitor_img_url, visitor_cat: visitor_cat, Visitor_sub_cat: Visitor_sub_cat, visitor_org: visitor_org, is_visitor_mask_on: is_visitor_mask_on, visitor_temp: visitor_temp, approval_user_id: approval_user_id, comm_id: comm_id, visit_id: visit_id, notif_sound: notif_sound)
                            
                            if #available(iOS 13.0, *) {
                                guard let rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
                                    return
                                }
                                rootViewController.dismiss(animated: true) {
                                    let controller = AppStoryboard.NotificationController.viewController(viewControllerClass: NotificationController.self)
                                    controller.modalPresentationStyle = .fullScreen
                                    rootViewController.present(controller, animated: true, completion: nil)
                                }
                            }else{
//                                window?.rootViewController?.dismiss(animated: true) {
                                    let controller = AppStoryboard.NotificationController.viewController(viewControllerClass: NotificationController.self)
                                    controller.modalPresentationStyle = .fullScreen
                                    self.window?.rootViewController?.present(controller, animated: true, completion: nil)
//                                }
                            }
                        }
                    }
                }
//            }
        }
        completionHandler([.banner, .badge, .sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("---------> 😍 didReceive response")
        NSLog("👏 [didReceiveRegistrationToken] didRefreshRegistrationToken: 👍 ---> \(response.notification.request.content.userInfo)")
        if let userInfo = response.notification.request.content.userInfo as? [String : AnyHashable]{
            print(userInfo)
            if let aps = userInfo["aps"]  as? [String: Any] {
                if let message = aps["alert"] as? [String: Any] {
                    let _ = message["body"] as? String ?? "Welcome to PushNotify."
                    let _ = message["title"] as? String ?? "Smartility"
                        if let push_topic = userInfo["push_topic"] as? String, push_topic == "visitor" {
                            let visitor_name = userInfo["visitor_name"] as? String
                            let visitor_img_url = userInfo["visitor_img_url"] as? String
                            let visitor_cat = userInfo["visitor_cat"] as? String
                            let Visitor_sub_cat = userInfo["visitor_sub_cat"] as? String
                            let visitor_org = userInfo["visitor_org"] as? String
                            let is_visitor_mask_on = userInfo["is_visitor_mask_on"] as? String
                            let visitor_temp = userInfo["visitor_temp"] as? String
                            let approval_user_id = userInfo["approval_user_id"] as? String
                            let comm_id = userInfo["comm_id"] as? String
                            let visit_id = userInfo["visit_id"] as? String
                            let notif_sound = userInfo["notif_sound"] as? String ?? "doorbell"
                            
                            let time_stamp = userInfo["notif_timestamp"] as? String ?? ""
                                                                             
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                            dateFormatter.timeZone = TimeZone(identifier: "UTC")
                            
                            let current_Time = Date()
                             let time = dateFormatter.string(from: current_Time)
                            guard let c_time = dateFormatter.date(from: time) else { return }
                            let calendar = Calendar.current
                            
                            if let date = dateFormatter.date(from: time_stamp), let seconds = calendar.dateComponents([.second], from: date, to: c_time)
                                .second {
                                                                                        
                                if seconds > 60 {
                                    if #available(iOS 13.0, *) {
                                        guard let rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
                                            return
                                        }
                                        rootViewController.showConfirmAlert(title: "", message: "Sorry, the notification is expired", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                                    }else{
                                        window?.rootViewController?.showConfirmAlert(title: "", message: "Sorry, the notification is expired", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                                    }
                                }else{
                                    notificationSingletone.shared.payload = notificationPayloadData(notificationIdentifire: response.notification.request.identifier, visitor_name: visitor_name, visitor_img_url: visitor_img_url, visitor_cat: visitor_cat, Visitor_sub_cat: Visitor_sub_cat, visitor_org: visitor_org, is_visitor_mask_on: is_visitor_mask_on, visitor_temp: visitor_temp, approval_user_id: approval_user_id, comm_id: comm_id, visit_id: visit_id, notif_sound: notif_sound)
                                    
                                    if #available(iOS 13.0, *) {
                                        guard let rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
                                            return
                                        }
                                        rootViewController.dismiss(animated: true) {
                                            let controller = AppStoryboard.NotificationController.viewController(viewControllerClass: NotificationController.self)
                                            controller.modalPresentationStyle = .fullScreen
                                            rootViewController.present(controller, animated: true, completion: nil)
                                        }
                                    }else{
//                                        getTopWindow()?.rootViewController?.dismiss(animated: true) {
                                            let controller = AppStoryboard.NotificationController.viewController(viewControllerClass: NotificationController.self)
                                            controller.modalPresentationStyle = .fullScreen
                                            getTopWindow()?.rootViewController?.present(controller, animated: true, completion: nil)
//                                        }
                                    }
                                }
                                
                            }
                        }
                        print("---------> 👏 didReceive response 👏 --> 😍 \(aps)")
                }
            }
        }
        
        completionHandler()
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("---------> 😍 didReceiveRemoteNotification")
                        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        if let aps = userInfo["aps"]  as? [String: Any] {
            if let message = aps["alert"] as? [String: Any] {
                let _ = message["body"] as? String ?? "Welcome to PushNotify."
                let _ = message["title"] as? String ?? "Smartility"
                    
                    if let push_topic = userInfo["push_topic"] as? String, push_topic == "visitor" {
                        let visitor_name = userInfo["visitor_name"] as? String
                        let visitor_img_url = userInfo["visitor_img_url"] as? String
                        let visitor_cat = userInfo["visitor_cat"] as? String
                        let Visitor_sub_cat = userInfo["visitor_sub_cat"] as? String
                        let visitor_org = userInfo["visitor_org"] as? String
                        let is_visitor_mask_on = userInfo["is_visitor_mask_on"] as? String
                        let visitor_temp = userInfo["visitor_temp"] as? String
                        let approval_user_id = userInfo["approval_user_id"] as? String
                        let comm_id = userInfo["comm_id"] as? String
                        let visit_id = userInfo["visit_id"] as? String
                        let notif_sound = userInfo["notif_sound"] as? String ?? "doorbell"
                        
                        let time_stamp = userInfo["notif_timestamp"] as? String ?? ""
                                                                            
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        dateFormatter.timeZone = TimeZone(identifier: "UTC")
                        
                        let current_Time = Date()
                            let time = dateFormatter.string(from: current_Time)
                        guard let c_time = dateFormatter.date(from: time) else { return }
                        let calendar = Calendar.current
                        
                        if let date = dateFormatter.date(from: time_stamp), let seconds = calendar.dateComponents([.second], from: date, to: c_time)
                            .second {
                                                                                    
                            if seconds > 60 {
                                if #available(iOS 13.0, *) {
                                    guard let rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
                                        return
                                    }
                                    rootViewController.showConfirmAlert(title: "", message: "Sorry, the notification is expired", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                                }else{
                                    window?.rootViewController?.showConfirmAlert(title: "", message: "Sorry, the notification is expired", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                                }
                            }else{
                                notificationSingletone.shared.payload = notificationPayloadData(notificationIdentifire: "", visitor_name: visitor_name, visitor_img_url: visitor_img_url, visitor_cat: visitor_cat, Visitor_sub_cat: Visitor_sub_cat, visitor_org: visitor_org, is_visitor_mask_on: is_visitor_mask_on, visitor_temp: visitor_temp, approval_user_id: approval_user_id, comm_id: comm_id, visit_id: visit_id, notif_sound: notif_sound)
                                
                                if #available(iOS 13.0, *) {
                                    guard let rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
                                        return
                                    }
                                    rootViewController.dismiss(animated: true) {
                                        let controller = AppStoryboard.NotificationController.viewController(viewControllerClass: NotificationController.self)
                                        controller.modalPresentationStyle = .fullScreen
                                        rootViewController.present(controller, animated: true, completion: nil)
                                    }
                                    }else{
//                                    getTopWindow()?.rootViewController?.dismiss(animated: true) {
                                        let controller = AppStoryboard.NotificationController.viewController(viewControllerClass: NotificationController.self)
                                        controller.modalPresentationStyle = .fullScreen
                                        getTopWindow()?.rootViewController?.present(controller, animated: true, completion: nil)
//                                    }
                                }
                            }
                            
                        }
                    print("---------> 👏 didReceive response 👏 --> 😍 \(aps)")
                }
            }
        }
        print("😘 ------> didReceiveRemoteNotification Userinfo in Background Mode On -----> 😍 \(userInfo) 😍")
        completionHandler(.newData)
    }
}
