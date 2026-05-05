//
//  SideMenuViewController.swift
//  Smartility
//
//  Created by Mani on 7/11/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import Kingfisher
import MessageUI
import GSImageViewerController
import SkeletonView

class SideMenuViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileRounded: UIImageView!
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var roundedBorder: UIView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profilePhoneNumber: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    @IBOutlet weak var arrowBackgrounded: UIView!
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var tabelview: UITableView!
    @IBOutlet weak var roundedBgView: UIView!
    
    var model = [profileModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrowBackgrounded.setClickListener {
            let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: ProfileViewController.self)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        tabelview.tableFooterView = UIView()
        tabelview.separatorStyle = .none
        tabelview.delegate = self
        tabelview.dataSource = self
        tabelview.reloadData()
        arrowIcon.image = UIImage(named: "rightArrow")?.imageWithColor(color1: .white)
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                headerHeight.constant = 240
            case 1334:
                print("iPhone 6/6S/7/8")
                headerHeight.constant = 240
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                headerHeight.constant = 240
            default:
                headerHeight.constant = 280
            }
        }else{
            headerHeight.constant = 240
        }
        setupApi()
        self.profileImage.image =  nil
        self.profileRounded.image = nil
        self.profileRounded.contentMode = .scaleToFill
                        
        roundedBgView.setClickListener {
            guard let imageview = self.profileRounded.image else { return }
            let imageInfo   = GSImageInfo(image: imageview, imageMode: .aspectFit)
            let transitionInfo = GSTransitionInfo(fromView: self.profileRounded)
            let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
            self.present(imageViewer, animated: true, completion: nil)
        }
    }
    
    
    func setupApi(){
        
        
        [self.profileRounded, self.profileImage].forEach { (view) in
            view?.isSkeletonable = true
            view?.showAnimatedSkeleton()
        }
        Networking.shared.profileByUserID(perams: ["user_id": UserDefaults.user_id,"comm_id": community.community_id]) { (data, error) in
            if let model = data, model.count != 0 {
                self.model = model
                self.profileEmail.text = model.first?.contact_email
                self.profilePhoneNumber.text = model.first?.contact_phone
                self.profileName.text = model.first?.cust_name
                let url = model.first?.avatar_url
                if let model = url, let profurl = URL(string: EndPoint.imageURL+(model)) {
                    
                    KingfisherManager.shared.retrieveImage(with: profurl, options: [.forceRefresh], progressBlock: nil, downloadTaskUpdated: nil) { (result) in
                        switch result {
                        case .success(let suc):
                            print("")
                            self.profileRounded.image = suc.image
                            self.profileImage.image = suc.image
                            [self.profileRounded, self.profileImage].forEach { (view) in
                                view?.hideSkeleton()
                            }
                        case .failure(_):
                            self.profileRounded.image = UIImage(named:"proflie_icon")
                            self.profileImage.image = UIImage(named:"proflie_icon")
                            [self.profileRounded, self.profileImage].forEach { (view) in
                                view?.hideSkeleton()
                            }
                        }                    
                    }
                }
            }
            if let erro = error {
                self.showConfirmAlert(title: "", message: erro.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        let maskView = CurvedHeaderView(frame: blurEffectView.bounds)
        maskView.clipsToBounds = true;
        maskView.backgroundColor = UIColor.clear
        blurEffectView.mask = maskView
        
        arrowBackgrounded.layer.cornerRadius = arrowBackgrounded.frame.height/2
        arrowBackgrounded.layer.masksToBounds = true
        roundedBorder.layer.cornerRadius = roundedBorder.frame.height/2
        roundedBorder.layer.masksToBounds = true
    }
    
}

extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            contactSupportClicked()
        }else if indexPath.row == 1 {
            let controller = AppStoryboard.NotificationController.viewController(viewControllerClass: NotificationSettingsController.self)
            self.navigationController?.pushViewController(controller, animated: true)
            
        }else if indexPath.row == 2 {
            logoutClicked()
        }
        print("\(indexPath.row)")
    }
}
extension SideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactSupportCell")
            return cell ?? UITableViewCell()
        }else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationSettings")
            return cell ?? UITableViewCell()
        }else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogoutCell")
            cell?.addLine(position: .LINE_POSITION_BOTTOM, color: UIColor(hex: "#333333"), width: 1.0)
            return cell ?? UITableViewCell()
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AppVersionCell") as? AppVersionCell
            return cell ?? UITableViewCell()
        }
    }
    
    func logoutClicked(){
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to logout?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Logout", style: .default) { (action:UIAlertAction) in
            community.community_id = ""
            community.community_name = ""
            community.cust_location = ""
            community.cust_unitId = ""
            UserDefaults.ApiKey = ""
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
                UIView.transition(with: window, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {}, completion: { completed in })
            }
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
        }
        alertController.addAction(action1)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func contactSupportClicked(){
        sendEmail()
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([CommunityData.support_email])
            present(mail, animated: true)
        }
    }
}

extension SideMenuViewController: MFMailComposeViewControllerDelegate {
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        print(result)
        switch (result){
        case MFMailComposeResult.cancelled:
            print("Mail cancelled");
            break;
        case MFMailComposeResult.saved:
            print("Mail saved");
            break;
        case MFMailComposeResult.sent:
            print("Mail sent");
            break;
        case MFMailComposeResult.failed:
            print("Mail sent failure: %@", error?.localizedDescription ?? "");
            break;
        default:
            break;
        }
        controller.dismiss(animated: true)
    }
}



class ContactSupportCell: UITableViewCell {
    override func setSelected(_ selected: Bool, animated: Bool) {
    }
}

class NotificationSettings: UITableViewCell {
    override func setSelected(_ selected: Bool, animated: Bool) {
    }
}

class LogoutCell: UITableViewCell {
    override func setSelected(_ selected: Bool, animated: Bool) {
    }
}

class AppVersionCell: UITableViewCell {
    @IBOutlet weak var appVersionString: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        appVersionString.text = "App Version "+(getAppVersion() ?? "")
    }
    override func awakeFromNib() {
        appVersionString.text = getAppVersion()
    }
    
    func getAppVersion()->String?{
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
}


@IBDesignable class CurvedHeaderView: UIView {
    @IBInspectable var curveHeight:CGFloat = 50.0
    var curvedLayer = CAShapeLayer()
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.move(to: CGPoint(x: 0, y: rect.height))
        //        path.addLine(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addArc(withCenter: CGPoint(x: CGFloat(rect.width) - curveHeight, y: 100), radius: curveHeight, startAngle: 0, endAngle: 1.5 * CGFloat.pi, clockwise: false)
        //        path.addArc(withCenter: CGPoint(x: CGFloat(rect.width) - curveHeight, y: rect.height), radius: curveHeight, startAngle: 0, endAngle: 1.5 * CGFloat.pi, clockwise: false)
        //        path.addLine(to: CGPoint(x: curveHeight, y: rect.height - curveHeight))
        
        //        path.addLine(to: CGPoint(x: curveHeight, y: 50))
        path.addLine(to: CGPoint(x: curveHeight, y: curveHeight))
        path.addArc(withCenter: CGPoint(x: curveHeight, y: 0), radius: curveHeight, startAngle: 0, endAngle:  CGFloat.pi, clockwise: true)
        
        path.addLine(to: CGPoint(x: 0, y: 0))
        //        path.addArc(withCenter: CGPoint(x: curveHeight, y: rect.height - (curveHeight * 2.0)), radius: curveHeight, startAngle: 0, endAngle:  CGFloat.pi, clockwise: true)
        path.close()
        curvedLayer.path = path.cgPath
        curvedLayer.fillColor = UIColor.white.cgColor
        curvedLayer.frame = rect
        self.layer.insertSublayer(curvedLayer, at: 0)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 10.0
        self.layer.shadowOpacity = 0.7
    }
}
