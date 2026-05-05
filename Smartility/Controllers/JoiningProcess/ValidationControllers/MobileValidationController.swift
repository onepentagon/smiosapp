//
//  MobileValidationController.swift
//  Smartility
//
//  Created by Mani on 7/8/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import PhoneNumberKit
import Presentr

class MobileValidationController: UIViewController {
    
    @IBOutlet weak var height_contraint: NSLayoutConstraint!
    @IBOutlet weak var sendOtpBtn: UIButton!
    @IBOutlet weak var privacyPolicy: UILabel!
    @IBOutlet weak var otpFeild: SkyFloatingLabelTextField!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var phoneNumberFeild: PhoneNumberTextField!
        
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var heighAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var privacyPolicyContraint: NSLayoutConstraint!
    var resendOTPTimer: Timer?
    var count = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            phoneNumberFeild.withDefaultPickerUI = true
        } else {
            // Fallback on earlier versions
        }
        phoneNumberFeild.withFlag = true
        phoneNumberFeild.withExamplePlaceholder = true
                        
        timerLabel.textColor = infoColor()
        otpFeild.lineColor = brandColor()
        otpFeild.keyboardType = .phonePad
        otpFeild.keyboardAppearance = .dark
        otpFeild.delegate = self
        privacyPolicyContraint.constant = 0
        heighAnchor.constant = 0
        backBtn.layer.cornerRadius = 5
        continueBtn.layer.cornerRadius = 5
        
        backBtn.layer.masksToBounds = true
        continueBtn.layer.masksToBounds = true
        
        backBtn.layer.borderColor =  brandColor().cgColor
        
        continueBtn.layer.borderColor =  brandColor().cgColor
        continueBtn.backgroundColor = brandColor()
        
        backBtn.setTitleColor(brandColor(), for: .normal)
        backBtn.layer.borderWidth = 1
        continueBtn.layer.borderWidth = 1
        
        
        
        height_contraint.constant = 0
        privacyPolicyContraint.constant = 0
        continueBtn.isEnabled = false
        
        phoneNumberFeild.autocorrectionType = .yes
        phoneNumberFeild.keyboardAppearance = .dark
        phoneNumberFeild.keyboardType = .phonePad
        phoneNumberFeild.delegate = self
        otpFeild.isHidden = true
        privacyPolicy.isHidden = true
        height_contraint.constant = 0
        otpFeild.selectedLineColor = brandColor()
        
        privacyPolicy.isUserInteractionEnabled = true
        privacyPolicy.textColor = UIColor.black
        let text = "By clicking continue, you agree to you agree to our terms & conditions and privacy policy"
        
        let trimmedString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let string = NSMutableAttributedString(string: trimmedString, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)])
        string.setColorForText("terms & conditions and privacy policy", with: UIColor(hex: "#2D9CDB"))
        privacyPolicy.attributedText = string
        privacyPolicy.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLabel(_:))))
                
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissfeild)))
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("Update_init1"), object: nil)
    }
    
    @objc func tapLabel(_ tap: UITapGestureRecognizer) {
        let text = (privacyPolicy.text)!
        let termsRange = (text as NSString).range(of: "terms & conditions and privacy policy")
        
        if tap.didTapAttributedTextInLabel(label: privacyPolicy, inRange: termsRange) {
            print("terms")
            let width = ModalSize.custom(size: Float(view.frame.width-40))
            let height = ModalSize.custom(size: Float(UIScreen.main.bounds.height/1.5))
            let centerPostion = ModalCenterPosition.center
            let presenter = Presentr(presentationType: .custom(width: width, height: height, center: centerPostion))
            presenter.transitionType = .coverVerticalFromTop
            presenter.dismissTransitionType = .crossDissolve
            presenter.roundCorners = true
            presenter.cornerRadius = 20
            presenter.backgroundOpacity = 0.5
            let popoverContent = AppStoryboard.joinBoard.viewController(viewControllerClass: termsCondtionController.self)
            customPresentViewController(presenter, viewController: popoverContent, animated: true, completion: nil)
        }
    }
    
    
    @objc func dismissfeild(){
        view.endEditing(true)
    }
    

        
    @IBAction func continueClickde(_ sender: UIButton) {
        guard let otpCode = otpFeild.text else { return }
        guard let phoneCodeEx = phoneNumberFeild.phoneNumber else { return }
        let phoneNumberKit = PhoneNumberKit()
        let phone = phoneNumberKit.format(phoneCodeEx, toType: .e164) // +61236618300
        
        dismissfeild()
        if phone.isEmpty {
            showConfirmAlert(title: "", message: "Please enter phone number!", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else if otpCode.count == 0 {
            showConfirmAlert(title: "", message: "Please Enter OTP", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else{
            //        8741027887
            //        919741010725
                    
//            Networking.shared.getUserHistory(perams: ["contact_phone":"+97335562108", "comm_id":337]) { (com_model, error) in
//                //        Networking.shared.getUserHistory(perams: ["contact_phone":"+918741027887", "comm_id":337]) { (model, error) in
//                Networking.shared.getRolesByCommId(perams: ["comm_id": "337"]) { (model, data) in
//                    let controller = AppStoryboard.joinBoard.viewController(viewControllerClass: PersonalDetailController.self)
//                    controller.communityModel = com_model!
//                    controller.roleModel = model!
//                    self.add(controller, frame: self.view.bounds, customVIew: self.view)
//                }
//            }
            
            continueBtn.loadingIndicator(true, .white, "")
            let params = ["contact_phone": phone, "purpose": "joining", "otp": otpCode]
            Networking.shared.otp_verify(perams: params) { (str, error) in
                if let _ = str {
                    Networking.shared.getUserHistory(perams: ["contact_phone":phone]) { (com_model, error) in
                        if let model = com_model {
                            self.continueBtn.loadingIndicator(false, .white, "Continue")
                            Networking.shared.getRolesByCommId(perams: ["comm_id": community.community_id]) { (Rolemodel, data) in
                                if let rollModel = Rolemodel {
                                    self.otpFeild.text = ""
                                    self.phoneNumberFeild.text = ""
                                    self.heighAnchor.constant = 0
                                    self.otpFeild.isHidden = true
                                    self.privacyPolicy.isHidden = true
                                    self.height_contraint.constant = 0
                                    self.privacyPolicyContraint.constant = 0
                                    self.continueBtn.isEnabled = false
                                    self.sendOtpBtn.setTitle("SEND OTP", for: .normal)
                                    self.sendOtpBtn.isEnabled = true
                                    self.timerLabel.text = ""
                                    self.resendOTPTimer?.invalidate()
                                    self.resendOTPTimer = nil
                                    let controller = AppStoryboard.joinBoard.viewController(viewControllerClass: PersonalDetailController.self)
                                    controller.phone = phone
                                    controller.communityModel = model
                                    controller.roleModel = rollModel
                                    self.add(controller, frame: self.view.bounds, customVIew: self.view)
                                }
                            }
                        }
                        if let erro = error {
                            self.continueBtn.loadingIndicator(false, .white, "Continue")
                            self.showConfirmAlert(title: "", message: erro.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                        }
                    }
                }
                if let err = error {
                    self.continueBtn.loadingIndicator(false, .white, "Continue")
                    self.showConfirmAlert(title: "", message: err.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                }
            }
        }
    }
    
    
    
    
    @IBAction func backClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendOtp(_ sender: UIButton) {
        
        if phoneNumberFeild.isValidNumber {
            
            guard let phoneCodeEx = phoneNumberFeild.phoneNumber else { return }
            let phoneNumberKit = PhoneNumberKit()
            let phoneNumber = phoneNumberKit.format(phoneCodeEx, toType: .e164) // +61236618300
            
            if phoneNumber.count == 0 {
                showConfirmAlert(title: "", message: "Please enter your phone number!", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
            }else{
                dismissfeild()
                sender.loadingIndicator(true, brandColor(), "")
                
                let params = ["contact_phone": phoneNumber, "purpose": "joining", "country_code": community.cust_location]
                Networking.shared.otp_send(perams: params) { (str, error) in
                    if let _ = str {
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                            self.heighAnchor.constant = 20
                            self.privacyPolicyContraint.constant = 41
                            self.otpFeild.placeholder = "Please Enter OTP"
                            self.otpFeild.isHidden = false
                            self.privacyPolicy.isHidden = false
                            self.height_contraint.constant = 40
                            self.view.layoutIfNeeded()
                        }, completion: nil)
                        sender.isEnabled = false
                        self.resendOTPTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                            if self.count != 0 {
                                sender.isEnabled = false
                                self.count = self.count-1
                                sender.isEnabled = false
                                UIView.transition(with: self.timerLabel,
                                                  duration: 0.25,
                                                  options: .transitionCrossDissolve,
                                                  animations: { [weak self] in
                                                    self?.timerLabel.text = "(Wait \(self!.count) sec to retry)"
                                                  }, completion: nil)
                                
                            }else{
                                sender.isEnabled = true
                                self.timerLabel.text = ""
                                self.resendOTPTimer?.invalidate()
                                self.resendOTPTimer = nil
                            }
                        })
                        
                        sender.loadingIndicator(false, .blue, "RESEND OTP")
                    }
                    if let err = error {
                        self.heighAnchor.constant = 0
                        self.privacyPolicyContraint.constant = 0
                        self.otpFeild.placeholder = "Please Enter OTP"
                        self.otpFeild.isHidden = true
                        self.privacyPolicy.isHidden = true
                        self.height_contraint.constant = 0
                        sender.loadingIndicator(false, .white, "SEND OTP")
                        self.showConfirmAlert(title: "", message: err.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                    }
                }
            }
        }

    }
    
}
extension MobileValidationController:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if phoneNumberFeild == textField {
            var updatedTextString : NSString = textField.text! as NSString
            updatedTextString = updatedTextString.replacingCharacters(in: range, with: string) as NSString
            if let textFieldString = textField.fullTextWith(range: range, replacementString: string) {
                if phoneNumberFeild == textField {
                    if textFieldString.count > 25 {
                        return false
                    }
                }
                phoneNumberFeild.text = textFieldString
            }
            if phoneNumberFeild.isValidNumber {
                sendOtpBtn.isEnabled = true
                sendOtpBtn.setTitleColor(brandColor(), for: .normal)
            }else{
                sendOtpBtn.setTitleColor(UIColor.lightGray, for: .normal)
                sendOtpBtn.isEnabled = false
            }
        }else{
            var updatedTextString : NSString = textField.text! as NSString
            updatedTextString = updatedTextString.replacingCharacters(in: range, with: string) as NSString
            
            if (updatedTextString as String).count != 0 {
                continueBtn.isEnabled = true
            }else{
                continueBtn.isEnabled = false
            }
        }
        return true
    }
}


extension UITextView {

    func fullTextWith(range: NSRange, replacementString: String) -> String? {

        if let fullSearchString = self.text, let swtRange = Range(range, in: fullSearchString) {

            return fullSearchString.replacingCharacters(in: swtRange, with: replacementString)
        }

        return nil
    }
}


extension UITextField {

    func fullTextWith(range: NSRange, replacementString: String) -> String? {

        if let fullSearchString = self.text, let swtRange = Range(range, in: fullSearchString) {

            return fullSearchString.replacingCharacters(in: swtRange, with: replacementString)
        }

        return nil
    }
}


extension NSMutableAttributedString{
    func setColorForText(_ textToFind: String?, with color: UIColor) {
        
        let range:NSRange?
        if let text = textToFind{
            range = self.mutableString.range(of: text, options: .caseInsensitive)
        }else{
            range = NSMakeRange(0, self.length)
        }
        if range!.location != NSNotFound {
            addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range!)
        }
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: (locationOfTouchInLabel.x - textContainerOffset.x), y:  (locationOfTouchInLabel.y - textContainerOffset.y))
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}


