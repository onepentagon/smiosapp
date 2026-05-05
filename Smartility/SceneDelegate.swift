//
//  SceneDelegate.swift
//  Smartility
//
//  Created by Mani on 7/5/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import Firebase

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate, SWRevealViewControllerDelegate {
    
    var window: UIWindow?
    var blurredEffectView: UIVisualEffectView?
    var updateAppView =  UpdateAppView().loadNib() as? UpdateAppView
    
    
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//        guard (scene is UIWindowScene) else { return }
//        
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
        
        guard let windowScene = scene as? UIWindowScene else { return }

            window = UIWindow(windowScene: windowScene)

            // 🔥 App opened by notification tap
            if let response = connectionOptions.notificationResponse {
                handleNotification(response.notification.request.content.userInfo)
            } else {
                showRouteVC()
            }

            window?.makeKeyAndVisible()
    }
    
    
    func showRouteVC() {
        let vc = AppStoryboard.RouteStoryBoard
            .viewController(viewControllerClass: RouteVC.self)

        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.isHidden = true
        window?.rootViewController = nav
    }

    
    func handleNotification(_ userInfo: [AnyHashable: Any]) {

        // 1️⃣ Always show RouteVC first
        showRouteVC()

        guard
            let pushTopic = userInfo["push_topic"] as? String,
            pushTopic == "visitor"
        else { return }

        // 2️⃣ Store payload
        notificationSingletone.shared.payload =
            notificationPayloadData(
                notificationIdentifire: "",
                visitor_name: userInfo["visitor_name"] as? String,
                visitor_img_url: userInfo["visitor_img_url"] as? String,
                visitor_cat: userInfo["visitor_cat"] as? String,
                Visitor_sub_cat: userInfo["visitor_sub_cat"] as? String,
                visitor_org: userInfo["visitor_org"] as? String,
                is_visitor_mask_on: userInfo["is_visitor_mask_on"] as? String,
                visitor_temp: userInfo["visitor_temp"] as? String,
                approval_user_id: userInfo["approval_user_id"] as? String,
                comm_id: userInfo["comm_id"] as? String,
                visit_id: userInfo["visit_id"] as? String,
                notif_sound: userInfo["notif_sound"] as? String ?? ""
            )

        // 3️⃣ Present AFTER root is ready
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            guard
                let nav = self.window?.rootViewController as? UINavigationController,
                let topVC = nav.topViewController
            else { return }

            let notificationVC = AppStoryboard.NotificationController
                .viewController(viewControllerClass: NotificationController.self)

            notificationVC.modalPresentationStyle = .fullScreen
            topVC.present(notificationVC, animated: true)
        }
    }


    
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
        
        
        Networking.shared.getLiveVersionNumber { curLiveAppVersion in
            if let curLiveAppVersion = curLiveAppVersion {
                Networking.shared.checkUpdate { (result, error) in
                    if let result = result {
                        var curInstalledAppVersion = ""
                        if let appVersionStr = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String { curInstalledAppVersion = appVersionStr }
                        let minReqAppVersion = result["min_req_app_ver_ios"] as? String ?? ""
                        if (curInstalledAppVersion < curLiveAppVersion){
                            if curInstalledAppVersion < minReqAppVersion {
                                self.setupUpdateUI(showNotNowBtn: false)
                                self.updateAppView?.notNowBtn.isHidden = true
                                self.updateAppView?.updateNowBtn.setClickListener {
                                    UIApplication.shared.open(URL(string: "https://apps.apple.com/bh/app/smartility-gate/id1533521084")!, options: [:], completionHandler: nil)
                                }
                            }else{
                                self.setupUpdateUI(showNotNowBtn: true)
                                self.updateAppView?.updateNowBtn.setClickListener {
                                    UIApplication.shared.open(URL(string: "https://apps.apple.com/bh/app/smartility-gate/id1533521084")!, options: [:], completionHandler: nil)
                                }
                                self.updateAppView?.notNowBtn.setClickListener {
                                    UIView.animate(withDuration: 0.2) {
                                        self.updateAppView?.alpha = 0.0
                                    } completion: { (com) in
                                        self.blurredEffectView?.removeFromSuperview()
                                    }
                                }
                                self.updateAppView?.notNowBtn.isHidden = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func setupUpdateUI(showNotNowBtn: Bool) {
        self.updateAppView?.removeFromSuperview()
        self.blurredEffectView?.removeFromSuperview()
        let blurEffect = UIBlurEffect(style: .dark)
        self.blurredEffectView = UIVisualEffectView(effect: blurEffect)
        self.blurredEffectView?.frame = UIScreen.main.bounds
        getTopWindow()?.rootViewController?.view?.addSubview(self.blurredEffectView!)
        getTopWindow()?.rootViewController?.view?.addSubview(self.updateAppView!)
        self.updateAppView?.layoutAnchor(top: nil, left: self.blurredEffectView?.leftAnchor, bottom: nil, right: self.blurredEffectView?.rightAnchor, centerX: self.blurredEffectView?.centerXAnchor, centerY: self.blurredEffectView?.centerYAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: showNotNowBtn == true ? 304 : 256, enableInsets: true)
        self.updateAppView?.setupUI()
        self.updateAppView?.layer.cornerRadius = 6
        self.updateAppView?.layer.masksToBounds = true
        self.blurredEffectView?.bringSubviewToFront(self.updateAppView!)
        UIView.animate(withDuration: 0.2) {
            self.updateAppView?.alpha = 1.0
        } completion: { (com) in
        }
    }
    
    
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

extension String {
    
    static func ==(lhs: String, rhs: String) -> Bool {
        return lhs.compare(rhs, options: .numeric) == .orderedSame
    }
    
    static func <(lhs: String, rhs: String) -> Bool {
        return lhs.compare(rhs, options: .numeric) == .orderedAscending
    }
    
    static func <=(lhs: String, rhs: String) -> Bool {
        return lhs.compare(rhs, options: .numeric) == .orderedAscending || lhs.compare(rhs, options: .numeric) == .orderedSame
    }
    
    static func >(lhs: String, rhs: String) -> Bool {
        return lhs.compare(rhs, options: .numeric) == .orderedDescending
    }
    
    static func >=(lhs: String, rhs: String) -> Bool {
        return lhs.compare(rhs, options: .numeric) == .orderedDescending || lhs.compare(rhs, options: .numeric) == .orderedSame
    }
    
}


enum VersionError: Error {
    case invalidBundleInfo, invalidResponse
}

class LookupResult: Decodable {
    var results: [AppInfo]
}

class AppInfo: Decodable {
    var version: String
    var trackViewUrl: String
}
