//
//  WelcomViewController.swift
//  Smartility
//
//  Created by Mani on 7/5/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import MaterialComponents
import SwiftSpinner
import Presentr
import PhoneNumberKit
import Toast_Swift
import Alamofire
class WelcomViewController: UIViewController, SWRevealViewControllerDelegate {
    
    @IBOutlet weak var container_view: UIView!
    
    @IBOutlet weak var back_image: UIImageView!
    
    @IBOutlet weak var join_btn: UIButton!
    @IBOutlet weak var login_btn: UIButton!
            
    @IBOutlet weak var malesia_view: MDCCard!
    @IBOutlet weak var india_view: MDCCard!
    
    @IBOutlet weak var malsia_flag: UIImageView!
    @IBOutlet weak var india_flag: UIImageView!
    
    @IBOutlet weak var contactUsLabel: UILabel!
    @IBOutlet weak var skyFloatingFeild: SkyFloatingLabelTextField!
    var constaint_height: NSLayoutConstraint?
    
    var country = "Search & Join Community in India"
    var data = [String]()
    
    var setText: String? = nil
    
    
    var dimView: UIView?
    var otp_View = OtpView().loadNib() as? OtpView
    
    var init_first_time = false
    var userData = [String:Any]()
    var centerConstraint: NSLayoutConstraint?
    var resendOTPTimer: Timer?
    var count = 30
    let phoneNumberKit = PhoneNumberKit()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
                    
        login_btn.setTitleColor(brandColor(), for: .normal)
        let attributeString = NSMutableAttributedString(string: "Not customer yet, would you like to try our app?", attributes: [NSAttributedString.Key.font: SFFont(font: FontFamily.Semibold, size: 14)])
        let underlineAttribute = [NSAttributedString.Key.foregroundColor : brandColor(), NSAttributedString.Key.font: SFFont(font: FontFamily.Semibold, size: 14)] as [NSAttributedString.Key : Any]
        let underlineAttributedString = NSAttributedString(string: " Contact Us", attributes: underlineAttribute)
        attributeString.append(underlineAttributedString)
        contactUsLabel.attributedText = attributeString
        contactUsLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLabel(_:))))
        contactUsLabel.isUserInteractionEnabled  = true
        
        malsia_flag.isUserInteractionEnabled  = false
        india_flag.isUserInteractionEnabled  = false
        
        india_view.cornerRadius = india_view.frame.height/2
        malesia_view.cornerRadius = india_view.frame.height/2
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(malesia_tapped))
        malesia_view.addGestureRecognizer(tap)
        
        let tap_1 = UITapGestureRecognizer(target: self, action: #selector(india_tapped))
        india_view.addGestureRecognizer(tap_1)
        
        india_view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        malesia_view.backgroundColor = UIColor.clear
        
        
        let tapp_feild = UITapGestureRecognizer(target: self, action: #selector(searchTapped))
        skyFloatingFeild.isUserInteractionEnabled = true
        skyFloatingFeild.addGestureRecognizer(tapp_feild)
        
        skyFloatingFeild.placeholderColor = .black
        
        skyFloatingFeild.placeholder = country
        
        skyFloatingFeild.selectedLineColor = UIColor(red: 2/256, green: 133/256, blue: 166/256, alpha: 1.0)
        skyFloatingFeild.selectedTitleColor = .black
        skyFloatingFeild.selectedTitle = country
        

        container_view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        container_view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        container_view.layer.shadowOpacity = 1.0
        container_view.layer.shadowRadius = 2
        container_view.layer.masksToBounds = false
        container_view.layer.cornerRadius = 4.0
                
        join_btn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        join_btn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        join_btn.layer.shadowOpacity = 1.0
        join_btn.layer.shadowRadius = 2
        join_btn.layer.masksToBounds = false
        join_btn.layer.cornerRadius = 4.0
        
        join_btn.addTarget(self, action: #selector(joinTapped), for: .touchUpInside)
        
//        let tap_contact = UITapGestureRecognizer(target: self, action: #selector(contact_click))
//        contact_us_btn.isUserInteractionEnabled = true
//        contact_us_btn.addGestureRecognizer(tap_contact)
//        contact_us_btn.textColor = brandColor()
        
        UIView.transition(with: back_image,
        duration: 0.75,
        options: .transitionCrossDissolve,
        animations: { self.back_image.image = UIImage(named: "IndiaBg") },
        completion: nil)
        
        community.cust_location = "IN"
        
    }
    
    @objc func tapLabel(_ tap: UITapGestureRecognizer) {
        let text = (contactUsLabel.text)!
        let termsRange = (text as NSString).range(of: "Contact Us")
        if tap.didTapAttributedTextInLabel(label: contactUsLabel, inRange: termsRange) {
            if let url = URL(string: "https://www.smartility.in/") {
                UIApplication.shared.open(url)
            }
        }
    }
    
    
    
    
    @objc func joinTapped(){
        
        guard let text = skyFloatingFeild.text else { return }
        if text.count == 0 {
            self.showConfirmAlert(title: "", message: "Choose a community to join", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else{
            join_btn.loadingIndicator(true, .black, "")
            Networking.shared.getCommByName(perams: ["comm_name":text]) { (model, error) in
                if let model = model {
                    for i in model {
                        if let id = i.comm_id {
                            community.community_id = "\(id)"
                            community.community_name = i.comm_name ?? ""
                            self.join_btn.loadingIndicator(false, .black, "JOIN")
                            let controller = AppStoryboard.joinBoard.viewController(viewControllerClass: JoinViewController.self)
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
                        self.join_btn.loadingIndicator(false, .black, "JOIN")
                    }
                }
                if let er = error {
                    self.join_btn.loadingIndicator(false, .black, "JOIN")
                    self.showConfirmAlert(title: "", message: er.localizedDescription , buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.otp_View?.send_otp.setTitle("SEND OTP", for: .normal)
        self.constaint_height?.constant = 225
        NotificationCenter.default.addObserver(forName: NSNotification.Name("pass_name"), object: nil, queue: .main) { (notify) in
            if let name = notify.userInfo as? [String:String] {
                self.skyFloatingFeild.text = name["name"]
            }
        }
        self.skyFloatingFeild.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !init_first_time {
            if let code = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
                if code == "MY" {
                    malesia_tapped()
                }else{
                    india_tapped()
                }
            }else{
                india_tapped()
            }
            init_first_time = true
        }
    }
    
    @IBAction func login_clicked(_ sender: Any) {
        
        dimView = UIView(frame: UIScreen.main.bounds)
        dimView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(dimView!)
        view.addSubview(otp_View!)
        dimView?.bringSubviewToFront(otp_View!)
        otp_View?.backgroundColor = .white
        otp_View?.layer.cornerRadius = 5
        otp_View?.layer.masksToBounds = true
        
        otp_View?.timerLabel.text = ""

        otp_View?.translatesAutoresizingMaskIntoConstraints = false
        otp_View?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        otp_View?.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        
        centerConstraint = otp_View?.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        centerConstraint?.isActive = true
        
//        otp_View?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        otp_View?.widthAnchor.constraint(equalToConstant: view.frame.width-40).isActive = true
        constaint_height?.isActive = false
        constaint_height = otp_View?.heightAnchor.constraint(equalToConstant: 225)
        constaint_height?.isActive = true

        
        otp_View?.otpViewContraint.constant = 0
        otp_View?.otpfeild.isHidden = true
        
        otp_View?.otpfeild.keyboardType = .phonePad
        otp_View?.otpfeild.addDoneButtonOnKeyboard()
        otp_View?.otpfeild.keyboardAppearance = .dark
        otp_View?.otpfeild.autocorrectionType = .no
        
        otp_View?.phoneNumberfeild.withFlag = true
        otp_View?.phoneNumberfeild.withExamplePlaceholder = true
        if #available(iOS 11.0, *) {
            otp_View?.phoneNumberfeild.withDefaultPickerUI = true
        }
        
        otp_View?.otpfeild.placeholder = "Please Enter OTP"
        otp_View?.otpfeild.placeholderColor = brandColor()
        otp_View?.phoneNumberfeild.text = ""
        otp_View?.phoneNumberfeild.addDoneButtonOnKeyboard()
        otp_View?.send_otp.isEnabled = false
        otp_View?.phoneNumberfeild.delegate = self
        otp_View?.cancel_btn.addTarget(self, action: #selector(outerTouch), for: .touchUpInside)
        otp_View?.login_btn.addTarget(self, action: #selector(Login_clicked), for: .touchUpInside)
                                
        otp_View?.send_otp.addTarget(self, action: #selector(send_otp), for: .touchUpInside)
        otp_View?.send_otp.setTitleColor(UIColor.lightGray, for: .normal)
        dimView?.alpha = 0.0
        otp_View?.alpha = 0.0
        
        UIView.animate(withDuration: 0.5) {
            self.dimView?.alpha = 1.0
            self.otp_View?.alpha = 1.0
        }
                
        let tap = UITapGestureRecognizer(target: self, action: #selector(outerTouch))
        dimView?.isUserInteractionEnabled = true
        dimView?.addGestureRecognizer(tap)
        
    }
    
    
    @objc func send_otp(){
                     
        view.endEditing(true)
        otp_View?.send_otp.loadingIndicator(true, .blue, "")
        guard let phoneNumberEx = otp_View?.phoneNumberfeild.phoneNumber else { return }
        let phoneNumber = phoneNumberKit.format(phoneNumberEx, toType: .e164) // +61236618300

        Networking.shared.getUserByPhone(phone_number: phoneNumber) { (success, error) in
            if success != nil {
                self.userData = success!
                let params = ["contact_phone": phoneNumber, "purpose": "login", "country_code": community.cust_location]
                Networking.shared.otp_send(perams: params) { (str, error) in
                    if let _ = str {
                        self.otp_View?.otpfeild.isHidden = false
                        self.otp_View?.otpViewContraint.constant = 35
                        
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                            self.constaint_height?.constant = 280
                            self.constaint_height?.isActive = true
                            self.view.layoutIfNeeded()
                        }, completion: nil)
                                                
                        self.resendOTPTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                            if self.count != 0 {
                                self.otp_View?.send_otp.isEnabled = false
                                self.count = self.count-1
                                
                                UIView.transition(with: self.otp_View!.timerLabel,
                                     duration: 0.25,
                                      options: .transitionCrossDissolve,
                                   animations: { [weak self] in
                                    self?.otp_View?.timerLabel.text = "(Wait \(self!.count) sec to retry)"
                                }, completion: nil)
                                                                
                            }else{
                                self.otp_View?.send_otp.isEnabled = true
                                self.otp_View?.timerLabel.text = ""
                                self.resendOTPTimer?.invalidate()
                                self.resendOTPTimer = nil
                            }
                        })
                        self.view.endEditing(true)
                        self.view.makeToast("An OTP is sent to your mobile & e-mail. Please check and enter here ")
                        self.otp_View?.send_otp.loadingIndicator(false, .blue, "RESEND OTP")
                    }
                    if let err = error {
                        self.view.endEditing(true)
                        self.otp_View?.otpfeild.isHidden = true
                        self.otp_View?.otpViewContraint.constant = 0
                        self.otp_View?.send_otp.loadingIndicator(false, .blue, "SEND OTP")
                        self.showConfirmAlert(title: "", message: err.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                    }
                }
            }
            if let error = error {
                self.view.endEditing(true)
                self.otp_View?.send_otp.loadingIndicator(false, .blue, "SEND OTP")
                self.showConfirmAlert(title: "", message: error.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
            }
        }
    }
    
    
            
    @objc func outerTouch(){
        view.endEditing(true)
        UIView.transition(with: otp_View!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.otp_View?.alpha = 0.0
            self.dimView?.alpha = 0.0
        }) { (tr) in
            
            self.otp_View?.send_otp.setTitle("SEND OTP", for: .normal)
            self.otp_View?.timerLabel.text = ""
            self.resendOTPTimer?.invalidate()
            self.resendOTPTimer = nil
            self.otp_View?.login_btn.loadingIndicator(false, .black, "LOG IN")
            self.otp_View?.removeFromSuperview()
            self.dimView?.removeFromSuperview()
        }
        self.constaint_height?.constant = 225
        view.layoutIfNeeded()
    }
    
    @objc func Login_clicked(){
                
        view.endEditing(true)
        guard let phoneNumberEx = otp_View?.phoneNumberfeild.phoneNumber else { return }
        guard let otpCode = otp_View?.otpfeild.text else { return }
        let phoneNumber = phoneNumberKit.format(phoneNumberEx, toType: .e164) // +61236618300
                
        if phoneNumber.isEmpty {
            showConfirmAlert(title: "", message: "Please enter phone number!", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else if otpCode.count == 0 {
            showConfirmAlert(title: "", message: "Please Enter OTP!", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else{
            otp_View?.login_btn.loadingIndicator(true, .white, "")
            let params = ["contact_phone": phoneNumber, "purpose": "login", "otp": otpCode, "user_device_id":UIDevice.current.identifierForVendor?.uuidString ?? ""]
            print(params)
            Networking.shared.otp_verify(perams: params) { (str, error) in
                if let _ = str {
                    Networking.shared.authorizeApi { result, error in
                        if let _ = result {
                            self.otp_View?.login_btn.loadingIndicator(false, .white, "LOG IN")
                            self.outerTouch()
                            if let cust_id = self.userData["cust_id"] as? Int {
                                UserDefaults.cust_id = "\(cust_id)"
                            }
                            if let user_id = self.userData["user_id"] as? Int {
                                UserDefaults.user_id = "\(user_id)"
                                let p = ["user_id": UserDefaults.user_id, "push_channel":"M", "push_sub": notificationSingletone.shared.tokenStore,"user_device_id": UIDevice.current.identifierForVendor?.uuidString ?? ""]
                                Networking.shared.registerNotification(perams: p) { (success, error) in
                                    if success != nil {
                                    }else{
                                        print("failure")
                                    }
                                }
                            }
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
                                if let err = error {
                                    self.otp_View?.login_btn.loadingIndicator(false, .blue, "LOG IN")
                                    self.showConfirmAlert(title: "", message: err.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                                }
                            }
                        }
                    }
                }
                if let err = error {
                    self.otp_View?.login_btn.loadingIndicator(false, .blue, "LOG IN")
                    self.showConfirmAlert(title: "", message: err.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                }
            }
        }
    
        
    }
    
    
    
    @objc func contact_click(){
        if let url = URL(string: "https://smartility.in/") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func malesia_tapped(){
        
        UIView.transition(with: back_image,
        duration: 0.75,
        options: .transitionCrossDissolve,
        animations: { self.back_image.image = UIImage(named: "malesiaBg") },
        completion: nil)
        community.cust_location = "MY"
        skyFloatingFeild.text = ""
        country = "Search & Join Community in Malaysia"
        setup_api(code: "MY")
        skyFloatingFeild.selectedTitle = country
        skyFloatingFeild.placeholder = country
        malesia_view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        india_view.backgroundColor = UIColor.clear
    }
    
    @objc func india_tapped(){
        community.cust_location = "IN"
        skyFloatingFeild.text = ""
        UIView.transition(with: back_image,
                          duration: 0.75,
                          options: .transitionCrossDissolve,
                          animations: { self.back_image.image = UIImage(named: "IndiaBg") },
                          completion: nil)
        
        country = "Search & Join Community in India"
        setup_api(code: "IN")
        skyFloatingFeild.selectedTitle = country
        skyFloatingFeild.placeholder = country
        india_view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        malesia_view.backgroundColor = UIColor.clear
    }
    
    func setup_api(code:String){
        SwiftSpinner.show("Fetching information...")
        Networking.shared.getLanguageData(contryCode: code) { (data, error) in
            if let data = data {
                self.data = data
                SwiftSpinner.hide()
            }
            if let error = error {
                SwiftSpinner.hide()
                self.showConfirmAlert(title: "", message: error.localizedDescription, buttonTitle: "Retry", buttonStyle: .default) { (action) in
                    self.setup_api(code: code)
                }
            }
        }
    }
    
    
    @objc func searchTapped(){
        let width = ModalSize.custom(size: Float(view.frame.width-40))
        let height = ModalSize.custom(size: Float(UIScreen.main.bounds.height-200))
        let centerPostion = ModalCenterPosition.center
        let presenter = Presentr(presentationType: .custom(width: width, height: height, center: centerPostion))
        presenter.transitionType = .coverVerticalFromTop
        presenter.dismissTransitionType = .crossDissolve
        presenter.roundCorners = true
        presenter.cornerRadius = 20
        presenter.backgroundOpacity = 0.5
        let popoverContent = AppStoryboard.Main.viewController(viewControllerClass: SearchViewController.self)
        popoverContent.placeHolder = country
        popoverContent.data = self.data
        customPresentViewController(presenter, viewController: popoverContent, animated: true, completion: nil)
    }
}



extension WelcomViewController:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var updatedTextString : NSString = textField.text! as NSString
        updatedTextString = updatedTextString.replacingCharacters(in: range, with: string) as NSString
        if let textFieldString = textField.fullTextWith(range: range, replacementString: string) {
            if otp_View?.phoneNumberfeild == textField {
                otp_View?.phoneNumberfeild.text = textFieldString
                if textFieldString.count > 25 {
                    return false
                }
            }
        }
        if let valid = otp_View?.phoneNumberfeild.isValidNumber, valid == true {
            otp_View?.send_otp.isEnabled = true
            self.otp_View?.send_otp.setTitleColor(brandColor(), for: .normal)
            self.centerConstraint?.isActive = false
            self.centerConstraint = self.otp_View?.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -50)
            self.centerConstraint?.isActive = true
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }else{
            self.constaint_height?.constant = 225
            self.otp_View?.otpfeild.isHidden = true
            self.otp_View?.otpViewContraint.constant = 0
            self.otp_View?.send_otp.setTitleColor(UIColor.lightGray, for: .normal)
            otp_View?.send_otp.isEnabled = false
            
            self.centerConstraint?.isActive = false
            self.centerConstraint = self.otp_View?.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0)
            self.centerConstraint?.isActive = true
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
        return true
    }
}
