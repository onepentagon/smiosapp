//
//  InvitedVisitorController.swift
//  Smartility
//
//  Created by Mani on 7/13/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import MaterialComponents
import DropDown


class InvitedVisitorController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var menuHeight: NSLayoutConstraint!
    @IBOutlet weak var navigationBarView: UIView!
    
    var model: InvitedVisitorModel?
    var unit_id_list = [Int]()
    var comm_id = Int()
    
    var whenVisitorDropDown = DropDown()
    var typeVisitorDropDown = DropDown()
    
    @IBOutlet weak var fillter_1: MDCCard!
    @IBOutlet weak var fillter_2: MDCCard!
    @IBOutlet weak var fillter_1_label: UITextField!
    @IBOutlet weak var fillter_2_label: UITextField!
    @IBOutlet weak var backBgView: UIView!
    
    var details =  [InvitedDetail]()
    var UnitCusModel = [getUnitsByCustIdModel]()
    var floatingBtn = CustomButton()
    var lastContentOffset: CGFloat = 0
    var emptyStringLabel: UILabel?
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
                menuHeight.constant = 80
            default:
                menuHeight.constant = 90
            }
        }else{
            menuHeight.constant = 90
        }
        //        
        //        if let details = self.model?.detail {
        //            self.details = details
        //        }
        
        fillter_1.addTarget(self, action: #selector(fillter_1Clicked), for: .touchUpInside)
        fillter_2.addTarget(self, action: #selector(fillter_2Clicked), for: .touchUpInside)
        
        fillter_1_label.setupRightImage(imageName: "dropDown")        
        fillter_2_label.setupRightImage(imageName: "dropDown")
        
        fillter_1_label.isUserInteractionEnabled = false
        fillter_2_label.isUserInteractionEnabled = false
        
        whenVisitorDropDown.selectionBackgroundColor = .white
        whenVisitorDropDown.backgroundColor = .white
        whenVisitorDropDown.anchorView = fillter_1
        whenVisitorDropDown.dataSource = ["When","Today", "Tomorrow", "Later"]
        whenVisitorDropDown.width = fillter_1.frame.size.width
        whenVisitorDropDown.cornerRadius = 10
        whenVisitorDropDown.bottomOffset = CGPoint(x: 0, y:((whenVisitorDropDown.anchorView?.plainView.bounds.height)!+5))
        
        whenVisitorDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.emptyStringLabel?.text = ""
            if item == "When" {
                self.fillter_1_label.text = ""
                self.reload()
            }else{
                self.fillter_1_label.text = item
                if let details = self.model?.detail {
                    self.details = details.filter { (model) -> Bool in
                        model.invited_when == item
                    }
                }
                var source = self.details.compactMap{ $0.visitor_cat}
                source = source
                    .enumerated()
                    .filter{ source.firstIndex(of: $0.1) == $0.0 }
                    .map{ $0.1 }
                source.insert("Type", at: 0)
                self.typeVisitorDropDown.dataSource = source
                self.table.reloadData()
            }
        }
        
        typeVisitorDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.emptyStringLabel?.text = ""
            if item == "Type" {
                let text = self.fillter_1_label.text
                if text == "" {
                    self.fillter_2_label.text = ""
                    if let details = self.model?.detail {
                        self.details = details
                    }
                    self.table.reloadData()
                }else{
                    self.fillter_2_label.text = ""
                    if let details = self.model?.detail {
                        self.details = details.filter { (model) -> Bool in
                            model.invited_when == text
                        }
                    }
                    self.table.reloadData()
                }
            }else{
                self.fillter_2_label.text = item
                let text = self.fillter_1_label.text
                if text == "" {
                    if let details = self.model?.detail {
                        self.details = details.filter { (model) -> Bool in
                            model.visitor_cat == item
                        }
                    }
                }else{
                    if let details = self.model?.detail {
                        self.details = details.filter { (model) -> Bool in
                            model.invited_when == text
                        }.filter({ (mode) -> Bool in
                            mode.visitor_cat == item
                        })
                    }
                }
                self.table.reloadData()
            }
        }
        
        typeVisitorDropDown.selectionBackgroundColor = .white
        typeVisitorDropDown.backgroundColor = .white
        typeVisitorDropDown.anchorView = fillter_2
        
        typeVisitorDropDown.width = fillter_2.frame.size.width
        typeVisitorDropDown.cornerRadius = 10
        typeVisitorDropDown.bottomOffset = CGPoint(x: 0, y:((typeVisitorDropDown.anchorView?.plainView.bounds.height)!+5))
        
        emptyStringLabel = UILabel(frame: .zero)
        view.addSubview(emptyStringLabel!)
        emptyStringLabel?.layoutAnchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: view.centerXAnchor, centerY: view.centerYAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: true)
        emptyStringLabel?.textColor = UIColor.gray
        emptyStringLabel?.numberOfLines = 0;
        emptyStringLabel?.textAlignment = .center;
        emptyStringLabel?.font = UIFont(name: "SFUIText-Regular", size: 17)
        emptyStringLabel?.sizeToFit()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        lastContentOffset = 0
        //        if UserDefaults.isAdmin == 1 {
        floatingBtn = CustomButton()
        floatingBtn.setImage(UIImage(named: "PlusBtn"), for: .normal)
        floatingBtn.actionHandle(controlEvents: .touchUpInside) {
            let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: NewInviteController.self)
            controller.UnitCusModel = self.UnitCusModel
            controller.inviteData = false
            self.navigationController?.pushViewController(controller, animated: true)
        }
        view.addSubview(floatingBtn)
        floatingBtn.layoutAnchor(top: nil, left: nil, bottom: self.view.bottomAnchor, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 10, width: 60, height: 60, enableInsets: true)
        getTopWindow()?.bringSubviewToFront(floatingBtn)
        //        }
        reload()
    }
    
    func reload(){
        var perams_details = [String:Any]()
        perams_details.updateValue(self.unit_id_list, forKey: "unit_id_list")
        perams_details.updateValue(UserDefaults.user_id, forKey: "user_id")
        perams_details.updateValue(community.community_id, forKey: "comm_id")
        perams_details.updateValue("active", forKey: "filter_by")
        self.table.delegate = nil
        self.table.dataSource = nil
        self.table.reloadData()
        self.table.showActivityIndicator()
        self.emptyStringLabel?.text = ""
        Networking.shared.getMyInvitedVisitor(perams: perams_details) { (model, error) in
            if let model = model {
                self.model = model
                if let details = self.model?.detail {
                    self.details = details
                }
                var source = self.details.compactMap{ $0.visitor_cat}
                source = source
                    .enumerated()
                    .filter{ source.firstIndex(of: $0.1) == $0.0 }
                    .map{ $0.1 }
                source.insert("Type", at: 0)
                self.typeVisitorDropDown.dataSource = source
            }
            if let _ = error {
                //                self.table.reloadData()
            }
            self.details.count == 1 ?  self.table.reloadData() : self.table.reloadWithAnimation()
            self.table.delegate = self
            self.table.dataSource = self
            self.table.reloadWithAnimation()
            self.table.hideActivityIndicator()
            self.table.scrollToTop()
        }
    }
    
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func fillter_1Clicked(){
        self.fillter_2_label.text = ""
        whenVisitorDropDown.show()
    }
    
    @objc func fillter_2Clicked(){
        typeVisitorDropDown.show()
    }
    
}


extension InvitedVisitorController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if details.count != 0 {
            UIView.transition(with: emptyStringLabel!,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                self?.emptyStringLabel!.text = ""
                              }, completion: nil)
            return details.count
        }
        
        UIView.transition(with: emptyStringLabel!,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.emptyStringLabel!.text = """
            No invites found!

            Create new by tapping on + button below
            """
                          }, completion: nil)
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvitedTableCell", for: indexPath) as! InvitedTableCell
        let dynamic = details[indexPath.row]
        cell.name.text = dynamic.visitor_name
        
        cell.desc.textColor  =  UIColor(hex: "#828282")
        cell.statusBtn.textColor = .black
        cell.cat_name.textColor  = brandColor()
        
        if let expected_shortly = dynamic.is_exp_shortly {
            if expected_shortly == 1 {
                cell.desc.text = "EXPECTED SHORTLY"
            }else{
                if let invited_da_time = dynamic.invited_dt_time  {
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    dateFormatter.timeZone = .current
                    
                    
                    if let time = dateFormatter.date(from: invited_da_time) {
                        let dateFormater_1 = DateFormatter()
                        dateFormater_1.dateFormat = "dd-MM-yyy hh:mm a"
                        let invite_time = dateFormater_1.string(from: time)
                        cell.desc.text = "EXPECTED ON \(invite_time)".uppercased()
                    }
                }
            }
        }
        
        if dynamic.invited_when == "Tomorrow" {
            cell.statusBtn.text = "Visiting Tomorrow"
            cell.statusBtn.backgroundColor = UIColor(hex: "#FFB760")
        }else if dynamic.invited_when == "Today" {
            cell.statusBtn.text = "Visiting Today"
            cell.statusBtn.backgroundColor = UIColor(hex: "#FF8F88")
        }else if dynamic.invited_when == "Later" {
            cell.statusBtn.text = "Visiting Later"
            cell.statusBtn.backgroundColor = UIColor(hex: "#67E1FF")
        }
        
        if let catagory = dynamic.visitor_cat {
            if catagory == "Daily Helper" {
                cell.icon.image = UIImage(named: "people_Black")?.imageWithColor(color1: UIColor(hex: "#828282"))
                cell.cat_name.text = "Daily Helper"
            }else if catagory == "Cab" {
                cell.cat_name.text = "Cab"
                cell.icon.image = UIImage(named: "Cab_Black")?.imageWithColor(color1: UIColor(hex: "#828282"))
            }else if catagory == "Guest" {
                cell.cat_name.text = "Guest"
                cell.icon.image = UIImage(named: "faceIconBlack")?.imageWithColor(color1: UIColor(hex: "#828282"))
            }else if catagory == "Delivery" {
                cell.icon.image = UIImage(named: "shopping_cartBlack")?.imageWithColor(color1: UIColor(hex: "#828282"))
                cell.cat_name.text = "Delivery"
            }else if catagory == "Vendor" {
                cell.cat_name.text = "Vendor"
                cell.icon.image = UIImage(named: "build_icon_black")?.imageWithColor(color1: UIColor(hex: "#828282"))
            }else{
                cell.cat_name.text = catagory
                cell.icon.image = UIImage(named: "person_icon")?.imageWithColor(color1: UIColor(hex: "#828282"))
            }
        }
        
        if let org = dynamic.visitor_org {
            cell.rolename.text = org
        }
        
        cell.callBtn.setImage(UIImage(named: "telephone_icon")?.imageWithColor(color1: brandColor()), for: .normal)
        cell.callBtn.isUserInteractionEnabled = false
        cell.callContainer.tag = indexPath.row
        cell.callContainer.addTarget(self, action: #selector(phoneCall(_:)), for: .touchUpInside)
        
        cell.deletBtn.tag = indexPath.row
        cell.deletBtn.addTarget(self, action: #selector(deleteClicked(_:)), for: .touchUpInside)
        
        cell.editeBtn.tag = indexPath.row
        cell.editeBtn.addTarget(self, action: #selector(editeBtnClicked(_:)), for: .touchUpInside)
        
        cell.shareBtn.tag = indexPath.row
        cell.shareBtn.addTarget(self, action: #selector(shareBtnClicked(_:)), for: .touchUpInside)
        
        cell.setReminder.tag = indexPath.row
        cell.setReminder.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendReminder(_:))))
        
        return cell
    }
    
    @objc
    func shareBtnClicked(_ btn: UIButton){
        let indexPath = btn.tag
        let data = details[indexPath]                        
        let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: QrCodeViewController.self)
        controller.invite_easyPass = "invite"
        controller.shareFrom = "Share"
        controller.user_name = "- "+(data.invite_issued_by ?? "")
        controller.wasSent = 1
        controller.glad_text = (data.invite_text ?? "")
        if let id = data.block_and_unit {
            controller.blockandUnit = "\(id)"
        }
        if let inviteNumber = data.invited_otp {
            controller.otpInvite = "\(inviteNumber)"
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @objc func editeBtnClicked(_ btn:UIButton){
        let index = btn.tag
        if let data = details[safe: index] {
            let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: NewInviteController.self)
            controller.inviteData = true
            controller.inviteModel = data
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func sendReminder(_ tap: UITapGestureRecognizer){
        guard let index = tap.view?.tag else { return }
        if let id = details[safe: index]?.invite_id, let unitID = details[safe: index]?.unit_id {
            let perams = ["invite_id":"\(id)","user_id":UserDefaults.user_id,"comm_id":community.community_id,"unit_id":unitID] as [String : Any]
            Networking.shared.setReminder(perams: perams) { (succes, error) in
                if succes != nil {
                    self.view.makeToast("Reminder sent successfully")
                }
                if let er = error {
                    self.showConfirmAlert(title: "", message: er.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        if details.count > 3 {
    //            if let lastCellRowIndex = tableView.indexPathsForVisibleRows?.last?.row {
    //                if details.count - 1 >= lastCellRowIndex + 1 {
    //                    floatingBtn.isHidden = false
    //                } else {
    //                    floatingBtn.isHidden = true
    //                }
    //            }
    //        }
    //    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.lastContentOffset < scrollView.contentOffset.y {
            // did move up
            if details.count != 0 {
                floatingBtn.isHidden = true
            }
        } else if self.lastContentOffset > scrollView.contentOffset.y {
            // did move down
            floatingBtn.isHidden = false
        } else {
            // didn't move
        }
    }
    
    
    
    @objc func phoneCall(_ view: MDCCard){
        let index = view.tag
        if let phoe = details[safe:index]?.visitor_phone {
            if let url = URL(string: "tel://\(phoe)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    @objc func deleteClicked(_ btn:UIButton){
        let dynamic = details[btn.tag]
        if let id = dynamic.invite_id, let name = dynamic.visitor_name {
            let otherAlert = UIAlertController(title: "Delete", message: "Sure, you want to delete the invite of \(name)", preferredStyle: .alert)
            let OkAction = UIAlertAction(title: "Delete Invite", style: .default) { (action) in
                Networking.shared.deleteInvite(perams: ["invite_id":id,"comm_id":community.community_id,"user_id":UserDefaults.user_id,"unit_id":dynamic.unit_id]) { (success, error) in
                    if let success  = success {
                        self.reload()
                        NotificationCenter.default.post(name: NSNotification.Name("UpdateActions"), object: nil)
                    }
                    if let error = error {
                        self.showConfirmAlert(title: "", message: error.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                    }
                }
            }
            let CanceAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            }
            otherAlert.addAction(OkAction)
            otherAlert.addAction(CanceAction)
            present(otherAlert, animated: true, completion: nil)
        }
    }
    
    
    
    func timeConversion12(time24:String)->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyy"
        if let date = dateFromString(dateString: time24) {
            let Str_date = formatter.string(from: date)
            return Str_date
        }
        return ""
    }
    
    func dateFromString(dateString:String)->Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = .current
        if let date = dateFormatter.date(from: dateString) {
            return date
        }else{
            return nil
        }
    }
}
