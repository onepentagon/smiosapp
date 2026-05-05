//
//  NewInviteControllerViewController.swift
//  Smartility
//
//  Created by Mani on 7/20/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import MaterialComponents
import PhoneNumberKit
import DropDown
import Contacts
import ContactsUI


class NewInviteController: UIViewController, CNContactPickerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var collectionsView: UICollectionView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var menuHeight: NSLayoutConstraint!
    @IBOutlet weak var navigationBarView: UIView!
    
    @IBOutlet weak var titleController: UILabel!
    @IBOutlet weak var backClicked: UIButton!
    @IBOutlet weak var backBgView: UIView!
    
    var inviteModel: InvitedDetail?
    
    var UnitCusModel = [getUnitsByCustIdModel]()
    var unitNo = [String]()
    var unitIDList = [Int]()
    var unitID = Int()
    let collection_data = ["Guest", "Daily Helper","Cab", "Delivery", "Vendor"]
    let collection_image = ["faceIconBlack", "people_Black","Cab_Black", "shopping_cartBlack", "build_icon_black"]
    let collection_white = ["face", "people", "Cab", "shopping_cart", "build_icon"]
    
    var selectedIndex = Int ()
    var dropDown = DropDown()
    
    var inivitePurpose = "P"
    var visitorCat = "Guest"
    var is_exp_shortly = true
    var clickedDate = ""
    var penFlagClicked = false
    
    var inviteData = false
    var unitID_feildData = ""
    var fullDate = ""
    
    var shortlyText = "We are glad to invite you to visit us shortly!"
    var laterText = "We are glad to invite you to visit us on "
//    var showBelowOtp = " Show below OTP at gate for seamless entry XXXX"
    var showBelowOtp = ""
    var date_string = ""
    var time_string = ""
    var date_time_UTC = ""
    
    var timeUTC = ""
    var dateUTC = ""
    
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
                self.menuHeight.constant = 60
            case 1334:
                print("iPhone 6/6S/7/8")
                self.menuHeight.constant = 80
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
            default:
                menuHeight.constant = 90
            }
        }else{
            menuHeight.constant = 90
        }
        table.showActivityIndicator()
                
        let id = "\(UserDefaults.user_id)/\(community.community_id)"
        Networking.shared.getUnitsByUserId(id: id) { (model, error) in
            if !self.inviteData {
                                       
                model?.forEach { (idlist) in
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
                
                
                self.titleController.text = "New Invite"
//                self.UnitCusModel = self.UnitCusModel.filter { (mode) -> Bool in
//                    mode.rel_status == "Linked"
//                }
//                self.unitNo = self.UnitCusModel.compactMap {  "\($0.block_nm ?? "") \($0.unit_no  ?? "")" }
//                self.unitIDList = self.UnitCusModel.compactMap {  $0.unit_id }
                self.table.delegate = self
                self.table.dataSource = self
                self.table.reloadData()
                self.collectionsView.delegate = self
                self.collectionsView.dataSource = self
                //                let layout = CenterFlowLayout()
                let layout = UICollectionViewFlowLayout()
                layout.minimumLineSpacing = 0
                layout.minimumInteritemSpacing = 0
                self.collectionsView.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
                self.selectedIndex = 0
                self.collectionsView.reloadData()
                self.table.hideActivityIndicator()
            }else{
                self.titleController.text = "Update Invite"
                if let model = model {
                    self.UnitCusModel = model
                }
                if let cat = self.inviteModel?.visitor_cat {
                    for i in 0..<self.collection_data.count where self.collection_data[i] == cat {
                        self.selectedIndex = i
                    }
                }
                
                self.UnitCusModel = self.UnitCusModel.filter { (mode) -> Bool in
                    mode.rel_status == "Linked"
                }
                self.unitNo = self.UnitCusModel.compactMap {  "\($0.block_nm ?? "") \($0.unit_no  ?? "")" }
                self.unitIDList = self.UnitCusModel.compactMap {  $0.unit_id }
                self.table.delegate = self
                self.table.dataSource = self
                self.table.reloadData()
                self.collectionsView.delegate = self
                self.collectionsView.dataSource = self
                //                let layout = CenterFlowLayout()
                let layout = UICollectionViewFlowLayout()
                layout.minimumLineSpacing = 0
                layout.minimumInteritemSpacing = 0;
                self.collectionsView.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
                self.collectionsView.reloadData()
                self.table.hideActivityIndicator()
            }
        }
        
        table.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hidekeyBoad)))
    }
    @objc func hidekeyBoad(){
        table.endEditing(true)
    }
    
    @IBAction func newInvitesClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension NewInviteController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collection_data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewInviteCollectionViewCell", for: indexPath) as? NewInviteCollectionViewCell
        cell?.nameText.text = collection_data[indexPath.row]
        cell?.logo.image = UIImage(named: collection_image[indexPath.row])
        cell?.containerBack.cornerRadius = 10
        
        cell?.containerBack.tag = indexPath.row
        cell?.containerBack.addTarget(self, action: #selector(cardTapped), for: .touchUpInside)
        
        if selectedIndex == indexPath.row {
            cell?.logo.image = UIImage(named: collection_white[indexPath.row])
            cell?.nameText.textColor = .white
            cell?.containerBack.backgroundColor = brandColor().withAlphaComponent(0.7)
        }else{
            cell?.nameText.textColor = .black
            cell?.containerBack.backgroundColor = UIColor(hex: "#E0E0E0")
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0:
            return CGSize(width: 85, height: 35)
        case 1:
            return CGSize(width: 120, height: 35)
        case 2:
            return CGSize(width: 80, height: 35)
        case 3:
            return CGSize(width: 120, height: 35)
        case 4:
            return CGSize(width: 110, height: 35)
        default:
            return CGSize(width: collectionView.frame.width/2-10, height: 50)
        }
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //        return 0
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    //        return 0
    //    }
    
    
    @objc func cardTapped(vi: MDCCard){
        visitorCat = collection_data[vi.tag]
        selectedIndex = vi.tag
        collectionsView.reloadData()
        table.reloadData()
    }
    
}


extension NewInviteController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewInviteTableViewCell", for: indexPath) as? NewInviteTableViewCell
        cell?.name.isUserInteractionEnabled = true
        cell?.name.delegate = self
        cell?.gladeText.numberOfLines = 0
        cell?.gladeText.adjustsFontSizeToFitWidth = true
        cell?.editeText.delegate = self
        cell?.editeText.text = laterText
        dropDown.selectionBackgroundColor = .white
        dropDown.backgroundColor = .white
        dropDown.anchorView = cell?.unitIDFeild
        dropDown.dataSource = unitNo
        dropDown.width = cell?.unitIDFeild.frame.size.width
        dropDown.cornerRadius = 10
        dropDown.bottomOffset = CGPoint(x: 0, y:((dropDown.anchorView?.plainView.bounds.height)!+5))
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            cell?.unitIDFeild.text = item
            self.unitID = self.unitIDList[index]
        }
        cell?.editeText.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        cell?.editeText.layer.borderWidth = 0.5
        cell?.editeText.layer.cornerRadius = 10
        cell?.editeText.layer.masksToBounds = true
        cell?.sendInviteBtn.layer.cornerRadius = 10
        cell?.sendInviteBtn.layer.masksToBounds = true
        
        cell?.mobileNoFeild.delegate = self
                
        if let smsInvite = CommunityData.sms_for_invite, smsInvite == 1 {
            cell?.sendInviteBtn.setTitle("Send Invite", for: .normal)
            cell?.sendBtnWidthConstaint.constant = 110
        }
        
        
        if self.unitIDList.count > 1 {
            cell?.unitLabel.isHidden = false
            cell?.unitIDFeild.isHidden = false
            cell?.spaceunitNoConstaint.constant = 13
            cell?.unitHeightConstraint.constant = 37
        }else{
//            self.unitID_feildData = unitNo[safe: 0] ?? ""
//            self.unitID = self.unitIDList[safe:0] ?? 0
            cell?.spaceunitNoConstaint.constant = 0
            cell?.unitHeightConstraint.constant = 0
            cell?.unitLabel.isHidden = true
            cell?.unitIDFeild.isHidden = true
            
            self.unitID_feildData = unitNo[safe: 0] ?? ""
            self.unitID = self.unitIDList[safe:0] ?? 0
        }
        
        if !self.inviteData {
            cell?.personalRadio.selectedColor = brandColor()
            cell?.personalRadio.select()
            cell?.mobileNoFeild.keyboardType = .phonePad
            cell?.personalRadio.onSelect {
                self.inivitePurpose = "P"
                cell?.personalRadio.selectedColor = brandColor()
                cell?.personalRadio.select()
                cell?.officialRadio.deselect()
            }
            cell?.officialRadio.onSelect {
                self.inivitePurpose = "O"
                cell?.personalRadio.deselect()
                cell?.officialRadio.selectedColor = brandColor()
                cell?.officialRadio.select()
            }
            
            if UserDefaults.isOtherUser == 1 || (self.unitIDList.count == 0 && UserDefaults.isAdmin == 1) {
                //office
                cell?.officialRadio.selectedColor = brandColor()
                cell?.officialRadio.select()
                self.inivitePurpose = "O"
                cell?.personalRadio.isHidden = true
                cell?.personalLabel.text = ""
                cell?.officialLabel.text = "Official"
                cell?.officialRadio.isHidden = false
                
                cell?.radioConstraint.constant = 0
                cell?.officialHeightConstraint.constant = 0
                cell?.officialLabel.text = ""
                cell?.officialRadio.isHidden = true
                cell?.personalRadio.isHidden = true
                cell?.personalLabel.text = ""
                
            }else if UserDefaults.isAdmin == 0 {
                //perso
                cell?.personalRadio.selectedColor = brandColor()
                cell?.personalRadio.select()
                cell?.officialLabel.text = ""
                cell?.officialRadio.isHidden = true
                cell?.personalRadio.isHidden = true
                cell?.personalRadio.isHidden = false
                cell?.personalLabel.text = "Personal"
                self.inivitePurpose = "P"
                
                cell?.radioConstraint.constant = 0
                cell?.officialHeightConstraint.constant = 0
                cell?.officialLabel.text = ""
                cell?.officialRadio.isHidden = true
                cell?.personalRadio.isHidden = true
                cell?.personalLabel.text = ""
            }else{
                cell?.radioConstraint.constant = 15
                cell?.officialHeightConstraint.constant = 24
                // show the radio button user choose personal // office
                cell?.officialLabel.text = "Official"
                cell?.officialRadio.isHidden = false
                cell?.personalRadio.isHidden = false
                cell?.personalLabel.text = "Personal"
            }
            
            if selectedIndex == 0 {
                cell?.gladeText.text = laterText+showBelowOtp
                cell?.editeLabel.isHidden = false
                cell?.heightConsta.constant = 72
                cell?.heightConstraint.constant = 0
//                penFlagClicked = false
                cell?.editeBack.isHidden = false
            }else{
//                penFlagClicked = false
                cell?.gladeText.text = ""
                cell?.editeLabel.isHidden = true
                cell?.heightConsta.constant = 0
                cell?.heightConstraint.constant = 0
                cell?.editeBack.isHidden = true
            }
            is_exp_shortly = false
            cell?.shortlyLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            cell?.laterLabel.backgroundColor = brandColor()
            cell?.laterLabel.textColor = .white
            cell?.shortlyLabel.textColor = .black
            cell?.dateFeild.setupRightImage(imageName: "event")
            cell?.aroundFeild.setupRightImage(imageName: "clock")
            cell?.dateFeild.isUserInteractionEnabled = true
            cell?.aroundFeild.isUserInteractionEnabled = true
            
        }else{
                                    
            if UserDefaults.isOtherUser == 1 || (self.unitIDList.count == 0 && UserDefaults.isAdmin == 1) {
                //office
                cell?.radioConstraint.constant = 0
                cell?.officialHeightConstraint.constant = 0
                self.inivitePurpose = "O"
                cell?.officialLabel.text = ""
                cell?.officialRadio.isHidden = true
                cell?.personalRadio.isHidden = true
                cell?.personalLabel.text = ""
            }else if UserDefaults.isAdmin == 0 {
                //perso
                cell?.radioConstraint.constant = 0
                cell?.officialHeightConstraint.constant = 0
                self.inivitePurpose = "P"
                cell?.officialLabel.text = ""
                cell?.officialRadio.isHidden = true
                cell?.personalRadio.isHidden = true
                cell?.personalLabel.text = ""
                
            }else{
                cell?.radioConstraint.constant = 15
                cell?.officialHeightConstraint.constant = 24
                // show the radio button user choose personal // office
//                cell?.officialLabel.text = "Official"
//                cell?.officialRadio.isHidden = false
//                cell?.personalRadio.isHidden = false
//                cell?.personalLabel.text = "Personal"
                
                if let off = inviteModel?.is_official {
                    
                    if off == 0 {
                        cell?.personalRadio.selectedColor = brandColor()
                        cell?.personalRadio.select()
                        cell?.personalLabel.text = "Personal"
                        self.inivitePurpose = "P"
                    }else{
                        cell?.officialRadio.selectedColor = brandColor()
                        cell?.officialRadio.select()
                        self.inivitePurpose = "O"
                        cell?.officialLabel.text = "Official"
                    }
                }
            }
                        
           
            
            
            cell?.personalRadio.onSelect {
                self.inivitePurpose = "P"
                cell?.personalRadio.selectedColor = brandColor()
                cell?.personalRadio.select()
                cell?.officialRadio.deselect()
            }
            
            cell?.officialRadio.onSelect {
                self.inivitePurpose = "O"
                cell?.personalRadio.deselect()
                cell?.officialRadio.selectedColor = brandColor()
                cell?.officialRadio.select()
            }
            
            
            if let id = inviteModel?.unit_id {
                print(UnitCusModel)
                for i in 0..<UnitCusModel.count where  UnitCusModel[i].unit_id == id {
                    cell?.unitIDFeild.text = UnitCusModel[i].block_and_unit
                    self.unitID = UnitCusModel[i].unit_id!
                }
            }
            
            cell?.mobileNoFeild.text = inviteModel?.visitor_phone
            cell?.heightConstraint.constant = 0
            cell?.name.text =  inviteModel?.visitor_name
            cell?.editeText.text = inviteModel?.invite_text
            if let invited_text = inviteModel?.invite_text {
                cell?.gladeText.text = invited_text+showBelowOtp
            }
            
            
            if let isExpectedShortly = inviteModel?.is_exp_shortly {
                if isExpectedShortly == 0 {
                    is_exp_shortly = false
                                                                                
                    cell?.shortlyLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
                    cell?.laterLabel.backgroundColor = brandColor()
                    cell?.laterLabel.textColor = .white
                    cell?.shortlyLabel.textColor = .black
                    cell?.dateFeild.setupRightImage(imageName: "event")
                    cell?.aroundFeild.setupRightImage(imageName: "clock")
                    cell?.dateFeild.isUserInteractionEnabled = true
                    cell?.aroundFeild.isUserInteractionEnabled = true
                    
                    if let date_time = inviteModel?.invited_dt_time {
                       
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        dateFormatter.timeZone = .current
                                                
                        if let date = dateFormatter.date(from: date_time) {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            cell?.dateFeild.text = dateFormatter.string(from: date)
                                                        
                            dateUTC = dateFormatter.string(from: date)
                            
                            let dateFormatter1 = DateFormatter()
                            dateFormatter1.dateFormat = "HH:mm"
                                                         
                            dateUTC = date.toString(dateFormat: "yyyy-MM-dd'T'")
                            timeUTC = date.toString(dateFormat: "HH:mm:ss.SSSZ")
                                   
                            time_string = date.toString(dateFormat: "hh:mm a")
                            date_string = date.toString(dateFormat: "dd-MM-yyyy")
                            
                            cell?.aroundFeild.text = dateFormatter1.string(from: date)
                        }
                    }
                }else{
                    is_exp_shortly = true
                    
                    cell?.shortlyLabel.backgroundColor = brandColor()
                    cell?.dateFeild.text = ""
                    cell?.aroundFeild.text = ""
                    cell?.shortlyLabel.textColor = .white
                    cell?.laterLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
                    cell?.laterLabel.textColor = .black
                    cell?.dateFeild.setupRightImage(imageName: "event",color: UIColor(hex: "BDBDBD"))
                    cell?.aroundFeild.setupRightImage(imageName: "clock",color: UIColor(hex: "BDBDBD"))
                    cell?.dateFeild.isUserInteractionEnabled = false
                    cell?.aroundFeild.isUserInteractionEnabled = false
                }
            }
        }
        
        
        cell?.dateFeild.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dateFeildCLicked)))
        cell?.aroundFeild.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(aroundClicked)))
        
        cell?.sendInviteBtn.addTarget(self, action: #selector(sendInviteClicked), for: .touchUpInside)
        cell?.unitIDFeild.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(unitid_clicked)))
        cell?.cancelBtn.addTarget(self, action: #selector(cancelClicked), for: .touchUpInside)
        cell?.cancelBtn.alpha = 0.0
        cell?.shortlyLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shoortyCliked)))
        cell?.laterLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(laterCliked)))
        cell?.editeBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(penClicked)))
                        
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        imageView.image = UIImage(named: "Contacts")
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
        imageContainerView.addSubview(imageView)
        
        let mobTapped = UITapGestureRecognizer(target: self, action: #selector(mobileTapped))
        mobTapped.numberOfTouchesRequired = 1
        imageContainerView.isUserInteractionEnabled = true
        imageContainerView.addGestureRecognizer(mobTapped)
        imageContainerView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(mobileTapped)))        
        cell?.mobileNoFeild.rightView = imageContainerView
        cell?.mobileNoFeild.rightViewMode = .always
        cell?.mobileNoFeild.tintColor = .lightGray
        
        if selectedIndex == 0 {
            if penFlagClicked {
//                UIView.animate(withDuration: 0.5, animations: {
                    cell?.heightConstraint.constant = 120
//                })
            }else{
//                UIView.animate(withDuration: 0.5, animations: {
                    cell?.heightConstraint.constant = 0
//                })
            }
        }else{
            cell?.heightConstraint.constant = 0
        }
        return cell!
    }
    

    
    func dateFromString(dateString:String)->Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: dateString) {
            return date
        }else{
            return nil
        }
    }
    
    @objc func penClicked(){
        let cell = table.cellForRow(at: IndexPath(row: 0, section: 0)) as? NewInviteTableViewCell
        if selectedIndex == 0 {
            if !penFlagClicked {
                penFlagClicked = true
                cell?.heightConstraint.constant = 120
            }else{
                penFlagClicked = false
                cell?.heightConstraint.constant = 0
            }
        }else{
            cell?.heightConstraint.constant = 0
        }
        let loc = table.contentOffset
        UIView.performWithoutAnimation {
            table.layoutIfNeeded()
            table.beginUpdates()
            table.endUpdates()
            
            table.layer.removeAllAnimations()
        }
        table.setContentOffset(loc, animated: true)
    }
    
    @objc func mobileTapped(){
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
        let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value
        let primaryPhoneNumberStr:String = firstPhoneNumber.stringValue
        print(primaryPhoneNumberStr)
        let cell = table.cellForRow(at: IndexPath(row: 0, section: 0)) as? NewInviteTableViewCell
        var trimmedString = primaryPhoneNumberStr.replacingOccurrences(of: " ", with: "")
        print(trimmedString)
        cell?.mobileNoFeild.text = trimmedString
        
        let char = trimmedString.prefix(1)
        if char != "+" {
            if let code = cell?.mobileNoFeild.phoneNumber?.countryCode {
                trimmedString = "+\(code)"+trimmedString
            }
        }
        cell?.mobileNoFeild.text = trimmedString
        cell?.mobileNoFeild.updateFlag()
        cell?.name.text = contact.givenName+" "+contact.familyName
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    @objc func sendInviteClicked(sender:UIButton){
        let cell = table.cellForRow(at: IndexPath(row: 0, section: 0)) as? NewInviteTableViewCell
        var perams = [String:Any?]()
                    
//        let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: QrCodeViewController.self)
//        controller.invite_easyPass = "invite"
//        controller.name_visitor = "- Mani"
//        controller.wasSent = 0
//        controller.glad_text = "glad text"
//        controller.blockandUnit = "834tn skfdhgdfg kjsfg"
//        controller.otpInvite = "273656"
//        self.navigationController?.pushViewController(controller, animated: true)
                
        if self.unitIDList.count > 1 {
            guard let unitFeild = cell?.unitIDFeild.text , unitFeild.count != 0 else {
                showConfirmAlert(title: "", message: "Choose Unit No", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                return
            }
            perams.updateValue(unitFeild, forKey: "block_and_unit")
        }else{
            perams.updateValue(unitID_feildData, forKey: "block_and_unit")
        }
        guard let mobileNo = cell?.mobileNoFeild.text , mobileNo.count != 0 else {
            showConfirmAlert(title: "", message: "Enter Mobile No!", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
            return
        }
        
        if !(cell?.mobileNoFeild.isValidNumber ?? true) {
            self.showConfirmAlert(title: "", message: "Invalid mobile number", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
            return
        }
        guard let name = cell?.name.text , name.count != 0 else {
            showConfirmAlert(title: "", message: "Enter name!", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
            return
        }        
        //        guard let countyCode = cell?.countryCode.text , countyCode.count != 0 else  {
        //            showConfirmAlert(title: "", message: "Choose Country Code!", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        //            return
        //        }
        if !is_exp_shortly {
            guard let dateFeild = cell?.dateFeild.text , dateFeild.count != 0 else  {
                showConfirmAlert(title: "", message: "Choose Date!", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                return
            }
            guard let around = cell?.aroundFeild.text , around.count != 0 else {
                showConfirmAlert(title: "", message: "Choose Around time!", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                return
            }
            
            date_time_UTC = dateUTC+timeUTC
            
            perams.updateValue(date_time_UTC, forKey: "invited_dt_time")
//            perams.updateValue(dateFeild, forKey: "invited_dt")
//            perams.updateValue(around, forKey: "invited_time")
            
        }
                
        
        guard let editeText = cell?.editeText.text, editeText.count != 0 else {
            showConfirmAlert(title: "", message: "Enter the invite Description!", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
            return
        }
        
        perams.updateValue(editeText, forKey: "invite_text")
        
        if visitorCat == "Guest" {
            guard let editeText = cell?.editeText.text, editeText.count != 0 else {
                showConfirmAlert(title: "", message: "Enter the invite Description!", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                return
            }
            perams.updateValue(editeText, forKey: "invite_text")
        }
        
        
        perams.updateValue(community.community_id, forKey: "comm_id")
        perams.updateValue(community.community_name, forKey: "comm_name")
        
        perams.updateValue(inivitePurpose, forKey: "invite_purpose")
        
        perams.updateValue(visitorCat, forKey: "visitor_cat")
        perams.updateValue(name, forKey: "visitor_name")
        perams.updateValue(nil, forKey: "visitor_org")
        
        guard let phoneNumberEx = cell?.mobileNoFeild.phoneNumber else { return }
        let mobile = PhoneNumberKit().format(phoneNumberEx, toType: .e164) // +61236618300
        
        perams.updateValue(mobile, forKey: "visitor_phone")
                
        perams.updateValue(inivitePurpose == "O", forKey: "is_official")
        
        perams.updateValue(is_exp_shortly, forKey: "is_exp_shortly")
        
        if self.unitID == 0 {
            perams.updateValue(nil, forKey: "unit_id")
        }else{
            perams.updateValue(self.unitID, forKey: "unit_id")
        }
                
        perams.updateValue(UserDefaults.user_id, forKey: "user_id")
        perams.updateValue(UserDefaults.user_name, forKey: "user_name")
        print(unitIDList)
        SpinnerClass.shared.createSpinnerView(controller: self)
        if !self.inviteData {
            perams.updateValue(UserDefaults.user_name, forKey: "user_name")
            Networking.shared.create_invite(parameters: perams) { (success, error) in
                if success != nil {
                    var unitB = ""
                    if self.unitIDList.count > 1 {
                        if let unitFeild = cell?.unitIDFeild.text {
                            unitB = unitFeild
                        }
                    }else{
                        unitB = self.unitID_feildData
                    }
                    
                    NotificationCenter.default.post(name: NSNotification.Name("UpdateActions"), object: nil)                    
                    let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: QrCodeViewController.self)
                    controller.invite_easyPass = "invite"
                    controller.user_name = "- "+UserDefaults.user_name
                    controller.wasSent = success?["was_sms_sent"] as? Int
                    controller.glad_text = cell?.gladeText.text ?? ""
                    controller.blockandUnit = unitB
                    if let inviteNumber = success?["invited_otp"] as? Int {
                        controller.otpInvite = "\(inviteNumber)"
                    }
                    SpinnerClass.shared.removeActivityIndicator()
                    self.navigationController?.pushViewController(controller, animated: true)
                }else{
                    SpinnerClass.shared.removeActivityIndicator()
                    self.showConfirmAlert(title: "", message: error?.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                }
            }
        }else{
            guard let inviteid = inviteModel?.invite_id  else { return }
            perams.updateValue(inviteid, forKey: "invite_id")
            Networking.shared.update_invite(parameters: perams) { (success, error) in
                if success != nil {
                    
                    var unitB = ""
                    if self.unitIDList.count > 1 {
                        if let unitFeild = cell?.unitIDFeild.text {
                            unitB = unitFeild
                        }
                    }else{
                        unitB = self.unitID_feildData
                    }
                    
                    NotificationCenter.default.post(name: NSNotification.Name("UpdateActions"), object: nil)
                    
                    let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: QrCodeViewController.self)
                    controller.invite_easyPass = "invite"
                    controller.user_name = "- "+UserDefaults.user_name
                    controller.wasSent = success?["was_sms_sent"] as? Int
                    controller.glad_text = cell?.gladeText.text ?? ""
                    controller.blockandUnit = unitB
                    controller.invite_update = true
                    if let inviteNumber = success?["invited_otp"] as? Int {
                        controller.otpInvite = "\(inviteNumber)"
                    }
                    SpinnerClass.shared.removeActivityIndicator()
                    self.navigationController?.pushViewController(controller, animated: true)
                }else{
                    SpinnerClass.shared.removeActivityIndicator()
                    self.showConfirmAlert(title: "", message: error?.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                }
            }
        }
    
        
    }
    
    @objc func cancelClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func unitid_clicked(){
        dropDown.show()
    }
    
    @objc func dateFeildCLicked(){
        clickedDate = "Date"
        view.endEditing(true)
        let selector = WWCalendarTimeSelector.instantiate()
        selector.delegate = self
        selector.optionTopPanelTitle = "Choose Date"
        self.present(selector, animated: true, completion: nil)
    }
    
    @objc func aroundClicked(){
        clickedDate = "Around"
        view.endEditing(true)
        let selector = WWCalendarTimeSelector.instantiate()
        selector.optionStyles.showTime(true)        
        selector.optionStyles.showDateMonth(false)
        selector.optionStyles.showYear(false)
        selector.delegate = self
        selector.optionTopPanelTitle = "Choose Date"
        self.present(selector, animated: true, completion: nil)
    }
    
    @objc func shoortyCliked(){
        is_exp_shortly = true
        let cell = table.cellForRow(at: IndexPath(row: 0, section: 0)) as? NewInviteTableViewCell
        cell?.shortlyLabel.backgroundColor = brandColor()
        cell?.dateFeild.text = ""
        cell?.aroundFeild.text = ""
        cell?.shortlyLabel.textColor = .white
        cell?.laterLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        cell?.laterLabel.textColor = .black
        cell?.dateFeild.setupRightImage(imageName: "event",color: UIColor(hex: "BDBDBD"))
        cell?.aroundFeild.setupRightImage(imageName: "clock",color: UIColor(hex: "BDBDBD"))
        cell?.dateFeild.isUserInteractionEnabled = false
        cell?.aroundFeild.isUserInteractionEnabled = false
                
        cell?.editeText.text = shortlyText
        cell?.gladeText.text = shortlyText+showBelowOtp
    }
      
    @objc func laterCliked(){
        is_exp_shortly = false
        let cell = table.cellForRow(at: IndexPath(row: 0, section: 0)) as? NewInviteTableViewCell
        cell?.shortlyLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        cell?.laterLabel.backgroundColor = brandColor()
        cell?.laterLabel.textColor = .white
        cell?.shortlyLabel.textColor = .black
        cell?.dateFeild.setupRightImage(imageName: "event")
        cell?.aroundFeild.setupRightImage(imageName: "clock")
        cell?.dateFeild.isUserInteractionEnabled = true
        cell?.aroundFeild.isUserInteractionEnabled = true
        cell?.dateFeild.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dateFeildCLicked)))
        cell?.aroundFeild.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(aroundClicked)))
        
        cell?.dateFeild.text = ""
        cell?.aroundFeild.text = ""
        cell?.editeText.text = laterText
        cell?.gladeText.text = laterText+showBelowOtp
    }    
}


extension NewInviteController: WWCalendarTimeSelectorProtocol, UITextFieldDelegate {
            
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let cell = table.cellForRow(at: IndexPath(row: 0, section: 0)) as? NewInviteTableViewCell
        if let te = textView.text{
            cell?.gladeText.text = te+showBelowOtp
        }
        let maxLength = 200
        let currentString: NSString = textView.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: text) as NSString
        return newString.length <= maxLength
                
    }
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        let cell = table.cellForRow(at: IndexPath(row: 0, section: 0)) as? NewInviteTableViewCell
                        
        if clickedDate == "Around" {
            time_string = date.toString(dateFormat: "hh:mm a")
            timeUTC = date.toString(dateFormat: "HH:mm:ss.SSSZ")
//            cell?.aroundFeild.text = date.toString(dateFormat: "HH:mm")
            cell?.aroundFeild.text = date.toString(dateFormat: "HH:mm")
        }else if clickedDate == "Date" {
            date_string = date.toString(dateFormat: "dd-MM-yyyy")
            dateUTC = date.toString(dateFormat: "yyyy-MM-dd'T'")
            cell?.dateFeild.text = date.toString(dateFormat: "yyyy-MM-dd")
        }
        
        fullDate = date_string+" around "+time_string
        cell?.editeText.text = laterText+fullDate+"!"
        cell?.gladeText.text = laterText+fullDate+"!"+showBelowOtp
    }
    
    func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool{
        let order = NSCalendar.current.compare(Date(), to: date, toGranularity: .day)
        if order == .orderedDescending{
            return false
        } else {
            return true
        }
    }
    
    
}

extension NewInviteController {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cell = table.cellForRow(at: IndexPath(row: 0, section: 0)) as? NewInviteTableViewCell
        if let textFieldString = textField.fullTextWith(range: range, replacementString: string) {
            if cell?.mobileNoFeild == textField {
                if textFieldString.count > 25 {
                    return false
                }
                cell?.mobileNoFeild.text = textFieldString
            }else if cell?.name == textField {
                if textFieldString.count > 25 {
                    return false
                }
            }
        }
        if let valid = cell?.mobileNoFeild.isValidNumber, valid == true {
            
        }else{
            
        }
        return true
    }
}


class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        
        return attributes
    }
}
