//
//  VisitorViewController.swift
//  Smartility
//
//  Created by Mani on 12/9/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit

class VisitorViewController: UIViewController {
    
    var visitorModel: TodaysVisitor?
    var invitedModel: InvitedVisitorModel?
    var easyPassHolderModel: EasyPassHolderModel?
    var UnitCusModel = [getUnitsByCustIdModel]()
    var rootModel: [CommuntyResultModel]?
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var menuHeight: NSLayoutConstraint!
    @IBOutlet weak var navigationBarView: UIView!
    
    var blockandUnit = [String]()
    var unit_id_list = [Int]()
    var comm_id = Int()
    var initialIndex = Int()
    var private_unitid_list = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.bringSubviewToFront(navigationBarView)
        navigationBarView.backgroundColor = .white
        navigationBarView.layer.shadowColor = UIColor(red: 0.049, green: 0.019, blue: 0.167, alpha: 0.2).cgColor
        navigationBarView.layer.shadowOpacity = 1
        navigationBarView.layer.shadowRadius = 1
        navigationBarView.layer.shadowOffset = CGSize(width: 0, height: 1)
        
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
        
        if let model = rootModel {
            select_indexValue(index: initialIndex, succ: model)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(backClicked))
        tap.numberOfTapsRequired = 1
        backImageView.isUserInteractionEnabled = true
        backImageView.addGestureRecognizer(tap)
    }
        
    @objc func backClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func select_indexValue(index: Int, succ: [CommuntyResultModel]){        
        self.comm_id = succ[safe:index]!.comm_id!
        community.community_id = "\(self.comm_id)"
        community.community_name = succ[safe:index]?.comm_name ?? ""
        let cusId = UserDefaults.cust_id
        let user_id = UserDefaults.user_id
        
        UserDefaults.UserContry = succ[safe: index]?.country_code  ?? ""
        if let isOtherUser = succ[safe: index]?.is_other_user {
            UserDefaults.isOtherUser = isOtherUser
        }
        if let isAdmin = succ[safe: index]?.is_admin {
            UserDefaults.isAdmin = isAdmin
        }
        if let otheruser = succ[safe:index]?.is_other_user {
            if (otheruser == 1){
                if succ[safe:index]?.rel_status_if_other_user == "Linked"  {
//                    self.error_Status = ""
                    self.loadVisitorDashboard()
                }else{
//                    self.error_Status = succ[safe: 0]?.rel_status_if_other_user ?? ""
//                    self.rejection_Reason = succ[safe: 0]?.rej_reason_if_other_user ?? ""
                    self.table.delegate = self
                    self.table.dataSource = self
                    self.table.reloadData()
                }
            }else{
                print("user_id--------------->",user_id)
                print("cusId--------------->",cusId)
                self.table.delegate = nil
                self.table.dataSource = nil
                self.table.showActivityIndicator()
                let id = "\(user_id)/\(self.comm_id)"
                self.unit_id_list.removeAll()
                self.private_unitid_list.removeAll()
                
                Networking.shared.getUnitsByUserId(id: id) { (model, error) in
                    if let model = model {
                        self.UnitCusModel = model
                        let linked =  model.filter { (model) -> Bool in
                            model.rel_status == "Linked"
                        }
                        if linked.count != 0 {
//                            self.error_Status = ""
                            self.unit_id_list =  model.filter { (model) -> Bool in
                                model.rel_status == "Linked"
                            }.compactMap({
                                $0.unit_id
                            })
                            model.forEach { (idlist) in
                                if idlist.is_rented == 1 {
                                    if idlist.ownership?.lowercased().contains("tenant") ?? false {
                                        if let id_list = idlist.unit_id {
                                            self.private_unitid_list.append(id_list)
                                        }
                                    }
                                }else{
                                    if let id_list = idlist.unit_id {
                                        self.private_unitid_list.append(id_list)
                                    }
                                }
                            }
                            
                            var private_block_unit_noList = model.map { $0.block_and_unit ?? "" }
                            
                            if let id = self.unit_id_list.first {
                                community.cust_unitId = "\(id)"
                            }
                            
                            self.blockandUnit.removeAll()
                            self.blockandUnit =  model.filter { (model) -> Bool in
                                model.rel_status != "Linked"
                            }.map({ $0.block_and_unit ?? "" })
                            
                            print(self.unit_id_list)
                            
                            self.loadVisitorDashboard()
                            
                        }else{
//                            self.error_Status = model[safe: 0]?.rel_status ?? ""
//                            self.rejection_Reason = model[safe: 0]?.rej_reason ?? ""
                            
                            self.table.delegate = self
                            self.table.dataSource = self
                            self.table.reloadData()
                        }
                    }
                                        
                    if let err = error {
                        self.table.hideActivityIndicator()
                        self.showConfirmAlert(title: "", message: err.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                    }
                    self.loadVisitorDashboard()
                    self.table.cr.endHeaderRefresh()
                }
            }
        }
    }
    
    func loadVisitorDashboard(){
        let user_id = UserDefaults.user_id
        let dispatch = DispatchGroup()
        var perams = [String:Any]()
        let current_date = Date()
        let date_formatter = DateFormatter()
        date_formatter.dateFormat = "yyy-MM-dd"
        let date = date_formatter.string(from: current_date)
        
        self.table.showActivityIndicator()
        perams.updateValue(self.private_unitid_list, forKey: "unit_id_list")
        perams.updateValue(user_id, forKey: "user_id")
        perams.updateValue(self.comm_id, forKey: "comm_id")
        perams.updateValue(date, forKey: "from_dt")
        perams.updateValue(date, forKey: "to_dt")
                    
        dispatch.enter()
        Networking.shared.getMyVisitorByPeriodAndStatus(perams: perams) { (model, error) in
            if let mode = model {
                self.visitorModel = mode
                dispatch.leave()
            }
            if let _ = error {
                dispatch.leave()
            }
        }
        
        var perams_details = [String:Any]()
        perams_details.updateValue(self.private_unitid_list, forKey: "unit_id_list")
        perams_details.updateValue(user_id, forKey: "user_id")
        perams_details.updateValue(self.comm_id, forKey: "comm_id")
        perams_details.updateValue("active", forKey: "filter_by")
        dispatch.enter()
        Networking.shared.getMyInvitedVisitor(perams: perams_details) { (model, error) in
            if let model = model {
                self.invitedModel = model
                dispatch.leave()
            }
            if let _ = error {
                dispatch.leave()
            }
        }
        dispatch.enter()
        Networking.shared.getMyEasyPassHolders(perams: perams_details) { (model, error) in
            if let model = model {
                self.easyPassHolderModel = model
                dispatch.leave()
            }
            if let _ = error {
                dispatch.leave()
            }
        }
        
        dispatch.notify(queue: .main) {
            self.table.delegate = self
            self.table.dataSource = self
            self.table.reloadData()
            self.table.hideActivityIndicator()
        }
    }
}

extension VisitorViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodayVisitorCell", for: indexPath) as? TodayVisitorCell
            cell?.setup(data: self.visitorModel)
            cell?.collectionView.bringSubviewToFront(cell!.none_label)
            cell?.containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(today_clicked)))
            
            return cell!
        }else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationSettingsCell", for: indexPath) as? NotificationSettingsCell
            cell?.notificationView.addTarget(self, action: #selector(notificationTapped), for: .touchUpInside)
            return cell!
        }else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvitedVisitorCell", for: indexPath) as? InvitedVisitorCell
            cell?.newInviteClosure = newInviteClicked
            if let invite = invitedModel {
                cell?.setup(model: invite)
            }
            cell?.containerVivew.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(invited_clicked)))
            return cell!
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EasyPassHolderCell", for: indexPath) as? EasyPassCell
            if let easypassModel = self.easyPassHolderModel {
                cell?.setup(model: easypassModel)
            }
            cell?.newPassLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(easyPass_CreatClicked)))
                            
            cell?.containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(easyPass_clicked)))
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 35
        }
        return 180
    }
    
   
    
    
    @objc func notificationTapped(){
        let controller = AppStoryboard.NotificationController.viewController(viewControllerClass: NotificationSettingsController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
  
    
    func newInviteClicked(){
        let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: NewInviteController.self)
        controller.UnitCusModel = self.UnitCusModel
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func today_clicked(){
        let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: TodaysVisitorViewController.self)
        controller.model = self.visitorModel
        controller.unit_id_list = self.private_unitid_list
        controller.comm_id = comm_id
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func invited_clicked(){
        let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: InvitedVisitorController.self)
        controller.model = self.invitedModel
        controller.unit_id_list = self.private_unitid_list
        controller.comm_id = comm_id
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @objc func easyPass_CreatClicked(){
        let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: EasyPassCreateController.self)
        controller.UnitCusModel = self.UnitCusModel
        controller.easyPassClick = false
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func easyPass_clicked(){
        let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: EasyPassViewController.self)
        controller.model = self.easyPassHolderModel?.detail
//        controller.unit_id_list = unit_id_list
//        controller.comm_id = comm_id
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
