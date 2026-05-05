//
//  ProfileViewController.swift
//  Smartility
//
//  Created by Mani on 9/28/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import DropDown
import Kingfisher
import PhoneNumberKit
import GSImageViewerController

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var profileTable: UITableView!
    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var backBgView: UIView!
    
    var model = [profileModel]()
    var contactRelationShip = DropDown()
    var genderDropDown = DropDown()
    var imagePicker = UIImagePickerController()
    var phoneCountry = ""
    var hide_contact = 0
    var is_mc_member = Bool()
    var flag_api = false
    var otpSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backBgView.setClickListener {
            self.navigationController?.popViewController(animated: true)
        }
        
        self.view.bringSubviewToFront(navigationBar)
        navigationBar.backgroundColor = .white
        navigationBar.layer.shadowColor = UIColor(red: 0.049, green: 0.019, blue: 0.167, alpha: 0.2).cgColor
        navigationBar.layer.shadowOpacity = 1
        navigationBar.layer.shadowRadius = 1
        navigationBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                heightConstraint.constant = 60
            case 1334:
                print("iPhone 6/6S/7/8")
                heightConstraint.constant = 80
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
            default:
                heightConstraint.constant = 90
            }
        }else{
            heightConstraint.constant = 90
        }
        
        profileTable.tableFooterView = UIView()
        setupApi()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endediting)))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    
    @objc func endediting(){
        view.endEditing(true)
    }
    
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            profileTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + profileTable.rowHeight, right: 0)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        profileTable.contentInset = .zero
    }
    
    func setupApi(){
        profileTable.showActivityIndicator()
        Networking.shared.profileByUserID(perams: ["user_id": UserDefaults.user_id,"comm_id": community.community_id]) { (data, error) in
            if let model = data, model.count != 0 {
                self.model = model
                self.profileTable.delegate = self
                self.profileTable.dataSource = self
                self.profileTable.reloadData()
                self.profileTable.hideActivityIndicator()
            }
            if let erro = error {
                self.showConfirmAlert(title: "", message: erro.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
            }
        }
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableCell", for: indexPath) as? ProfileTableCell
        let data = model[indexPath.row]
        
        [cell?.name,
        cell?.phoneNumber,
        cell?.bloodGrp,
        cell?.emergencyPhone,
        cell?.contactRelation,
        cell?.contactName,
        cell?.email,
        cell?.gstIdentificationNo,
         cell?.country,
         cell?.state,
        cell?.pinCode,
        cell?.city,
        cell?.address].forEach { (text) in
            text?.delegate = self
        }
        if let model = data.avatar_url {
            let profurl = URL(string: EndPoint.imageURL+(model))
            cell?.profileIcon.contentMode = .scaleAspectFill
            cell?.profileIcon.kf.indicatorType = .activity
            cell?.profileIcon.kf.setImage(
                with: profurl,
                placeholder: UIImage(named:"proflie_icon"),
                options: [.transition(.fade(0.3)),
                          ], completionHandler:
                    {
                        result in
                        switch result {
                        case .success(let value):
                            print(value)
                        case .failure(_):
                            print("")
                        }
                    })
        }
        cell?.presidentBt.setTitle(data.role_name, for: .normal)
        if let admin = data.is_admin, let mc_me = data.is_mc_member {
            if admin == 0 && mc_me == 0 {
                cell?.isAdminBtn.isHidden = true
                cell?.presidentBt.isHidden = true
                cell?.persidentHeight.constant = 0
                cell?.adminHeigh.constant = 0
            }
            if mc_me == 0 {
                is_mc_member = false
                cell?.presidentBt.isHidden = true
                cell?.presidentContraint.constant = 0
                cell?.adminConstraint.constant = 0
            }else{
                cell?.persidentHeight.constant = 30
                is_mc_member = true
                cell?.presidentBt.isHidden = false
            }
            if admin == 0 {
                cell?.isAdminBtn.isHidden = true
            }else{
                cell?.adminHeigh.constant = 30
                cell?.isAdminBtn.isHidden = false
            }
        }
        genderDropDown.selectionBackgroundColor = .white
        genderDropDown.backgroundColor = .white
        genderDropDown.anchorView = cell?.gender
        genderDropDown.dataSource = ["Male","Female"]
        genderDropDown.width = (cell?.gender.frame.size.width)!-40
        genderDropDown.cornerRadius = 10
        genderDropDown.bottomOffset = CGPoint(x: 0, y:((genderDropDown.anchorView?.plainView.bounds.height)!+5))
        genderDropDown.selectionAction = { (index: Int, item: String) in
            cell?.gender.text = item
        }
        
        if let hide = data.hideContact  {
            if hide == 0 {
//                cell?.checkBox.isUserInteractionEnabled = false
                hide_contact = 0
                cell?.checkBox.on = false
            }else{
//                cell?.checkBox.isUserInteractionEnabled = true
                hide_contact = 1
                cell?.checkBox.on = true
            }
        }
        cell?.checkBox.setClickListener {
            if self.hide_contact == 1 {
                self.hide_contact = 0
                cell?.checkBox.setOn(false, animated: true)
            }else{
                self.hide_contact = 1
                cell?.checkBox.setOn(true, animated: true)
            }
        }
        if UserDefaults.UserContry != "IN" {
            cell?.raxinfo.isHidden = true
            cell?.gstIdentificationNo.isHidden = true
            cell?.hideConstaint.constant = 0
        }else{
            cell?.hideConstaint.constant = 60
            cell?.raxinfo.isHidden = false
            cell?.gstIdentificationNo.isHidden = false
        }
        let genderTap = UITapGestureRecognizer(target: self, action: #selector(genderTapped))
        genderTap.numberOfTouchesRequired = 1
        cell?.gender.isUserInteractionEnabled = true
        cell?.gender.addGestureRecognizer(genderTap)
                         
        let tappPickImageTapped = UITapGestureRecognizer(target: self, action: #selector(pick_imageTapped))
        tappPickImageTapped.numberOfTouchesRequired = 1
        cell?.edite_image.isUserInteractionEnabled = true
        cell?.edite_image.addGestureRecognizer(tappPickImageTapped)
        
        let camTapped = UITapGestureRecognizer(target: self, action: #selector(cam_imageTapped))
        camTapped.numberOfTouchesRequired = 1
        cell?.camBtn.isUserInteractionEnabled = true
        cell?.camBtn.addGestureRecognizer(camTapped)
        
        let imageTapp = UITapGestureRecognizer(target: self, action: #selector(showImageTapped))
        imageTapp.numberOfTouchesRequired = 1
        cell?.profileIcon.isUserInteractionEnabled = true
        cell?.profileIcon.addGestureRecognizer(imageTapp)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showRelationShip))
        tap.numberOfTouchesRequired = 1
        
        cell?.contactRelation.isUserInteractionEnabled = true
        cell?.contactRelation.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(showRelationShip)))
        cell?.contactRelation.addGestureRecognizer(tap)
                
        contactRelationShip.selectionBackgroundColor = .white
        contactRelationShip.backgroundColor = .white
        contactRelationShip.anchorView = cell?.contactRelation
        contactRelationShip.dataSource = ["Spouse","Father", "Mother", "Son", "Daughter"]
        contactRelationShip.width = cell?.contactRelation.frame.size.width
        contactRelationShip.cornerRadius = 10
        contactRelationShip.bottomOffset = CGPoint(x: 0, y:((contactRelationShip.anchorView?.plainView.bounds.height)!+5))
        contactRelationShip.selectionAction = { (index: Int, item: String) in
            cell?.contactRelation.text = item
        }
        cell?.phoneNumber.delegate = self
        cell?.isAdminBtn.layer.cornerRadius = 5
        cell?.isAdminBtn.layer.masksToBounds = true
        
        cell?.presidentBt.layer.cornerRadius = 5
        cell?.presidentBt.layer.masksToBounds = true
        
        cell?.name.text = data.cust_name
        cell?.gender.text = data.gender
        cell?.phoneNumber.text = data.contact_phone
        cell?.phoneNumber.updateFlag()
        cell?.email.text = data.contact_email
        cell?.checkBox.onTintColor = brandColor()
        cell?.checkBox.onCheckColor = .white
        cell?.checkBox.onFillColor = brandColor()
        cell?.checkBox.boxType = .square
        cell?.emergencyPhone.text = data.emergency_phone
        cell?.contactName.text = data.emergency_contact_name
        cell?.contactRelation.text = data.emergency_contact_relation
        cell?.occupation.text = data.occupation
        cell?.hobbies.text = data.hobbies
        cell?.address.text = data.address
        cell?.city.text = data.city
        cell?.pinCode.text = data.pin_code
        cell?.state.text = data.state
        cell?.country.text = data.country
        cell?.gstIdentificationNo.text = data.gst_no
        
        cell?.cancelBtn.addTarget(self, action: #selector(cancelClicked), for: .touchUpInside)
        cell?.saveBtn.addTarget(self, action: #selector(submitClicked), for: .touchUpInside)
        cell?.sendOTPConstraint.constant = 0
        cell?.mobileVerificationConstraint.constant = 0
        phoneCountry = data.phone_country ?? ""
        
        cell?.mobileVerificationContainer.alpha = 0
        cell?.otpDescLabel.alpha = 0
        cell?.otpFeild.alpha = 0
        cell?.registerNumber.alpha = 0
        
        cell?.registerNumber.addTarget(self, action: #selector(registerNumber), for: .touchUpInside)
        cell?.sendOTPBtn.addTarget(self, action: #selector(sendOTP), for: .touchUpInside)
        return cell!
    }
    

    
    @objc func sendOTP(){
        let cell = profileTable.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileTableCell
        
        guard let phoneNumberEx = cell?.phoneNumber.phoneNumber else {
            self.showConfirmAlert(title: "", message: "Invalid mobile number!", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
            return }
        let phoneNumber = PhoneNumberKit().format(phoneNumberEx, toType: .e164) // +61236618300
        
        let params = ["contact_phone": phoneNumber, "purpose": "joining", "country_code": "IN"]
        cell?.sendOTPBtn.loadingIndicator(true, .blue, "")
        view.endEditing(true)
        Networking.shared.otp_send(perams: params) { (str, error) in
            if let _ = str {
                cell?.sendOTPBtn.loadingIndicator(false, .blue, "Send OTP")
                UIView.animate(withDuration: 0.5) {
                    cell?.mobileVerificationContainer.alpha = 1
                    cell?.otpDescLabel.alpha = 1
                    cell?.otpFeild.alpha = 1
                    cell?.registerNumber.alpha = 1
                    self.otpSuccess = true
                    cell?.mobileVerificationConstraint.constant = 128
                    self.view.layoutIfNeeded()
                }
            }
            if let er = error {
                cell?.sendOTPBtn.loadingIndicator(false, .blue, "Send OTP")
                self.showConfirmAlert(title: "", message: er.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
            }
        }
    }
    
    
    @objc func registerNumber(){
        let cell = profileTable.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileTableCell
        
        if cell?.otpFeild.text?.count == 0 {
            showConfirmAlert(title: "", message: "Please Enter Otp!!", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else{
            
            guard let phoneNumberEx = cell?.phoneNumber.phoneNumber else { return }
            let phoneNumber = PhoneNumberKit().format(phoneNumberEx, toType: .e164) // +61236618300
            
            let otpCode = cell?.otpFeild.text ?? ""
            let params = ["contact_phone": phoneNumber, "purpose": "joining", "otp": otpCode,"user_device_id":UIDevice.current.identifierForVendor?.uuidString ?? ""]
            cell?.registerNumber.loadingIndicator(true, .blue, "")
            Networking.shared.otp_verify(perams: params) { (str, error) in
                if let _ = str {
                    Networking.shared.deleteTempRecor(perams: ["contact_phone": phoneNumber]) { (success, error) in
                        if success != nil {
                            cell?.registerNumber.loadingIndicator(false, .blue, "Register Number")
                            UIView.animate(withDuration: 0.5) {
                                cell?.otpFeild.text = ""
                                self.flag_api = true
                                self.otpSuccess = false
                                cell?.mobileVerificationContainer.alpha = 0
                                cell?.otpDescLabel.alpha = 0
                                cell?.otpFeild.alpha = 0
                                cell?.registerNumber.alpha = 0
                                cell?.sendOTPConstraint.constant = 0
                                cell?.mobileVerificationConstraint.constant = 0
                                self.view.layoutIfNeeded()
                            }
                        }
                        if let err = error {
                            cell?.registerNumber.loadingIndicator(false, .blue, "Register Number")
                            self.showConfirmAlert(title: "", message: err.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                        }
                    }
                }
                if let er = error {
                    cell?.registerNumber.loadingIndicator(false, .blue, "Register Number")
                    self.showConfirmAlert(title: "", message: er.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                }
            }
        }
        
        
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var updatedTextString : NSString = textField.text! as NSString
        updatedTextString = updatedTextString.replacingCharacters(in: range, with: string) as NSString
//        if string == "," {
//            textField.text = textField.text! + "."
//            return false
//        }
//
        let cell = profileTable.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileTableCell
        if let textFieldString = textField.fullTextWith(range: range, replacementString: string) {
            if cell?.name == textField {
                if textFieldString.count >= 50 {
                    return false
                }
            }else if cell?.phoneNumber == textField {
                if textFieldString.count >= 25 {
                    return false
                }
                if !["1","2","3","4","5","6","7","8","9","0","","+"].contains(string) {
                    return false
                }
                var data = ""
                if flag_api == false {
                    data = model[0].contact_phone ?? ""
                }else{
                    data = cell?.phoneNumber.text ?? ""
                }
                let number = String(updatedTextString).replacingOccurrences(of: " ", with: "")
                if number != data {
                    cell?.mobileVerificationContainer.alpha = 1
                    cell?.otpDescLabel.alpha = 1
                    cell?.otpFeild.alpha = 1
                    cell?.registerNumber.alpha = 1
                    cell?.sendOTPConstraint.constant = 80
                    cell?.mobileVerificationConstraint.constant = 128
                    UIView.animate(withDuration: 0.5) {
                        self.view.layoutIfNeeded()
                    }
                }else{
                    cell?.mobileVerificationContainer.alpha = 0
                    cell?.otpDescLabel.alpha = 0
                    cell?.otpFeild.alpha = 0
                    cell?.registerNumber.alpha = 0
                    cell?.sendOTPConstraint.constant = 0
                    cell?.mobileVerificationConstraint.constant = 0
                    UIView.animate(withDuration: 0.5) {
                        self.view.layoutIfNeeded()
                    }
                }
            }else if cell?.bloodGrp == textField {
                if textFieldString.count >= 10 {
                    return false
                }
            }else if cell?.emergencyPhone == textField {
                if textFieldString.count >= 15 {
                    return false
                }
            }else if cell?.contactRelation == textField {
                if textFieldString.count >= 15 {
                    return false
                }
            }else if cell?.contactName == textField {
                if textFieldString.count >= 25 {
                    return false
                }
            }else if cell?.email == textField {
                if textFieldString.count >= 50 {
                    return false
                }
            }else if cell?.gstIdentificationNo == textField {
                if textFieldString.count >= 15 {
                    return false
                }
            }else if cell?.country == textField {
                if textFieldString.count >= 50 {
                    return false
                }
            }else if cell?.state == textField {
                if textFieldString.count >= 25 {
                    return false
                }
            }else if cell?.pinCode == textField {
                if textFieldString.count >= 10 {
                    return false
                }
            }else if cell?.city == textField {
                if textFieldString.count >= 25 {
                    return false
                }
            }else if cell?.address == textField {
                if textFieldString.count >= 150 {
                    return false
                }
            }
        }
        profileTable.beginUpdates()
        profileTable.endUpdates()
        return true
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    @objc func submitClicked(){
        var perams = [String:Any]()
        
        perams.updateValue(UserDefaults.cust_id, forKey: "cust_id")
        
        let cell = profileTable.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileTableCell
        if cell?.name.text?.count == 0 {
            self.showConfirmAlert(title: "", message: "Please enter the name", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else if cell?.email.text?.count == 0 {
            self.showConfirmAlert(title: "", message: "Please enter the Email", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else if let email = cell?.email.text, !isValidEmail(email) {
            self.showConfirmAlert(title: "", message: "Please enter the valid Email", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else if self.otpSuccess == true {
            self.showConfirmAlert(title: "", message: "Please register Mobile number", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else {
            perams.updateValue(cell?.name.text ?? "", forKey: "cust_name")
            perams.updateValue(cell?.gender.text ?? "", forKey: "gender")
            perams.updateValue(cell?.address.text ?? "", forKey: "address")
            perams.updateValue(cell?.city.text ?? "", forKey: "city")
            perams.updateValue(cell?.pinCode.text ?? "", forKey: "pin_code")
            perams.updateValue(cell?.state.text ?? "", forKey: "state")
            perams.updateValue(cell?.country.text ?? "", forKey: "country")
            
            guard let phoneNumberEx = cell?.phoneNumber.phoneNumber else { return }
            let phoneNumber = PhoneNumberKit().format(phoneNumberEx, toType: .e164) // +61236618300
            
            perams.updateValue(phoneNumber, forKey: "contact_phone")
            perams.updateValue(phoneCountry, forKey: "phone_country")
            perams.updateValue(true, forKey: "is_self_service")
            
            
            if let img1 = cell?.profileIcon.image {
                print(img1)
//                perams.updateValue(img1, forKey: "avatar_url")
            }
            
            
            if let img1 = cell?.profileIcon.image?.jpeg(.high)?.base64EncodedString() {
                perams.updateValue(img1, forKey: "avatar_url")
            }
            
            perams.updateValue(hide_contact, forKey: "hide_contact")
            perams.updateValue(is_mc_member, forKey: "is_mc_member")
            perams.updateValue(UserDefaults.isOtherUser, forKey: "is_other_user")
            perams.updateValue(UserDefaults.user_id, forKey: "user_id")
            perams.updateValue(cell?.hobbies.text ?? "", forKey: "hobbies")
            perams.updateValue(cell?.occupation.text ?? "", forKey: "occupation")
            perams.updateValue(cell?.bloodGrp.text ?? "", forKey: "blood_group")
            perams.updateValue(cell?.contactRelation.text ?? "", forKey: "emergency_contact_relation")
            perams.updateValue(cell?.contactName.text ?? "", forKey: "emergency_contact_name")
            perams.updateValue(cell?.emergencyPhone.text ?? "", forKey: "emergency_phone")
            perams.updateValue(cell?.email.text ?? "", forKey: "contact_email")
            perams.updateValue(cell?.gstIdentificationNo.text ?? "", forKey: "gst_no")
            
            SpinnerClass.shared.createSpinnerView(controller: self)
            Networking.shared.saveClicked(perams: perams) { (success, erro) in
                if let _ = success {
                    self.view.makeToast("Profile Updated Successfully!")
                    SpinnerClass.shared.removeActivityIndicator()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                if let erro = erro {
                    self.showConfirmAlert(title: "", message: erro.localizedDescription, buttonTitle: "Ok", buttonStyle: .default) { (ac) in
                        SpinnerClass.shared.removeActivityIndicator()
                    }
                }
            }
        }
    }
    
    
    @objc func cancelClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
        
    
    @objc func genderTapped(){
        genderDropDown.show()
    }
    
    @objc func pick_imageTapped(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func cam_imageTapped(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.cameraDevice = .front            
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let cell = profileTable.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileTableCell
        guard let image = info[.originalImage] as? UIImage else { return }
            cell?.profileIcon.image = image
            self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func showImageTapped(){
        guard let cell = profileTable.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileTableCell,  let imageview = cell.profileIcon.image else { return }
        let imageInfo   = GSImageInfo(image: imageview, imageMode: .aspectFit)
        let transitionInfo = GSTransitionInfo(fromView: cell.profileIcon)
        let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        self.present(imageViewer, animated: true, completion: nil)
    }
    
    @objc func showRelationShip(){
        contactRelationShip.show()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
