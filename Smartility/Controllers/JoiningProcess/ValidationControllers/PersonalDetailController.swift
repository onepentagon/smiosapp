//
//  PersonalDetailController.swift
//  Smartility
//
//  Created by Mani on 7/8/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import LTHRadioButton
import DropDown


class PersonalDetailController: UIViewController {

    @IBOutlet weak var containerVIew: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var height_constraint: NSLayoutConstraint!
        
    @IBOutlet weak var name_feild: UITextField!
    @IBOutlet weak var gender_feild: UITextField!
    @IBOutlet weak var email_feild: UITextField!
    
    @IBOutlet weak var checkBoz: BEMCheckBox!
    @IBOutlet weak var hideLable: UILabel!
    @IBOutlet weak var notPassibleLabel: UILabel!
    
    private let selectedColor   = brandColor()
    var fillter = [CommunityModel]()
    var communityModel = [CommunityModel]()
    var roleModel = [RoleModel]()
    
    var data_string = [String]()
    
    @IBOutlet weak var residentBtn: LTHRadioButton!
    @IBOutlet weak var asociationBtn: LTHRadioButton!
    @IBOutlet weak var staffBtn: LTHRadioButton!
    @IBOutlet weak var othersBtn: LTHRadioButton!
    
    @IBOutlet weak var resident_label: UILabel!
    @IBOutlet weak var AssociationLable: UILabel!
    @IBOutlet weak var staffLable: UILabel!
    @IBOutlet weak var other_label: UILabel!
    
    @IBOutlet weak var roleFeild: UITextField!
    @IBOutlet weak var role_heightConstaint: NSLayoutConstraint!
    
    @IBOutlet weak var continue_btn: UIButton!
    @IBOutlet weak var back_btn: UIButton!
    
    let dropDown = DropDown()
    var selection_data = ""
    var phone = ""
    var associcationMem = false
    var otherUser = false
    var rolid: Int?
        
    var asosicationModel = [RoleModel]()
    var staff = [RoleModel]()
    var others = [RoleModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
                
        containerVIew.layer.borderColor = brandColor().cgColor
        containerVIew.layer.borderWidth = 1.0
        setup_api()
                
        name_feild.delegate = self
        email_feild.delegate = self
        NotificationCenter.default.post(name: NSNotification.Name("Update_init2"), object: nil)
        roleFeild.addLine(position: .LINE_POSITION_BOTTOM, color: brandColor(), width: 1.0)
        name_feild.addLine(position: .LINE_POSITION_BOTTOM, color: brandColor(), width: 1.0)
        gender_feild.addLine(position: .LINE_POSITION_BOTTOM, color: brandColor(), width: 1.0)
        email_feild.addLine(position: .LINE_POSITION_BOTTOM, color: brandColor(), width: 1.0)
                        
        let resident_tap = UITapGestureRecognizer(target: self, action: #selector(resident_clicked))
        let association_tap = UITapGestureRecognizer(target: self, action: #selector(association_clicked))
        let staff_tap = UITapGestureRecognizer(target: self, action: #selector(staff_clicked))
        let others_tap = UITapGestureRecognizer(target: self, action: #selector(others_clicked))
                        
        resident_label.addGestureRecognizer(resident_tap)
        AssociationLable.addGestureRecognizer(association_tap)
        staffLable.addGestureRecognizer(staff_tap)
        other_label.addGestureRecognizer(others_tap)
                             
        let resident_r_tap = UITapGestureRecognizer(target: self, action: #selector(resident_clicked))
        let association_r_tap = UITapGestureRecognizer(target: self, action: #selector(association_clicked))
        let staff_r_tap = UITapGestureRecognizer(target: self, action: #selector(staff_clicked))
        let others_r_tap = UITapGestureRecognizer(target: self, action: #selector(others_clicked))
                        
        residentBtn.addGestureRecognizer(resident_r_tap)
        asociationBtn.addGestureRecognizer(association_r_tap)
        staffBtn.addGestureRecognizer(staff_r_tap)
        othersBtn.addGestureRecognizer(others_r_tap)
                        
        back_btn.layer.cornerRadius = 5
        continue_btn.layer.cornerRadius = 5
        
        back_btn.layer.masksToBounds = true
        continue_btn.layer.masksToBounds = true
        
        back_btn.layer.borderColor =  brandColor().cgColor
        
        continue_btn.layer.borderColor =  brandColor().cgColor
        continue_btn.backgroundColor = brandColor()
        
        back_btn.setTitleColor(brandColor(), for: .normal)
        back_btn.layer.borderWidth = 1
        continue_btn.layer.borderWidth = 1
        
        roleFeild.placeholder = "Role"
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewEnd)))
              
        gender_feild.setupRightImage(imageName: "dropDown")
        roleFeild.setupRightImage(imageName: "dropDown")
        
        gender_feild.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(genderTapped)))
        roleFeild.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(roleSelected)))
        
        residentBtn.select()
        
        checkBoz.boxType = .square
        checkBoz.setOn(false)
        checkBoz.isEnabled = true
        hideLable.textColor = UIColor.black
        notPassibleLabel.textColor = UIColor.black
        
        checkBoz.onTintColor = brandColor()
        checkBoz.onCheckColor = brandColor()
        
                                
    }
    
    override func viewDidLayoutSubviews() {
        [residentBtn,
         asociationBtn,staffBtn,othersBtn].forEach { (bt) in
            bt?.selectedColor = brandColor()
         }
    }
    
    @objc func genderTapped(){
        dropDown.backgroundColor = .white
        dropDown.anchorView = gender_feild
        dropDown.dataSource = ["Male", "Female"]
        dropDown.width = gender_feild.frame.size.width
        dropDown.cornerRadius = 10
        dropDown.bottomOffset = CGPoint(x: 0, y:((dropDown.anchorView?.plainView.bounds.height)!+5))

        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.gender_feild.text = item
        }
    }
    
    
    @objc func roleSelected(){
        dropDown.backgroundColor = .white
        dropDown.width = roleFeild.frame.size.width
        dropDown.cornerRadius = 10
        dropDown.anchorView = roleFeild
        dropDown.bottomOffset = CGPoint(x: 0, y:((dropDown.anchorView?.plainView.bounds.height)!+5))
                
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.roleFeild.text = item
            if self.selection_data == "As" {
                self.rolid = self.asosicationModel[index].role_id
            }else if self.selection_data == "St" {
                self.rolid = self.staff[index].role_id
            }else if self.selection_data == "Ot" {
                self.rolid = self.others[index].role_id
            }else{
                self.selection_data = ""
                self.rolid = nil
            }
        }
        
        if selection_data == "As" {
            
            self.roleFeild.text = ""
            let data = roleModel.filter { (model) -> Bool in
                model.role_type == "RWA"
            }.map { $0.role_name ?? "" }
            dropDown.dataSource = data
            
            asosicationModel = roleModel.filter { (model) -> Bool in
                model.role_type == "RWA"
            }
            
        }else if selection_data == "St" {
            self.roleFeild.text = ""
            let data = roleModel.filter { (model) -> Bool in
                model.role_type == "Staff"
            }.map { $0.role_name ?? "" }
            dropDown.dataSource = data
            
            staff = roleModel.filter { (model) -> Bool in
                model.role_type == "Staff"
            }
            
        }else if selection_data == "Ot" {
            self.roleFeild.text = ""
            let data = roleModel.filter { (model) -> Bool in
                model.role_type == "Others"
            }.map { $0.role_name ?? "" }
            dropDown.dataSource = data
                     
            others = roleModel.filter { (model) -> Bool in
                model.role_type == "Others"
            }
        }else{
            selection_data = ""
        }
     
        
    }
    
    @objc func viewEnd(){
        view.endEditing(true)
    }
        
    
    @objc func resident_clicked(){
        selection_data = ""
        associcationMem = false
        otherUser = false
        self.roleFeild.text = ""
        roleFeild.isHidden = true
        role_heightConstaint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        residentBtn.select()
        asociationBtn.deselect()
        staffBtn.deselect()
        othersBtn.deselect()
        checkBoz.isEnabled = true
        hideLable.textColor = UIColor.black
        notPassibleLabel.textColor = UIColor.black
    }
    
    @objc func association_clicked(){
        otherUser = false
        associcationMem = true
        self.roleFeild.text = ""
        roleFeild.isHidden = false
        role_heightConstaint.constant = 40
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        residentBtn.deselect()
        asociationBtn.select()
        staffBtn.deselect()
        othersBtn.deselect()
        checkBoz.setOn(false)
        hideLable.textColor = UIColor.lightGray.withAlphaComponent(0.8)
        notPassibleLabel.textColor = UIColor.lightGray.withAlphaComponent(0.8)
        checkBoz.isEnabled = false
        selection_data = "As"
    }
    
    @objc func staff_clicked(){
        otherUser = false
        associcationMem = false
        self.roleFeild.text = ""
        roleFeild.isHidden = false
        role_heightConstaint.constant = 40
        staffBtn.select()
        residentBtn.deselect()
        asociationBtn.deselect()
        othersBtn.deselect()
        checkBoz.setOn(false)
        hideLable.textColor = UIColor.lightGray.withAlphaComponent(0.8)
        notPassibleLabel.textColor = UIColor.lightGray.withAlphaComponent(0.8)
        checkBoz.isEnabled = false
        selection_data = "St"
    }
    
    @objc func others_clicked(){
        otherUser = true
        associcationMem = false
        self.roleFeild.text = ""
        roleFeild.isHidden = false
        role_heightConstaint.constant = 40
        othersBtn.select()
        residentBtn.deselect()
        asociationBtn.deselect()
        staffBtn.deselect()
        checkBoz.setOn(false)
        hideLable.textColor = UIColor.lightGray.withAlphaComponent(0.8)
        notPassibleLabel.textColor = UIColor.lightGray.withAlphaComponent(0.8)
        checkBoz.isEnabled = false
        selection_data = "Ot"
    }
                
    
    func setup_api(){
       
        roleFeild.isHidden = true
        role_heightConstaint.constant = 0
        
        if communityModel.count != 0  {
            name_feild.text = communityModel[safe:0]?.custName
            gender_feild.text = communityModel[safe:0]?.gender
            email_feild.text = communityModel[safe:0]?.contactEmail
        }
        
        fillter = communityModel.filter({ (model) -> Bool in
            return model.has_joined_to_comm == 1
        })
        print(fillter.count)
        if fillter.count != 0 {
            containerVIew.isHidden = false
             for i in fillter {
                if i.unitNo == nil {
                    let str = (i.roleName ?? "")+" "+(i.commName ?? "")
                    data_string.append(str)
                }else{
                    if let cor = i.unitNo{
                        let str = (i.blockNm ?? "")+" \(cor) "+(i.commName ?? "")
                        data_string.append(str)
                    }
                }
            }
                                    
            tableview.separatorStyle = .none
            tableview.tableFooterView = UIView()
            tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            tableview.delegate = self
            tableview.dataSource = self
            
            var height = [CGFloat]()
            for i in data_string {
                height.append(calculateHeight(inString: i))
            }
            let reduceSum = height.reduce(0) {$0 + CGFloat($1)}
            
            checkBoz.isEnabled = false
            height_constraint.constant = reduceSum+100
        }else{
            checkBoz.isEnabled = true
            height_constraint.constant = 0
            containerVIew.isHidden = true
        }
    }
    
    @IBAction func backClicked(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("Update_init1"), object: nil)
        remove()
    }
    
    @IBAction func continueClicked(_ sender: UIButton) {
        
        guard let email = email_feild.text?.trimmingCharacters(in: .whitespaces) else { return  }
        if name_feild.text?.count == 0 {
            showConfirmAlert(title: "", message: "Name cannot be empty!", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else if gender_feild.text?.count == 0 {
            showConfirmAlert(title: "", message: "Please select gender!", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else if email.count == 0 {
            showConfirmAlert(title: "", message: "Email cannot be empty!", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else if !isValidEmail(email) {
            showConfirmAlert(title: "", message: "Enter valid Email-ID!", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else{
            
            guard let role = roleFeild.text else { return }
            
            if selection_data == "Ot" {
                if role.count == 0 {
                    showConfirmAlert(title: "", message: "Please select role", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                }else{
                    setup_layout(role: role, email: email)
                }
            }else if selection_data == "St" {
                if role.count == 0 {
                    showConfirmAlert(title: "", message: "Please select role!", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                }else{
                    setup_layout(role: role, email: email)
                }
            }else if selection_data == "As" {
                if role.count == 0 {
                    showConfirmAlert(title: "", message: "Please select role!", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                }else{
                    setup_layout(role: role, email: email)
                }
            }else{
                setup_layout(role: "", email: email)
            }
        }
        
    }
    
    func setup_layout(role:String,email: String){
        let controller = AppStoryboard.joinBoard.viewController(viewControllerClass: CommunityViewController.self)
        controller.name = name_feild.text ?? ""
        controller.gender = gender_feild.text ?? ""
        controller.phone = phone
        controller.email = email
        controller.is_mc_member = associcationMem
        controller.is_other_user = otherUser
        
                
        controller.role_name = role
        controller.roleid  = self.rolid
        
        if checkBoz.on == true {
            controller.hideDetails = true
        }else{
            controller.hideDetails = false
        }
        controller.communityModel = communityModel
        controller.fillter = fillter
        controller.selection_data = selection_data
        controller.rollModel = roleModel
        self.add(controller, frame: self.view.bounds, customVIew: self.view)
    }
    
}


extension PersonalDetailController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let textFieldString = textField.fullTextWith(range: range, replacementString: string) {
            if name_feild == textField {
                if textFieldString.count > 50 {
                    return false
                }
            }else if email_feild == textField {
                if textFieldString.count > 50 {
                    return false
                }
            }
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data_string.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        let index = indexPath.row+1
        let text = "\(index). "+data_string[indexPath.row]
        
        cell.textLabel?.text = text
        cell.textLabel?.textColor = UIColor(hex: "#FF7F2A")
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height:CGFloat = calculateHeight(inString: self.data_string[indexPath.row])
        return height
    }
    
    func calculateHeight(inString:String) -> CGFloat
    {
        let messageString = inString
        let attributes = [NSAttributedString.Key.font:
            UIFont(name: "Helvetica-Bold", size: 15.0)!,
                          NSAttributedString.Key.foregroundColor: UIColor.white] as [NSAttributedString.Key: Any]
        let attributedString : NSAttributedString = NSAttributedString(string: messageString, attributes: attributes)
        
        let rect : CGRect = attributedString.boundingRect(with: CGSize(width: 222.0, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        let requredSize:CGRect = rect
        return requredSize.height
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
