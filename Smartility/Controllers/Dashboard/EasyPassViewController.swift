//
//  EasyPassViewController.swift
//  Smartility
//
//  Created by Mani on 7/15/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import Kingfisher
import MaterialComponents
import DropDown
import GSImageViewerController

class EasyPassViewController: UIViewController {
    
    var timelimit_dropDown = DropDown()
    var typeVisitorDropDown = DropDown()
    
    
    @IBOutlet weak var backBgView: UIView!
    @IBOutlet weak var fillter_1: MDCCard!
    @IBOutlet weak var fillter_2: MDCCard!
    
    @IBOutlet weak var fillter_1_label: UITextField!
    @IBOutlet weak var fillter_2_label: UITextField!
    
    @IBOutlet weak var menuHeight: NSLayoutConstraint!
    @IBOutlet weak var navigationBarView: UIView!
    
    @IBOutlet weak var table: UITableView!
    
    var details: [EasyPassHolderDetail] = []
    var private_unitid_list: [Int] = []
    
    var UnitCusModel = [getUnitsByCustIdModel]()
    var model: [EasyPassHolderDetail]?
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
            default:
                menuHeight.constant = 90
            }
        }else{
            menuHeight.constant = 90
        }
        
        fillter_1_label.placeholder = "Time Limit"
        fillter_2_label.placeholder = "Type"
        
        fillter_1.addTarget(self, action: #selector(fillter_1Clicked), for: .touchUpInside)
        fillter_2.addTarget(self, action: #selector(fillter_2Clicked), for: .touchUpInside)
        
        fillter_1_label.setupRightImage(imageName: "dropDown")
        fillter_2_label.setupRightImage(imageName: "dropDown")
        
        fillter_1_label.isUserInteractionEnabled = false
        fillter_2_label.isUserInteractionEnabled = false
                
//        if let detail_mode = model {
//            self.details = detail_mode
//        }
                
        timelimit_dropDown.selectionBackgroundColor = .white
        timelimit_dropDown.backgroundColor = .white
        timelimit_dropDown.anchorView = fillter_1
        timelimit_dropDown.dataSource = ["Time Limit","With Expiry", "No Expiry"]
        timelimit_dropDown.width = fillter_1.frame.size.width
        timelimit_dropDown.cornerRadius = 10
        timelimit_dropDown.bottomOffset = CGPoint(x: 0, y:((timelimit_dropDown.anchorView?.plainView.bounds.height)!+5))
        
        timelimit_dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            emptyStringLabel?.text = ""
            if item == "Time Limit" {
                self.fillter_1_label.text = ""
                self.reloadData()
            }else{
                self.fillter_1_label.text = item
                if let mode = self.model{
                    self.details = mode.filter { (modelData) -> Bool in
                        modelData.time_limit == item
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
            emptyStringLabel?.text = ""
            if item != "Type" {
                self.fillter_2_label.text = item
                let text = self.fillter_1_label.text
                
                if let mode = self.model{
                    self.details = mode.filter { (modelData) -> Bool in
                        modelData.time_limit == text
                    }
                }
                self.details = self.details.filter { (model) -> Bool in
                    model.visitor_cat == item
                }
                self.table.reloadData()
            }else{
                self.fillter_2_label.text = ""
                let text = self.fillter_1_label.text
                if let mode = self.model{
                    self.details = mode.filter { (modelData) -> Bool in
                        modelData.time_limit == text
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
            let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: EasyPassCreateController.self)
            controller.UnitCusModel = self.UnitCusModel
            controller.easyPassClick = false
            self.navigationController?.pushViewController(controller, animated: true)
        }
        view.addSubview(floatingBtn)
        floatingBtn.layoutAnchor(top: nil, left: nil, bottom: self.view.bottomAnchor, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 10, width: 60, height: 60, enableInsets: true)
        getTopWindow()?.bringSubviewToFront(floatingBtn)
        //        }
        reloadData()
    }
    
    func reloadData(){
        var perams_details = [String:Any]()
        perams_details.updateValue(self.private_unitid_list, forKey: "unit_id_list")
        perams_details.updateValue(UserDefaults.user_id, forKey: "user_id")
        perams_details.updateValue(community.community_id, forKey: "comm_id")
        perams_details.updateValue("active", forKey: "filter_by")
        emptyStringLabel?.text = ""
        self.table.delegate = nil
        self.table.dataSource = nil
        self.table.reloadData()
        table.showActivityIndicator()
        Networking.shared.getMyEasyPassHolders(perams: perams_details) { (model, error) in
            if let model = model?.detail, model.count != 0 {
                self.details = model
                var source = model.compactMap{ $0.visitor_cat}
                source = source
                    .enumerated()
                    .filter{ source.firstIndex(of: $0.1) == $0.0 }
                    .map{ $0.1 }
                source.insert("Type", at: 0)
                self.typeVisitorDropDown.dataSource = source
            }
            self.table.delegate = self
            self.table.dataSource = self
            if self.details.count == 1 {
                self.table.reloadData()
            }else{
                self.table.reloadWithAnimation()
            }
            self.table.scrollToTop()
            self.table.hideActivityIndicator()
        }
    }
    
    @objc func tapProfile(sender:UITapGestureRecognizer){
        guard let index = sender.view?.tag else { return }
        guard let cell = table.cellForRow(at: IndexPath(row: index, section: 0)) as? EasyPassTableCell else { return }
        guard let icon = cell.profileIcon?.image else { return }
        let imageInfo   = GSImageInfo(image: icon, imageMode: .aspectFit)
        let transitionInfo = GSTransitionInfo(fromView: cell.profileIcon)
        let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        self.present(imageViewer, animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func fillter_1Clicked(){
        self.fillter_2_label.text = ""
        timelimit_dropDown.show()
    }
    
    @objc func fillter_2Clicked(){
        typeVisitorDropDown.show()
    }
}

extension EasyPassViewController: UITableViewDelegate, UITableViewDataSource {
    
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
            No EasyPass holders!

            Create new by tapping on + button below
            """
                          }, completion: nil)
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EasyPassTableCell", for: indexPath) as? EasyPassTableCell
        cell?.profileIcon.isUserInteractionEnabled = true
        cell?.name.textColor = UIColor(hex: "#000000")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapProfile(sender:)))
        tap.numberOfTouchesRequired = 1
        cell?.profileIcon.tag = indexPath.row
        cell?.profileIcon.addGestureRecognizer(tap)
        
        if let data = details[safe:indexPath.row] {
            
            if let comid = data.comm_id, "\(comid)" == community.community_id  {
                cell?.notPassibleLable.isHidden = true
                cell?.editeBtn.tag = indexPath.row
                cell?.deleteBtn.tag = indexPath.row
                cell?.shareBtn.tag = indexPath.row
                
                cell?.shareBtn.isHidden = false
                cell?.editeBtn.isHidden = false
                cell?.deleteBtn.isHidden = false
                
                if let user_id = data.user_id {
                    if UserDefaults.user_id == "\(user_id)" {
                        cell?.shareBtn.addTarget(self, action: #selector(shareClicked), for: .touchUpInside)
                        cell?.deleteBtn.addTarget(self, action: #selector(deleteClicked), for: .touchUpInside)
                        cell?.editeBtn.addTarget(self, action: #selector(editeClicked), for: .touchUpInside)
                        cell?.deleteBtn.isHidden = false
                        cell?.editeBtn.isHidden = false
                        cell?.shareBtn.isHidden = false
                    }else{
                        cell?.shareBtn.isHidden = true
                        cell?.deleteBtn.isHidden = true
                        cell?.editeBtn.isHidden = true
                    }
                }
                
            }else{
                cell?.shareBtn.isHidden = true
                cell?.editeBtn.isHidden = true
                cell?.deleteBtn.isHidden = true
                cell?.notPassibleLable.isHidden = false
            }
            
            
            if let id_type = data.id_type {
                cell?.otherCard.text = id_type
            }            
            
            if let urlStr = data.visitor_img_url {
                let url_st = EndPoint.imageURL+urlStr
                let url = URL(string: url_st)
                cell?.profileIcon.kf.indicatorType = .activity
                cell?.profileIcon.kf.setImage(
                    with: url,
                    placeholder: UIImage(named:"proflie_icon"),
                    options: [.transition(.fade(0.3))], completionHandler:
                        {
                            result in
                            switch result {
                            case .success(let value):
                                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                            case .failure(let error):
                                print("Job failed: \(error.localizedDescription)")
                            }
                        })
            }
            cell?.name.text = data.visitor_name
            
            if let date = data.easypass_exp {
                let getTime = timeConversion12(time24:date)
                cell?.date.text = "Expires On \(getTime)".uppercased()
            }else{
                cell?.date.text = "NO EXPIRY DATE"
            }
            
            cell?.notPassibleLable.textColor = UIColor(hex: "#828282")
            cell?.issuesByLabel.textColor = UIColor(hex: "#828282")
            cell?.date.textColor = UIColor(hex: "#828282")
            cell?.catName.textColor = brandColor()
            
            if let name = data.user_name {
                if let date = data.easypass_dt {
                    let getTime = timeConversion12(time24:date)
                    cell?.issuesByLabel.text = "Issued by \(name) on \(getTime)"
                }
            }
            cell?.notPassibleLable.text = "Not possible to update EasyPass issued by others"
            
            if let catagory = data.visitor_cat {
                if catagory == "Daily Helper" {
                    cell?.icon.image = UIImage(named: "people_Black")?.imageWithColor(color1: UIColor(hex: "#828282"))
                    cell?.catName.text = "Daily Helper"
                }else if catagory == "Cab" {
                    cell?.catName.text = "Cab"
                    cell?.icon.image = UIImage(named: "Cab_Black")?.imageWithColor(color1: UIColor(hex: "#828282"))
                }else if catagory == "Guest" {
                    cell?.catName.text = "Guest"
                    cell?.icon.image = UIImage(named: "faceIconBlack")?.imageWithColor(color1: UIColor(hex: "#828282"))
                }else if catagory == "Delivery" {
                    cell?.icon.image = UIImage(named: "shopping_cartBlack")?.imageWithColor(color1: UIColor(hex: "#828282"))
                    cell?.catName.text = "Delivery"
                }else if catagory == "Vendor" {
                    cell?.catName.text = "Vendor"
                    cell?.icon.image = UIImage(named: "build_icon_black")?.imageWithColor(color1: UIColor(hex: "#828282"))
                }else{
                    cell?.catName.text = catagory
                    cell?.icon.image = UIImage(named: "person_icon")?.imageWithColor(color1: UIColor(hex: "#828282"))
                }
            }
            
            cell?.callBtnC.setImage(UIImage(named: "telephone_icon")?.imageWithColor(color1: brandColor()), for: .normal)
            cell?.callBtnC.isUserInteractionEnabled = false
            cell?.telephoneContainer.tag = indexPath.row
            cell?.telephoneContainer.addTarget(self, action: #selector(phoneCall(_:)), for: .touchUpInside)
        }
        
        
        return cell!
    }
    
    
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
    
    
    @objc func shareClicked(sender: UIButton){
        let index = sender.tag
        let data = details[index]
        print(data)
        let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: QrCodeViewController.self)
        controller.invite_easyPass = "EasyPass"
        controller.shareFrom = "Share"
        controller.user_name = "- "+(data.user_name ?? "")
        controller.wasSent = 1
        controller.glad_text = "Please find below your EasyPass number. Show this everytime at gate for smooth entry."
        if let id = data.block_and_unit {
            controller.blockandUnit = "\(id)"
        }
        if let inviteNumber = data.easypass_no {
            controller.otpInvite = "\(inviteNumber)"
        }
        self.navigationController?.pushViewController(controller, animated: true)
        
        
    }
    
    
    
    
    @objc func deleteClicked(sender: UIButton){
        let index = sender.tag
        if let easyPassID = details[safe:index]?.easypass_id,  let name = details[safe:index]?.visitor_name,  let personID = details[safe:index]?.person_id, let unitID = details[safe:index]?.unit_id{
            
            let otherAlert = UIAlertController(title: "Delete", message: "Sure, you want to delete the EasyPass of \(name)", preferredStyle: .alert)
            let OkAction = UIAlertAction(title: "Delete EasyPass", style: .default) { (action) in
                
                Networking.shared.deletePass(perams: ["user_id": UserDefaults.user_id, "unit_id":unitID ,"easypass_id":easyPassID, "comm_id":community.community_id, "person_id": personID]) { (succes, error) in
                    if succes != nil {
//                        self.reloadData()
                        CATransaction.begin()
                        CATransaction.setCompletionBlock({
                            self.table.beginUpdates()
                            self.details.remove(at: index)
                            self.table.deleteRows(at: [IndexPath(row: index, section: 0)], with: .top)
                            self.table.endUpdates()
                        })
                        self.table.setEditing(false, animated: true)
                        CATransaction.commit()
                        
                        NotificationCenter.default.post(name: NSNotification.Name("UpdateActions"), object: nil)
                    }
                    if let er = error {
                        self.table.reloadData()
                        self.showConfirmAlert(title: "", message: er.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                    }
                }
            }
            let CanceAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            }
            otherAlert.addAction(OkAction)
            otherAlert.addAction(CanceAction)
            self.present(otherAlert, animated: true, completion: nil)
        }
    }
    
    @objc func editeClicked(sender: UIButton){
        let index = sender.tag
        let data = details[safe:index]
        let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: EasyPassCreateController.self)
        controller.easyPassClick = true
        controller.modelExistingData = data
        self.navigationController?.pushViewController(controller, animated: true)
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
            
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let data = details[safe:indexPath.row] {
            if let user_id = data.user_id {
                if UserDefaults.user_id == "\(user_id)" {
                    return 200
                }else{
                    return 175
                }
            }
            return 175
        }
        return 175
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
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = .current
        if let date = dateFormatter.date(from: dateString) {
            return date
        }else{
            return nil
        }
    }
    
}
