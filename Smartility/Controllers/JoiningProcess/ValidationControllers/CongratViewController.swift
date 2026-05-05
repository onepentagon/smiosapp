//
//  CongratViewController.swift
//  Smartility
//
//  Created by Mani on 7/11/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit

class CongratViewController: UIViewController {

    @IBOutlet weak var containerShow: UIView!
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var communityLabel: UILabel!
    
    
    var is_verified_user = Bool()
    var is_Admin = Bool()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeBtn.backgroundColor = brandColor()
        containerShow.layer.borderColor = brandColor().cgColor
        containerShow.layer.borderWidth = 1.0
        labelText.textColor = brandColor()
        
        if (is_verified_user && !is_Admin) {
            labelText.text = "Your resident identity verified successfully. You can start using the app right away!"
        }else if !is_Admin {
            labelText.text = "You will be notified as soon as your community admin accepts your request"
        }else{
            labelText.text = """
            IMPORTANT

            As your community is just beginning to grow up in Smartility, you will be one of 3 admins until a committee takes it over.
            
            Till then, you will be requested to approve whenever other users wish to join your community.
            """
        }
                
        print(community.community_name)
        communityLabel.text = community.community_name
                                
        NotificationCenter.default.post(name: NSNotification.Name("Update_init4"), object: nil)
                
    }
    
    @IBAction func closeBtnClicked(_ sender: UIButton) {
        Networking.shared.authorizeApi { result, error in
            if let _ = result {
                Networking.shared.getUserByID(user_id: UserDefaults.user_id) { (model, error) in
                    if let succ = model {
                        UserDefaults.user_name = succ[safe: 0]?.cust_name ?? ""
                        
                        let frontViewController = AppStoryboard.Dashboard.viewController(viewControllerClass: DashBoardController.self)
                        let nav_controller = UINavigationController(rootViewController: frontViewController)
                        if let window = UIApplication.shared.windows.first {
                            window.rootViewController = nav_controller
                            window.makeKeyAndVisible()
                            UIView.transition(with: window, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {}, completion:
                                                { completed in
                                                })
                        }
                    }
                }
            }
        }
    }
}
