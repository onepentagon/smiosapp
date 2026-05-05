//
//  NotificationSettingsController.swift
//  Smartility
//
//  Created by Mani on 8/25/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//


import UIKit
import LTHRadioButton
import SwiftSpinner
import Toast_Swift
import DropDown

class NotificationSettingsController: UIViewController, WWCalendarTimeSelectorProtocol {
            
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var disableFromMeSwitch: UISwitch!
    @IBOutlet weak var dontDistrubeMeSwitch: UISwitch!
            
    @IBOutlet weak var notification_sound_Feild: UITextField!
    @IBOutlet weak var testNotificationContainer: UIView!
    @IBOutlet weak var pushBtn: UIButton!
    @IBOutlet weak var callListContainer: UIView!
    
    @IBOutlet weak var allUnitRadiBtb: LTHRadioButton!
    @IBOutlet weak var belowRadioBtn: LTHRadioButton!
    
    @IBOutlet weak var fromTextFeild: UITextField!
    @IBOutlet weak var tillTextFeild: UITextField!
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var containerInfo: UIView!
    @IBOutlet weak var notrecevingLabel: UILabel!
    @IBOutlet weak var pushdidNotWork: UILabel!
    @IBOutlet weak var backClicked: UIButton!
        
    @IBOutlet weak var aproveRejectLabel: UILabel!
    @IBOutlet weak var callUnitMember: UILabel!
    @IBOutlet weak var callOneByOne: UILabel!
    @IBOutlet weak var heightConstrainNotReceiv: NSLayoutConstraint!
    
    
    
    
    var soundDropDown = DropDown()
    var clickedDate = ""
    
    var arrayData: NSMutableArray?
    var boolFlag = false
    var initial_flag = false
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.bringSubviewToFront(navigationBarView)
        navigationBarView.backgroundColor = .white
        navigationBarView.layer.shadowColor = UIColor(red: 0.049, green: 0.019, blue: 0.167, alpha: 0.2).cgColor
        navigationBarView.layer.shadowOpacity = 1
        navigationBarView.layer.shadowRadius = 1
        navigationBarView.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        self.tabBarController?.tabBar.isHidden = true
        
        table.isEditing = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        allUnitRadiBtb.deselectedColor = UIColor.white
        belowRadioBtn.deselectedColor = UIColor.white
        
        self.allUnitRadiBtb.deselect()
        self.belowRadioBtn.tintColor = UIColor(hex: "#FFD42A")
        self.belowRadioBtn.selectedColor = UIColor(hex: "#FFD42A")
        
        self.allUnitRadiBtb.tintColor = UIColor(hex: "#FFD42A")
        self.allUnitRadiBtb.selectedColor = UIColor(hex: "#FFD42A")
        self.belowRadioBtn.deselect()
        
        allUnitRadiBtb.onSelect {
            self.belowRadioBtn.deselect()
            self.updateDatatoServer(updateIndex: false)
        }
        
        belowRadioBtn.onSelect {
            self.allUnitRadiBtb.deselect()
            self.updateDatatoServer(updateIndex: false)
        }
                         
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
        
        notification_sound_Feild.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(select_sound)))
        let tapguest = UITapGestureRecognizer(target: self, action: #selector(select_sound))
        tapguest.numberOfTouchesRequired = 1
        notification_sound_Feild.addGestureRecognizer(tapguest)
        
        soundDropDown.selectionBackgroundColor = .white
        soundDropDown.backgroundColor = .white
        soundDropDown.anchorView = notification_sound_Feild
        soundDropDown.dataSource = ["Doorbell", "Door knock"]
        soundDropDown.width = notification_sound_Feild.frame.size.width
        soundDropDown.cornerRadius = 10
        soundDropDown.bottomOffset = CGPoint(x: 0, y:((soundDropDown.anchorView?.plainView.bounds.height)!+5))
        
        soundDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.notification_sound_Feild.text = item
            self.updateDatatoServer(updateIndex: false)
        }
        containerInfo.layer.cornerRadius = 13
        containerInfo.layer.masksToBounds = true
        containerInfo.layer.borderColor = UIColor(hex: "#00D455").cgColor
        containerInfo.layer.borderWidth = 1.0
        
        testNotificationContainer.layer.cornerRadius = 13
        testNotificationContainer.layer.masksToBounds = true
        testNotificationContainer.layer.borderColor = brandColor().cgColor
        testNotificationContainer.layer.borderWidth = 1.0
        
        callListContainer.layer.cornerRadius = 13
        callListContainer.layer.masksToBounds = true
        callListContainer.layer.borderColor = UIColor(hex: "#FF7F2A").cgColor
        callListContainer.layer.borderWidth = 1.0
        
        pushBtn.backgroundColor = UIColor.white
        pushBtn.layer.cornerRadius = 10
        pushBtn.layer.masksToBounds = true
                
        notrecevingLabel.isUserInteractionEnabled = true
        pushdidNotWork.isUserInteractionEnabled = true
        
        notrecevingLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(receivingTappeed)))
        pushdidNotWork.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushdidNotWorkfunc)))
        
        fromTextFeild.isUserInteractionEnabled = true
        tillTextFeild.isUserInteractionEnabled = true
        
        fromTextFeild.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fromCLicked)))
        tillTextFeild.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tillCLicked)))
                
        fromTextFeild.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(fromCLicked)))
        tillTextFeild.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(tillCLicked)))
        
        
        disableFromMeSwitch.addTarget(self, action: #selector(disableFromMeSwitchChanged), for: .valueChanged)
        dontDistrubeMeSwitch.addTarget(self, action: #selector(dontDistrubeMeSwitchChanged), for: .valueChanged)
        setupApi()
    }
    
    
    @objc func select_sound(){
        view.endEditing(true)
        soundDropDown.show()
    }
    
    func setupApi(){
        let params = ["cust_id": UserDefaults.cust_id, "unit_id": community.cust_unitId,"user_id":UserDefaults.user_id,"comm_id":community.community_id]
        print(params)
        SwiftSpinner.show("Fetching information...")
        Networking.shared.getNotificationData(perams: params) { (success, error) in
            
            if success != nil {
                                
                if let sound_name = success?["notif_sound"] as? String {
                    self.notification_sound_Feild.text = (sound_name == "doorbell") ?  "Doorbell" : "Door Knock"
                }
                if let dontDistStart = success?["dont_disturb_from"] as? String, let dontDistEnd = success?["dont_disturb_till"] as? String {
                    if dontDistStart != "" && dontDistEnd != "" {
                        self.dontDistrubeMeSwitch.isOn = true
                        self.fromTextFeild.text = dontDistStart
                        self.tillTextFeild.text = dontDistEnd
                    }else{
                        self.dontDistrubeMeSwitch.isOn = false
                    }
                }else{
                    self.dontDistrubeMeSwitch.isOn = false
                }
                                
                if let gatOpen = success?["is_notif_gate_opted_out"] as? Bool {
                    if gatOpen {
                        self.disableFromMeSwitch.isOn = true
                    }else{
                        self.disableFromMeSwitch.isOn = false
                    }
                }
                
                if let order = success?["call_order"] as? String {
                    if order == "A" {
                        self.allUnitRadiBtb.selectedColor = UIColor(hex: "#FFD42A")
                        self.allUnitRadiBtb.select()
                        self.belowRadioBtn.deselect()
                    }else{
                        self.belowRadioBtn.selectedColor = UIColor(hex: "#FFD42A")
                        self.allUnitRadiBtb.deselect()
                        self.belowRadioBtn.select()
                    }
                }
                if let ivrList = success?["ivr_order_list"] as? NSArray {
                    self.arrayData = NSMutableArray(array: ivrList)
                                        
                    if let ivrData = CommunityData.ivr_for_visitor, ivrData == 0 {
                        self.callListContainer.isHidden = true
                        self.aproveRejectLabel.isHidden = true
                        self.callOneByOne.isHidden = true
                        self.callUnitMember.isHidden = true
                        self.allUnitRadiBtb.isHidden = true
                        self.belowRadioBtn.isHidden = true
                        self.notrecevingLabel.isHidden = true
                    }else{
                        
                    }
                    
                    print("community.cust_location",UserDefaults.UserContry)
                    if UserDefaults.UserContry == "MY" {
                        self.heightConstrainNotReceiv.constant = 0
                        self.notrecevingLabel.isHidden = true
                    }
                                                            
                    self.tableHeight.constant = CGFloat((ivrList.count)*30)
                    self.table.layoutIfNeeded()
                    self.table.backgroundColor = .clear
                    self.table.delegate = self
                    self.table.dataSource = self
                    self.table.reloadData()
                }
                self.boolFlag = true
            }
            if let er = error {
                SwiftSpinner.hide()
                self.showConfirmAlert(title: "", message: er.localizedDescription, buttonTitle: "Ok", buttonStyle: .cancel, confirmAction: nil)
            }
            SwiftSpinner.hide()
        }
    }
    
    @objc func disableFromMeSwitchChanged(mySwitch: UISwitch) {
        updateDatatoServer(updateIndex: false)
    }
    @objc func dontDistrubeMeSwitchChanged(mySwitch: UISwitch) {
        if fromTextFeild.text != "" &&
            tillTextFeild.text != "" {
            if !mySwitch.isOn {
                fromTextFeild.text = ""
                tillTextFeild.text = ""
                updateDatatoServer(updateIndex: false)
            }else{
                updateDatatoServer(updateIndex: false)
            }
            allUnitRadiBtb.isUserInteractionEnabled = false
            belowRadioBtn.isUserInteractionEnabled = false
            
            pushdidNotWork.isUserInteractionEnabled = false
            pushBtn.isUserInteractionEnabled = false
            disableFromMeSwitch.isUserInteractionEnabled = false
            notification_sound_Feild.isUserInteractionEnabled = false
            table.isUserInteractionEnabled = false
            notrecevingLabel.isUserInteractionEnabled = false
        }else{
            allUnitRadiBtb.isUserInteractionEnabled = true
            belowRadioBtn.isUserInteractionEnabled = true
            pushdidNotWork.isUserInteractionEnabled = true
            pushBtn.isUserInteractionEnabled = true
            disableFromMeSwitch.isUserInteractionEnabled = true
            notification_sound_Feild.isUserInteractionEnabled = true
            table.isUserInteractionEnabled = true
            notrecevingLabel.isUserInteractionEnabled = true
            
            self.view.makeToast("Please choose time")
            mySwitch.setOn(false, animated: true)
        }
    }
    
    @IBAction func navback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func updateDatatoServer(updateIndex: Bool){
                        
        if self.boolFlag {
            var params = [String:Any]()
            params.updateValue(UserDefaults.user_id, forKey: "user_id")
            params.updateValue(community.community_id, forKey: "comm_id")
            params.updateValue(community.cust_unitId, forKey: "unit_id")
            params.updateValue(UserDefaults.cust_id, forKey: "cust_id")
            params.updateValue(disableFromMeSwitch.isOn, forKey: "is_notif_gate_opted_out")
            
            if dontDistrubeMeSwitch.isOn {
                params.updateValue(dontDistrubeMeSwitch.isOn, forKey: "is_dont_disturb")
                params.updateValue(fromTextFeild.text ?? "", forKey: "dont_disturb_from")
                params.updateValue(tillTextFeild.text ?? "", forKey: "dont_disturb_till")
            }else{
                params.updateValue(false, forKey: "is_dont_disturb")
                params.updateValue("", forKey: "dont_disturb_from")
                params.updateValue("", forKey: "dont_disturb_till")
            }
            
            let sound = (self.notification_sound_Feild.text ?? "" == "Doorbell") ?  "doorbell" : "door_knock"
            params.updateValue(sound, forKey: "notif_sound")
            if allUnitRadiBtb.isSelected {
                params.updateValue("A", forKey: "call_order")
            }else{
                params.updateValue("O", forKey: "call_order")
            }
            
//            if updateIndex {
//                if let da = arrayData {
//                    params.updateValue(da, forKey: "ivr_order_list")
//                }
//            }else{
                if let da = arrayData {
                    print(da)
                    var dict = NSMutableArray()
                    for i in 0..<da.count {
                        var con = da[i] as? [String:Any]
                        con?.updateValue(i, forKey: "ivr_order")
                        dict.add(con)
                    }
                    arrayData = dict
                    print(dict)
                    params.updateValue(arrayData, forKey: "ivr_order_list")
                }
//            }
            
            
            
            
            print(params)
            self.view.makeToastActivity(.center)
            Networking.shared.saveSettings(perams: params) { (success, error) in
                if success != nil {
                    self.view.makeToast("Settings updated successfully", duration: 0.5, position: .bottom, title: "", image: nil, style: .init()) { (act) in
                        self.view.hideToastActivity()
                        if !updateIndex {
                            self.setupApi()
                        }
                    }
                }
                if let error = error {
                    self.view.hideToastActivity()
                    self.showConfirmAlert(title: "", message: error.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                }
            }
        }
        
    }
    
    @IBAction func testPush(_ sender: UIButton) {
        sender.loadingIndicator(true, .blue, "")
        let params = ["user_id": UserDefaults.user_id, "comm_id": community.community_id]
        Networking.shared.testPush(perams: params) { (success, error) in
            if success != nil {
                sender.loadingIndicator(false, .blue, "Test PushNotification")
            }
            if let erro = error {
                sender.loadingIndicator(false, .blue, "Test PushNotification")
                self.showConfirmAlert(title: "", message: erro.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
            }
        }
    }
    
    
    @objc func fromCLicked(){
        view.endEditing(true)
        clickedDate = "fromClicked"
        let selector = WWCalendarTimeSelector.instantiate()
        selector.optionStyles.showTime(true)
        selector.optionStyles.showDateMonth(false)
        selector.optionStyles.showYear(false)
        selector.delegate = self
        selector.optionTopPanelTitle = "Choose Date"
        self.present(selector, animated: true, completion: nil)
    }
    
    @objc func tillCLicked(){
        view.endEditing(true)
        clickedDate = "tillClicked"
        let selector = WWCalendarTimeSelector.instantiate()
        selector.optionStyles.showTime(true)
        selector.optionStyles.showDateMonth(false)
        selector.optionStyles.showYear(false)
        selector.delegate = self
        selector.optionTopPanelTitle = "Choose Date"
        self.present(selector, animated: true, completion: nil)
    }
        
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        if clickedDate == "fromClicked" {
            let dateString = date.toString(dateFormat: "HH:mm")
            fromTextFeild.text = dateString
//            self.updateDatatoServer(updateIndex: false)
        }else if clickedDate == "tillClicked" {
            let dateString = date.toString(dateFormat: "HH:mm")
            tillTextFeild.text = dateString
//            self.updateDatatoServer(updateIndex: false)
        }
    }
            
    @objc func pushdidNotWorkfunc(){
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                    self.showConfirmAlert(title: "Notifications", message: "Push Notification already enabled", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                }
            }else {
                // Either denied or notDetermined
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: nil, message: "Do you want to change notifications settings?", preferredStyle: .alert)
                    let action1 = UIAlertAction(title: "Settings", style: .default) { (action:UIAlertAction) in
                        if let appSettings = NSURL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(appSettings as URL, options: [:], completionHandler: nil)
                        }
                    }
                    let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
                    }
                    alertController.addAction(action1)
                    alertController.addAction(action2)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func receivingTappeed(){
        self.showConfirmAlert(title: "Automated IVR Calls", message: "Give a call just once to below number to white list your phone number to abide by the regulations laid down by TRAI \n  080 471 90590 \n Automated calls are not initiated to foreign numbers", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
    }
}



extension NotificationSettingsController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let da = arrayData {
            return da.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let da = arrayData, let data = da[indexPath.row] as? [String:Any] {
            cell.textLabel?.text = data["contact_phone"] as? String
            cell.textLabel?.textColor = .white
            cell.textLabel?.textAlignment = .left
        }
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if allUnitRadiBtb.isSelected {
            return false
        }
        return true
    }
    
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let da = arrayData {
            
//            arrayData?.removeObject(at: sourceIndexPath.row)
//            arrayData?.insert(movedObject, at: destinationIndexPath.row)
//            print(arrayData)
            
//            initial_flag
//            print(sourceIndexPath.row)
//                for i in 0..<da.count {
            arrayData?.removeObject(at: sourceIndexPath.row)
            
            if let indexValue = da[destinationIndexPath.row] as? [String:Any] {
                arrayData?.insert(indexValue, at: sourceIndexPath.row)
            }
                        
            
            
                    
                    
//                    if destinationIndexPath.row == i {
//                        var movedObject = da[sourceIndexPath.row] as? [String:Any]
//                        movedObject?.updateValue(destinationIndexPath.row, forKey: "ivr_order")
//                        arrayData?.removeObject(at: sourceIndexPath.row)
//                        arrayData?.insert(movedObject, at: destinationIndexPath.row)
//                    }else{
//                        var movedObject = da[i] as? [String:Any]
//                        movedObject?.updateValue(i, forKey: "ivr_order")
//                        arrayData?.removeObject(at: i)
//                        arrayData?.insert(movedObject, at: i)
//                    }
//                }
            self.updateDatatoServer(updateIndex: true)
        }
    }
}
