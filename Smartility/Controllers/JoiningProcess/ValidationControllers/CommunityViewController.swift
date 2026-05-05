//
//  CommunityViewController.swift
//  Smartility
//
//  Created by Mani on 7/10/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import DropDown

class CommunityViewController: UIViewController {

    
    @IBOutlet weak var contine_btn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var unitNo: UITextField!
    @IBOutlet weak var ownerShip: UITextField!
    @IBOutlet weak var blockField: UITextField!
    
    @IBOutlet weak var back_btn: UIButton!
    @IBOutlet weak var continue_btn: UIButton!
    
    @IBOutlet weak var community_label: UILabel!
    @IBOutlet weak var container_view: UIView!
    
    @IBOutlet weak var heightContraint: NSLayoutConstraint!
    
    
    var selection_data = String()
    var rollModel = [RoleModel]()
    var fillter = [CommunityModel]()
    var communityModel = [CommunityModel]()
    
    var block_model = [BlocksModel]()
    var unit_model = [UnitsModel]()
    
    let bloack_dropDown = DropDown()
    let unit_dropDown = DropDown()
    let ownership_dropDown = DropDown()
        
    var block_id = Int()
    var unit_id = Int()
    
    var is_verified_user = Bool()
    var rel_status = ""
    
    var user_id = 0
    
    var name = ""
    var email = ""
    var gender = ""
    var hideDetails = Bool()
    var phone = String()
    var cust_id = Int()
        
    var is_mc_member = Bool()
    var is_other_user = Bool()
    
    var role_name = String()
    var roleid: Int?
    var is_Admin = Bool()
    
    var ownershipRole = [RoleModel]()
    var relStatusIfOthers = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continue_btn.setTitle("Submit", for: .normal)
        
        unitNo.setupRightImage(imageName: "dropDown")
        blockField.setupRightImage(imageName: "dropDown")
        ownerShip.setupRightImage(imageName: "dropDown")
        
        unitNo.addLine(position: .LINE_POSITION_BOTTOM, color: brandColor(), width: 1.0)
        blockField.addLine(position: .LINE_POSITION_BOTTOM, color: brandColor(), width: 1.0)
        ownerShip.addLine(position: .LINE_POSITION_BOTTOM, color: brandColor(), width: 1)
        
        back_btn.layer.cornerRadius = 5
        continue_btn.layer.cornerRadius = 5
        back_btn.setTitleColor(brandColor(), for: .normal)
        back_btn.layer.masksToBounds = true
        continue_btn.layer.masksToBounds = true
        
        back_btn.layer.borderColor =  brandColor().cgColor
        
        continue_btn.layer.borderColor =  brandColor().cgColor
        continue_btn.backgroundColor = brandColor()
        
        back_btn.layer.borderWidth = 1
        continue_btn.layer.borderWidth = 1
                
        community_label.text = community.community_name
        
        
        let rolle = rollModel.filter { (model) -> Bool in
            model.role_type == "Resident"
        }.map { $0.role_name ?? "" }
        ownership_dropDown.dataSource = rolle
        ownershipRole = rollModel.filter { (model) -> Bool in
            model.role_type == "Resident"
        }
        
        if (fillter.count == 0 && communityModel.count >= 1) {
            
            is_verified_user = true
            rel_status = "Linked"
            // he has some unit yet to be joined - prepopulate and disable
            if let block = communityModel[safe:0]?.blockNm {
                blockField.text = "\(block)"
            }
            
            if let id = communityModel[safe:0]?.blockId {
                self.block_id = id
            }
            
            if let id = communityModel[safe:0]?.unitId {
                self.unit_id = id
            }
            
            if let unit = communityModel[safe:0]?.unitNo {
                unitNo.text = "\(unit)"
            }
            
            let ownership = communityModel[safe:0]?.ownership
            ownerShip.text = ownership
            
            
            if let id = self.roleid {
                self.roleid = id
            }else{
                let indexRol = self.ownershipRole.firstIndex { (model) -> Bool in
                    model.role_name == ownership
                }
                if let roldID = indexRol {
                    self.roleid = self.ownershipRole[safe: roldID]?.role_id
                }
            }
            
            
            ownerShip.isEnabled = false
            unitNo.isEnabled = false
            blockField.isEnabled = false
          
        } else {
            
            /*
            if let block = fillter[safe:0]?.blockNm {
                blockField.text = "\(block)"
            }
            
            if let unit = fillter[safe:0]?.unitNo {
                unitNo.text = "\(unit)"
            }
            
            let ownership = fillter[safe:0]?.ownership
            ownerShip.text = ownership
            
            if let userid = fillter[safe:0]?.userId {
                user_id = userid
            }
            
            if let id = fillter[safe:0]?.blockId {
                self.block_id = id
            }
            
            if let id = fillter[safe:0]?.unitId {
                self.unit_id = id
            }
                        
            if let roleId = rollModel.first?.role_id {
                self.roleid = roleId
            }
            
            if let cu_id = fillter[safe:0]?.custId {
                cust_id = cu_id
            }
            */
            
            ownerShip.isEnabled = true
            unitNo.isEnabled = true
            blockField.isEnabled = true
            is_verified_user=false
            rel_status = "Pending Approval"
            // let him allow to choose block and unit details as he has no history in the community
        }
        
        if let userid = communityModel[safe:0]?.userId {
            user_id = userid
        }
        
        if let cu_id = communityModel[safe:0]?.custId {
            cust_id = cu_id
        }
                        
        bloack_dropDown.backgroundColor = .white
        bloack_dropDown.anchorView = blockField
        bloack_dropDown.width = blockField.frame.size.width
        bloack_dropDown.cornerRadius = 10
        bloack_dropDown.bottomOffset = CGPoint(x: 0, y:((bloack_dropDown.anchorView?.plainView.bounds.height)!+5))
                
        unit_dropDown.backgroundColor = .white
        unit_dropDown.anchorView = unitNo
        unit_dropDown.width = unitNo.frame.size.width
        unit_dropDown.cornerRadius = 10
        unit_dropDown.bottomOffset = CGPoint(x: 0, y:((bloack_dropDown.anchorView?.plainView.bounds.height)!+5))
                
        ownership_dropDown.backgroundColor = .white
        ownership_dropDown.anchorView = ownerShip
        ownership_dropDown.width = ownerShip.frame.size.width
        ownership_dropDown.cornerRadius = 10
        ownership_dropDown.bottomOffset = CGPoint(x: 0, y:((bloack_dropDown.anchorView?.plainView.bounds.height)!+5))
        
                        
        
        ownership_dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.ownerShip.text = item
            
            if self.selection_data == "As" {
            }else if self.selection_data == "St" {
            }else if self.selection_data == "Ot" {
            }else{
                self.roleid = self.ownershipRole[index].role_id
                self.role_name = item
            }
        }
        
        unit_dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.unitNo.text = item
            if let id = self.unit_model[index].unit_id {
                self.unit_id = id
            }
        }
        
        bloack_dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            if let id = self.block_model[index].block_id {
                self.block_id = id
            }
            
            self.blockField.text = item
            if let blockId = self.block_model[index].block_id {
                Networking.shared.getUnitsByBlockId(perams: ["block_id":blockId]) { (unitModel, error) in
                    if let model = unitModel {
                        self.unitNo.text = ""
                        self.unit_model = unitModel!
                        self.unit_dropDown.dataSource = model.map {  $0.unit_no ?? "" }
                    }
                }
            }
        }
                        
        Networking.shared.getUserCountByCommId(url_String: EndPoint.getUserCountByCommId+"/"+community.community_id) { (result, error) in
            print(result)
            if result != nil && result?.count != 0 {
                if let array = result?[0] as? [String:Any], let total_user = array["total_user"] as? Int {
                    if total_user < 3 {
                        self.is_Admin = true
                    }else{
                        self.is_Admin = false
                    }
                }
            }
        }
                        
        if (selection_data == "St" || selection_data == "Ot") {
            relStatusIfOthers = is_Admin ? "Linked" : "Pending Approval"
            is_verified_user = false
        }
                        
        setup()
                    
        ownerShip.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ownershipClicked)))
        blockField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(blockClicked)))
        unitNo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(unitClicked)))
                    
        if selection_data == "As" {
            heightContraint.constant = 150
            container_view.isHidden = false
        }else if selection_data == "St" {
            heightContraint.constant = 0
            container_view.isHidden = true
        }else if selection_data == "Ot" {
            container_view.isHidden = true
            heightContraint.constant = 0
        }else{
            heightContraint.constant = 150
            container_view.isHidden = false
        }
    }
    
    @objc func ownershipClicked(){
        view.endEditing(true)
        ownership_dropDown.show()
    }
                    
    @objc func unitClicked(){
        view.endEditing(true)
        unit_dropDown.show()
    }
    
    @objc func blockClicked(){
        view.endEditing(true)
        bloack_dropDown.show()
    }
                
    func setup(){
        Networking.shared.getBlocksByCommId(perams: ["comm_id": community.community_id]) { (model, error) in
            if let model = model {
                self.block_model = model
                self.bloack_dropDown.dataSource = model.map {  $0.block_nm ?? "" }
            }
        }
    }
    
    @IBAction func backClicked(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("Update_init2"), object: nil)
        remove()
    }
    
    @IBAction func continueBtn(_ sender: Any) {
     
        guard  let unitNo = unitNo.text else { return }
        guard  let bloack = blockField.text else { return }
        guard  let ownership = ownerShip.text else { return }
        
        if selection_data == "As" {
            
            if bloack.count == 0 {
                showConfirmAlert(title: "", message: "Please select Block", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
            }else if unitNo.count == 0 {
                showConfirmAlert(title: "", message: "Please select Unit No", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
            }else if ownership.count == 0 {
                showConfirmAlert(title: "", message: "Please select ownership!", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
            }else{
                setup_submit(ownership: ownership)
            }
        }else if selection_data == "St" {
            heightContraint.constant = 0
            container_view.isHidden = true
            setup_submit(ownership: ownership)
        }else if selection_data == "Ot" {
            container_view.isHidden = true
            heightContraint.constant = 0
            setup_submit(ownership: ownership)
        }else{
            
            if bloack.count == 0 {
                showConfirmAlert(title: "", message: "Please select Block", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
            }else if unitNo.count == 0 {
                showConfirmAlert(title: "", message: "Please select Unit No", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
            }else if ownership.count == 0 {
                showConfirmAlert(title: "", message: "Please select ownership", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
            }else{
                setup_submit(ownership: ownership)
            }
        }
    }
    
    
    func setup_submit(ownership:String){
        var perams = [String:Any?]()
        
        guard  let unitNo = unitNo.text else { return }
        guard  let bloack = blockField.text else { return }
        perams.updateValue(bloack, forKey: "block_nm")
        perams.updateValue(unitNo, forKey: "unit_no")
        perams.updateValue(community.community_name, forKey: "comm_name")
        perams.updateValue(name, forKey: "cust_name")
        perams.updateValue(cust_id, forKey: "cust_id")
        perams.updateValue(community.community_id, forKey: "comm_id")
        perams.updateValue(phone, forKey: "contact_phone")
        perams.updateValue(community.cust_location, forKey: "phone_country")
        perams.updateValue(email, forKey: "contact_email")
        perams.updateValue(is_mc_member, forKey: "is_mc_member")
        perams.updateValue(is_other_user, forKey: "is_other_user")
        perams.updateValue(false, forKey: "is_admin")
        perams.updateValue(role_name, forKey: "role_name")
        perams.updateValue(roleid, forKey: "role_id")
        perams.updateValue(gender, forKey: "gender")
        perams.updateValue(hideDetails, forKey: "hide_contact")
        perams.updateValue(block_id, forKey: "block_id")
        perams.updateValue(unit_id, forKey: "unit_id")
        perams.updateValue(ownership, forKey: "ownership")
        perams.updateValue(rel_status, forKey: "rel_status")
        perams.updateValue("APP", forKey: "reg_mode")
        perams.updateValue(user_id, forKey: "user_id")
                
        perams.updateValue(is_verified_user, forKey: "is_ver_resident")
        perams.updateValue(true, forKey: "is_self_service")

        perams.updateValue(is_Admin, forKey: "is_admin")
        perams.updateValue(relStatusIfOthers, forKey: "rel_status_if_other_user")
        perams.updateValue(UIDevice.current.identifierForVendor?.uuidString ?? "", forKey: "user_device_id")
             
        print(perams)
        
//        'cust_name': ‘venkat’,
//        'cust_id': ‘1234’,
//        'comm_id': 126,
//        'contact_phone': ‘+919741027887’,
//        'phone_country':’IN’,
//        'contact_email': ‘venkattweet.gmail.com’,
//        'is_mc_member': false, // true if user choose the role as Association member
//        'is_other_user': false, // true if user choose the role as Staff or External
//        'is_admin': false, // false always
//        'role_name': ‘Resident’,
//        'role_id': 12,
//        'gender': ‘Male’,
//        'hide_contact': false, // true if user choose to hid contact
//        'block_id': 12,
//        'unit_id': 2323,
//        'ownership': ‘Owner’, // or Empty if is_other_user true is empty
//        'rel_status': 'Linked', // ‘Pending Approval’ is user record not found for this community in getUserHistoryByPhone // Bloack or Unit id empty
//        'reg_mode': ‘APP’,
//        'user_id': 12, // set this only if user has history
//        'is_ver_resident': true, // false if is user record not found for this community in getUserHistoryByPhone
//        'is_self_service': true // true always
        
    
        Networking.shared.residentCreate(perams: perams) { (success, error) in
            if let success = success {
                Networking.shared.deleteTempRecor(perams: ["contact_phone": self.phone]) { (success, error) in
                    if success != nil {
                        let controller = AppStoryboard.joinBoard.viewController(viewControllerClass: CongratViewController.self)
                        controller.is_verified_user = self.is_verified_user
                        controller.is_Admin = self.is_Admin
                        self.add(controller, frame: self.view.bounds, customVIew: self.view)
                    }
                    if let err = error {
                        self.showConfirmAlert(title: "", message: err.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                    }
                }
            }
            if let err = error {
                self.showConfirmAlert(title: "", message: err.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                Networking.shared.deleteTempRecor(perams: ["contact_phone": self.phone]) { (success, error) in
                }
            }
        }
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("Update_init3"), object: nil)
    }
}


