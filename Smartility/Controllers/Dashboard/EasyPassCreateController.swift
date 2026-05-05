//
//  EasyPassCreateController.swift
//  Smartility
//
//  Created by Mani on 7/21/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import LTHRadioButton
import  DropDown
import ContactsUI
import Contacts
import Kingfisher
import GSImageViewerController
import PhoneNumberKit


class EasyPassCreateController: UIViewController, imageCaptureDelegate, WWCalendarTimeSelectorProtocol, CNContactPickerDelegate {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var menuHeight: NSLayoutConstraint!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var backBgView: UIView!
    @IBOutlet weak var titleEasyPass: UILabel!
    
    let unitNoDropDown = DropDown()
    let issuedDropDown = DropDown()
    let genderDropDown = DropDown()
    let vehicleDropDown = DropDown()
    let vehicleIDTypeDropDown = DropDown()
    var UnitCusModel = [getUnitsByCustIdModel]()
    
    var unitNo = [String]()
    var unitIDList = [Int]()
    var unitID = Int()
    
    var unitID_feildData = ""
    
    var passPurpose = "P"
    var noExpiryClicks = false
    var easyPassClick = false
    var modelExistingData: EasyPassHolderDetail?
    var nonCliced = ""
    var easyPass_Expiry = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backBgView.setClickListener {
            self.navigationController?.popViewController(animated: true)
        }
        
        self.view.bringSubviewToFront(navigationBarView)
        navigationBarView.backgroundColor = .white
        navigationBarView.layer.shadowColor = UIColor(red: 0.049, green: 0.019, blue: 0.167, alpha: 0.2).cgColor
        navigationBarView.layer.shadowOpacity = 1
        navigationBarView.layer.shadowRadius = 1
        navigationBarView.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        self.tabBarController?.tabBar.isHidden = true

    
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                menuHeight.constant = 60
            case 1334:
                print("iPhone 6/6S/7/8")
                menuHeight.constant = 80
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
            default:
                menuHeight.constant = 90
            }
        }else{
            menuHeight.constant = 90
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        self.unitNoDropDown.selectionBackgroundColor = .white
        self.unitNoDropDown.backgroundColor = .white
        self.unitNoDropDown.cornerRadius = 10
        
        genderDropDown.dataSource = ["Male", "Female"]
        genderDropDown.selectionBackgroundColor = .white
        genderDropDown.backgroundColor = .white
        genderDropDown.cornerRadius = 10
        
        if UserDefaults.UserContry == "IN" {
            vehicleDropDown.dataSource = ["Car", "Two Wheeler", "Mini Truck", "Tanker", "None", "Others"]
        }else{
            vehicleDropDown.dataSource = ["Car", "Motorcycle", "None", "Others"]
        }
        
        vehicleDropDown.selectionBackgroundColor = .white
        vehicleDropDown.backgroundColor = .white
        vehicleDropDown.cornerRadius = 10
        
        
        if UserDefaults.UserContry == "IN" {
            vehicleIDTypeDropDown.dataSource = ["Aadhaar Card", "Driving License", "Passport", "Voter ID"]
        }else{
            vehicleIDTypeDropDown.dataSource = ["Driving License", "Goverment ID", "Mykad", "Passport"]
        }
        vehicleIDTypeDropDown.selectionBackgroundColor = .white
        vehicleIDTypeDropDown.backgroundColor = .white
        vehicleIDTypeDropDown.cornerRadius = 10
        
        issuedDropDown.dataSource = ["Guest", "Tutor", "Cab", "Delivery", "Vendor", "Daily Helper", "Driver"]
        issuedDropDown.selectionBackgroundColor = .white
        issuedDropDown.backgroundColor = .white
        issuedDropDown.cornerRadius = 10
        table.showActivityIndicator()
        let id = "\(UserDefaults.user_id)/\(community.community_id)"
        Networking.shared.getUnitsByUserId(id: id) { (model, error) in
            if let model = model {
                self.UnitCusModel = model
                self.UnitCusModel = self.UnitCusModel.filter { (mode) -> Bool in
                    mode.rel_status == "Linked"
                }
                
                model.forEach { (idlist) in
                    if idlist.rel_status == "Linked" {
                        if idlist.is_rented == 1 {
                            if idlist.ownership?.lowercased().contains("tenant") ?? false {
                                if let id_list = idlist.unit_id {
                                    self.unitIDList.append(id_list)
                                }
                                if let id_no = idlist.block_and_unit {
                                    self.unitNo.append(id_no)
                                }
                            }
                        }else{
                            if let id_list = idlist.unit_id {
                                self.unitIDList.append(id_list)
                            }
                            if let id_no = idlist.block_and_unit {
                                self.unitNo.append(id_no)
                            }
                        }
                    }
                }
                
                //                self.unitNo = self.UnitCusModel.compactMap {  $0.block_and_unit }
                //                self.unitNo = self.UnitCusModel.compactMap {  "\($0.block_nm ?? "") \($0.unit_no  ?? "")" }
                //                self.unitIDList = self.UnitCusModel.compactMap {  $0.unit_id }
                
                
                self.table.delegate = self
                self.table.dataSource = self
                self.table.reloadData()
                self.table.hideActivityIndicator()
            }
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeKeyBoard)))
    }
    
    @objc func closeKeyBoard(){
        view.endEditing(true)
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + table.rowHeight+150, right: 0)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        table.contentInset = .zero
    }
}

extension EasyPassCreateController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EasyPassTableViewCell", for: indexPath) as? EasyPassTableViewCell
        cell?.visitorName.isUserInteractionEnabled = true
        unitNoDropDown.anchorView = cell?.unitFeild
        unitNoDropDown.width = cell?.unitFeild.frame.size.width
        unitNoDropDown.bottomOffset = CGPoint(x: 0, y:((unitNoDropDown.anchorView?.plainView.bounds.height)!+5))
        unitNoDropDown.dataSource = unitNo
        
        cell?.visitorName.delegate = self
        cell?.vehicleNumber.delegate = self
        unitNoDropDown.selectionAction = {  (index: Int, item: String) in
            cell?.unitFeild.text = item
            self.unitID_feildData = item
            self.unitID = self.unitIDList[index]
        }
        
        if let smsEasyPass = CommunityData.sms_for_easypass, smsEasyPass == 1 {
            cell?.easyPassBtn.setTitle("Send EasyPass", for: .normal)
            cell?.sendBtnWidthConstaint.constant = 140
        }
        
        issuedDropDown.anchorView = cell?.issuedForFeild
        issuedDropDown.width = cell?.issuedForFeild.frame.size.width
        issuedDropDown.bottomOffset = CGPoint(x: 0, y:((issuedDropDown.anchorView?.plainView.bounds.height)!+5))
        
        issuedDropDown.selectionAction = {  (index: Int, item: String) in
            cell?.issuedForFeild.text = item
        }
        vehicleDropDown.anchorView = cell?.vehicleType
        vehicleDropDown.width = cell?.vehicleType.frame.size.width
        vehicleDropDown.bottomOffset = CGPoint(x: 0, y:((vehicleDropDown.anchorView?.plainView.bounds.height)!+5))
        
        vehicleDropDown.selectionAction = {  (index: Int, item: String) in
            cell?.vehicleType.text = item
        }
        genderDropDown.anchorView = cell?.gender
        genderDropDown.width = cell?.gender.frame.size.width
        genderDropDown.bottomOffset = CGPoint(x: 0, y:((genderDropDown.anchorView?.plainView.bounds.height)!+5))
        
        genderDropDown.selectionAction = {  (index: Int, item: String) in
            cell?.gender.text = item
        }
        
        vehicleIDTypeDropDown.anchorView = cell?.verifiedIDType
        vehicleIDTypeDropDown.width = cell?.verifiedIDType.frame.size.width
        vehicleIDTypeDropDown.bottomOffset = CGPoint(x: 0, y:((vehicleIDTypeDropDown.anchorView?.plainView.bounds.height)!+5))
        
        vehicleIDTypeDropDown.selectionAction = { (index: Int, item: String) in
            cell?.verifiedIDType.text = item
        }
                        
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        imageView.image = UIImage(named: "Contacts")
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
        imageContainerView.addSubview(imageView)
        
        let mobTapped = UITapGestureRecognizer(target: self, action: #selector(MobileTapped))
        mobTapped.numberOfTouchesRequired = 1
        imageContainerView.isUserInteractionEnabled = true
        imageContainerView.addGestureRecognizer(mobTapped)
        imageContainerView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(MobileTapped)))
                
        cell?.mobileFeild.rightView = imageContainerView
        cell?.mobileFeild.rightViewMode = .always
        cell?.mobileFeild.tintColor = .lightGray
        
        cell?.mobileFeild.delegate = self
        
        if self.unitIDList.count > 1 {
            cell?.unitFeild.isHidden = false
            cell?.unitLabel.isHidden = false
            cell?.unitHieght.constant = 37
            cell?.hightSpace.constant = 16
        }else{
            self.unitID_feildData = unitNo[safe: 0] ?? ""
            self.unitID = self.unitIDList[safe:0] ?? 0
            cell?.hightSpace.constant = 0
            cell?.unitHieght.constant = 0
            cell?.unitLabel.isHidden = true
            cell?.unitFeild.isHidden = true
        }
        
        if !easyPassClick {
            
            if UserDefaults.isOtherUser == 1 || (self.unitIDList.count == 0 && UserDefaults.isAdmin == 1) {
                self.passPurpose = "O"
                cell?.officialLabel.text = ""
                cell?.officialRadio.isHidden = true
                cell?.personalRadio.isHidden = true
                cell?.personalLabel.text = ""
                
            }else if UserDefaults.isAdmin == 0 {
                //perso
                self.passPurpose = "P"
                cell?.officialLabel.text = ""
                cell?.officialRadio.isHidden = true
                cell?.personalRadio.isHidden = true
                cell?.personalLabel.text = ""
                
            }else{
                self.passPurpose = "P"
                cell?.personalRadio.selectedColor = brandColor()
                cell?.personalRadio.select()
                cell?.officialRadio.deselect()
            }
            cell?.personalRadio.onSelect {
                self.passPurpose = "P"
                cell?.personalRadio.selectedColor = brandColor()
                cell?.personalRadio.select()
                cell?.officialRadio.deselect()
            }
            cell?.officialRadio.onSelect {
                self.passPurpose = "O"
                cell?.officialRadio.selectedColor = brandColor()
                cell?.officialRadio.select()
                cell?.personalRadio.deselect()
            }
            
            noExpiryClicks = true
            
            cell?.expiryFeild.font = UIFont.systemFont(ofSize: 12)
            cell?.Noexpiry.setTitleColor(.black, for: .normal)
            cell?.ExpiryBtn.setTitleColor(.white, for: .normal)
            
            cell?.expiryFeild.setupExpirryRightImage(imageName: "event")
            cell?.expiryFeild.isUserInteractionEnabled = true
            cell?.Noexpiry.backgroundColor  = UIColor.lightGray.withAlphaComponent(0.4)
            cell?.ExpiryBtn.backgroundColor  = brandColor()
            cell?.expiryFeild.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ExpiryClicked)))
            
        }else{
            
            titleEasyPass.text = "Update EasyPass"
            if UserDefaults.isOtherUser == 1 || (self.unitIDList.count == 0 && UserDefaults.isAdmin == 1) {
                //office
                self.passPurpose = "O"
                cell?.officialLabel.text = ""
                cell?.officialRadio.isHidden = true
                cell?.personalRadio.isHidden = true
                cell?.personalLabel.text = ""
            }else if UserDefaults.isAdmin == 0 {
                //perso
                self.passPurpose = "P"
                cell?.officialLabel.text = ""
                cell?.officialRadio.isHidden = true
                cell?.personalRadio.isHidden = true
                cell?.personalLabel.text = ""
            }else{
                
                if let off = modelExistingData?.is_official {
                    
                    if off == 0 {
                        cell?.personalRadio.selectedColor = brandColor()
                        cell?.personalRadio.select()
                        cell?.personalLabel.text = "Personal"
                        self.passPurpose = "P"
                    }else{
                        cell?.officialRadio.selectedColor = brandColor()
                        cell?.officialRadio.select()
                        self.passPurpose = "O"
                        cell?.officialLabel.text = "Official"
                    }
                    
                }
            }
            
            if let unitid = modelExistingData?.unit_id {
                self.unitID = unitid
            }
            cell?.issuedForFeild.text = modelExistingData?.visitor_cat
            cell?.mobileFeild.text = modelExistingData?.visitor_phone
            cell?.visitorName.text = modelExistingData?.visitor_name
            cell?.gender.text = modelExistingData?.gender
            cell?.vehicleType.text = modelExistingData?.vehicle_type
            cell?.vehicleNumber.text = modelExistingData?.vehicle_no
            cell?.verifiedIDType.text = modelExistingData?.id_type
            
            if let model = modelExistingData {
                
                for i in 0..<(unitIDList.count) where unitIDList[i] == model.unit_id {
                    cell?.unitFeild.text = unitNo[i]
                    self.unitID_feildData = unitNo[i]
                    unitID = unitIDList[i]
                }
                
                if model.is_no_expiry == 1 {
                    noExpiryClicks = false
                    cell?.expiryFeild.font = UIFont.systemFont(ofSize: 12)
                    cell?.Noexpiry.setTitleColor(.white, for: .normal)
                    cell?.ExpiryBtn.setTitleColor(.black, for: .normal)
                    cell?.expiryFeild.setupExpirryRightImage(imageName: "event", color: UIColor(hex: "BDBDBD"))
                    cell?.expiryFeild.isUserInteractionEnabled = false
                    cell?.Noexpiry.backgroundColor  = brandColor()
                    cell?.ExpiryBtn.backgroundColor  = UIColor.lightGray.withAlphaComponent(0.4)
                }else{
                    noExpiryClicks = true
                    
                    cell?.expiryFeild.font = UIFont.systemFont(ofSize: 12)
                    cell?.Noexpiry.setTitleColor(.black, for: .normal)
                    cell?.ExpiryBtn.setTitleColor(.white, for: .normal)
                    
                    if let expDat = model.easypass_exp {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        dateFormatter.timeZone = .current
                        if let date = dateFormatter.date(from: expDat) {
                            let dateFormatter1 = DateFormatter()
                            dateFormatter1.dateFormat = "yyyy-MM-dd"
                            let date = dateFormatter1.string(from: date)
                            cell?.expiryFeild.text = date
                        }
                    }
                    
                    cell?.expiryFeild.setupExpirryRightImage(imageName: "event")
                    cell?.expiryFeild.isUserInteractionEnabled = true
                    cell?.Noexpiry.backgroundColor  = UIColor.lightGray.withAlphaComponent(0.4)
                    cell?.ExpiryBtn.backgroundColor  = brandColor()
                    cell?.expiryFeild.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ExpiryClicked)))
                    
                }
                
                let profurl = URL(string: EndPoint.imageURL+(model.visitor_img_url ?? ""))
                let processor1 = DownsamplingImageProcessor(size: cell!.profile_icon.bounds.size)
                
                cell?.profile_icon.contentMode = .scaleAspectFill
                cell?.verified_image.contentMode = .scaleAspectFill
                
                cell?.profile_icon.kf.indicatorType = .activity
                cell?.profile_icon.kf.setImage(
                    with: profurl,
                    placeholder: UIImage(named: "proflie_icon"),
                    options: [
                        .processor(processor1),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ])
                {
                    result in
                    switch result {
                    case .success(let value):
                        cell?.attachLable.isHidden = true
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        cell?.attachLable.isHidden = false
                        print("Job failed: \(error.localizedDescription)")
                    }
                }
                
                let url = URL(string: EndPoint.imageURL+(model.id_img_url ?? ""))
                let processor = DownsamplingImageProcessor(size: cell!.verified_image.bounds.size)
                cell?.verified_image.kf.indicatorType = .activity
                cell?.verified_image.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "proflie_icon"),
                    options: [
                        .processor(processor),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ])
                {
                    result in
                    switch result {
                    case .success(let value):
                        cell?.notAvailabeLabel.isHidden = true
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        cell?.notAvailabeLabel.isHidden = false
                        print("Job failed: \(error.localizedDescription)")
                    }
                }
            }
        }
        
        cell?.Noexpiry.addTarget(self, action: #selector(noexpiryClicked), for: .touchUpInside)
        cell?.ExpiryBtn.addTarget(self, action: #selector(expiryClicked), for: .touchUpInside)
        cell?.verifiedCamBtn.addTarget(self, action: #selector(captuImageidProof), for: .touchUpInside)
        cell?.profileCamBtn.addTarget(self, action: #selector(captuImageProfile), for: .touchUpInside)
        cell?.unitFeild.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(unitIDClicked)))
        cell?.vehicleType.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(vehicleTypeClicked)))
        cell?.gender.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(genderClicked)))
        cell?.verifiedIDType.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(vehicleIDClicked)))
        cell?.issuedForFeild.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(issueDropClicked)))
        cell?.cancelBtn.addTarget(self, action: #selector(cancelCLicked), for: .touchUpInside)
        cell?.cancelBtn.alpha = 0.0
        cell?.easyPassBtn.addTarget(self, action: #selector(sendEPasTapped), for: .touchUpInside)
        cell?.easyPassBtn.backgroundColor = brandColor()
        cell?.easyPassBtn.setTitleColor(.white, for: .normal)
        cell?.profile_icon.isUserInteractionEnabled = true
        cell?.verified_image.isUserInteractionEnabled = true
        
        cell?.profile_icon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileICon)))
        cell?.verified_image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(proofofid)))
        
        return cell!
    }
    
    @objc func MobileTapped(){
        view.endEditing(true)
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys =
            [CNContactGivenNameKey
             , CNContactPhoneNumbersKey]
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
        print(contact.givenName)
        let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value
        let primaryPhoneNumberStr:String = firstPhoneNumber.stringValue
        print(primaryPhoneNumberStr)
        let cell = table.cellForRow(at: IndexPath(row: 0, section: 0)) as? EasyPassTableViewCell
        var trimmedString = primaryPhoneNumberStr.replacingOccurrences(of: " ", with: "")
        
        cell?.mobileFeild.text = trimmedString
        
        let char = trimmedString.prefix(1)
        if char != "+" {
            if let code = cell?.mobileFeild.phoneNumber?.countryCode {
                trimmedString = "+\(code)"+trimmedString
            }
        }
        cell?.mobileFeild.text = trimmedString
        
        cell?.mobileFeild.updateFlag()
        cell?.visitorName.text = contact.givenName+" "+contact.familyName
    }
    
    
    @objc func profileICon(){
        if easyPassClick {
            let cell = table.cellForRow(at: IndexPath(row: 0, section: 0)) as! EasyPassTableViewCell
            if let model = modelExistingData {
                let profurl = URL(string: EndPoint.imageURL+(model.visitor_img_url ?? ""))
                cell.profile_icon.kf.indicatorType = .activity
                cell.profile_icon.kf.setImage(
                    with: profurl,
                    placeholder: UIImage(named: "proflie_icon"),
                    options: nil, completionHandler:
                        {
                            result in
                            switch result {
                            case .success(let value):
                                let imageInfo   = GSImageInfo(image: value.image, imageMode: .aspectFit)
                                let transitionInfo = GSTransitionInfo(fromView: cell.profile_icon)
                                let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
                                self.present(imageViewer, animated: true, completion: nil)
                            case .failure(let _):
                                print("")
                            }
                        })
            }
        }
    }
    
    @objc func proofofid(){
        if easyPassClick {
            let cell = table.cellForRow(at: IndexPath(row: 0, section: 0)) as! EasyPassTableViewCell
            if let model = modelExistingData {
                let profurl = URL(string: EndPoint.imageURL+(model.id_img_url ?? ""))
                cell.verified_image.kf.indicatorType = .activity
                cell.verified_image.kf.setImage(
                    with: profurl,
                    placeholder: UIImage(named: "proflie_icon"),
                    options: nil, completionHandler:
                        {
                            result in
                            switch result {
                            case .success(let value):
                                let imageInfo   = GSImageInfo(image: value.image, imageMode: .aspectFit)
                                let transitionInfo = GSTransitionInfo(fromView: cell.verified_image)
                                let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
                                self.present(imageViewer, animated: true, completion: nil)
                            case .failure(let _):
                                print("")
                            }
                        })
            }
        }
    }
    
    @objc func sendEPasTapped(){
        
        let cell = table.cellForRow(at: IndexPath(row: 0, section: 0)) as! EasyPassTableViewCell
        
        
        var params  = [String:Any?]()
        
        
        
        guard let block_unit = cell.unitFeild.text else { return }
        guard let issuesFeild = cell.issuedForFeild.text else { return }
        guard let expiryFeild = cell.expiryFeild.text else { return }
        guard let idType = cell.verifiedIDType.text else { return }
        guard let vehicleNo = cell.vehicleNumber.text else { return }
        guard let vehicleTypa = cell.vehicleType.text else { return }
        guard let visitor_name = cell.visitorName.text else { return }
        
        guard let phone_numbe = cell.mobileFeild.text else { return }
        guard let gender = cell.gender.text else { return }
        
        if self.unitIDList.count > 1 {
            if block_unit.count == 0 {
                self.showConfirmAlert(title: "", message: "Please Choose Unit number", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                return
            }
        }
        if issuesFeild.count == 0 {
            self.showConfirmAlert(title: "", message: "Please Choose issued for fields", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else if phone_numbe.count == 0 {
            self.showConfirmAlert(title: "", message: "Please enter mobile no", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else if !(cell.mobileFeild.isValidNumber) {
            self.showConfirmAlert(title: "", message: "Invalid mobile number", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else if visitor_name.count == 0 {
            self.showConfirmAlert(title: "", message: "Please enter visitor name", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else if gender.count == 0 {
            self.showConfirmAlert(title: "", message: "Please choose gender", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else if vehicleTypa.count == 0 {
            self.showConfirmAlert(title: "", message: "Please choose vehicle type", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else if idType.count == 0 {
            self.showConfirmAlert(title: "", message: "Please choose Verified ID Type", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else if noExpiryClicks == true && expiryFeild.count == 0 {
            self.showConfirmAlert(title: "", message: "Please choose expiry date", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else if cell.profile_icon.image == nil {
            self.showConfirmAlert(title: "", message: "Please capture visitor photo", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else if cell.verified_image.image == nil {
            self.showConfirmAlert(title: "", message: "Please capture photo of ID", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else{
            
            if vehicleTypa != "None" &&  vehicleNo.count == 0 {
                self.showConfirmAlert(title: "", message: "Please enter vehicle number", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
            }else {
                
                let Phone_number = phone_numbe                
                params.updateValue(unitID_feildData, forKey: "block_and_unit")
                params.updateValue(community.community_id, forKey: "comm_id")
                params.updateValue(community.community_name, forKey: "comm_name")
                if expiryFeild.count != 0 {
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    
                    let formatter_1 = DateFormatter()
                    formatter_1.dateFormat = "HH:mm:ss"
                    
                    if let full_date = formatter.date(from: expiryFeild), let full_time = formatter_1.date(from: "23:59:59"){
                        let firstDate = full_date.toString(dateFormat: "yyyy-MM-dd'T'")
                        let firstTime = full_time.toString(dateFormat: "HH:mm:ss.SSSZ")
                        params.updateValue(firstDate+firstTime, forKey: "easypass_exp")
                    }
                    
                }else{
                    params.updateValue(nil, forKey: "easypass_exp")
                }
                
                params.updateValue(idType, forKey: "id_type")
                params.updateValue(true, forKey: "is_id_verified")
                params.updateValue(0, forKey: "is_no_expiry")
                params.updateValue(passPurpose == "O", forKey: "is_official")
                params.updateValue(passPurpose, forKey: "pass_purpose")
                
                
                if unitID == 0 {
                    params.updateValue(nil, forKey: "unit_id_list")
                }else{
                    params.updateValue([unitID], forKey: "unit_id_list")
                    params.updateValue(unitID, forKey: "unit_id")
                }
                
                params.updateValue(UserDefaults.user_id, forKey: "user_id")
                params.updateValue(UserDefaults.user_name, forKey: "user_name")
                params.updateValue(vehicleNo, forKey: "vehicle_no")
                params.updateValue(vehicleTypa, forKey: "vehicle_type")
                params.updateValue(issuesFeild, forKey: "visitor_cat")
                params.updateValue(gender, forKey: "gender")
                params.updateValue(visitor_name, forKey: "visitor_name")
                
                guard let phoneNumberEx = cell.mobileFeild.phoneNumber else { return }
                let mobile = PhoneNumberKit().format(phoneNumberEx, toType: .e164) // +61236618300
                
                params.updateValue(mobile, forKey: "visitor_phone")
                
                //            guard let img1 = UIImage(named:"pngima")?.pngData()?.base64EncodedString() else { return }
                //            guard let img2 = UIImage(named:"pngima")?.pngData()?.base64EncodedString() else { return }
                
                if let img1 = cell.profile_icon.image {
                    print(img1)
                }
                if let img2 = cell.verified_image.image {
                    print(img2)
                }
                
                
                if let img1 = cell.profile_icon.image?.jpeg(.high)?.base64EncodedString() {
                    params.updateValue(img1, forKey: "visitor_img_url")
                    print("------->",img1.count)
                }
                
                if let img2 = cell.verified_image.image?.jpeg(.high)?.base64EncodedString() {
                    params.updateValue(img2, forKey: "id_img_url")
                    print("------->",img2.count)
                }
                                
                if let easypass_no = modelExistingData?.easypass_no {
                    params.updateValue(easypass_no, forKey: "easypass_no")
                }
                                                
                if !easyPassClick {
                    update_create(visitorName: visitor_name, url: EndPoint.create_easy_Pass, params: params)
                }else{
                    if let id =  modelExistingData?.easypass_id{
                        params.updateValue(id, forKey: "easypass_id")
                    }
                    update_create(visitorName: visitor_name, url: EndPoint.update_easyPass, params: params)
                }
                //                }
            }
        }
    }
    func update_create(visitorName: String,url:String, params: [String : Any]){
        SpinnerClass.shared.createSpinnerView(controller: self)
        Networking.shared.myvisitor_create_pass(url: url ,parameters: params) { (success, error) in
            if success != nil {
                NotificationCenter.default.post(name: NSNotification.Name("UpdateActions"), object: nil)
                let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: QrCodeViewController.self)
                controller.invite_easyPass = "EasyPass"
                controller.shareFrom = ""
                controller.user_name = "- "+UserDefaults.user_name
                controller.wasSent = success?["was_sms_sent"] as? Int
                controller.glad_text = "Please find below your EasyPass number. Show this everytime at gate for smooth entry."
                controller.blockandUnit = self.unitID_feildData
                
                if let number = success?["easypass_no"] as? Int {
                    controller.otpInvite = "\(number)"
                    controller.shareFrom = ""
                    controller.easypass_update = false
                }else{
                    if let inviteNumber = self.modelExistingData?.easypass_no {
                        controller.otpInvite = "\(inviteNumber)"
                        controller.shareFrom = "update"
                        controller.easypass_update = true
                    }
                }
                SpinnerClass.shared.removeActivityIndicator()
                self.navigationController?.pushViewController(controller, animated: true)
            }
            if let er = error {
                self.showConfirmAlert(title: "", message: er.localizedDescription, buttonTitle: "Ok", buttonStyle: .default) { (action) in
                    SpinnerClass.shared.removeActivityIndicator()
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    @objc func countryFlagTapped() {
        //        let cell = table.cellForRow(at: IndexPath(row: 0, section: 0)) as? EasyPassTableViewCell
        //        let vc = PCCPViewController() { countryDic in
        //            if let dic = countryDic as? [String:Any]{
        //                if let phoneCode = dic["phone_code"] as? Int {
        //                    let flag = PCCPViewController.image(forCountryCode: dic["country_code"] as? String)
        //                    cell?.countryCode.text = "+"+String(phoneCode)
        //                    cell?.countryFlag.image = flag
        //                    self.navigationController?.popViewController(animated: true)
        //                }
        //            }
        //        }
        //        guard let controller = vc else { return }
        //        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func noexpiryClicked(){
        noExpiryClicks = false
        let cell = table.cellForRow(at: IndexPath(row: 0, section: 0)) as? EasyPassTableViewCell
        cell?.Noexpiry.setTitleColor(.white, for: .normal)
        cell?.ExpiryBtn.setTitleColor(.black, for: .normal)
        cell?.expiryFeild.setupExpirryRightImage(imageName: "event", color: UIColor(hex: "BDBDBD"))
        cell?.expiryFeild.isUserInteractionEnabled = false
        cell?.expiryFeild.text = ""
        cell?.Noexpiry.backgroundColor  = brandColor()
        cell?.ExpiryBtn.backgroundColor  = UIColor.lightGray.withAlphaComponent(0.4)
        
    }
    
    @objc func expiryClicked(){
        noExpiryClicks = true
        let cell = table.cellForRow(at: IndexPath(row: 0, section: 0)) as? EasyPassTableViewCell
        cell?.Noexpiry.setTitleColor(.black, for: .normal)
        cell?.ExpiryBtn.setTitleColor(.white, for: .normal)
        cell?.expiryFeild.setupExpirryRightImage(imageName: "event")
        cell?.expiryFeild.isUserInteractionEnabled = true
        cell?.expiryFeild.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ExpiryClicked)))
        cell?.Noexpiry.backgroundColor  = UIColor.lightGray.withAlphaComponent(0.4)
        cell?.ExpiryBtn.backgroundColor  = brandColor()
    }
    
    
    @objc func ExpiryClicked(){
        let selector = WWCalendarTimeSelector.instantiate()
        selector.delegate = self
        selector.optionTopPanelTitle = "Choose Date and Time"
        self.present(selector, animated: true, completion: nil)
    }
    
    
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        let cell = table.cellForRow(at: IndexPath(row: 0, section: 0)) as? EasyPassTableViewCell
        let dateString = date.toString(dateFormat: "yyyy-MM-dd")
        cell?.expiryFeild.text = dateString
    }
    
    func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool{
        let order = NSCalendar.current.compare(Date(), to: date, toGranularity: .day)
        if order == .orderedDescending{
            return false
        } else {
            return true
        }
    }
    
    @objc func captuImageProfile() {
        let controller = CustomCameraController()
        controller.profilePick = "Profile"
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func captuImageidProof() {
        let controller = CustomCameraController()
        controller.profilePick = "Proof"
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    
    func imageSendFrom(profile: UIImage?, proof: UIImage?) {
        let cell = table.cellForRow(at: IndexPath(row: 0, section: 0)) as? EasyPassTableViewCell
        if let prof = profile {
            cell?.attachLable.isHidden = true
            cell?.profile_icon.image = prof
            cell?.profile_icon.contentMode = .scaleAspectFill
        }
        if let prof = proof {
            cell?.notAvailabeLabel.isHidden = true
            cell?.verified_image.image = prof
            cell?.verified_image.contentMode = .scaleAspectFill
        }
    }
    
    @objc func cancelCLicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func unitIDClicked(){
        unitNoDropDown.show()
    }
    
    @objc func issueDropClicked(){
        issuedDropDown.show()
    }
    
    @objc func genderClicked(){
        genderDropDown.show()
    }
    
    @objc func vehicleTypeClicked(){
        vehicleDropDown.show()
    }
    
    @objc func vehicleIDClicked(){
        vehicleIDTypeDropDown.show()
    }
}


extension EasyPassCreateController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cell = table.cellForRow(at: IndexPath(row: 0, section: 0)) as? EasyPassTableViewCell
        if let textFieldString = textField.fullTextWith(range: range, replacementString: string) {
            if cell?.mobileFeild == textField {
                if textFieldString.count > 25 {
                    return false
                }
                cell?.mobileFeild.text = textFieldString
            }else if cell?.visitorName == textField {
                if textFieldString.count > 25 {
                    return false
                }
            }else if cell?.vehicleNumber == textField {
                if textFieldString.count > 15 {
                    return false
                }
            }
            
        }
        return true
    }
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}


