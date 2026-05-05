//
//  TodaysVisitorViewController.swift
//  Smartility
//
//  Created by Mani on 7/13/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import MaterialComponents
import DropDown
import Kingfisher
import GSImageViewerController

class TodaysVisitorViewController: UIViewController, WWCalendarTimeSelectorProtocol {
    
    @IBOutlet weak var fillter_1: MDCCard!
    @IBOutlet weak var fillter_2: MDCCard!
    
    @IBOutlet weak var menuHeight: NSLayoutConstraint!
    @IBOutlet weak var navigationBarView: UIView!
    
    
    @IBOutlet weak var fillter_1_label: UITextField!
    @IBOutlet weak var fillter_2_label: UITextField!
    @IBOutlet weak var visitorTable: UITableView!
    let dropDown = DropDown()
    
    @IBOutlet weak var startDateFeild: UITextField!
    @IBOutlet weak var endDateFeild: UITextField!
    @IBOutlet weak var fillterBtn: UIButton!
    
    @IBOutlet weak var periodContainer: UIView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backBgView: UIView!
    
    
    let typeDropDown = DropDown()
    

    var model: TodaysVisitor?
    var unit_id_list = [Int]()
    var comm_id = Int()
    var empty_str: UILabel?
    var Details_Model = [Detail]()
    var startEndCLicked = ""
    var selectedItem: String?
            
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

        self.empty_str?.textColor = .gray
        
        self.periodContainer.alpha = 0
        self.startDateFeild.alpha = 0
        self.endDateFeild.alpha = 0
        self.startDateFeild.text = ""
        self.endDateFeild.text = ""
        self.fillterBtn.alpha = 0
        self.heightConstraint.constant = 0
        
        fillterBtn.layer.cornerRadius = 5
        
        
                
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
        
        fillter_1_label.setupRightImage(imageName: "dropDown")
        fillter_2_label.setupRightImage(imageName: "dropDown")
        
        fillter_1_label.isUserInteractionEnabled = false
        fillter_2_label.isUserInteractionEnabled = false
        
        
        empty_str = UILabel(frame: .zero)
        empty_str?.numberOfLines = 0
        empty_str?.text = ""
        empty_str?.textAlignment = .center
        empty_str?.textColor = UIColor.gray
        
        view.addSubview(empty_str!)
        view.bringSubviewToFront(empty_str!)
        
        empty_str?.layoutAnchor(top: nil, left: nil, bottom: nil, right: nil, centerX: visitorTable.centerXAnchor, centerY: visitorTable.centerYAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 100, enableInsets: true)
        
        dropDown.selectionBackgroundColor = .white
        dropDown.backgroundColor = .white
        dropDown.anchorView = fillter_1
        dropDown.dataSource = ["Today", "Yesterday", "This Week", "Period"]
        dropDown.width = fillter_1.frame.size.width
        dropDown.cornerRadius = 10
        dropDown.bottomOffset = CGPoint(x: 0, y:((dropDown.anchorView?.plainView.bounds.height)!+5))
        
        typeDropDown.selectionBackgroundColor = .white
        typeDropDown.backgroundColor = .white
        typeDropDown.anchorView = fillter_2
        typeDropDown.width = fillter_2.frame.size.width
        typeDropDown.cornerRadius = 10
        typeDropDown.bottomOffset = CGPoint(x: 0, y:((dropDown.anchorView?.plainView.bounds.height)!+5))
        
        //
        
        
        visitorTable.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [unowned self] in
            self.visitorTable.cr.beginHeaderRefresh()
            if let item = self.selectedItem {
                self.setupDropDown(item: item, pullToRefresh: true)
            }else{
                self.visitorTable.cr.endHeaderRefresh()
            }
        }
        
        if let model = model?.detail {
            Details_Model = model
        }
        
        let datasource = Details_Model.map({ $0.visitor_cat ?? "" })
        var source = datasource
        source.insert("All", at: 0)
        
        source = source
            .enumerated()
            .filter{ source.firstIndex(of: $0.1) == $0.0 }
            .map{ $0.1 }
        
        typeDropDown.dataSource = source
        
        typeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.fillter_2_label.text = item
            
            if item != "All" {
                if let mod = self.model, let det = mod.detail {
                    self.Details_Model = det.filter({ (details) -> Bool in
                        details.visitor_cat == item
                    })
                }
                self.visitorTable.reloadData()
            }else{
                if let mod = self.model, let det = mod.detail {
                    self.Details_Model = det
                }
                self.visitorTable.reloadData()
            }
        }
                
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.empty_str?.text = ""
            self.fillter_1_label.text = item
            self.visitorTable.showActivityIndicator()
            self.visitorTable.delegate = nil
            self.visitorTable.dataSource = nil
            self.fillter_2_label.text = ""
            self.selectedItem = item
            self.setupDropDown(item: item, pullToRefresh: false)
        }
        
        fillter_1_label.placeholder = "Today"
        fillter_2_label.placeholder = "Type"
        
        
        fillter_1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fillter_1_click)))
        fillter_2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fillter_2_click)))
        
        visitorTable.delegate = self
        visitorTable.dataSource = self
        
        if Details_Model.count == 0 {
            self.empty_str?.text = "No visitors found!"
        }else{
            self.empty_str?.text = ""
        }
    }
    
    
    func setupDropDown(item: String, pullToRefresh: Bool){
        
        var perams = [String:Any]()
        let user_id = UserDefaults.user_id
        
        if item == "Today" {
            self.resetPeriod()
            let current_date = Date()
            let date_formatter = DateFormatter()
            date_formatter.dateFormat = "yyy-MM-dd"
            let date = date_formatter.string(from: current_date)
            
            perams.updateValue(self.unit_id_list, forKey: "unit_id_list")
            perams.updateValue(user_id, forKey: "user_id")
            perams.updateValue(self.comm_id, forKey: "comm_id")
            perams.updateValue(date, forKey: "from_dt")
            perams.updateValue(date, forKey: "to_dt")
            
            Networking.shared.getMyVisitorByPeriodAndStatus(perams: perams) { (model, error) in
                self.visitorTable.cr.endHeaderRefresh()
                if let mode = model {
                    self.model = model
                    if let mode = mode.detail {
                        if self.fillter_2_label.text != "" {
                            self.Details_Model = mode.filter({ (details) -> Bool in
                                details.visitor_cat == self.fillter_2_label.text
                            })
                        }else{
                            self.Details_Model = mode
                        }
                    }
                    let datasource = self.Details_Model.compactMap({ $0.visitor_cat ?? "" })
                    if datasource.count != 0 {
                        var sourceToday = datasource
                        sourceToday = datasource.unique{$0}
                        sourceToday.insert("All", at: 0)
                        self.typeDropDown.dataSource = sourceToday
                    }else{
                        self.typeDropDown.dataSource = []
                    }
                    
                    if self.Details_Model.count == 0 {
                        self.empty_str?.text = "No visitors found!"
                        
                    }else{
                        self.empty_str?.text = ""
                    }
                    
                    self.visitorTable.hideActivityIndicator()
                    self.visitorTable.delegate = self
                    self.visitorTable.dataSource = self
                    self.visitorTable.reloadData()
                }
                if let err = error {
                    self.visitorTable.hideActivityIndicator()
                    self.showConfirmAlert(title: "", message: err.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                }
            }
            
        }else if  item == "Yesterday" {
            self.resetPeriod()
            let current_date = Date().dayBefore
            let date_formatter = DateFormatter()
            date_formatter.dateFormat = "yyy-MM-dd"
            let date = date_formatter.string(from: current_date)
            
            perams.updateValue(self.unit_id_list, forKey: "unit_id_list")
            perams.updateValue(user_id, forKey: "user_id")
            perams.updateValue(self.comm_id, forKey: "comm_id")
            perams.updateValue(date, forKey: "from_dt")
            perams.updateValue(date, forKey: "to_dt")
            Networking.shared.getMyVisitorByPeriodAndStatus(perams: perams) { (model, error) in
                self.visitorTable.cr.endHeaderRefresh()
                if let mode = model {
                    self.model = model
                    if let mode = mode.detail {
                        if self.fillter_2_label.text != "" {
                            self.Details_Model = mode.filter({ (details) -> Bool in
                                details.visitor_cat == self.fillter_2_label.text
                            })
                        }else{
                            self.Details_Model = mode
                        }
                    }
                    let datasource = self.Details_Model.compactMap({ $0.visitor_cat ?? "" })
                    if datasource.count != 0 {
                        var sourceYesterDay = datasource
                       sourceYesterDay = datasource.unique{$0}
                        sourceYesterDay.insert("All", at: 0)
                        self.typeDropDown.dataSource = sourceYesterDay
                    }else{
                        self.typeDropDown.dataSource = []
                    }
                    if self.Details_Model.count == 0 {
                        self.empty_str?.text = "No visitors found!"
                    }else{
                        self.empty_str?.text = ""
                    }
                    self.visitorTable.hideActivityIndicator()
                    self.visitorTable.delegate = self
                    self.visitorTable.dataSource = self
                    self.visitorTable.reloadData()
                }
                if let err = error {
                    self.visitorTable.hideActivityIndicator()
                    self.showConfirmAlert(title: "", message: err.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                }
            }
            
        }else if  item == "This Week" {
            self.resetPeriod()
             let weak_start = Date().startOfWeek
             let weak_end_data = Date().endOfWeek
            let date_formatter = DateFormatter()
            date_formatter.dateFormat = "yyy-MM-dd"
            let st_w = date_formatter.string(from: weak_start!)
            let en_w = date_formatter.string(from: weak_end_data)
            
            perams.updateValue(self.unit_id_list, forKey: "unit_id_list")
            perams.updateValue(user_id, forKey: "user_id")
            perams.updateValue(self.comm_id, forKey: "comm_id")
            perams.updateValue(st_w, forKey: "from_dt")
            perams.updateValue(en_w, forKey: "to_dt")
            
            Networking.shared.getMyVisitorByPeriodAndStatus(perams: perams) { (model, error) in
                self.visitorTable.cr.endHeaderRefresh()
                if let mode = model {
                    self.model = model
                    if let mode = mode.detail {
                        if self.fillter_2_label.text != "" {
                            self.Details_Model = mode.filter({ (details) -> Bool in
                                details.visitor_cat == self.fillter_2_label.text
                            })
                        }else{
                            self.Details_Model = mode
                        }
                    }
                    let datasource = self.Details_Model.compactMap({ $0.visitor_cat ?? "" })
                    if datasource.count != 0 {
                        var sourceThisWeal = datasource
                        sourceThisWeal = datasource.unique{$0 }
                        sourceThisWeal.insert("All", at: 0)
                        self.typeDropDown.dataSource = sourceThisWeal
                    }else{
                        self.typeDropDown.dataSource = []
                    }
                    
                    if self.Details_Model.count == 0 {
                        self.empty_str?.text = "No visitors found!"
                    }else{
                        self.empty_str?.text = ""
                    }
                    self.visitorTable.hideActivityIndicator()
                    self.visitorTable.delegate = self
                    self.visitorTable.dataSource = self
                    self.visitorTable.reloadData()
                }
                if let err = error {
                    self.visitorTable.hideActivityIndicator()
                    self.showConfirmAlert(title: "", message: err.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                }
            }
            
        }else if  item == "Period" {
            print(item)
            
            if !pullToRefresh {
                self.showPeriodContainer()
                self.visitorTable.hideActivityIndicator()
                self.visitorTable.reloadData()
                
                let startTap = UITapGestureRecognizer(target: self, action: #selector(StartClicked))
                startTap.numberOfTouchesRequired = 1
                startDateFeild.addGestureRecognizer(startTap)
                startDateFeild.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(StartClicked)))
                
                let endTap = UITapGestureRecognizer(target: self, action: #selector(EndClicked))
                endTap.numberOfTouchesRequired = 1
                endDateFeild.addGestureRecognizer(endTap)
                endDateFeild.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(EndClicked)))
                fillterBtn.addTarget(self, action: #selector(fillterClicked), for: .touchUpInside)
            }else{
                fillterClicked()
            }
            
        }
    }
    
  
    
    
    @objc func fillterClicked(){
       
        let st_w = startDateFeild.text ?? "" //"2020-09-14"//startDateFeild.text
        let en_w = endDateFeild.text ?? "" //"2020-09-19"//endDateFeild.text
        let user_id = UserDefaults.user_id
        
        if st_w.count == 0 {
            self.visitorTable.cr.endHeaderRefresh()
            self.showConfirmAlert(title: "", message: "Please choose Start Data", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else if en_w.count == 0 {
            self.visitorTable.cr.endHeaderRefresh()
            self.showConfirmAlert(title: "", message: "Please choose End Data", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else{
            self.visitorTable.delegate = nil
            self.visitorTable.dataSource = nil
            self.visitorTable.reloadData()
            self.visitorTable.showActivityIndicator()
            var perams = [String:Any]()
            perams.updateValue(self.unit_id_list, forKey: "unit_id_list")
            perams.updateValue(user_id, forKey: "user_id")
            perams.updateValue(self.comm_id, forKey: "comm_id")
            perams.updateValue(st_w, forKey: "from_dt")
            perams.updateValue(en_w, forKey: "to_dt")
            self.empty_str?.text = ""
            
            Networking.shared.getMyVisitorByPeriodAndStatus(perams: perams) { (model, error) in
                if let mode = model {
                    self.model = model
                    if let mode = mode.detail {
                        if self.fillter_2_label.text != "" && self.fillter_2_label.text != "All" {
                            self.Details_Model = mode.filter({ (details) -> Bool in                                
                                details.visitor_cat == self.fillter_2_label.text
                            })
                        }else{
                            self.Details_Model = mode
                        }
                    }
                    let datasource = self.Details_Model.compactMap({ $0.visitor_cat ?? "" })
                    if datasource.count != 0 {
                        var sourceThisWeal = datasource
                        sourceThisWeal = datasource.unique{$0 }
                        sourceThisWeal.insert("All", at: 0)
                        self.typeDropDown.dataSource = sourceThisWeal
                    }else{
                        self.typeDropDown.dataSource = []
                    }
                    
                    if self.Details_Model.count == 0 {
                        self.empty_str?.text = "No visitors found!"
                    }else{
                        self.empty_str?.text = ""
                    }
                    self.visitorTable.cr.endHeaderRefresh()
                    self.visitorTable.hideActivityIndicator()
                    self.visitorTable.delegate = self
                    self.visitorTable.dataSource = self
                    self.visitorTable.reloadData()
                }
                if let err = error {
                    self.visitorTable.cr.endHeaderRefresh()
                    self.visitorTable.hideActivityIndicator()
                    self.showConfirmAlert(title: "", message: err.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                }
            }
        }
    }
    
    @objc func StartClicked(){
        let selector = WWCalendarTimeSelector.instantiate()
        selector.delegate = self
        startEndCLicked = "Start"
        selector.optionTopPanelTitle = "Choose Date"
        self.present(selector, animated: true, completion: nil)
    }
    
    @objc func EndClicked(){
        let selector = WWCalendarTimeSelector.instantiate()
        selector.delegate = self
        startEndCLicked = "End"
        selector.optionTopPanelTitle = "Choose Date"
        self.present(selector, animated: true, completion: nil)
    }
    
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        let dateString = date.toString(dateFormat: "yyy-MM-dd")
        if startEndCLicked == "Start" {
            startDateFeild.text = dateString
        }else{
            endDateFeild.text = dateString
        }
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func fillter_1_click() {
        print("Fillter")
        dropDown.show()
    }
    
    @objc func fillter_2_click() {
        print("Fillter_2")
        typeDropDown.show()
    }
    
    func resetPeriod(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.periodContainer.alpha = 0
            self.startDateFeild.alpha = 0
            self.endDateFeild.alpha = 0
            self.startDateFeild.text = ""
            self.endDateFeild.text = ""
            self.fillterBtn.alpha = 0
            self.heightConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    func showPeriodContainer(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.periodContainer.alpha = 1.0
            self.startDateFeild.alpha = 1.0
            self.endDateFeild.alpha = 1.0
            
//            self.startDateFeild.text = ""
//            self.endDateFeild.text = ""
            
            self.fillterBtn.alpha = 1.0
            self.heightConstraint.constant = 100
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    @objc func tapProfile(sender:UITapGestureRecognizer){
        guard let index = sender.view?.tag else { return }
        guard let cell = visitorTable.cellForRow(at: IndexPath(row: index, section: 0)) as? VisitoControllerCell else { return }
        guard let icon = cell.person_image?.image else { return }
        let imageInfo   = GSImageInfo(image: icon, imageMode: .aspectFit)
        let transitionInfo = GSTransitionInfo(fromView: cell.person_image)
        let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        self.present(imageViewer, animated: true, completion: nil)
    }
}


extension TodaysVisitorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Details_Model.count != 0 {
            return Details_Model.count
        }else {
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VisitorControllerCell", for: indexPath) as!  VisitoControllerCell
        
        cell.person_image.isUserInteractionEnabled = true
        cell.person_image.tag = indexPath.row
        cell.person_image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapProfile(sender:))))
        
        
        
        if let data = Details_Model[safe:indexPath.row] {
            
            if let urlStr = data.visitor_img_url {
                let url_st = EndPoint.imageURL+urlStr
                guard let urlString = url_st.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return cell }
                let url = URL(string: urlString)
                cell.person_image.kf.indicatorType = .activity
                cell.person_image.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "proflie_icon"),
                    options: [
                        .transition(.fade(1)),                        
                    ], completionHandler:
                        {
                            result in
                            switch result {
                            case .success(let value):
                                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                            case .failure(let error):
                                print("Job failed: \(error.localizedDescription)")
                            }
                        })
            }else{
                cell.person_image.image = UIImage(named: "proflie_icon")
            }
            
            cell.name.text = data.visitor_name
            cell.visitorCatagory.text = data.visitor_cat?.uppercased()
            cell.visitorCatagory.textColor = brandColor()
            
            if data.visitor_org == "" {
                cell.catagoryOrf.text = data.visitor_sub_cat
            }else{
                cell.catagoryOrf.text = data.visitor_org
            }
            if let time = data.in_time,  time != "" {
                cell.inDate.text = timeConversion12(time24: time)
            }
            if let time = data.out_time,  time != "" {
                cell.outDate.text = timeConversion12(time24: time)
            }
            if data.visitor_cat == "Daily Helper" {
                cell.catagoryOrf.text = data.visitor_sub_cat
                cell.catagory_image.image = UIImage(named: "people_Black")
            }else if data.visitor_cat == "Cab" {
                cell.catagoryOrf.text = data.visitor_sub_cat
                cell.catagory_image.image = UIImage(named: "Cab_Black")
            }else if data.visitor_cat == "Guest" {
                cell.catagoryOrf.text = data.visitor_sub_cat
                cell.catagory_image.image = UIImage(named: "faceIconBlack")
            }else if data.visitor_cat == "Delivery" {
                cell.catagoryOrf.text = data.visitor_sub_cat
                cell.catagory_image.image = UIImage(named: "shopping_cartBlack")
            }else if data.visitor_cat == "Vendor" {
                cell.catagoryOrf.text = data.visitor_sub_cat
                cell.catagory_image.image = UIImage(named: "build_icon_black")
            }else{
                cell.catagoryOrf.text = data.visitor_sub_cat
                cell.catagory_image.image = UIImage(named: "person_icon")
            }
            
            
            if data.visitor_status == "Waiting" {
                cell.withConstraint.constant = 83
                cell.setupColor(UIColor(hex: "#FBB35E"),data.visitor_status ?? "")
            }else if data.visitor_status == "Inside" {
                cell.withConstraint.constant = 83
                cell.setupColor(UIColor(hex: "#27AE60"),data.visitor_status ?? "")
            }else if data.visitor_status == "Left" {
                cell.withConstraint.constant = 83
                cell.setupColor(UIColor(hex: "#E0E0E0"),data.visitor_status ?? "")
            }else if data.visitor_status == "Not Allowed" {
                cell.withConstraint.constant = 110
                cell.setupColor(UIColor(hex: "#E0E0E0"),data.visitor_status ?? "")
            }
            
            
            var str_data = [String]()
            if let approv = data.approvals {
                for i in approv {
                    var str = ""
                    if let name = i.approved_by {
                        str = name
                    }
                    if let name = i.approval_status {
                        str = str+" - "+name
                    }
                    if let name = i.approval_mode {
                        str = str+" - "+name
                    }
                    if let name = i.denied_due_to {
                        str = str+" - "+name
                    }
                    str_data.append(str)
                }
            }
            if data.visitor_type != "normal" {
                cell.passData(stArr: [data.visitor_type ?? ""], type: "")
            }else{
                cell.passData(stArr: str_data, type: "normal")
            }
        }                        
        cell.telephoneBtn.setImage(UIImage(named: "telephone_icon")?.imageWithColor(color1: brandColor()), for: .normal)
        cell.telephoneBtn.isUserInteractionEnabled = false        
        cell.telephonecontainer.tag = indexPath.row
        cell.telephonecontainer.addTarget(self, action: #selector(phoneCall(_:)), for: .touchUpInside)
        
        return cell
    }
    
    
    @objc func phoneCall(_ view: MDCCard){
        let index = view.tag
        if let phoe = Details_Model[safe:index]?.visitor_phone {
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
        var approv = [Approvals]()
        if let data = Details_Model[safe:indexPath.row] {
            if let app = data.approvals {
                approv = app
            }
            if data.visitor_type != "normal" {
                return 125+20
            }else{
                let height = CGFloat(approv.count*20)
                return height+125
            }
        }
        let height = CGFloat(approv.count*20)
        return height+125
    }
    
    func timeConversion12(time24:String)->String {
        if let date = dateFromString(dateString: time24) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyy hh:mm a"
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
    
    func calculateHeight(inString:String) -> CGFloat{
        let messageString = inString
        let attributes = [NSAttributedString.Key.font:
            UIFont(name: "Helvetica-Bold", size: 15.0)!,
                          NSAttributedString.Key.foregroundColor: UIColor.white] as [NSAttributedString.Key: Any]
        let attributedString : NSAttributedString = NSAttributedString(string: messageString, attributes: attributes)
        
        let rect : CGRect = attributedString.boundingRect(with: CGSize(width: 222.0, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        let requredSize:CGRect = rect
        return requredSize.height
    }
}


extension Array {
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }

        return arrayOrdered
    }
}
