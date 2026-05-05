//
//  RouteVC.swift
//  Smartility
//
//  Created by Mani Kandan on 30/06/2021.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit

class RouteVC: UIViewController {
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first

        if UserDefaults.ApiKey.count == 0 {
            let controller = AppStoryboard.Main.viewController(viewControllerClass: WelcomViewController.self)
            let nav_controller = UINavigationController(rootViewController: controller)
            nav_controller.navigationBar.isHidden = true

            keyWindow?.rootViewController =  nav_controller
            keyWindow?.makeKeyAndVisible()
            if let window = keyWindow {
                UIView.transition(with: window, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {}, completion:{ completed in })
            }
        }else{
            Networking.shared.authorizeApi { result, error in
                if let _ = result {
                    let frontViewController = AppStoryboard.Dashboard.viewController(viewControllerClass: DashBoardController.self)
                    let nav_controller = UINavigationController(rootViewController: frontViewController)
                    UIApplication.shared.keyWindow?.window?.rootViewController = nav_controller
                    
                    keyWindow?.rootViewController =  nav_controller
                    keyWindow?.makeKeyAndVisible()
                    if let window = keyWindow {
                        UIView.transition(with: window, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {}, completion:
                                            { completed in
                                            })
                    }
                }else{
                    self.view.makeToast("Previous session expired, please login again", duration: 3.0, position: .bottom)
                    let controller = AppStoryboard.Main.viewController(viewControllerClass: WelcomViewController.self)
                    let nav_controller = UINavigationController(rootViewController: controller)
                    nav_controller.navigationBar.isHidden = true
                    keyWindow?.rootViewController =  nav_controller
                    keyWindow?.makeKeyAndVisible()
                    if let window = keyWindow {
                        UIView.transition(with: window, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {}, completion:
                                            { completed in
                                            })
                    }
                }
            }
        }
    }
}
