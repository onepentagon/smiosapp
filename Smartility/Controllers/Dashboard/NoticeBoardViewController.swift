//
//  NoticeBoardViewController.swift
//  Smartility
//
//  Created by Mani on 12/9/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import GSImageViewerController
import Alamofire

class NoticeBoardViewController: UIViewController{
    
    @IBOutlet weak var menuHeight: NSLayoutConstraint!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var segmentedControl: ScrollableSegmentedControl!
    @IBOutlet weak var noticeBoardTable: UITableView!
    @IBOutlet weak var backView: UIView!
    
    var status = NoticeBoardStatus.active
    var expiredModel: [NoticeExpiredModel]?
    var emptyLabel: UILabel?
    var expandFlag: [Bool] = []
    var expandFlag_new: [Int:Bool] = [:]
    var modelData = ["Image Attachments":[documentModel](),"Other Attachments":[documentModel]()]
    //    var selectedIndexPath: IndexPath?
    
    var currentPage: Int = 1
    var isLoading = false
    
    var draftSelectedIndexPath: IndexPath?
    var activeSelectedIndexPath: IndexPath?
    var expiredSelectedIndexPath: IndexPath?
    
    var noticeTitle = [String:String]()
    var noticeIndex = Int()
    var floatingBtn: CustomButton?
    var lastContentOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backView.setClickListener {
            self.navigationController?.popViewController(animated: true)
        }
        
        self.view.bringSubviewToFront(menuView)
        menuView.backgroundColor = .white
        menuView.layer.shadowColor = UIColor(red: 0.049, green: 0.019, blue: 0.167, alpha: 0.2).cgColor
        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowRadius = 1
        menuView.layer.shadowOffset = CGSize(width: 0, height: 1)
        
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
                menuHeight.constant = 120
            }
        }else{
            menuHeight.constant = 120
        }
        
        floatingBtn = CustomButton()
        floatingBtn?.setImage(UIImage(named: "PlusBtn"), for: .normal)
        
        floatingBtn?.mk_addTapHandler(action: { (btn) in
            let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: CreateNoticeController.self)
            controller.boolUpdate = false
            self.navigationController?.pushViewController(controller, animated: true)
        })
        
        
        if UserDefaults.isAdmin != 0 {
            floatingBtn?.isHidden = false
        }else{
            floatingBtn?.isHidden = true
        }
        
        view.addSubview(floatingBtn!)
        floatingBtn?.layoutAnchor(top: nil, left: nil, bottom: self.view.bottomAnchor, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 10, width: 60, height: 60, enableInsets: true)
        getTopWindow()?.bringSubviewToFront(floatingBtn!)
        
        segmentedControl.segmentStyle = .textOnly
        segmentedControl.underlineHeight = 1.5
        
        if UserDefaults.isAdmin == 0 {
            self.segmentedControl.insertSegment(withTitle: noticeTitle["Active"], image: nil, at: 0)
            self.segmentedControl.insertSegment(withTitle: noticeTitle["Expired"], image: nil, at: 1)
        }else{
            self.segmentedControl.insertSegment(withTitle: noticeTitle["Active"], image: nil, at: 0)
            self.segmentedControl.insertSegment(withTitle: noticeTitle["Expired"], image: nil, at: 1)
            self.segmentedControl.insertSegment(withTitle: noticeTitle["Draft"], image: nil, at: 2)
        }
        
        
        segmentedControl.underlineSelected = true
        
        segmentedControl.addTarget(self, action: #selector(self.segmentSelected(sender:)), for: .valueChanged)
        segmentedControl.segmentContentColor = .black
        segmentedControl.selectedSegmentContentColor = brandColor()
        segmentedControl.tintColor = accentColor()
        segmentedControl.backgroundColor = UIColor.clear
        segmentedControl.fixedSegmentWidth = true
        segmentedControl.selectedSegmentIndex = noticeIndex
        
        noticeBoardTable.delegate = self
        noticeBoardTable.dataSource = self
        noticeBoardTable.tableFooterView = UIView()        
        
        self.noticeBoardTable.rowHeight = UITableView.automaticDimension;
        self.noticeBoardTable.estimatedRowHeight = 44.0; // set to whatever your "average" cell height is
        
        
        emptyLabel = UILabel()
        emptyLabel?.textColor = UIColor.gray
        emptyLabel?.numberOfLines = 0;
        emptyLabel?.textAlignment = .center;
        emptyLabel?.font = UIFont(name: "SFUIText-Regular", size: 17)
        emptyLabel?.sizeToFit()
        view.addSubview(emptyLabel!)
        emptyLabel?.layoutAnchor(top: noticeBoardTable.topAnchor, left: noticeBoardTable.leftAnchor, bottom: nil, right: noticeBoardTable.rightAnchor, centerX: nil, centerY: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.UpdateNotice), name: NSNotification.Name("updateNotice"), object: nil)
    }
    @objc func backClicked(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    @objc func segmentSelected(sender:ScrollableSegmentedControl) {
        print("Segment at index \(sender.selectedSegmentIndex)  selected")
        self.modelData["Image Attachments"]?.removeAll()
        self.modelData["Other Attachments"]?.removeAll()
        self.expiredModel = nil
        
        emptyLabel?.text = ""
        noticeBoardTable.delegate = nil
        noticeBoardTable.dataSource = nil
        noticeBoardTable.reloadData()
        self.noticeBoardTable.showActivityIndicator()
        
        switch sender.selectedSegmentIndex {
        case 0:
            status = NoticeBoardStatus.active
            if let path = activeSelectedIndexPath {
                activeSelectedIndexPath = path
                UpdateNotice(index: path.row)
            }else{
                activeSelectedIndexPath = IndexPath(row: 0, section: 0)
                UpdateNotice(index: 0)
            }
        case 1:
            status = NoticeBoardStatus.expired
            if let path = expiredSelectedIndexPath {
                expiredSelectedIndexPath = path
                UpdateNotice(index: path.row)
            }else{
                expiredSelectedIndexPath = IndexPath(row: 0, section: 0)
                UpdateNotice(index: 0)
            }
        case 2:
            status = NoticeBoardStatus.drafts
            if let path = draftSelectedIndexPath {
                draftSelectedIndexPath = path
                UpdateNotice(index: path.row)
            }else{
                draftSelectedIndexPath = IndexPath(row: 0, section: 0)
                UpdateNotice(index: 0)
            }
        default:
            status = NoticeBoardStatus.active
            if let path = activeSelectedIndexPath {
                activeSelectedIndexPath = path
                UpdateNotice(index: path.row)
            }else{
                activeSelectedIndexPath = IndexPath(row: 0, section: 0)
                UpdateNotice(index: 0)
            }
        }
    }
    
    @objc
    func UpdateNotice(index:Int){
        var params = [String:Any]()
        params.updateValue(community.community_id, forKey: "comm_id")
        params.updateValue(UserDefaults.user_id, forKey: "user_id")
        params.updateValue(status.rawValue, forKey: "notice_status")
        params.updateValue(10, forKey: "rec_per_page")
        
        Networking.shared.getNoticesByCommIdAndStatus(perams: params) { (model, error) in
            if let succes = model {
                self.expandFlag.removeAll()
                for _ in succes {
                    self.expandFlag.append(false)
                }
                self.expiredModel = succes
                self.noticeBoardTable.delegate = self
                self.noticeBoardTable.dataSource = self
                self.noticeBoardTable.reloadData()
                self.cellDocumentExpand(index: index)
                //self.noticeBoardTable.reloadData()
                self.noticeBoardTable.hideActivityIndicator()
            }else{
                self.expandFlag.removeAll()
                self.noticeBoardTable.delegate = self
                self.noticeBoardTable.dataSource = self
                self.noticeBoardTable.reloadData()
                self.noticeBoardTable.hideActivityIndicator()
            }
        }
    }
    
}

extension NoticeBoardViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch status {
        case .active:
            if let count = expiredModel?.count, count != 0 {
                emptyLabel?.text = ""
                return count
            }
            UIView.transition(with: emptyLabel!,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                self?.emptyLabel!.text = "No active notices"
                              }, completion: nil)
            
            
            return 0
        case .expired:
            if let count = expiredModel?.count, count != 0 {
                emptyLabel?.text = ""
                return count
            }
            UIView.transition(with: emptyLabel!,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                self?.emptyLabel?.text = "No expired notices"
                              }, completion: nil)
            
            
            return 0
        case .drafts:
            if let count = expiredModel?.count, count != 0 {
                emptyLabel?.text = ""
                return count
            }
            UIView.transition(with: emptyLabel!,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                self?.emptyLabel?.text = "No drafts notices"
                              }, completion: nil)
            
            
            return 0
        }
    }
    
    
    @objc func cellTapped(sender: UITapGestureRecognizer){
        guard let index = sender.view?.tag else { return }
        //        expandFlag[index] ? (expandFlag[index] = false) : (expandFlag[index] = true)
        self.modelData["Image Attachments"]?.removeAll()
        self.modelData["Other Attachments"]?.removeAll()
        
        switch status {
        case .active:
            if activeSelectedIndexPath == IndexPath(row: index, section: 0) {
                activeSelectedIndexPath = nil
                noticeBoardTable.reloadData()
            }else{
                activeSelectedIndexPath = IndexPath(row: index, section: 0)
                cellDocumentExpand(index: index)
            }
        case .drafts:
            if draftSelectedIndexPath == IndexPath(row: index, section: 0) {
                draftSelectedIndexPath = nil
                noticeBoardTable.reloadData()
            }else{
                draftSelectedIndexPath = IndexPath(row: index, section: 0)
                cellDocumentExpand(index: index)
            }
        case .expired:
            if expiredSelectedIndexPath == IndexPath(row: index, section: 0) {
                expiredSelectedIndexPath = nil
                noticeBoardTable.reloadData()
            }else{
                expiredSelectedIndexPath = IndexPath(row: index, section: 0)
                cellDocumentExpand(index: index)
            }
        }
        
        //        if expandFlag[index] == true {
        //            expandFlag[index] = false
        //            noticeBoardTable.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        //        }else{
        //            expandFlag[index] = true
        //        }
    }
    
    
    @objc
    func notice_publish(_ sender:UIButton){
        let index = sender.tag
        var peram = [String:Any]()
        peram.updateValue(expiredModel?[index].ad_by ?? "", forKey: "ad_by")
        peram.updateValue(expiredModel?[index].app_by ?? "", forKey: "app_by")
        peram.updateValue(expiredModel?[index].app_dt ?? "", forKey: "app_dt")
        peram.updateValue(expiredModel?[index].comm_id ?? "", forKey: "comm_id")
        peram.updateValue(expiredModel?[index].cust_name ?? "", forKey: "cust_name")
        peram.updateValue(expiredModel?[index].expiry_dt ?? "", forKey: "expiry_dt")
        peram.updateValue(expiredModel?[index].is_ad ?? "", forKey: "is_ad")
        peram.updateValue(expiredModel?[index].notice_dt ?? "", forKey: "notice_dt")
        peram.updateValue(expiredModel?[index].notice_id ?? "", forKey: "notice_id")
        peram.updateValue(expiredModel?[index].notice_status ?? "", forKey: "notice_status")
        peram.updateValue(expiredModel?[index].notice_text ?? "", forKey: "notice_text")
        peram.updateValue(expiredModel?[index].notice_title ?? "", forKey: "notice_title")
        peram.updateValue(expiredModel?[index].role_name ?? "", forKey: "role_name")
        peram.updateValue(expiredModel?[index].user_id ?? "", forKey: "user_id")
        var doc = [documentUpdateModel]()
        
        let otherAlert = UIAlertController(title: "Publish", message: "Sure, you want to publish \(expiredModel?[index].notice_title ?? "") ", preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.modelData["Image Attachments"]?.removeAll()
            self.modelData["Other Attachments"]?.removeAll()
            
            if let noticeID = self.expiredModel?[index].notice_id {
                SpinnerClass.shared.createSpinnerView(controller: self)
                Networking.shared.getAttachmentByNoticeId(perams: ["notice_id": noticeID,"user_id":UserDefaults.user_id,"comm_id":community.community_id]) { (model, error) in
                    if let array = model, array.count != 0 {
                        for i in 0..<array.count {
                            if let arrayData = array[i] as? [String:Any] {
                                let fileURL = arrayData["file_url"] as? String ?? ""
                                if let range = fileURL.range(of: "/", options: .backwards)  {
                                    let extensionValue = fileURL[range.upperBound...]
                                    doc.append(documentUpdateModel(file_url: fileURL, file_name: String(extensionValue), is_selected: true, is_changed: true))
                                }
                            }
                        }
                    }
                    
                    if doc.count != 0 {
                        do {
                            let jsonData = try JSONEncoder().encode(doc)
                            let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
                            peram.updateValue(json, forKey: "files")
                        } catch { print(error) }
                    }else{
                        peram.updateValue(doc, forKey: "files")
                    }
                    
                    Networking.shared.notice_publish(perams: peram) { (status, error) in
                        if status != nil {
                            
                            var params = [String:Any]()
                            params.updateValue(community.community_id, forKey: "comm_id")
                            params.updateValue(UserDefaults.user_id, forKey: "user_id")
                            
                            let dispatch = DispatchGroup()
                            dispatch.enter()
                            params.updateValue("active", forKey: "notice_status")
                            Networking.shared.getTotalNoticesByStatus(perams: params) { (model, error) in
                                if let succes = model, let countArra = succes[0] as? [String:Any],let count = countArra["total"] as? Int {
                                    self.activeSelectedIndexPath = nil
                                    self.segmentedControl.removeSegment(at: 0)
                                    self.segmentedControl.insertSegment(withTitle: "Active (\(count))", image: nil, at: 0)
                                    self.segmentedControl.selectedSegmentIndex = 0
                                    dispatch.leave()
                                }
                            }
                            
                            dispatch.enter()
                            params.updateValue("drafts", forKey: "notice_status")
                            Networking.shared.getTotalNoticesByStatus(perams: params) { (model, error) in
                                if let succes = model,let countArra = succes[0] as? [String:Any],let count = countArra["total"] as? Int {
                                    self.draftSelectedIndexPath = nil
                                    self.segmentedControl.removeSegment(at: 2)
                                    self.segmentedControl.insertSegment(withTitle: "Draft (\(count))", image: nil, at: 2)
                                    dispatch.leave()
                                }
                            }
                            
                            dispatch.notify(queue: .main) {
                                NotificationCenter.default.post(name: NSNotification.Name("UpdateActions"), object: nil)
                                self.showConfirmAlert(title: "", message: "Notice published successfully", buttonTitle: "Ok", buttonStyle: .default) {_ in
                                    SpinnerClass.shared.removeActivityIndicator()
                                }
                            }
                        }else{
                            SpinnerClass.shared.removeActivityIndicator()
                            self.showConfirmAlert(title: "", message: error?.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                        }
                    }
                    if let error = error {
                        self.showConfirmAlert(title: "", message: error.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                    }
                }
            }
            
        }
        let CanceAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        otherAlert.addAction(OkAction)
        otherAlert.addAction(CanceAction)
        self.present(otherAlert, animated: true, completion: nil)
    }
    
    @objc
    func deleteBtn(_ sender:UIButton){
        let index = sender.tag
        self.modelData["Image Attachments"]?.removeAll()
        self.modelData["Other Attachments"]?.removeAll()
        var peram = [String:Any]()
        
        peram.updateValue(expiredModel?[index].ad_by ?? "", forKey: "ad_by")
        peram.updateValue(expiredModel?[index].app_by ?? "", forKey: "app_by")
        peram.updateValue(expiredModel?[index].app_dt ?? "", forKey: "app_dt")
        peram.updateValue(expiredModel?[index].comm_id ?? "", forKey: "comm_id")
        peram.updateValue(expiredModel?[index].cust_name ?? "", forKey: "cust_name")
        peram.updateValue(expiredModel?[index].expiry_dt ?? "", forKey: "expiry_dt")
        peram.updateValue(expiredModel?[index].is_ad ?? "", forKey: "is_ad")
        peram.updateValue(expiredModel?[index].notice_dt ?? "", forKey: "notice_dt")
        peram.updateValue(expiredModel?[index].notice_id ?? "", forKey: "notice_id")
        peram.updateValue(expiredModel?[index].notice_status ?? "", forKey: "notice_status")
        peram.updateValue(expiredModel?[index].notice_text ?? "", forKey: "notice_text")
        peram.updateValue(expiredModel?[index].notice_title ?? "", forKey: "notice_title")
        peram.updateValue(expiredModel?[index].role_name ?? "", forKey: "role_name")
        peram.updateValue(UserDefaults.user_id, forKey: "user_id")
        
        var doc = [documentUpdateModel]()
        let otherAlert = UIAlertController(title: "Delete", message: "Sure, you want to delete the notice \(expiredModel?[index].notice_title ?? "") ", preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            if let noticeID = self.expiredModel?[index].notice_id {
                SpinnerClass.shared.createSpinnerView(controller: self)
                Networking.shared.getAttachmentByNoticeId(perams: ["notice_id": noticeID,"user_id":UserDefaults.user_id,"comm_id":community.community_id]) { (model, error) in
                    if let array = model, array.count != 0 {
                        for i in 0..<array.count {
                            if let arrayData = array[i] as? [String:Any] {
                                let fileURL = arrayData["file_url"] as? String ?? ""
                                if let range = fileURL.range(of: "/", options: .backwards)  {
                                    let extensionValue = fileURL[range.upperBound...]
                                    doc.append(documentUpdateModel(file_url: fileURL, file_name: String(extensionValue), is_selected: false, is_changed: true))
                                }
                            }
                        }
                    }
                    
                    if doc.count != 0 {
                        do {
                            let jsonData = try JSONEncoder().encode(doc)
                            let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
                            peram.updateValue(json, forKey: "files")
                        } catch { print(error) }
                    }else{
                        peram.updateValue(doc, forKey: "files")
                    }
                    
                    
                    Networking.shared.notice_delete(perams: peram) { (status, error) in
                        if status != nil {
                            SpinnerClass.shared.removeActivityIndicator()
                            var params = [String:Any]()
                            params.updateValue(community.community_id, forKey: "comm_id")
                            params.updateValue(UserDefaults.user_id, forKey: "user_id")
                            switch self.status {
                            case .active:
                                self.activeSelectedIndexPath = nil
                                params.updateValue("active", forKey: "notice_status")
                                Networking.shared.getTotalNoticesByStatus(perams: params) { (model, error) in
                                    if let succes = model,let countArra = succes[0] as? [String:Any],let count = countArra["total"] as? Int {
                                        self.segmentedControl.removeSegment(at: 0)
                                        self.segmentedControl.insertSegment(withTitle: "Active (\(count))", at: 0)
                                        self.segmentedControl.selectedSegmentIndex = 0
                                    }
                                }
                            case .drafts:
                                self.draftSelectedIndexPath = nil
                                params.updateValue("drafts", forKey: "notice_status")
                                Networking.shared.getTotalNoticesByStatus(perams: params) { (model, error) in
                                    if let succes = model,let countArra = succes[0] as? [String:Any],let count = countArra["total"] as? Int {
                                        self.segmentedControl.removeSegment(at: 2)
                                        self.segmentedControl.insertSegment(withTitle: "Draft (\(count))", at: 2)
                                        self.segmentedControl.selectedSegmentIndex = 2
                                    }
                                }
                            case .expired:
                                self.expiredSelectedIndexPath = nil
                            }
                            
                            self.UpdateNotice(index:0)
                        }else{
                            SpinnerClass.shared.removeActivityIndicator()
                            self.showConfirmAlert(title: "", message: error?.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                        }
                        
                    }
                }
            }
        }
        
        let CanceAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        otherAlert.addAction(OkAction)
        otherAlert.addAction(CanceAction)
        self.present(otherAlert, animated: true, completion: nil)
        
    }
    @objc
    func redirectToEdite(_ sender:UIButton){
        let index = sender.tag
        var doc = [documentUpdateModel]()
        if let noticeID = self.expiredModel?[index].notice_id {
            Networking.shared.getAttachmentByNoticeId(perams: ["notice_id": noticeID,"user_id":UserDefaults.user_id,"comm_id":community.community_id]) { (model, error) in
                if let array = model, array.count != 0 {
                    for i in 0..<array.count {
                        if let arrayData = array[i] as? [String:Any] {
                            let fileURL = arrayData["file_url"] as? String ?? ""
                            if let range = fileURL.range(of: "/", options: .backwards)  {
                                let extensionValue = fileURL[range.upperBound...]
                                doc.append(documentUpdateModel(file_url: fileURL, file_name: String(extensionValue), is_selected: false, is_changed: true))
                            }
                        }
                    }
                }
                let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: CreateNoticeController.self)
                controller.boolUpdate = true
                controller.expiredModel = self.expiredModel?[index]
                
                var docUpdated = [documentUpdateModel]()
                docUpdated = doc
                
                for i in 0..<docUpdated.count {
                    docUpdated[i].is_selected = true
                    docUpdated[i].is_changed = false
                }
                controller.doc = docUpdated
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpiryTableViewCell", for: indexPath) as? ExpiryTableViewCell
        cell?.stackEdit.constant = 0
        let ExpiredData = expiredModel?[indexPath.row]
        cell?.imagePDFDelegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        tap.numberOfTouchesRequired = 1
        cell?.tag = indexPath.row
        cell?.isUserInteractionEnabled = true
        cell?.tapContainer.tag = indexPath.row
        cell?.tapContainer.addGestureRecognizer(tap)
        cell?.adLabel.textColor = brandColor()
        //            cell?.addGestureRecognizer(tap)
        
        cell?.expiredBtn.isUserInteractionEnabled = false
        cell?.startDate.isUserInteractionEnabled = false
        
        cell?.provideLabel.textColor = brandColor()
        
        transitionForAny(type: cell?.noticeTitleLabel, data: ExpiredData?.notice_title)
        let concatinate = "by "+(ExpiredData?.cust_name ?? "")+" (\(ExpiredData?.role_name ?? ""))"
        transitionForAny(type: cell?.provideLabel, data: concatinate)
        
        cell?.deleteBtn.isUserInteractionEnabled = true
        cell?.deleteBtn.tag = indexPath.row
        cell?.deleteBtn.addTarget(self, action: #selector(deleteBtn), for: .touchUpInside)
        
        cell?.editeBtn.isUserInteractionEnabled = true
        cell?.editeBtn.tag = indexPath.row
        cell?.editeBtn.addTarget(self, action: #selector(redirectToEdite), for: .touchUpInside)
        
        cell?.publishBtn.isUserInteractionEnabled = true
        cell?.publishBtn.tag = indexPath.row
        cell?.publishBtn.addTarget(self, action: #selector(notice_publish), for: .touchUpInside)
        
        if let noticeDate = ExpiredData?.notice_dt {
            let noticeD = timeConversion12(time24: noticeDate)
            cell?.startDate.setTitle("\(noticeD)", for: .normal)
        }
        
        switch status {
        case .active:
            
            if let expired = ExpiredData?.expiry_dt {
                let exp = timeConversion12(time24: expired)
                cell?.expiredBtn.setTitle("Expires \(exp)", for: .normal)
            }
            
            if activeSelectedIndexPath != indexPath {
                cell?.arrow.image = UIImage(named: "Right_arrow-1")?.imageWithColor(color1: .lightGray)
                
                cell?.noticeDescriptionLabel.text = ""
                cell?.tableHeight.constant = 0
                cell?.modelData = nil
                cell?.modelData?.removeAll()
                cell?.documentTable.alpha = 0
                
                cell?.publishBtn.isHidden = true
                cell?.stackEdit.constant = 0
                
                cell?.documentTable.delegate = nil
                cell?.documentTable.dataSource = nil
                cell?.documentTable.reloadData()
                
            }else{
                cell?.documentTable.alpha = 1
                cell?.modelData?.removeAll()
                
                if self.modelData["Image Attachments"]?.count != 0 && self.modelData["Other Attachments"]?.count != 0 {
                    let imageCount = self.modelData["Image Attachments"]?.count ?? 0
                    let otherCount = self.modelData["Other Attachments"]?.count ?? 0
                    cell?.tableHeight.constant = CGFloat(50+(imageCount*100)+(otherCount*35))
                }else if self.modelData["Image Attachments"]?.count != 0 {
                    let imageCount = self.modelData["Image Attachments"]?.count ?? 0
                    cell?.tableHeight.constant = CGFloat(25+(imageCount*100))
                }else if self.modelData["Other Attachments"]?.count != 0 {
                    let otherCount = self.modelData["Other Attachments"]?.count ?? 0
                    cell?.tableHeight.constant = CGFloat(10+(otherCount*20))
                }else{
                    cell?.tableHeight.constant = 0
                }
                
                cell?.cellData(modelData: self.modelData)
                cell?.arrow.image = UIImage(named: "dropDown")?.imageWithColor(color1: .lightGray)
                cell?.noticeDescriptionLabel.text = ExpiredData?.notice_text?.htmlToString
                
                switch status {
                case .active:
                    if UserDefaults.isAdmin == 1 {
                        cell?.publishBtn.isHidden = true
                        cell?.stackEdit.constant = 24
                    }else{
                        cell?.publishBtn.isHidden = true
                        cell?.stackEdit.constant = 0
                    }
                case .drafts:
                    if UserDefaults.isAdmin == 1 {
                        cell?.publishBtn.isHidden = false
                        cell?.stackEdit.constant = 24
                    }else{
                        cell?.publishBtn.isHidden = false
                        cell?.stackEdit.constant = 0
                    }
                case .expired:
                    cell?.publishBtn.isHidden = true
                    cell?.stackEdit.constant = 0
                }
            }
        case .drafts:
            
            if let expired = ExpiredData?.expiry_dt {
                let exp = timeConversion12(time24: expired)
                cell?.expiredBtn.setTitle("Expires \(exp)", for: .normal)
            }
            
            if draftSelectedIndexPath != indexPath {
                cell?.arrow.image = UIImage(named: "Right_arrow-1")?.imageWithColor(color1: .lightGray)
                
                cell?.noticeDescriptionLabel.text = ""
                cell?.tableHeight.constant = 0
                cell?.modelData = nil
                cell?.modelData?.removeAll()
                cell?.documentTable.alpha = 0
                cell?.documentTable.delegate = nil
                cell?.documentTable.dataSource = nil
                cell?.documentTable.reloadData()
                
                cell?.publishBtn.isHidden = true
                cell?.stackEdit.constant = 0
                
            }else{
                cell?.documentTable.alpha = 1
                cell?.modelData?.removeAll()
                
                if self.modelData["Image Attachments"]?.count != 0 && self.modelData["Other Attachments"]?.count != 0 {
                    let imageCount = self.modelData["Image Attachments"]?.count ?? 0
                    let otherCount = self.modelData["Other Attachments"]?.count ?? 0
                    cell?.tableHeight.constant = CGFloat(50+(imageCount*100)+(otherCount*35))
                }else if self.modelData["Image Attachments"]?.count != 0 {
                    let imageCount = self.modelData["Image Attachments"]?.count ?? 0
                    cell?.tableHeight.constant = CGFloat((imageCount*100))
                }else if self.modelData["Other Attachments"]?.count != 0 {
                    let otherCount = self.modelData["Other Attachments"]?.count ?? 0
                    cell?.tableHeight.constant = CGFloat(10+(otherCount*20))
                }else{
                    cell?.tableHeight.constant = 0
                }
                
                switch status {
                case .active:
                    cell?.publishBtn.isHidden = true
                    cell?.stackEdit.constant = 24
                case .drafts:
                    cell?.publishBtn.isHidden = false
                    cell?.stackEdit.constant = 24
                case .expired:
                    cell?.publishBtn.isHidden = true
                    cell?.stackEdit.constant = 0
                }
                
                cell?.cellData(modelData: self.modelData)
                cell?.arrow.image = UIImage(named: "dropDown")?.imageWithColor(color1: .lightGray)
                cell?.noticeDescriptionLabel.text = ExpiredData?.notice_text?.htmlToString
            }
        case .expired:
            if let expired = ExpiredData?.expiry_dt {
                let exp = timeConversion12(time24: expired)
                cell?.expiredBtn.setTitle("Expired \(exp)", for: .normal)
            }
            if expiredSelectedIndexPath != indexPath {
                cell?.arrow.image = UIImage(named: "Right_arrow-1")?.imageWithColor(color1: .lightGray)
                
                cell?.noticeDescriptionLabel.text = ""
                cell?.tableHeight.constant = 0
                cell?.modelData = nil
                cell?.modelData?.removeAll()
                cell?.documentTable.alpha = 0
                cell?.documentTable.delegate = nil
                cell?.documentTable.dataSource = nil
                cell?.documentTable.reloadData()
                
                cell?.publishBtn.isHidden = true
                cell?.stackEdit.constant = 0
                
            }else{
                cell?.documentTable.alpha = 1
                cell?.modelData?.removeAll()
                
                if self.modelData["Image Attachments"]?.count != 0 && self.modelData["Other Attachments"]?.count != 0 {
                    let imageCount = self.modelData["Image Attachments"]?.count ?? 0
                    let otherCount = self.modelData["Other Attachments"]?.count ?? 0
                    cell?.tableHeight.constant = CGFloat(50+(imageCount*100)+(otherCount*35))
                }else if self.modelData["Image Attachments"]?.count != 0 {
                    let imageCount = self.modelData["Image Attachments"]?.count ?? 0
                    cell?.tableHeight.constant = CGFloat((imageCount*100))
                }else if self.modelData["Other Attachments"]?.count != 0 {
                    let otherCount = self.modelData["Other Attachments"]?.count ?? 0
                    cell?.tableHeight.constant = CGFloat(10+(otherCount*20))
                }else{
                    cell?.tableHeight.constant = 0
                }
                
                switch status {
                case .active:
                    cell?.publishBtn.isHidden = true
                    cell?.stackEdit.constant = 24
                case .drafts:
                    cell?.publishBtn.isHidden = false
                    cell?.stackEdit.constant = 24
                case .expired:
                    cell?.publishBtn.isHidden = true
                    cell?.stackEdit.constant = 0
                }
                
                cell?.cellData(modelData: self.modelData)
                cell?.arrow.image = UIImage(named: "dropDown")?.imageWithColor(color1: .lightGray)
                
                //                if let data = ExpiredData?.notice_text?.data(using: .utf8) {
                //                    let attributedString = try? NSAttributedString(
                //                        data: data,
                //                        options: [.documentType: NSAttributedString.DocumentType.html],
                //                        documentAttributes: nil)
                //                    cell?.noticeDescriptionLabel.attributedText = attributedString
                //                }
                cell?.noticeDescriptionLabel.text = ExpiredData?.notice_text?.htmlToString
            }
            
        }
        
        if ExpiredData?.is_ad == 0 {
            cell?.adLabel.alpha = 0
        }else{
            cell?.adLabel.alpha = 1
        }
        
        return cell!
    }    
    
    
    func cellDocumentExpand(index: Int){
        if let noticeID = expiredModel?[safe: index]?.notice_id {
            Networking.shared.getAttachmentByNoticeId(perams: ["notice_id": noticeID,"user_id":UserDefaults.user_id,"comm_id":community.community_id]) { (model, error) in
                if let array = model, array.count != 0 {
                    for i in 0..<array.count {
                        if let arrayData = array[i] as? [String:Any] {
                            let fileURL = arrayData["file_url"] as? String ?? ""
                            let notice_id = arrayData["notice_id"] as? Int
                            
                            let imageExtensions = ["png", "jpg", "gif", "jpeg", "PNG", "JPEG"]
                            let urlStr = EndPoint.imageURL+fileURL.replace(string: " ", replacement: "")
                            let iconURL = URL(string: urlStr)
                            let pathExtention = iconURL?.pathExtension
                            if imageExtensions.contains(pathExtention!)
                            {
                                self.modelData["Image Attachments"]?.append(documentModel(file_url: EndPoint.imageURL+fileURL, notice_id: notice_id!))
                            }else{
                                self.modelData["Other Attachments"]?.append(documentModel(file_url: EndPoint.imageURL+fileURL, notice_id: notice_id!))
                            }
                        }                        
                    }
                }
                
                //                self.noticeBoardTable.reloadData {
                switch self.status {
                case .active:
                    if let indexPath = self.activeSelectedIndexPath, indexPath != IndexPath(row: 0, section: 0){
                        self.noticeBoardTable.scrollToRow(at: self.activeSelectedIndexPath!, at: .none, animated: false)
                    }
                case .drafts:
                    if let indexPath = self.draftSelectedIndexPath, indexPath != IndexPath(row: 0, section: 0){
                        self.noticeBoardTable.scrollToRow(at: self.draftSelectedIndexPath!, at: .none, animated: false)
                    }
                case .expired:
                    if let indexPath = self.expiredSelectedIndexPath, indexPath != IndexPath(row: 0, section: 0){
                        self.noticeBoardTable.scrollToRow(at: self.expiredSelectedIndexPath!, at: .none, animated: false)
                    }
                }
                //                }
                self.noticeBoardTable.reloadData()
                //                self.noticeBoardTable.layoutIfNeeded()
                
                //                self.noticeBoardTable.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        }
        //        self.noticeBoardTable.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if self.lastContentOffset < scrollView.contentOffset.y {
            // did move up
            if expiredModel?.count != 0 {
                if UserDefaults.isAdmin != 0 {
                    floatingBtn?.isHidden = false
                }else{
                    floatingBtn?.isHidden = true
                }
            }
        } else if self.lastContentOffset > scrollView.contentOffset.y {
            // did move down
            floatingBtn?.isHidden = false
        } else {
            // didn't move
        }
        
        if (offsetY > contentHeight - scrollView.frame.height * 4) && !isLoading {
            loadMoreData()
        }
    }
    
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            
            guard let index = expiredModel?.last?.notice_id else { return }
            
            var params = [String:Any]()
            params.updateValue(community.community_id, forKey: "comm_id")
            params.updateValue(UserDefaults.user_id, forKey: "user_id")
            params.updateValue(status.rawValue, forKey: "notice_status")
            params.updateValue(index, forKey: "rec_per_page")
            
            Networking.shared.getNoticesByCommIdAndStatus(perams: params) { (model, error) in
                if let succes = model {
                    self.expiredModel?.removeAll()
                    self.expiredModel = succes
                    self.noticeBoardTable.reloadData()
                    self.isLoading = false
                }else{
                    self.noticeBoardTable.reloadData()
                }
            }
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch status {
        case .active:
            if activeSelectedIndexPath == indexPath {
                return UITableView.automaticDimension
            }
        case .drafts:
            if draftSelectedIndexPath == indexPath {
                return UITableView.automaticDimension
            }
        case .expired:
            if expiredSelectedIndexPath == indexPath {
                return UITableView.automaticDimension
            }
        }
        
        if let font = UIFont(name: "HelveticaNeue-Medium", size: 17.0), let titile = expiredModel?[safe: indexPath.row]?.notice_title {
            let castString = titile as NSString
            let size: CGSize = castString.size(withAttributes: [NSAttributedString.Key.font : font])
            let height = heightForView(text: titile, font: font, width: size.width)
            return 100+height
        }
        return 100
        //        if !self.expandFlag[indexPath.row] {
        //            return 100
        //        }else{
        //            return UITableView.automaticDimension
        //        }
    }
    
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        if let model_count = expiredModel?.count, model_count > 3 {
    //            if let lastCellRowIndex = tableView.indexPathsForVisibleRows?.last?.row {
    //                if model_count - 1 >= lastCellRowIndex + 1 {
    //                    floatingBtn.isHidden = false
    //                } else {
    //                    floatingBtn.isHidden = true
    //                }
    //            }
    //        }
    //    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame:  CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    
    
    
    func timeConversion12(time24:String)->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
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
    
    func transitionForAny(type: UILabel?, data: String?){
        UIView.transition(with: type!,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: {
                            type?.text = data
                          }, completion: nil)
        
    }
    func transitionForAnyButton(type: UIButton?, data: String?){
        UIView.transition(with: type!,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: {
                            type?.setTitle(data, for: .normal)
                          }, completion: nil)
        
    }
    
    
    
}

extension UITableView {
    func reloadData(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData()})
            {_ in completion() }
    }
}


extension NoticeBoardViewController: ImagePDFDelegate {
    func imagePDF(type: String, fileURL: URL, file_name: String) {
        if type != "" {
            if #available(iOS 11.0, *) {
                let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: PDFViewController.self)
                controller.fileURL = fileURL
                controller.file_name = file_name
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
}

enum NoticeBoardStatus :String{
    case active
    case expired
    case drafts
}



extension String {
    
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
    
    
    public func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    public func width(withConstrainedHeight height: CGFloat, font: UIFont, minimumTextWrapWidth:CGFloat) -> CGFloat {
        
        var textWidth:CGFloat = minimumTextWrapWidth
        let incrementWidth:CGFloat = minimumTextWrapWidth * 0.1
        var textHeight:CGFloat = self.height(withConstrainedWidth: textWidth, font: font)
        
        //Increase width by 10% of minimumTextWrapWidth until minimum width found that makes the text fit within the specified height
        while textHeight > height {
            textWidth += incrementWidth
            textHeight = self.height(withConstrainedWidth: textWidth, font: font)
        }
        return ceil(textWidth)
    }
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}




protocol ImagePDFDelegate {
    func imagePDF(type: String, fileURL: URL, file_name: String)
}


struct documentUpdateModel: Encodable {
    var file_url: String?
    var file_name: String?
    var is_selected: Bool?
    var is_changed: Bool?
}

