//
//  menuController.swift
//  Smartility
//
//  Created by Mani on 12/30/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//


import UIKit
import MessageUI

class menuController: UIViewController {
    
    
    @IBOutlet weak var profile: UIButton!
    @IBOutlet weak var logout: UIButton!
    @IBOutlet weak var contactSupport: UIButton!
    @IBOutlet weak var invoicePaymentBtn: UIButton!
    @IBOutlet weak var appVersion: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        profile.addTarget(self, action: #selector(profileCLicked), for: .touchUpInside)
        logout.addTarget(self, action: #selector(logoutClicked), for: .touchUpInside)
        logout.addLine(position: .LINE_POSITION_BOTTOM, color: UIColor.black.withAlphaComponent(0.7), width: 1.0)
        contactSupport.addTarget(self, action: #selector(contactSupportClicked), for: .touchUpInside)
        contactSupport.addLine(position: .LINE_POSITION_BOTTOM, color: UIColor.black.withAlphaComponent(0.7), width: 1.0)
        if let appVersionStr = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion.text = "App Ver "+appVersionStr
        }
        
        
        invoicePaymentBtn.mk_addTapHandler { (btn) in
            let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: Invoice_Payment_ViewController.self)
            if let viewController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController{
                self.dismiss(animated: true) {
                    viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                    viewController.pushViewController(controller, animated: true)
                }
            }
            
//            navigationControllerClass.shared.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    @objc
    func profileCLicked(){
        let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: ProfileViewController.self)
        if let viewController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController{
            self.dismiss(animated: true) {
                viewController.pushViewController(controller, animated: true)
            }
        }
    }
    
    @objc
    func logoutClicked(){
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to logout?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Logout", style: .default) { (action:UIAlertAction) in
            community.community_id = ""
            community.community_name = ""
            community.cust_location = ""
            community.cust_unitId = ""
            
            UserDefaults.cust_id = ""
            UserDefaults.user_id = ""
            UserDefaults.standard.removeObject(forKey: "topModel")
            UserDefaults.standard.removeObject(forKey: "Index")
            let controller = AppStoryboard.Main.viewController(viewControllerClass: WelcomViewController.self)
            let nav_controller = UINavigationController(rootViewController: controller)
            nav_controller.navigationBar.isHidden = true
            getTopWindow()?.rootViewController =  nav_controller
            getTopWindow()?.makeKeyAndVisible()
            if let window = getTopWindow() {
                UIView.transition(with: window, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {}, completion:
                                    { completed in
                                    })
            }
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
        }
        alertController.addAction(action1)
        alertController.addAction(action2)
        if let viewController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController{
            self.dismiss(animated: true) {
                viewController.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    @objc
    func contactSupportClicked(){
        sendEmail()
    }
    
    func sendEmail() {
        if let viewController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController{
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()                
                mail.setToRecipients([CommunityData.support_email])
                self.dismiss(animated: true) {
                    viewController.present(mail, animated: true)
                }
            }
        } else {
            // show failure alert
        }
    }
}
