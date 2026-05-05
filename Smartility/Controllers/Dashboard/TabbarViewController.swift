//
//  TabbarViewController.swift
//  Smartility
//
//  Created by Mani on 3/30/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController,UITabBarControllerDelegate {
    
    var myhouseView = myHouseView().loadNib() as? myHouseView
    var tabbarWidget = tabbarWidgetView().loadNib() as? tabbarWidgetView
    var blurredEffectView: UIVisualEffectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBarController?.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        if let myTabbar = tabBar as? STTabbar {
            myTabbar.centerButtonActionHandler = {
                print("Center Button Tapped")
                self.blurredEffectView?.alpha = 1.0
                self.showWidgetPopup()
            }
        }
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) {
            if selectedIndex == 1 {
                addMyHousePopUp()
                self.blurredEffectView?.alpha = 1.0
                return false
            }
        }
        return true
    }
    
    
    func showWidgetPopup(){
        removeWidgetPopUp()
        let blurEffect = UIBlurEffect(style: .dark)
        self.blurredEffectView = UIVisualEffectView(effect: blurEffect)
        self.blurredEffectView?.frame = self.view.frame
        view.addSubview(blurredEffectView!)
        self.blurredEffectView?.contentView.addSubview(tabbarWidget!)
                        
        tabbarWidget?.layoutAnchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 100, paddingRight: 16, width: 0, height: 486, enableInsets: true)
        if let myTabbar = tabBar as? STTabbar {
            view.bringSubviewToFront(myTabbar)
        }
        tabbarWidget?.animShow()
        let slideDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown))
        slideDown.direction = .down
        tabbarWidget?.addGestureRecognizer(slideDown)
        
        tabbarWidget?.newInviteView.setClickListener {
            NotificationCenter.default.post(name: NSNotification.Name("NewInvite"), object: nil)
        }        
        tabbarWidget?.newEasyPassView.setClickListener {
            NotificationCenter.default.post(name: NSNotification.Name("NewEasyPass"), object: nil)
        }
        
        tabbarWidget?.noticeBottomView.setClickListener {
            let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: CreateNoticeController.self)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        
    }
    
    func removeWidgetPopUp(){
        blurredEffectView?.removeFromSuperview()
        tabbarWidget?.removeFromSuperview()
    }
    
    
    @objc func swipeDown(){
        tabbarWidget?.animHide()
        UIView.animate(withDuration: 0.5) {
            self.blurredEffectView?.alpha = 0.0
        } completion: { (comp) in
            self.removeWidgetPopUp()
        }
    }
    
    func addMyHousePopUp(){
        let blurEffect = UIBlurEffect(style: .dark)
        self.blurredEffectView = UIVisualEffectView(effect: blurEffect)
        self.blurredEffectView?.frame = self.view.frame
        view.addSubview(blurredEffectView!)
        self.blurredEffectView?.contentView.addSubview(myhouseView!)
        myhouseView?.layoutAnchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 286, enableInsets: true)
        myhouseView?.animShow()
        
        let slideDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissView(gesture:)))
        slideDown.direction = .down
        myhouseView?.addGestureRecognizer(slideDown)
        
        let slideUp = UISwipeGestureRecognizer(target: self, action: #selector(dismissView(gesture:)))
        slideUp.direction = .up
        myhouseView?.addGestureRecognizer(slideUp)
        
        myhouseView?.invoiceBgview.setClickListener {
            let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: Invoice_Payment_ViewController.self)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        myhouseView?.profileBgview.setClickListener {
            let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: ProfileViewController.self)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    func removeMyHouse(){
        blurredEffectView?.removeFromSuperview()
        myhouseView?.removeFromSuperview()
    }
        
    
    @objc func dismissView(gesture: UISwipeGestureRecognizer) {
        myhouseView?.animHide()
        UIView.animate(withDuration: 0.5) {
            self.blurredEffectView?.alpha = 0.0
        } completion: { (comp) in
            self.removeMyHouse()
        }
    }
    
    @objc func showView(gesture: UISwipeGestureRecognizer) {
        addMyHousePopUp()
        UIView.animate(withDuration: 0.5) {
            self.blurredEffectView?.alpha = 1.0
        } completion: { (comp) in
            
        }
    }
}
extension UIView{
    func animShow(){
        UIView.animate(withDuration: 0.3, delay: 0.01, options: [.curveEaseIn],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
                       }, completion: nil)
        self.isHidden = false
    }
    func animHide(){
        UIView.animate(withDuration: 0.3, delay: 0.01, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()
                        
                       },  completion: {(_ completed: Bool) -> Void in
                        self.isHidden = true
                       })
    }
}
