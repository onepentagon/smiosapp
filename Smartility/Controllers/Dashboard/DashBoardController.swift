//
//  DashBoardController.swift
//  Smartility
//
//  Created by Mani on 7/11/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import SwiftSpinner
import MaterialComponents
import Kingfisher
import SideMenu

class DashBoardController: UIViewController, SWRevealViewControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var joiningRequestTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintJoiningRequest: NSLayoutConstraint!
    @IBOutlet weak var joiningRequestBackgroundView: UIView!
    @IBOutlet weak var joiningRequestShadow: UIView!
    @IBOutlet weak var joiningRequestLabel: UILabel!
    @IBOutlet weak var joiningRequestCount: UILabel!
    
    @IBOutlet weak var menu_btn: UIButton!
    @IBOutlet weak var pendingAproveTable: UITableView!
    @IBOutlet weak var pendingTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var pendingJoiningLabel: UILabel!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewExisitingCommunity: UIStackView!
    @IBOutlet weak var containerView: MDCCard!
    @IBOutlet weak var menuHeight: NSLayoutConstraint!
    @IBOutlet weak var privateUnitAlertLabel: UILabel!
    @IBOutlet weak var privateUnitAlert: MDCCard!
    @IBOutlet weak var chooseDropDownLabel: UILabel!
    @IBOutlet weak var privateAlerConstant: NSLayoutConstraint!
    @IBOutlet weak var privateAlertTop: NSLayoutConstraint!
    
    @IBOutlet weak var visitorCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var down_arrow: UIImageView!
    @IBOutlet weak var dropDownContainer: UIView!
    
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var noticeBoxShadow: UIView!
    @IBOutlet weak var noticeBox: UIView!
    @IBOutlet weak var noticeNameLabel: UILabel!
    @IBOutlet weak var noticeIcon: UIImageView!
    @IBOutlet weak var newNoticeLabel: UILabel!
    
    @IBOutlet weak var VisitorBoxShadow: UIView!
    @IBOutlet weak var VisitorBox:UIView!
    
    @IBOutlet weak var invitesBackgroundView: UIView!
    @IBOutlet weak var inviteCountLabel: UIButton!
    @IBOutlet weak var visitorImageVIew: UIImageView!
    @IBOutlet weak var unreadLabel: UILabel!
    
    @IBOutlet weak var easyPassesBackgroundView: UIView!
    @IBOutlet weak var easyPassCountLabel: UIButton!
    
    @IBOutlet weak var visitorsListCountLabel: UILabel!
    @IBOutlet weak var visitorCollection: UICollectionView!
    
    @IBOutlet weak var _scrollView: UIScrollView!
    @IBOutlet weak var _scrollViewContainer: UIView!
    @IBOutlet weak var invoiceView: UIView!
    @IBOutlet weak var invoiceHeight: NSLayoutConstraint!
    @IBOutlet weak var noticeCollectionView: UICollectionView!
    @IBOutlet weak var plusBtn: UIImageView!
    @IBOutlet weak var myHouseViewBg: UIView!
    @IBOutlet weak var tabbarView: UIView!
    
    @IBOutlet weak var visitorsCount: UILabel!
    var dropDownCommunity =  CommunityDropDown().loadNib() as? CommunityDropDown
    
    var error_Status = ""
    var rejection_Reason = ""
    var blockandUnit = [String]()
    var visitorModel: TodaysVisitor?
    var invitedModel: InvitedVisitorModel?
    var easyPassHolderModel: EasyPassHolderModel?
    var UnitCusModel = [getUnitsByCustIdModel]()
    var rootModel: [CommuntyResultModel]?
    var joiningModel = [joingRequestModel]()
    var noticeList: [noticeModel]?
    var unit_id_list = [Int]()
    var comm_id = Int()
    var initialIndex = Int()
    var private_unitid_list = [Int]()
    var messageLabel: UILabel?
    
    var myhouseViewTab = myHouseView().loadNib() as? myHouseView
    var tabbarWidget = tabbarWidgetView().loadNib() as? tabbarWidgetView
    var blurredEffectView: UIVisualEffectView?
    var visitorData: [String:[String]]?
    var isPlusClicked = false
    var isShowVisitors = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        visitorData = [String:[String]]()
        
        visitorCollection.register(UINib(nibName: "VisitorCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "VisitorCollectionViewCell")
        
        
        self.view.backgroundColor = UIColor(red: 0.816, green: 0.816, blue: 0.816, alpha: 1)
        
        self.plusBtn.image = UIImage(named: "PlusBtn")
        [joiningRequestShadow,joiningRequestBackgroundView,noticeBoxShadow,noticeBox,VisitorBoxShadow,VisitorBox].forEach { (view) in
            view?.isHidden =  true
        }
        self.navigationController?.navigationBar.isHidden = true
        self.invoiceView.alpha = 0.0
        self.invoiceHeight.constant = 0
        
        joiningRequestBackgroundView.backgroundColor = .clear
        joiningRequestBackgroundView.setClickListener { [weak self] in
            self?.joiningRequestBackgroundClicked()
        }
        
        joiningRequestLabel.text = ""
        joiningRequestCount.text = ""
        joiningRequestTopConstraint.constant = 0
        heightConstraintJoiningRequest.constant = 0        
        joiningRequestLabel.text = ""
        joiningRequestCount.text = ""
        
        VisitorBox.backgroundColor = .clear
        visitorCollection.backgroundColor = .white
        
        
        messageLabel = UILabel()
        messageLabel?.textColor = UIColor.gray
        messageLabel?.numberOfLines = 0;
        messageLabel?.textAlignment = .center;
        messageLabel?.font = UIFont(name: "SFUIText-Regular", size: 17)
        messageLabel?.sizeToFit()
        view.addSubview(messageLabel!)
        
        messageLabel?.layoutAnchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: view.centerXAnchor, centerY: view.centerYAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: true)
        
        
        [noticeNameLabel,noticeIcon,newNoticeLabel].forEach { (view) in
            view?.isUserInteractionEnabled = false
        }
        
        newNoticeLabel.textColor = brandColor()
        visitorsListCountLabel.textColor = brandColor()                
        invitesBackgroundView.backgroundColor = brandColor()
        easyPassesBackgroundView.backgroundColor = successColor()
        
        unreadLabel.backgroundColor = secondaryColor()
        visitorsCount.backgroundColor = secondaryColor()
        
        [inviteCountLabel,easyPassCountLabel,easyPassesBackgroundView,invitesBackgroundView,newNoticeLabel].forEach { (view) in
            view?.layer.cornerRadius = 6
            view?.layer.masksToBounds = true
        }
        
        self.dropDownContainer.setClickListener { [weak self] in
            self?.showDropDown()
        }
        chooseDropDownLabel.setClickListener {  [weak self] in
            self?.showDropDown()
        }
        
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
        
        
        stackViewExisitingCommunity.isHidden = true
        self.containerView.isHidden = true
        self.heightConstraint.constant = 0
        //        self.heightExisitingCommunityConstraint.constant = 0
        
        view.backgroundColor = UIColor.white
        
        //        table.backgroundColor = UIColor.clear
        //        table.backgroundView = UIImageView(image: UIImage(named: "IndiaBg"))
        
        pendingAproveTable.tableFooterView = UIView()
        pendingAproveTable.separatorStyle = .none
        
        setup()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("UpdateActions"), object: nil, queue: .main) { (notify) in
            self.invite_id()
            self.setup_initialApi(index: self.initialIndex)
        }
        
        noticeBox.backgroundColor = .clear
        VisitorBoxShadow.backgroundColor = UIColor.clear
        noticeBoxShadow.backgroundColor = UIColor.clear
        joiningRequestLabel.textColor = UIColor.white
        joiningRequestCount.textColor = secondaryColor()
        
        
        noticeBox.setClickListener {
            self.NoticeClicked()
        }
        
        VisitorBox.setClickListener {
            let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: TodaysVisitorViewController.self)
            controller.model = self.visitorModel
            controller.unit_id_list = self.private_unitid_list
            controller.comm_id = self.comm_id
            controller.navigationController?.tabBarController?.tabBar.isHidden = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        
        inviteCountLabel.mk_addTapHandler { (btn) in
            let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: InvitedVisitorController.self)
            controller.model = self.invitedModel
            controller.unit_id_list = self.private_unitid_list
            controller.comm_id = self.comm_id
            controller.UnitCusModel = self.UnitCusModel
            controller.navigationController?.tabBarController?.tabBar.isHidden = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        easyPassCountLabel.mk_addTapHandler { (btn) in
            let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: EasyPassViewController.self)
            controller.model = self.easyPassHolderModel?.detail
            controller.UnitCusModel = self.UnitCusModel
            controller.private_unitid_list = self.private_unitid_list
            controller.navigationController?.tabBarController?.tabBar.isHidden = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        invoiceView.setClickListener {
            let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: Invoice_Payment_ViewController.self)
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        plusBtn.setClickListener { [weak self] in
            if !(self?.isPlusClicked ?? false){
                self?.isPlusClicked = true
                self?.showWidgetPopup()
            }else{
                self?.isPlusClicked = false
                self?.plusDownClicked()
            }
        }
        
        myHouseViewBg.setClickListener {
            self.addMyHousePopUp()
        }
        
        tabbarView.bringSubviewToFront(plusBtn)
        
        
        self.pendingAproveTable.delegate = self
        self.pendingAproveTable.dataSource = self
        self.pendingAproveTable.reloadData()
        
        //        let layout = CollectionViewOverlappingLayout()
        //        layout.sectionInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        //        visitorCollection.collectionViewLayout = layout
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.visitorCollection.showsHorizontalScrollIndicator = false
        self.visitorCollection.collectionViewLayout = layout
        if let layout = self.visitorCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 15
            layout.minimumLineSpacing = 15
        }
        visitorCollection.delegate = self
        visitorCollection.dataSource = self
        visitorCollection.reloadData()
        visitorCollectionHeight.constant = 6
        navigationControllerClass.shared.navigationController = self.navigationController
        
        menu_btn.mk_addTapHandler { (btn) in
            let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: SideMenuViewController.self)
            let menu = SideMenuNavigationController(rootViewController: controller)
            menu.navigationBar.isHidden = true
            menu.leftSide = true
            menu.presentationStyle = .menuSlideIn
            menu.enableTapToDismissGesture = true
            menu.enableSwipeToDismissGesture = true
            menu.view.backgroundColor = .clear
            menu.menuWidth = self.view.frame.width*0.8
            menu.navigationController?.navigationBar.isHidden = true
            self.present(menu, animated: true, completion: nil)
        }
        
        self.dropDownCommunity = CommunityDropDown().loadNib() as? CommunityDropDown
        
        self._scrollView.isScrollEnabled = true
        self._scrollView.alwaysBounceVertical = true
                
        _scrollView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [unowned self] in
            self._scrollView.cr.beginHeaderRefresh()
            let cusId = UserDefaults.cust_id
            let user_id = UserDefaults.user_id
            print("user_id--------------->",user_id)
            print("cusId--------------->",cusId)
            Networking.shared.getCommByCustId(id:user_id) { [unowned self] (success, error) in
                if let model = success {
                    self.rootModel = model
                    do {
                        SwiftSpinner.show("Fetching information...")
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(model)
                        UserDefaults.standard.set(data, forKey: "topModel")
                        UserDefaults().setValue(self.initialIndex, forKey: "Index")
                        self.select_indexValue(index: self.initialIndex, succ: self.rootModel!)
                    } catch { print(error) }
                }
                self._scrollView.cr.endHeaderRefresh()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.unreadLabel.layer.cornerRadius = 10
        self.unreadLabel.layer.masksToBounds = true
        
        noticeBoxShadow.makeCustomRound(shadow: true,backgroundColor: UIColor.white,topLeft: 50, topRight: 6, bottomLeft: 6, bottomRight: 6)
        joiningRequestShadow.makeCustomRound(shadow: true,backgroundColor: warningColor(),topLeft: 50, topRight: 6, bottomLeft: 6, bottomRight: 6)
//        VisitorBoxShadow.makeCustomRound(shadow: true,backgroundColor: UIColor.white,topLeft: 50, topRight: 6, bottomLeft: 6, bottomRight: 6)
        
        
        self.visitorsCount.layer.cornerRadius = 10
        self.visitorsCount.layer.masksToBounds = true
        
        navigationBarView.backgroundColor = .white
        navigationBarView.layer.shadowColor = UIColor(red: 0.049, green: 0.019, blue: 0.167, alpha: 0.2).cgColor
        navigationBarView.layer.shadowOpacity = 1
        navigationBarView.layer.shadowRadius = 1
        navigationBarView.layer.shadowOffset = CGSize(width: 0, height: 1)
    }        
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.navigationController?.navigationBar.isHidden = true
        
        [invitesBackgroundView].forEach { (view) in
            view?.layer.borderWidth = 1.0
            view?.layer.borderColor = UIColor.white.cgColor
        }
        
    }
    
    
    @objc func joiningRequestBackgroundClicked(){
        let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: ApproveRejectJoineeController.self)
        controller.joiningModel = self.joiningModel
        controller.navigationController?.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    
    
    
    
    @objc func NoticeClicked(){
        
        var data_params = [String:String]()
        var params = [String:Any]()
        params.updateValue(community.community_id, forKey: "comm_id")
        params.updateValue(UserDefaults.user_id, forKey: "user_id")
        
        SwiftSpinner.show("Fetching Notice informations...")
        let dispatch = DispatchGroup()
        dispatch.enter()
        print("1")
        params.updateValue("active", forKey: "notice_status")
        Networking.shared.getTotalNoticesByStatus(perams: params) { (model, error) in
            if let succes = model, let countArra = succes[0] as? [String:Any],let count = countArra["total"] as? Int {
                data_params.updateValue("Active (\(count))", forKey: "Active")
                dispatch.leave()
            }
        }
        dispatch.enter()
        params.updateValue("expired", forKey: "notice_status")
        Networking.shared.getTotalNoticesByStatus(perams: params) { (model, error) in
            if let succes = model,let countArra = succes[0] as? [String:Any],let count = countArra["total"] as? Int {
                dispatch.leave()
                data_params.updateValue("Expired (\(count))", forKey: "Expired")
            }
        }
        dispatch.enter()
        params.updateValue("drafts", forKey: "notice_status")
        Networking.shared.getTotalNoticesByStatus(perams: params) { (model, error) in
            if let succes = model,let countArra = succes[0] as? [String:Any],let count = countArra["total"] as? Int {
                dispatch.leave()
                data_params.updateValue("Draft (\(count))", forKey: "Draft")
            }
        }
        
        dispatch.notify(queue: .main) {
            print("Finish")
            SwiftSpinner.hide()
            let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: NoticeBoardViewController.self)
            controller.noticeTitle = data_params
            controller.noticeIndex = 0
            controller.status = NoticeBoardStatus.active
            controller.navigationController?.tabBarController?.tabBar.isHidden = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    
    
    func setup_initialApi(index:Int){
        let cusId = UserDefaults.cust_id
        let user_id = UserDefaults.user_id
        print("user_id--------------->",user_id)
        print("cusId--------------->",cusId)
        
        Networking.shared.getCommByCustId(id:user_id) { (success, error) in
            if let succ = success {
                self.rootModel = succ
                self.initialIndex = index
                self.select_indexValue(index: index, succ: succ)
            }
            if let err = error {
                SwiftSpinner.hide()
                self.showConfirmAlert(title: "", message: err.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
            }
        }
    }
    
    @objc func showDropDown(){
        
        let blurEffect = UIBlurEffect(style: .dark)
        self.blurredEffectView = UIVisualEffectView(effect: blurEffect)
        self.blurredEffectView?.frame = UIScreen.main.bounds
        self.view.addSubview(blurredEffectView!)
        self.view.addSubview(self.dropDownCommunity!)
        
        if (dropDownCommunity?.communitList.count ?? 0) > 5 {
            let height = view.frame.size.height/2
            self.dropDownCommunity?.layoutAnchor(top: self.blurredEffectView?.topAnchor, left: blurredEffectView?.leftAnchor, bottom: nil, right: blurredEffectView?.rightAnchor, centerX: nil, centerY: nil, paddingTop: 152, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: height, enableInsets: true)
        }else{
            let height = CGFloat((dropDownCommunity?.communitList.count ?? 0) * 64 + 48)
            self.dropDownCommunity?.layoutAnchor(top: self.blurredEffectView?.topAnchor, left: blurredEffectView?.leftAnchor, bottom: nil, right: blurredEffectView?.rightAnchor, centerX: nil, centerY: nil, paddingTop: 152, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: height, enableInsets: true)
        }
        dropDownCommunity?.setupTable()
        dropDownCommunity?.selectedCommunityIndex = initialIndex
        dropDownCommunity?.layer.cornerRadius = 6
        dropDownCommunity?.layer.masksToBounds = true
        self.blurredEffectView?.bringSubviewToFront(dropDownCommunity!)
        
        UIView.animate(withDuration: 0.2) {
            self.dropDownCommunity?.alpha = 1.0
        } completion: { (com) in
        }
        
        blurredEffectView?.contentView.setClickListener {
            UIView.animate(withDuration: 0.2) {
                self.dropDownCommunity?.alpha = 0.0
            } completion: { (com) in
                self.blurredEffectView?.removeFromSuperview()
            }
        }
        
        dropDownCommunity?.didUpdate = { communityName, index in
            self.blurredEffectView?.removeFromSuperview()
            UIView.animate(withDuration: 0.2) {
                self.dropDownCommunity?.alpha = 0.0
            } completion: { (com) in
            }
            self.chooseDropDownLabel.text = communityName
            let cusId = UserDefaults.cust_id
            let user_id = UserDefaults.user_id
            print("user_id--------------->",user_id)
            print("cusId--------------->",cusId)
            Networking.shared.getCommByCustId(id:user_id) { (success, error) in
                if let model = success {
                    self.rootModel = model
                    do {
                        SwiftSpinner.show("Fetching information...")
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(model)
                        UserDefaults.standard.set(data, forKey: "topModel")
                        UserDefaults().setValue(index, forKey: "Index")
                        self.initialIndex = index
                        self.select_indexValue(index: index, succ: self.rootModel!)
                    } catch { print(error) }
                }
            }
        }
    }
    
    @IBAction func reloadData(_ sender: UIButton) {
        self.setup_initialApi(index: self.initialIndex)
    }
    
    func invite_id(){
        var perams_details = [String:Any]()
        perams_details.updateValue(self.private_unitid_list, forKey: "unit_id_list")
        perams_details.updateValue(UserDefaults.user_id, forKey: "user_id")
        perams_details.updateValue(self.comm_id, forKey: "comm_id")
        perams_details.updateValue("active", forKey: "filter_by")
        Networking.shared.getMyInvitedVisitor(perams: perams_details) { (model, error) in
            if let model = model {
                self.invitedModel = model
                //                self.table.reloadData()
            }
            if let _ = error {
                //                self.table.reloadData()
            }
        }
    }
    func checkJoiningRequest(){
        var perams = [String:Any]()
        perams.updateValue(Int(UserDefaults.user_id) ?? "", forKey: "user_id")
        perams.updateValue(Int(community.community_id) ?? "", forKey: "comm_id")
        perams.updateValue((UserDefaults.isAdmin == 0) ? "false" : "true", forKey: "is_admin")
        perams.updateValue(unit_id_list, forKey: "unit_id")
        Networking.shared.getJoiningRequest(perams: perams) { (model, error) in
            if let modelArray = model, modelArray.count != 0 {
                self.joiningModel = modelArray
                self.joiningRequestTopConstraint.constant = 10
                self.joiningRequestBackgroundView.isHidden = false
                self.joiningRequestShadow.isHidden = false
                self.heightConstraintJoiningRequest.constant = 90
                self.joiningRequestLabel.text = "Joining Request"
                self.joiningRequestCount.text = "\(modelArray.count)"
                //                self.joiningRequestCount.text = "\(modelArray.count) \(modelArray.count == 1 ? "request" : "requests") pending for review!"
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }else{
                self.joiningRequestShadow.isHidden = true
                self.joiningRequestBackgroundView.isHidden = true
                self.joiningRequestLabel.text = ""
                self.joiningRequestCount.text = ""
                self.joiningRequestTopConstraint.constant = 0
                self.heightConstraintJoiningRequest.constant = 0
            }
        }
    }
    
    
    func select_indexValue(index: Int, succ: [CommuntyResultModel]){
        self.containerView.isHidden = true
        self.stackViewExisitingCommunity.isHidden = true
        self.privateAlerConstant.constant = 0
        self.heightConstraint.constant = 0
        self.privateUnitAlertLabel.text = ""
        
        if let commid = succ[safe:index]?.comm_id {
            self.comm_id = commid
        }
        
        if let support_email = succ[safe:index]?.support_email {
            CommunityData.support_email = support_email
        }
        
        if let sms_for_invite = succ[safe:index]?.sms_for_invite {
            CommunityData.sms_for_invite = sms_for_invite
        }
        
        if let sms_for_easypass = succ[safe:index]?.sms_for_easypass {
            CommunityData.sms_for_easypass = sms_for_easypass
        }
        
        if let ivr_for_visitor = succ[safe:index]?.ivr_for_visitor {
            CommunityData.ivr_for_visitor = ivr_for_visitor
        }
        
        community.community_id = "\(self.comm_id)"
        community.community_name = succ[safe:index]?.comm_name ?? ""
        print(community.community_name)
        
        let cusId = UserDefaults.cust_id
        let user_id = UserDefaults.user_id
        
        Networking.shared.updateToken(token: notificationSingletone.shared.tokenStore)
        
        UserDefaults.UserContry = succ[safe: index]?.country_code  ?? ""
        if let isOtherUser = succ[safe: index]?.is_other_user {
            UserDefaults.isOtherUser = isOtherUser
        }
        if let isAdmin = succ[safe: index]?.is_admin {
            UserDefaults.isAdmin = isAdmin
        }
        checkJoiningRequest()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.noticeCollectionView.showsHorizontalScrollIndicator = false
        self.noticeCollectionView.collectionViewLayout = layout
        
        if let layout = self.noticeCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 15
            layout.minimumLineSpacing = 15
        }
        self.newNoticeLabel.text = ""
        self.unreadLabel.isHidden = true
        self.noticeList?.removeAll()
        
        self.invoiceView.alpha = 0.0
        self.invoiceHeight.constant = 0
        
        self.noticeCollectionView.dataSource = self
        self.noticeCollectionView.delegate = self
        self.noticeCollectionView.reloadData()
        
        if let otheruser = succ[safe:index]?.is_other_user {
            if (otheruser == 1){
                if succ[safe:index]?.rel_status_if_other_user == "Linked"  {
                    self.error_Status = ""
                    self.loadVisitorDashboard()
                }else{
                    self.error_Status = succ[safe: 0]?.rel_status_if_other_user ?? ""
                    self.rejection_Reason = succ[safe: 0]?.rej_reason_if_other_user ?? ""
                    //                    self.table.delegate = self
                    //                    self.table.dataSource = self
                    //                    self.table.reloadData()
                    self.pendingAproveTable.reloadData()
                }
                SwiftSpinner.hide()                
            }else{
                print("user_id--------------->",user_id)
                print("cusId--------------->",cusId)
                //                self.table.delegate = nil
                //                self.table.dataSource = nil
                //                self.table.showActivityIndicator()
                let id = "\(user_id)/\(self.comm_id)"
                self.unit_id_list.removeAll()
                self.private_unitid_list.removeAll()
                let semaphore = DispatchSemaphore(value: 1)
                semaphore.wait()
                
                Networking.shared.getNoticeByCommId(perams: ["comm_id": community.community_id, "user_id": user_id]) { (model, error) in
                    SwiftSpinner.hide()
                    if let model = model {
                        
                        UIView.transition(with: self.newNoticeLabel,
                                          duration: 0.25,
                                          options: .transitionCrossDissolve,
                                          animations: { [weak self] in
                                            self?.newNoticeLabel.text = "\(model.count == 0 ? "0" : "\(model.count)")"
                                          }, completion: nil)
                        let unread = model.filter { (newNotice) -> Bool in
                            return newNotice.is_ack == 0
                        }
                        self.unreadLabel.isHidden = unread.count == 0 ? true : false
                        UIView.transition(with: self.unreadLabel,
                                          duration: 0.25,
                                          options: .transitionCrossDissolve,
                                          animations: { [weak self] in
                                            self?.unreadLabel.text = "\(unread.count) Unread"
                                          }, completion: nil)
                        
                        self.noticeList = [noticeModel]()
                        self.noticeList?.removeAll()
                        self.noticeList = model
                        self.noticeCollectionView.reloadData()
                    }else{
                        self.noticeList?.removeAll()
                        self.noticeCollectionView.reloadData()
                    }
                    
                    semaphore.signal()
                }
                Networking.shared.getUnitsByUserId(id: id) { (model, error) in
                    SwiftSpinner.hide()
                    if let model = model {
                        self.UnitCusModel = model
                        let linked =  model.filter { (model) -> Bool in
                            model.rel_status == "Linked"
                        }
                        if linked.count != 0 {
                            self.error_Status = ""
                            self.unit_id_list =  model.filter { (model) -> Bool in
                                model.rel_status == "Linked"
                            }.compactMap({
                                $0.unit_id
                            })                                                                                                                
                            model.forEach { (idlist) in
                                if idlist.rel_status == "Linked" {
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
                            }
                            
                            let private_block_unit_noList = model.map { $0.block_and_unit ?? "" }
                            //Enable visitor card & visitor module in plus button
                            self.VisitorBox.isHidden = false
                            self.VisitorBoxShadow.isHidden = false
                            self.VisitorBox.subviews.forEach { view in
                                view.isHidden = false
                            }
                            self.isShowVisitors = true
                            self.VisitorBoxShadow.makeCustomRound(shadow: true,backgroundColor: UIColor.white,topLeft: 50, topRight: 6, bottomLeft: 6, bottomRight: 6)
                            if UserDefaults.isOtherUser == 0 && self.private_unitid_list.count == 0 && self.unit_id_list.count > 0 {
                                //display msg
                                var text_msg = "Visitor information of your unit (\(private_block_unit_noList.joined(separator: ","))) is hidden as it is rented out based on your profile config."
                                if UserDefaults.isAdmin == 1 {
                                    text_msg = text_msg+" However, as an admin you can manage your official visitors here"
                                }else{
                                    self.VisitorBoxShadow.layer.sublayers?.forEach({ lat in
                                        if lat.isKind(of: CAShapeLayer.self) {
                                            lat.removeFromSuperlayer()
                                        }
                                    })
                                    self.VisitorBoxShadow.makeCustomRound(shadow: false,backgroundColor: UIColor.white,topLeft: 50, topRight: 6, bottomLeft: 6, bottomRight: 6)
                                    self.VisitorBox.subviews.forEach { view in
                                        view.isHidden = true
                                    }
                                    self.isShowVisitors = false
                                    self.VisitorBox.isHidden = true
                                    self.VisitorBoxShadow.isHidden = true
                                    self.visitorCollectionHeight.constant = 0
                                    //hide visitor card
                                    //Hide visitor module plusButton
                                }
                                self.privateUnitAlert.cornerRadius = 10
                                self.privateUnitAlert.setBorderColor(secondaryColor(), for: .normal)
                                self.privateUnitAlert.setBorderWidth(1.0, for: .normal)
                                self.privateUnitAlert.isUserInteractionEnabled = false
                                
                                self.privateUnitAlertLabel.adjustsFontSizeToFitWidth = true
                                
                                UIView.transition(with: self.privateUnitAlertLabel,
                                                  duration: 0.25,
                                                  options: .transitionCrossDissolve,
                                                  animations: { [weak self] in
                                                    self?.self.privateUnitAlertLabel.text = text_msg
                                                  }, completion: nil)
                                self.privateAlerConstant.constant = 83
                                self.privateAlertTop.constant = 10
                            }else{
                                self.privateAlertTop.constant = 0
                                self.privateUnitAlertLabel.text = ""
                                self.privateAlerConstant.constant = 0
                            }
                            if let id = self.unit_id_list.first {
                                community.cust_unitId = "\(id)"
                            }
                            
                            self.blockandUnit.removeAll()
                            self.blockandUnit =  model.filter { (model) -> Bool in
                                model.rel_status != "Linked"
                            }.map({ $0.block_and_unit ?? "" })
                            
                            print(self.unit_id_list)
                            if self.blockandUnit.count != 0 {
                                var height = [CGFloat]()
                                for i in self.blockandUnit {
                                    height.append(self.calculateHeight(inString: i))
                                }
                                let reduceSum = height.reduce(0) {$0 + CGFloat($1)}
                                self.heightConstraint.constant = reduceSum
                                
                                self.pendingTopConstraint.constant = 10
                                self.pendingAproveTable.isScrollEnabled = false
                                self.containerView.isHidden = false
                                self.stackViewExisitingCommunity.isHidden = false
                                
                                self.containerView.setBorderColor(secondaryColor(), for: .normal)
                                self.containerView.setBorderWidth(1.0, for: .normal)
                                self.containerView.layer.cornerRadius = 10
                                self.pendingAproveTable.register(UITableViewCell.self, forCellReuseIdentifier: "pendingCell")
                                self.pendingAproveTable.delegate = self
                                self.pendingAproveTable.dataSource  = self
                                self.pendingAproveTable.reloadData()
                                self.pendingAproveTable.isUserInteractionEnabled = false
                                self.pendingJoiningLabel.text = " Your joining request for below unit is yet to be approved by your community admin."
                            }else{
                                self.pendingJoiningLabel.text = ""
                                self.pendingTopConstraint.constant = 0
                                self.stackViewExisitingCommunity.isHidden = true
                                self.containerView.isHidden = true
                                self.heightConstraint.constant = 0
                            }
                            self.loadVisitorDashboard()
                        }else{
                            self.error_Status = model[safe: 0]?.rel_status ?? ""
                            self.rejection_Reason = model[safe: 0]?.rej_reason ?? ""
                            
                            self.pendingAproveTable.reloadData()
                        }
                    }
                    if let err = error {
                        self.showConfirmAlert(title: "", message: err.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                    }
                    
                    UIView.animate(withDuration: 0.5) {
                        self.view.layoutIfNeeded()
                    }
                    semaphore.signal()
                }
                
                
                var perams: [String:Any] = [:]
                perams.updateValue(self.unit_id_list, forKey: "unit_id_list")
                perams.updateValue(UserDefaults.user_id, forKey: "user_id")
                perams.updateValue(cusId, forKey: "cust_id")
                perams.updateValue(self.comm_id, forKey: "comm_id")

                Networking.shared.getAccBalByCustId(URL: EndPoint.getAccBalByCustId, perams: perams) { (result, error) in
                    if let result = result {
                        let resultArray = result.filter {
                            let rootArray = $0 as? [String:Any]
                            let pay_towards = rootArray?["pay_towards"] as? String
                            return pay_towards == "I"
                        }
                        if resultArray.count != 0{
                            self.invoiceHeight.constant = 160
                            self.invoiceView.alpha = 1.0
                            NotificationCenter.default.post(name: NSNotification.Name("UpdateInvoice"), object: nil, userInfo: ["result": result])
                        }else{
                            self.invoiceView.alpha = 0.0
                            self.invoiceHeight.constant = 0
                            NotificationCenter.default.post(name: NSNotification.Name("UpdateInvoice"), object: nil, userInfo: ["result": ""])
                        }
                    }else{
                        self.invoiceView.alpha = 0.0
                        self.invoiceHeight.constant = 0
                        NotificationCenter.default.post(name: NSNotification.Name("UpdateInvoice"), object: nil, userInfo: ["result": ""])
                    }
                    UIView.animate(withDuration: 0.5) {
                        self.view.layoutIfNeeded()
                    }
                    semaphore.signal()
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
        
        //        self.table.showActivityIndicator()
        perams.updateValue(self.private_unitid_list, forKey: "unit_id_list")
        perams.updateValue(user_id, forKey: "user_id")
        perams.updateValue(self.comm_id, forKey: "comm_id")
        perams.updateValue(date, forKey: "from_dt")
        perams.updateValue(date, forKey: "to_dt")
        
        dispatch.enter()
        Networking.shared.getMyVisitorByPeriodAndStatus(perams: perams) { (model, error) in
            if let mode = model {
                self.visitorModel = mode
                
                let insideCount = mode.detail?.filter({ (details) -> Bool in
                    return details.visitor_status == "Inside"
                })
                self.visitorData?.removeAll()
                var dailyHelper = [String]()
                var Cab = [String]()
                var Guest = [String]()
                var Delivery = [String]()
                var Vendor = [String]()
                mode.detail?.forEach({ (details) in
                    let catagory = details.visitor_cat ?? ""
                    if catagory == "Daily Helper" {
                        dailyHelper.append(details.visitor_img_url ?? "")
                    }else if catagory == "Cab" {
                        Cab.append(details.visitor_img_url ?? "")
                    }else if catagory == "Guest" {
                        Guest.append(details.visitor_img_url ?? "")
                    }else if catagory == "Delivery" {
                        Delivery.append(details.visitor_img_url ?? "")
                    }else if catagory == "Vendor" {
                        Vendor.append(details.visitor_img_url ?? "")
                    }
                })
                
                if dailyHelper.count != 0 {
                    self.visitorData?.updateValue(dailyHelper, forKey: "Daily Helper")
                }
                if Cab.count != 0 {
                    self.visitorData?.updateValue(Cab, forKey: "Cab")
                }
                if Guest.count != 0 {
                    self.visitorData?.updateValue(Guest, forKey: "Guest")
                }
                if Delivery.count != 0 {
                    self.visitorData?.updateValue(Delivery, forKey: "Delivery")
                }
                if Vendor.count != 0 {
                    self.visitorData?.updateValue(Vendor, forKey: "Vendor")
                }
                
                if self.visitorData?.count != 0 {
                    UIView.animate(withDuration: 0.5) {
                        self.visitorCollectionHeight.constant = 66
                    } completion: { (COMP) in
                        self.visitorCollection.reloadData()
                    }
                    self.visitorCollection.reloadData()
                }else{
                    UIView.animate(withDuration: 0.5) {
                        self.visitorData?.removeAll()
                        self.visitorCollectionHeight.constant = 6
                    } completion: { (COMP) in
                        self.visitorCollection.reloadData()
                    }
                }
                self.visitorsCount.isHidden = insideCount?.count == 0
                self.visitorsCount.text = insideCount?.count == 0 ? "" : "\(insideCount?.count ?? 0) Inside"
                dispatch.leave()
            }
            if let _ = error {
                self.visitorData?.removeAll()
                self.visitorCollectionHeight.constant = 6
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
                var tot_rec = Int()
                model.stats?.forEach({ (objects) in
                    if let ob = objects.tot_rec {
                        tot_rec += ob
                    }
                })
                
                if tot_rec != 0 {
                    UIView.transition(with: self.inviteCountLabel,
                                      duration: 0.25,
                                      options: .transitionCrossDissolve,
                                      animations: { [weak self] in
                                        if tot_rec <= 1 {
                                            self?.inviteCountLabel.setTitle("\(tot_rec) Invite", for: .normal)
                                        }else{
                                            self?.inviteCountLabel.setTitle("\(tot_rec) Invites", for: .normal)
                                        }
                                      }, completion: nil)
                }else{
                    UIView.transition(with: self.inviteCountLabel,
                                      duration: 0.25,
                                      options: .transitionCrossDissolve,
                                      animations: { [weak self] in
                                        self?.inviteCountLabel.setTitle("No Invites", for: .normal)
                                      }, completion: nil)
                    
                }
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
                var tot_rec = Int()
                model.stats?.forEach({ (objects) in
                    if let ob = objects.tot_rec {
                        tot_rec += ob
                    }
                })
                if tot_rec != 0 {
                    UIView.transition(with: self.easyPassCountLabel,
                                      duration: 0.25,
                                      options: .transitionCrossDissolve,
                                      animations: { [weak self] in
                                        if tot_rec <= 1 {
                                            self?.easyPassCountLabel.setTitle("\(tot_rec) EasyPass", for: .normal)
                                        }else{
                                            self?.easyPassCountLabel.setTitle("\(tot_rec) EasyPasses", for: .normal)
                                        }
                                      }, completion: nil)
                    
                }else{
                    UIView.transition(with: self.easyPassCountLabel,
                                      duration: 0.25,
                                      options: .transitionCrossDissolve,
                                      animations: { [weak self] in
                                        self?.easyPassCountLabel.setTitle("No EasyPasses", for: .normal)
                                      }, completion: nil)
                }
                dispatch.leave()
            }
            if let _ = error {
                dispatch.leave()
            }
        }
        
        dispatch.notify(queue: .main) {
            self.pendingAproveTable.reloadData()
            self.error_Status = ""
            SwiftSpinner.hide()
            
            self.view.setNeedsLayout()
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    
    func setup(){
        
        SwiftSpinner.show("Fetching information...")
        if UserDefaults.cust_id == "" && UserDefaults.user_id == "" {
            UserDefaults.standard.removeObject(forKey: "topModel")
            UserDefaults.standard.removeObject(forKey: "Index")
            UserDefaults.cust_id = ""
            UserDefaults.user_id = ""
            let controller = AppStoryboard.Main.viewController(viewControllerClass: WelcomViewController.self)
            let nav_controller = UINavigationController(rootViewController: controller)
            nav_controller.navigationBar.isHidden = true
            getTopWindow()?.rootViewController =  nav_controller
            getTopWindow()?.makeKeyAndVisible()
            if let window = getTopWindow() {
                UIView.transition(with: window, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {}, completion:
                                    { completed in
                                    })
            }
        }else{
            if let _ = UserDefaults.standard.data(forKey: "topModel"), let index = UserDefaults().value(forKey: "Index") as? Int {
                let cusId = UserDefaults.cust_id
                let user_id = UserDefaults.user_id
                print("user_id--------------->",user_id)
                print("cusId--------------->",cusId)
                Networking.shared.getCommByCustId(id:user_id) { (success, error) in
                    if let succ = success {
                        self.rootModel = succ
                        if succ.count == 1 {
                            self.dropDownContainer.isUserInteractionEnabled = false
                            self.down_arrow.isHidden = true
                            self.chooseDropDownLabel.isUserInteractionEnabled = false
                            self.chooseDropDownLabel.text = succ[safe: 0]?.comm_name
                        }else{
                            self.dropDownContainer.isUserInteractionEnabled = true
                            self.chooseDropDownLabel.isUserInteractionEnabled = true
                            self.down_arrow.isHidden = false
                            self.chooseDropDownLabel.text = succ[safe: index]?.comm_name
                        }
                        self.dropDownCommunity?.communitList = succ.map {  ($0.comm_name ?? "") }
                        //                        self.dropDownForCommunity.dataSource = succ.map {  ($0.comm_name ?? "") }
                        self.initialIndex = index
                        self.select_indexValue(index: index, succ: succ )
                    }else{
                        SwiftSpinner.hide()
                        self.showConfirmAlert(title: "", message: error?.localizedDescription, buttonTitle: "Ok", buttonStyle: .cancel, confirmAction: nil)
                    }
                }
            }else{
                let cusId = UserDefaults.cust_id
                let user_id = UserDefaults.user_id
                print("user_id--------------->",user_id)
                print("cusId--------------->",cusId)
                Networking.shared.getCommByCustId(id:user_id) { (success, error) in
                    if let succ = success {
                        self.rootModel = succ
                        self.chooseDropDownLabel.text = succ[safe: 0]?.comm_name
                        if succ.count == 1 {
                            self.dropDownContainer.isUserInteractionEnabled = false
                            self.down_arrow.isHidden = true
                            self.chooseDropDownLabel.isUserInteractionEnabled = false
                        }else{
                            self.dropDownContainer.isUserInteractionEnabled = true
                            self.chooseDropDownLabel.isUserInteractionEnabled = true
                            self.down_arrow.isHidden = false
                        }
                        self.dropDownCommunity?.communitList = succ.map {  ($0.comm_name ?? "") }
                        //                        self.dropDownForCommunity.dataSource = succ.map {  ($0.comm_name ?? "") }
                        self.initialIndex = 0
                        self.select_indexValue(index: 0, succ: succ)
                    }
                    if let err = error {
                        SwiftSpinner.hide()
                        self.showConfirmAlert(title: "", message: err.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                    }
                }
            }
        }
    }
    
}

extension DashBoardController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.error_Status == "Pending Approval" {
            
            UIView.transition(with: messageLabel!,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                self?.messageLabel?.text = """
                Your joining request is yet to be approved by your community admin.

                It may take few hours to process your request and you will be notified as soon as it is done.

                You may close the app now and reopen it once your request is approved.
                """
                              }, completion: nil)
            
            _ = [joiningRequestShadow,joiningRequestBackgroundView,noticeBoxShadow,noticeBox,VisitorBoxShadow,VisitorBox].map { $0?.isHidden = true }
            
            //            [joiningRequestShadow,joiningRequestBackgroundView,noticeBoxShadow,noticeBox,VisitorBoxShadow].forEach { (view) in
            //                view?.isHidden =  true
            //            }
            
        }else if self.error_Status == "Rejected" {
            
            UIView.transition(with: messageLabel!,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                self?.messageLabel?.text = """
                Your joining request was rejected with below reason

                "\(self!.rejection_Reason)"

                Please contact your community admin if you did not expect to see this message.
                """
                              }, completion: nil)
            _ = [joiningRequestShadow,joiningRequestBackgroundView,noticeBoxShadow,noticeBox,VisitorBoxShadow,VisitorBox].map { $0?.isHidden = true }
            //            [joiningRequestShadow,joiningRequestBackgroundView,noticeBoxShadow,noticeBox,VisitorBoxShadow].forEach { (view) in
            //                view?.isHidden =  true
            //            }
            
        }else if self.error_Status == "Delinked" {
            
            UIView.transition(with: messageLabel!,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                self?.messageLabel?.text = """
                You are currently delinked from your unit.

                Please contact your community admin if you did not expect to see this message.
                """
                              }, completion: nil)
            _ = [joiningRequestShadow,joiningRequestBackgroundView,noticeBoxShadow,noticeBox,VisitorBoxShadow, VisitorBox].map { $0?.isHidden = true }
            //            [joiningRequestShadow,joiningRequestBackgroundView,noticeBoxShadow,noticeBox,VisitorBoxShadow].forEach { (view) in
            //                view?.isHidden =  true
            //            }
        }else{
            
            _ = [noticeBoxShadow,noticeBox,VisitorBoxShadow,VisitorBox].map { $0?.isHidden = false }
            
            //            [noticeBoxShadow, noticeBox,VisitorBoxShadow].forEach { (view) in
            //                view?.isHidden =  false
            //            }
            messageLabel?.text = ""
        }
        
        if blockandUnit.count != 0 {
            return blockandUnit.count
        }else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pendingCell", for: indexPath)
        cell.selectionStyle = .none
        let index = indexPath.row+1
        let text = "\(index). "+blockandUnit[indexPath.row]
        cell.textLabel?.font = SFFont(font: .Medium, size: 12)
        cell.textLabel?.text = text
        cell.textLabel?.textColor = secondaryColor()
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.numberOfLines = 0
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height:CGFloat = calculateHeight(inString: self.blockandUnit[indexPath.row])
        return height
    }
    
    func calculateHeight(inString:String) -> CGFloat
    {
        let messageString = inString
        let attributes = [NSAttributedString.Key.font:
                            SFFont(font: .Medium, size: 12),
                          NSAttributedString.Key.foregroundColor: UIColor.white] as [NSAttributedString.Key: Any]
        let attributedString : NSAttributedString = NSAttributedString(string: messageString, attributes: attributes)
        
        let rect : CGRect = attributedString.boundingRect(with: CGSize(width: 222.0, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        let requredSize:CGRect = rect
        return requredSize.height
    }
}


extension DashBoardController: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == noticeCollectionView {
            if let notice = self.noticeList, notice.count != 0 {
                return notice.count
            }else{
                return 1
            }
        }else{
            
            let visior = visitorData?.count ?? 0
            
            let statsCount = visitorModel?.stats?.count ?? 0
            UIView.transition(with: visitorsListCountLabel,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                self?.visitorsListCountLabel.text = "\(statsCount)"
                              }, completion: nil)
            return visior
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == noticeCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoticeCollectionViewCell", for: indexPath) as! NoticeCollectionViewCell
            if let notice = self.noticeList, notice.count != 0 {
                cell.noNotice.text = ""
                cell.noticeTitle.text = notice[indexPath.row].notice_title
                cell.noticeDescription.text = notice[indexPath.row].notice_text?.htmlToString
            }else{
                cell.noticeTitle.text = ""
                cell.noticeDescription.text = ""
                cell.noNotice.text = "No active notices"
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VisitorCollectionViewCell", for: indexPath) as? VisitorCollectionViewCell
            if let data = visitorData?.keys, let value = visitorData?.values{
                let data1 = Array(data)
                let catagory = data1[indexPath.row]
                
                let arrayOfValue = Array(value)
                let visitorImageList = arrayOfValue[indexPath.row]
                print(visitorImageList)
                
                if catagory == "Daily Helper" {
                    cell?.visitorsCount.text = "\(visitorImageList.count)"
                    cell?.visitorName.text = "Daily Helper"
                }else if catagory == "Cab" {
                    cell?.visitorsCount.text = "\(visitorImageList.count)"
                    cell?.visitorName.text = "Cab"
                }else if catagory == "Guest" {
                    cell?.visitorsCount.text = "\(visitorImageList.count)"
                    cell?.visitorName.text = "Guest"
                }else if catagory == "Delivery" {
                    cell?.visitorsCount.text = "\(visitorImageList.count)"
                    cell?.visitorName.text = "Delivery"
                }else if catagory == "Vendor" {
                    cell?.visitorsCount.text = "\(visitorImageList.count)"
                    cell?.visitorName.text = "Vendor"
                }
                cell?.visitorImageList = visitorImageList
                cell?.visitorCollectionView.reloadData()
                cell?.setup(visitorImageList: visitorImageList, typeVisitor: catagory)
                cell?.visitorCollectionView.reloadData()
                cell?.visitorCollectionView.isScrollEnabled = false
            }
            
            return cell ?? UICollectionViewCell()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == noticeCollectionView {
            return CGSize(width: 220, height: collectionView.frame.size.height)
        }else{
            if let data = visitorData?.keys, let value = visitorData?.values{
                let arrayOfValue = Array(value)
                let visitorImageList = arrayOfValue[indexPath.row]
                let data1 = Array(data)
                let catagory = data1[indexPath.row]
                
                let halfRound = 30
                let Round = 60
                
                if catagory == "Daily Helper" {
                    if (visitorImageList.count != 1) {
                        let countValue = ((visitorImageList.count-1)*halfRound)+Round+65
                        return CGSize(width: CGFloat(countValue), height: collectionView.frame.size.height)
                    }else{
                        let countValue = ((visitorImageList.count-1)*halfRound)+Round+65
                        return CGSize(width: CGFloat(countValue), height: collectionView.frame.size.height)
                    }
                }else if catagory == "Delivery"{
                    if (visitorImageList.count != 1) {
                        let countValue = ((visitorImageList.count-1)*halfRound)+Round+41
                        return CGSize(width: CGFloat(countValue), height: collectionView.frame.size.height)
                    }else{
                        let countValue = ((visitorImageList.count-1)*halfRound)+Round+41
                        return CGSize(width: CGFloat(countValue), height: collectionView.frame.size.height)
                    }
                }else if catagory == "Vendor"{
                    if (visitorImageList.count != 1) {
                        let countValue = ((visitorImageList.count-1)*halfRound)+Round+41
                        return CGSize(width: CGFloat(countValue), height: collectionView.frame.size.height)
                    }else{
                        let countValue = ((visitorImageList.count-1)*halfRound)+Round+41
                        return CGSize(width: CGFloat(countValue), height: collectionView.frame.size.height)
                    }
                }else if catagory == "Guest" {
                    if (visitorImageList.count != 1) {
                        let countValue = ((visitorImageList.count-1)*halfRound)+Round+28
                        return CGSize(width: CGFloat(countValue), height: collectionView.frame.size.height)
                    }else{
                        let countValue = ((visitorImageList.count-1)*halfRound)+Round+28
                        return CGSize(width: CGFloat(countValue), height: collectionView.frame.size.height)
                    }
                }else{
                    if (visitorImageList.count != 1) {
                        let countValue = ((visitorImageList.count-1)*halfRound)+Round+20
                        return CGSize(width: CGFloat(countValue), height: collectionView.frame.size.height)
                    }else{
                        let countValue = ((visitorImageList.count-1)*halfRound)+Round+20
                        return CGSize(width: CGFloat(countValue), height: collectionView.frame.size.height)
                    }
                }
            }else{
                return CGSize(width: 0, height: 0)
            }
        }
    }
}




extension DashBoardController {
    
    func showWidgetPopup(){
        
        removeWidgetPopUp()
        removeMyHouse()
        let blurEffect = UIBlurEffect(style: .dark)
        self.blurredEffectView = UIVisualEffectView(effect: blurEffect)
        self.blurredEffectView?.frame = UIScreen.main.bounds
        
        self.view.addSubview(blurredEffectView!)
        self.view.bringSubviewToFront(tabbarView)
        self.view.bringSubviewToFront(plusBtn)
        
        blurredEffectView?.contentView.setClickListener { [weak self] in
            self?.swipeDown()
        }
        UIView.transition(with: self.plusBtn,
                          duration: 0.5,
                          options: .curveEaseIn,
                          animations: { [weak self] in
                            self?.plusBtn.image = UIImage(named: "PlusBtnRotate")
                          }, completion: nil)
        
        tabbarWidget = tabbarWidgetView().loadNib() as? tabbarWidgetView
        self.blurredEffectView?.contentView.addSubview(tabbarWidget!)
        
        [tabbarWidget?.VisitorBackView,tabbarWidget?.visitorBgView,tabbarWidget?.newInviteView,tabbarWidget?.newEasyPassView].forEach { view in
            view?.isHidden = false
        }
        if !isShowVisitors {
            tabbarWidget?.VisitorBackView.isHidden = true
            
            [tabbarWidget?.VisitorBackView,tabbarWidget?.visitorBgView,tabbarWidget?.newInviteView,tabbarWidget?.newEasyPassView].forEach { view in
                view?.isHidden = true
            }
            
        }
        
        var height = 486
        if UserDefaults.isAdmin == 0 {
            height = 300
            tabbarWidget?.widgetCurveView.image = UIImage(named: "widgetViewSmall")
            tabbarWidget?.noticeBoardBgView.isHidden = true
        }else{
            tabbarWidget?.widgetCurveView.image = UIImage(named: "widgetView")
            height = 369
            tabbarWidget?.noticeBoardBgView.isHidden = false
        }
        
        tabbarWidget?.layoutAnchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: tabbarView.frame.size.height/2+3, paddingRight: 16.5, width: 0, height: CGFloat(height), enableInsets: true)
        tabbarWidget?.animShow()
        
        let slideDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown))
        slideDown.direction = .down
        tabbarWidget?.addGestureRecognizer(slideDown)
        
        tabbarWidget?.newInviteView.setClickListener { [weak self] in
            let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: NewInviteController.self)
            if let model = self?.UnitCusModel {
                controller.UnitCusModel = model
            }
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        tabbarWidget?.newEasyPassView.setClickListener { [weak self] in
            let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: EasyPassCreateController.self)
            if let model = self?.UnitCusModel {
                controller.UnitCusModel = model
            }
            controller.easyPassClick = false
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        tabbarWidget?.noticeBottomView.setClickListener { [weak self] in
            let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: CreateNoticeController.self)
            self?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    func plusDownClicked(){
        tabbarView.bringSubviewToFront(plusBtn)
        UIView.transition(with: self.plusBtn,
                          duration: 0.5,
                          options: .curveEaseOut,
                          animations: { [weak self] in
                            self?.plusBtn.image = UIImage(named: "PlusBtn")
                          }, completion: nil)
        
        tabbarWidget?.animHide()
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.blurredEffectView?.alpha = 0.0
        } completion: { [weak self] (comp) in
            self?.removeWidgetPopUp()
        }
    }
    
    @objc func swipeDown(){
        isPlusClicked = false
        tabbarView.bringSubviewToFront(plusBtn)
        UIView.transition(with: self.plusBtn,
                          duration: 0.5,
                          options: .curveEaseOut,
                          animations: { [weak self] in
                            self?.plusBtn.image = UIImage(named: "PlusBtn")
                          }, completion: nil)
        
        tabbarWidget?.animHide()
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.blurredEffectView?.alpha = 0.0
        } completion: {[weak self] (comp) in
            self?.removeWidgetPopUp()
        }
    }
    
    func removeWidgetPopUp(){
        blurredEffectView?.removeFromSuperview()
        tabbarWidget?.removeFromSuperview()
        tabbarWidget = nil
        blurredEffectView = nil
    }
    
    func addMyHousePopUp(){
        isPlusClicked = false
        self.plusBtn.image = UIImage(named: "PlusBtn")
        removeWidgetPopUp()
        removeMyHouse()
        let blurEffect = UIBlurEffect(style: .dark)
        self.blurredEffectView = UIVisualEffectView(effect: blurEffect)
        self.blurredEffectView?.frame = UIScreen.main.bounds
        self.view.addSubview(blurredEffectView!)
        myhouseViewTab = myHouseView().loadNib() as? myHouseView
        self.blurredEffectView?.contentView.addSubview(myhouseViewTab!)
    
        blurredEffectView?.contentView.setClickListener {
            self.dismissView()
        }
        
        myhouseViewTab?.layoutAnchor(top: nil, left: tabbarView.leftAnchor, bottom: tabbarView.bottomAnchor, right: tabbarView.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 286, enableInsets: true)
        myhouseViewTab?.animShow()
        
        let slideDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissView))
        slideDown.direction = .down
        myhouseViewTab?.addGestureRecognizer(slideDown)
        
        myhouseViewTab?.invoiceBgview.setClickListener { [weak self] in
            let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: Invoice_Payment_ViewController.self)
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        
        myhouseViewTab?.profileBgview.setClickListener { [weak self] in
            let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: ProfileViewController.self)
            self?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    @objc func dismissView() {
        myhouseViewTab?.animHide()
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.blurredEffectView?.alpha = 0.0
        } completion: { [weak self] (comp) in
            self?.removeMyHouse()
            self?.view.layoutIfNeeded()
        }
    }
    
    func removeMyHouse(){
        blurredEffectView?.removeFromSuperview()
        myhouseViewTab?.removeFromSuperview()
        myhouseViewTab = nil
        blurredEffectView = nil
    }
}




extension DashBoardController: SideMenuNavigationControllerDelegate {
    
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Appearing! (animated: \(animated))")
        removeWidgetPopUp()
        removeMyHouse()
        let blurEffect = UIBlurEffect(style: .dark)
        self.blurredEffectView = UIVisualEffectView(effect: blurEffect)
        self.blurredEffectView?.frame = UIScreen.main.bounds
        self.view.addSubview(blurredEffectView!)
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.blurredEffectView?.alpha = 1.0
        } completion: { [weak self] (comp) in
            self?.view.layoutIfNeeded()
        }
    }
    func sideMenuDidAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Appeared! (animated: \(animated))")
    }
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappearing! (animated: \(animated))")
        UIView.animate(withDuration: 0.5) {
            self.blurredEffectView?.alpha = 0.0
        } completion: { (comp) in
            self.blurredEffectView?.removeFromSuperview()
            self.view.layoutIfNeeded()
        }
    }
    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappeared! (animated: \(animated))")
    }
}
