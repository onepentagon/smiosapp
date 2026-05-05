//
//  PaymentHistoryController.swift
//  Smartility
//
//  Created by Mani on 2/17/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit

class PaymentHistoryController: UIViewController {
    
    @IBOutlet weak var closingBox: UIView!
    @IBOutlet weak var closeAmount: UILabel!
    @IBOutlet weak var historyTable: UITableView!
    @IBOutlet weak var donwloadAccStmBtn: UIButton!
    
    var dimView: UIVisualEffectView?
    var invoicePopView = invoicePopUp().loadNib() as? invoicePopUp
    var paymentPopView = PaymentShapView().loadNib() as? PaymentShapView
    
    var response: NSArray?
    var responseData: [String:Any]?
    var leftData = ""
    var paid = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        donwloadAccStmBtn.setTitleColor(infoColor(), for: .normal)
        donwloadAccStmBtn.layer.cornerRadius = 6
        donwloadAccStmBtn.layer.masksToBounds = true
        donwloadAccStmBtn.layer.borderWidth = 1.0
        donwloadAccStmBtn.layer.borderColor = infoColor()?.cgColor
        
        historyTable.register(UINib(nibName: "PaymentRightCell", bundle: .main), forCellReuseIdentifier: "PaymentRightCell")
        historyTable.register(UINib(nibName: "invoiceLeftCell", bundle: .main), forCellReuseIdentifier: "invoiceLeftCell")
        historyTable.showsVerticalScrollIndicator = false
        historyTable.showsHorizontalScrollIndicator = false        
        
        historyTable.tableFooterView = nil
        historyTable.separatorStyle = .none
        historyTable.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: historyTable.frame.width, height: 0))
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("LoadingPaymentHistory"), object: nil, queue: .main) { (notify) in
            if let userInfoDate = notify.userInfo as? [String:String] {
                self.apiRequest(formDate: userInfoDate["from_dt"],endDate: userInfoDate["to_dt"])
            }
        }
    }
    
    
    func apiRequest(formDate: String?, endDate: String?){
        var perams = [String:Any]()
        perams.updateValue(UserDefaults.cust_id, forKey: "cust_id")
        perams.updateValue(community.community_id, forKey: "comm_id")
        perams.updateValue(formDate ?? "", forKey: "from_dt")
        perams.updateValue(endDate ?? "", forKey: "to_dt")
        perams.updateValue(UnitDetails.shared.unitID, forKey: "unit_id")
        perams.updateValue(UserDefaults.user_id, forKey: "user_id")
        perams.updateValue(UnitDetails.shared.unitID, forKey: "unit_id_list")
        
        
        
        
        
                
        self.historyTable.delegate = nil
        self.historyTable.dataSource = nil
        self.historyTable.reloadData()
        self.historyTable.showActivityIndicator()
        Networking.shared.getAccStmtByUnitId(perams: perams) { (result, error) in
            self.response = result
            if let result = result {
                print(result)
                let debit = result.map {
                    if let amount = $0 as? [String:Any] , let double = amount["debit_amount"] as? Double{
                        return double
                    }
                    return 0.0
                }.reduce(0.0, +)
                
                let crdit = result.map {
                    if let amount = $0 as? [String:Any] , let double = amount["credit_amount"] as? Double{
                        return double
                    }
                    return 0.0
                }.reduce(0.0, +)
                                
                let amount = debit-crdit
                self.closeAmount.text = countryCurrencyFormate(amount: amount)
                NotificationCenter.default.post(name: NSNotification.Name("ShowNoDues"), object: nil, userInfo: ["NoDues":"Payment"])
            }else{
                NotificationCenter.default.post(name: NSNotification.Name("ShowNoDues"), object: nil, userInfo: ["NoDues":"NoPayment"])
            }            
            self.leftData = ""
            self.historyTable.isUserInteractionEnabled = true
            self.historyTable.hideActivityIndicator()
            self.historyTable.delegate = self
            self.historyTable.dataSource = self            
            self.historyTable.reloadWithAnimation()
        }
    }
    override func viewDidLayoutSubviews() {
        closingBox.layer.masksToBounds = false
        closingBox.layer.shadowRadius = 6
        closingBox.layer.shadowOpacity = 1
        closingBox.layer.shadowColor = UIColor(red: 0.098, green: 0.098, blue: 0.098, alpha: 0.15).cgColor
        closingBox.layer.shadowOffset = CGSize(width: 0 , height: -1)
    }
}
extension PaymentHistoryController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = dimView {
            if leftData == "left" {
                if paid == "Paid" {
                    return 3
                }else{
                    return 2
                }
            }else{
                return 1
            }
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = dimView {
            if leftData == "left" {
                if section == 0 {
                    let invoiceDetailsArray = responseData?["detail"] as? NSArray
                    return invoiceDetailsArray?.count ?? 0
                }else if section == 1{
                    let paymentDetails = responseData?["payment"] as? NSArray
                    return paymentDetails?.count ?? 0
                }else{
                    return 1
                }
            }else{
                let paymentDetails = responseData?["lineitems"] as? NSArray
                return paymentDetails?.count ?? 0
            }
        }else{
            if let result =  response, result.count != 0 {
                return result.count
            }
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let _ = dimView {
            if leftData == "left" {
                if indexPath.section == 0 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "invoicePopUpDetailsCell", for: indexPath) as? invoicePopUpDetailsCell else { return UITableViewCell() }
                    let invoiceDetailsArray = responseData?["detail"] as? NSArray
                    if let data = invoiceDetailsArray?[indexPath.row] as? [String:Any]{
                        
                        cell.dueTitleLabel.text = data["line_desc"] as? String
                        cell.dueAmount.text = countryCurrencyFormate(amount: data["line_amount"] as? Double ?? 0.0)
                        cell.dateFromT0.text = ""                                                
                        let dataT = data["line_sub_desc"] as? String
                        cell.dueDesc.text = dataT
                    }
                    
                    
                    return cell
                }else if indexPath.section == 1{
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "invoicePaymentCell", for: indexPath) as? invoicePaymentCell else { return UITableViewCell() }
                    let paymentDetails = responseData?["payment"] as? NSArray
                    if let data = paymentDetails?[indexPath.row] as? [String:Any]{
                        var amountValue = ""
                        amountValue = countryCurrencyFormate(amount: data["pay_amount"] as? Double ?? 0.0)
                        let pay_dt = data["pay_dt"] as? String ?? ""
                        let from = timeConversion12(time24: pay_dt, formate: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormate: "dd MMM yyyy")
                        let dataText = "Paid \(amountValue) on \(from)"
                        
                        let paidStatus = data["pay_status"] as? String ?? ""
                        cell.editeBtn.setTitleColor(brandColor(), for: .normal)
                        cell.editeBtn.alpha = 0
                        if paidStatus == "Rejected" {
                            let rej_reason = data["rej_reason"] as? String ?? ""
                            cell.paidDescLabel.text = "Paid \(amountValue) on \(from) (Rejected with reason \"\(rej_reason)\""
                            cell.paidDescLabel.textColor = UIColor(hex: "#f09952")
                            cell.paidImageView.image = UIImage(named: "Rejected")
                            cell.editeBtn.alpha = 1
                        }else if paidStatus == "Pending Receipt"{
                            cell.paidDescLabel.textColor = UIColor(hex: "#27AE60")
                            cell.paidDescLabel.text = dataText+" ("+paidStatus+")"
                            cell.paidImageView.image = UIImage(named: "Pending")
                            cell.paidDescLabel.textColor = UIColor(hex: "#f09952")
                            cell.editeBtn.alpha = 1
                        }else{
                            cell.editeBtn.alpha = 0
                            cell.paidDescLabel.textColor = UIColor(hex: "#27AE60")
                            cell.paidDescLabel.text = dataText
                            cell.paidImageView.image = UIImage(named: "checkBox")
                        }
                    }
                    
                    cell.editeBtn.mk_addTapHandler(action: { (btn) in
                        UIView.animate(withDuration: 0.5) {
                            self.dimView?.alpha = 0.0
                            self.invoicePopView?.alpha = 0.0
                        } completion: { (action) in
                            self.invoicePopView?.removeFromSuperview()
                            self.dimView?.removeFromSuperview()
                            self.dimView = nil
                            self.invoicePopView = nil
                        }
                        let paymentDetails = self.responseData?["payment"] as? NSArray
                        if let data = paymentDetails?[indexPath.row] as? [String:Any]{
                            let contrller = AppStoryboard.Dashboard.viewController(viewControllerClass: EditRemoveInvoiceController.self)
                            contrller.transID = "\(data["pay_id"] as? Int ?? 0)"
                            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                            self.navigationController?.pushViewController(contrller, animated: true)
                        }
                    })
                    
                    return cell
                }else{
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaidImageCell", for: indexPath) as? PaidImageCell else { return UITableViewCell() }
                    return cell
                }
            }else{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentReceiptCell", for: indexPath) as? PaymentReceiptCell else { return UITableViewCell() }
                if let paymentDetails = responseData?["lineitems"] as? NSArray {
                    let data = paymentDetails[indexPath.row] as? [String:Any]
                    cell.amountDesc.text = countryCurrencyFormate(amount: data?["pay_amount"] as? Double ?? 0.0)
                    cell.descLabel.text = data?["pay_desc"] as? String
                    cell.amountDesc.textColor = UIColor(hex: "4F4F4F")
                    cell.descLabel.textColor = UIColor(hex: "4F4F4F")
                    cell.leadingConstraint.constant = 0
                    cell.checkBoxImage.isHidden = true
                    
                }
                return cell
            }
        }else{
            if let data = response?[indexPath.row] as? [String:Any]{
                if let doubleAm = data["debit_amount"] as? Double {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "invoiceLeftCell", for: indexPath) as? invoiceLeftCell
                    cell?.invoiceTitle.text = data["trans_desc"] as? String
                    cell?.invoiceAmount.text = "\(countryCurrencyFormate(amount: doubleAm))"
                    cell?.invoiceNo.text = "\((data["trans_no"] as? String ?? "").count != 0 ? "#": "")"+(data["trans_no"] as? String ?? "")
                    let dateFor = DateFormatter()
                    dateFor.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    if let trans_dt = data["trans_dt"] as? String {
                        cell?.invoiceDate.text =  dateFor.date(from: trans_dt)?.toString(dateFormat: "dd MMM yyyy")
                    }
                      
                    return cell!
                    
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentRightCell", for: indexPath) as? PaymentRightCell
                    let title = data["trans_desc"] as? String ?? ""
                    let transferMode = data["trans_mode"] as? String ?? ""
                    let mode = transferMode == "" ? "" : " (\(transferMode))"
                    let PendingReceipt = data["status"] as? String ?? ""
                    if PendingReceipt == "Pending Receipt" {
                        cell?.paymentLabel.text =  "Pending"
                        cell?.edieBtn.alpha = 1.0
                    }else{
                        cell?.paymentLabel.text = ""
                        cell?.edieBtn.alpha = 0.0
                    }
                    
                    cell?.paymentTitle.numberOfLines = 2
                    cell?.paymentTitle.text = title+mode
                    if let doubleAm = data["credit_amount"] as? Double {
                        cell?.paymentAmount.text = "\(countryCurrencyFormate(amount: doubleAm))"
                    }
                    cell?.paymentNo.text = "\((data["trans_no"] as? String ?? "").count != 0 ? "#": "")"+(data["trans_no"] as? String ?? "")
                    let dateFor = DateFormatter()
                    dateFor.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    if let trans_dt = data["trans_dt"] as? String {
                        cell?.paymentDate.text =  dateFor.date(from: trans_dt)?.toString(dateFormat: "dd MMM yyyy")
                    }
                    
                    cell?.edieBtn.mk_addTapHandler(action: { (action) in
                        let contrller = AppStoryboard.Dashboard.viewController(viewControllerClass: EditRemoveInvoiceController.self)
                        contrller.transID = data["trans_id"] as? String ?? ""                        
                        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                        self.navigationController?.pushViewController(contrller, animated: true)
                    })                    
                    return cell!
                }
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let _ = dimView {
            if leftData == "left" {
                if section == 0 {
                    return 0
                }else if section == 1 {
                    return 20
                }else{
                    return 0
                }
            }
            return 0
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let _ = dimView {
            if leftData == "left" {
                if indexPath.section == 0 {
                    return 50
                }else if indexPath.section == 1{
                    return 20
                }else{
                    if paid == "Paid" {
                        return 80
                    }else{
                        return 0
                    }
                }
            }else{
                return 20
            }
        }else{
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = dimView {
            
            if let data = response?[indexPath.row] as? [String:Any]{
                let trans_type = data["trans_type"] as? String ?? ""
                if trans_type == "Invoice" {
                    UIView.animate(withDuration: 0.5) {
                        self.dimView?.alpha = 0.0
                        self.invoicePopView?.alpha = 0.0
                        self.invoicePopView?.layoutIfNeeded()
                    } completion: { (action) in
                        self.invoicePopView?.removeFromSuperview()
                        self.dimView?.removeFromSuperview()
                        self.dimView = nil
                        self.invoicePopView = nil
                    }
                }else{
                    UIView.animate(withDuration: 0.5) {
                        self.dimView?.alpha = 0.0
                        self.paymentPopView?.alpha = 0.0
                        self.paymentPopView?.layoutIfNeeded()
                    } completion: { (action) in
                        self.paymentPopView?.removeFromSuperview()
                        self.dimView?.removeFromSuperview()
                        self.dimView = nil
                        self.paymentPopView = nil
                    }
                }
            }
        }else{
            if let data = response?[indexPath.row] as? [String:Any]{
                let trans_type = data["trans_type"] as? String ?? ""
                if trans_type == "Invoice" {
                    let cell = tableView.cellForRow(at: indexPath) as? invoiceLeftCell
                    cell?.activityIndicator.startAnimating()
                    tableView.isUserInteractionEnabled = false
                    let invID = data["trans_id"] as? String ?? ""
                    self.leftData = "left"
                    paid = data["status"] as? String ?? ""
                    Networking.shared.GetInvoiceByInvId(perams: ["inv_id":invID,"user_id":UserDefaults.user_id,"unit_id":UnitDetails.shared.unitID,"comm_id":community.community_id]) { (result, error) in
                        if let error = error {
                            cell?.activityIndicator.stopAnimating()
                            self.historyTable.isUserInteractionEnabled = true
                            getTopWindow()?.rootViewController?.showConfirmAlert(title: "", message: error.localizedDescription, buttonTitle: "Ok", buttonStyle: .cancel, confirmAction: nil)
                        }else{
                            self.responseData = result
                            self.historyTable.isUserInteractionEnabled = true
                            cell?.activityIndicator.stopAnimating()
                            self.showTheInvoiceBlurView(response: result)
                        }
                    }
                }else if trans_type == "Payment" {
                    self.leftData = "Right"
                    let cell = tableView.cellForRow(at: indexPath) as? PaymentRightCell
                    cell?.activityIndicator.startAnimating()
                    tableView.isUserInteractionEnabled = false
                    let invID = data["trans_id"] as? String ?? ""
                    Networking.shared.getPaymentByPayId(perams: ["pay_id":invID,"user_id":UserDefaults.user_id,"comm_id":community.community_id,"unit_id":UnitDetails.shared.unitID]) { (result, error) in
                        if let error = error {
                            cell?.activityIndicator.stopAnimating()
                            self.historyTable.isUserInteractionEnabled = true
                            getTopWindow()?.rootViewController?.showConfirmAlert(title: "", message: error.localizedDescription, buttonTitle: "Ok", buttonStyle: .cancel, confirmAction: nil)
                        }else{
                            self.responseData = result
                            self.historyTable.isUserInteractionEnabled = true
                            cell?.activityIndicator.stopAnimating()
                            self.showThePaymentBlurView(response: result)
                        }
                    }
                }
            }
        }
    }
    
    func showThePaymentBlurView(response: [String:Any]?){
        
        let blurEffect = UIBlurEffect(style: .dark)
        dimView = UIVisualEffectView(effect: blurEffect)    // Global variable
        dimView?.frame = UIScreen.main.bounds
        dimView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        guard let view = getTopWindow()?.rootViewController?.view else { return }
        view.addSubview(dimView!)
        paymentPopView = PaymentShapView().loadNib() as? PaymentShapView
        dimView?.contentView.addSubview(paymentPopView!)
        
        let height = (response?["lineitems"] as? NSArray)?.count ?? 0
        
        
        var heightFor = CGFloat()
        if let paidStatus = response?["pay_status"] as? String {
             if paidStatus == "Pending Receipt"{
                heightFor = CGFloat(300+height*20)
                paymentPopView?.downloadReceipt.alpha = 0.0
                paymentPopView?.downloadReceiptHeight.constant = 0.0
                paymentPopView?.downloadReceiptBottomConstraint.constant = 0.0
                paymentPopView?.pendingReceiptLabel.alpha = 1.0
             }else{
                heightFor = CGFloat(360+height*20)
                paymentPopView?.downloadReceiptHeight.constant = 48.0
                paymentPopView?.downloadReceiptBottomConstraint.constant = 26.0
                paymentPopView?.downloadReceipt.alpha = 1.0
                paymentPopView?.pendingReceiptLabel.alpha = 0
             }
        }else{
            heightFor = CGFloat(226+height*20)
            paymentPopView?.downloadReceiptBottomConstraint.constant = 0.0
            paymentPopView?.downloadReceiptHeight.constant = 0.0
            paymentPopView?.downloadReceipt.alpha = 0.0
            paymentPopView?.pendingReceiptLabel.alpha = 0
        }
        
        
        paymentPopView?.layoutAnchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: view.centerXAnchor, centerY: view.centerYAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: heightFor, enableInsets: true)
        self.dimView?.alpha = 0.0
        self.paymentPopView?.alpha = 0.0
                
        self.paymentPopView?.tableHeight.constant = CGFloat(height*20)
        
        paymentPopView?.center.y = -50
        UIView.animate(withDuration: 1.5, delay: 0.2, options: .curveEaseInOut, animations: {
            self.paymentPopView?.center.y = 0
        }, completion: nil)
                
        let paidID = response?["pay_id"] as? Double ?? 0.0
        paymentPopView?.receiptTitle.text = "Receipt #\(paidID.clean)".uppercased()        
        paymentPopView?.receiptAmount.text = countryCurrencyFormate(amount: response?["cons_pay_amount"] as? Double ?? 0.0)
            
        let dateFor = DateFormatter()
        dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFor.timeZone = .current
        if let pay_dt = response?["pay_dt"] as? String {
            paymentPopView?.receiptDateFromTO.text =  dateFor.date(from: pay_dt)?.toString(dateFormat: "dd MMM yyyy")
        }
        
        paymentPopView?.paidByName.text = response?["pay_from"] as? String
        paymentPopView?.paidMode.text = response?["pay_mode"] as? String
        paymentPopView?.paymentDesc.text = response?["pay_note"] as? String
        
        let notes = response?["pay_note"] as? String ?? ""
        if notes == "" {
            paymentPopView?.iconDesc.alpha = 0.0
            paymentPopView?.paymentDesc.text = ""
        }else{
            paymentPopView?.iconDesc.alpha = 1.0
            paymentPopView?.paymentDesc.text = notes
        }
        paymentPopView?.transferNo.text = response?["tran_ref_no"] as? String
        
        
        paymentPopView?.receiptTable.register(UINib(nibName: "PaymentReceiptCell", bundle: .main), forCellReuseIdentifier: "PaymentReceiptCell")
        paymentPopView?.receiptTable.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: paymentPopView!.receiptTable.frame.width, height: 0))
        paymentPopView?.receiptTable.delegate = self
        paymentPopView?.receiptTable.dataSource = self
        paymentPopView?.receiptTable.separatorStyle = .none
        
        paymentPopView?.downloadReceipt.mk_addTapHandler(action: { (btn) in
            if let invID = self.responseData?["pay_id"] as? Double{
                let perams = ["pay_id":invID, "convert_to_pdf":true,"user_id":UserDefaults.user_id,"comm_id":community.community_id,"unit_id":UnitDetails.shared.unitID] as [String : Any]
                btn.loadingIndicator(true, .black, "")
                Networking.shared.getPaymentsForPDFByPayID(perams: perams) { (response, error) in
                    if let response = response {
                        btn.loadingIndicator(false, .black, "Download Invoice")
                        let controller =  AppStoryboard.Dashboard.viewController(viewControllerClass:InvoiceShowPDFViewController.self)
                        controller.htmlString = response
                        UIView.animate(withDuration: 0.5) {
                            self.dimView?.alpha = 0.0
                            self.invoicePopView?.alpha = 0.0
                        } completion: { (action) in
                            self.invoicePopView?.removeFromSuperview()
                            self.dimView?.removeFromSuperview()
                            self.dimView = nil
                            self.invoicePopView = nil
                            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                            self.navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = infoColor()
                            self.navigationController?.navigationItem.backBarButtonItem?.tintColor = infoColor()
                            self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor: infoColor() ?? UIColor.clear]
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
                    }
                    if let error = error {
                        self.showConfirmAlert(title: "", message: error.localizedDescription, buttonTitle: "Okey", buttonStyle: .cancel, confirmAction: nil)
                    }
                }
            }
        })
        
        UIView.animate(withDuration: 0.5) {
            self.dimView?.alpha = 1.0
            self.paymentPopView?.alpha = 1.0
            self.paymentPopView?.layoutIfNeeded()
        }
        getTopWindow()?.bringSubviewToFront(dimView!)
        getTopWindow()?.bringSubviewToFront(paymentPopView!)
        
        self.dimView?.contentView.setClickListener {
            UIView.animate(withDuration: 0.5) {
                self.dimView?.alpha = 0.0
                self.paymentPopView?.alpha = 0.0
                self.dimView?.layoutIfNeeded()
                self.paymentPopView?.layoutIfNeeded()
            } completion: { (action) in
                self.paymentPopView?.removeFromSuperview()
                self.dimView?.removeFromSuperview()
                self.dimView = nil
                self.paymentPopView = nil
            }
        }
        
        paymentPopView?.setClickListener {
            UIView.animate(withDuration: 0.5) {
                self.dimView?.alpha = 0.0
                self.paymentPopView?.alpha = 0.0
                self.dimView?.layoutIfNeeded()
                self.paymentPopView?.layoutIfNeeded()
            } completion: { (action) in
                self.paymentPopView?.removeFromSuperview()
                self.dimView?.removeFromSuperview()
                self.dimView = nil
                self.paymentPopView = nil
            }
        }
    }
    
    
    func showTheInvoiceBlurView(response: [String:Any]?){
        let blurEffect = UIBlurEffect(style: .dark)
        dimView = UIVisualEffectView(effect: blurEffect)    // Global variable
        dimView?.frame = UIScreen.main.bounds
        dimView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        guard let view = getTopWindow()?.rootViewController?.view else { return }
        view.addSubview(dimView!)
        invoicePopView = invoicePopUp().loadNib() as? invoicePopUp
        dimView?.contentView.addSubview(invoicePopView!)
        
        let paymentDetails = responseData?["payment"] as? NSArray
        let invoiceDetailsArray = responseData?["detail"] as? NSArray
        let payCount = paymentDetails?.count ?? 0
        let invoiceCount = invoiceDetailsArray?.count ?? 0
        
        var overAllHeight = CGFloat()
        if paid == "Paid" {
            overAllHeight = CGFloat(206+(payCount*20)+(invoiceCount*50)+160)
        }else{
            overAllHeight = CGFloat(206+(payCount*20)+(invoiceCount*50)+100)
        }
        
        
        invoicePopView?.layoutAnchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: view.centerXAnchor, centerY: view.centerYAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: overAllHeight, enableInsets: true)
        self.dimView?.alpha = 0.0
        self.invoicePopView?.alpha = 0.0
        self.invoicePopView?.updateData()
                
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dateFormatt = DateFormatter()
        dateFormatt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatt.calendar = Calendar.current
        dateFormatt.timeZone = TimeZone.current
        dateFormatt.timeZone = TimeZone(abbreviation: "UTC")
                        
        let todayDate = dateFormatt.string(from: Date())
        let today = dateFormatt.date(from: todayDate) ?? Date()
                        
        [invoicePopView?.pastDue,
        invoicePopView?.dueToday,
        invoicePopView?.paritiallyPaid,
        invoicePopView?.unPaid].forEach { (label) in
            label?.backgroundColor = UIColor(hex: "#EE552F")
            label?.textColor = .white
            label?.layer.cornerRadius = 10
            label?.layer.masksToBounds = true
        }
        
        if let date = responseData?["due_dt"] as? String {
            if  let due_date = dateFormatt.date(from: date) {
                let compareResult = today.compare(due_date)
                switch compareResult {
                case .orderedAscending:
                    invoicePopView?.dueToday.isHidden = true
                    invoicePopView?.pastDue.isHidden = true
                    print("Future Date")
                case .orderedDescending:
                    invoicePopView?.dueToday.isHidden = true
                    invoicePopView?.pastDue.isHidden = false
                    print("Earlier Date")
                case .orderedSame:                    
                    let numOfDays = today.daysBetweenDate(toDate: due_date)
                    if numOfDays == 0  {
                        invoicePopView?.dueToday.isHidden = false
                        invoicePopView?.pastDue.isHidden = true
                    }else{
                        invoicePopView?.pastDue.isHidden = false
                        invoicePopView?.dueToday.isHidden = true
                    }
                    print("Today")
                default:
                    print("Today/Null Date Passed")
                    invoicePopView?.dueToday.isHidden = true
                    invoicePopView?.pastDue.isHidden = true
                }
            }
        }
        
        if let inv_status = responseData?["inv_status"] as? String {
            if inv_status == "Partially Paid"{
                invoicePopView?.paritiallyPaid.isHidden = false
            }else{
                invoicePopView?.paritiallyPaid.isHidden = true
            }
            if inv_status == "Unpaid"{
                invoicePopView?.unPaid.isHidden = false
            }else{
                invoicePopView?.unPaid.isHidden = true
            }
        }
                                        
        
        invoicePopView?.billingPeriod.text = ""
        invoicePopView?.invoiceType.text = (response?["inv_type"] as? String)?.uppercased()
        if let amount = response?["inv_amount"] as? Double {
            invoicePopView?.ivoiceAmount.text = countryCurrencyFormate(amount: amount)
        }
        if let no = response?["inv_no"] as? String {
            invoicePopView?.ivoiceNo.text = no
        }
        if paid == "Paid" {
            invoicePopView?.dueDtBtn.select()
        }else{
            invoicePopView?.dueDtBtn.deselect()
        }
                
        invoicePopView?.fromDate.text = timeConversion12(time24: (response?["inv_dt"] as? String) ?? "", formate: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormate: "dd MMM yyyy")
        invoicePopView?.tillDate.text = timeConversion12(time24: (response?["due_dt"] as? String) ?? "", formate: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormate: "dd MMM yyyy")
                
        if let covering_from = response?["covering_from"] as? String, let covering_till = response?["covering_till"] as? String  {
            let from = timeConversion12(time24: covering_from, formate: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormate: "dd MMM yyyy")
            let till = timeConversion12(time24: covering_till, formate: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormate: "dd MMM yyyy")
            
            let attributedQuote = NSMutableAttributedString(string: "Billing Period ", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: "#828282"),NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)])
            let attributedQuote1 = NSMutableAttributedString(string: "\(from) - \(till)", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: "#4F4F4F"),NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)])
            attributedQuote.append(attributedQuote1)
            invoicePopView?.billingPeriod.attributedText = attributedQuote
        }else{
            invoicePopView?.billingPeriod.text = ""
        }
        
        invoicePopView?.table.register(UINib(nibName: "invoicePopUpDetailsCell", bundle: .main), forCellReuseIdentifier: "invoicePopUpDetailsCell")
        invoicePopView?.table.register(UINib(nibName: "invoicePaymentCell", bundle: .main), forCellReuseIdentifier: "invoicePaymentCell")
        invoicePopView?.table.register(UINib(nibName: "PaidImageCell", bundle: .main), forCellReuseIdentifier: "PaidImageCell")
        
        invoicePopView?.downloadInvoiceBtn.mk_addTapHandler(action: { (btn) in
            if let invID = self.responseData?["inv_id"] as? Double{
                let perams = ["inv_id":invID, "convert_to_pdf":true,"comm_id":community.community_id,"user_id":UserDefaults.user_id,"unit_id":UnitDetails.shared.unitID] as [String : Any]
                btn.loadingIndicator(true, .black, "")
                Networking.shared.getInvoiceForPDFByInvID(perams: perams) { (response, error) in
                    if let response = response {
                        btn.loadingIndicator(false, .black, "Download Invoice")
                        let controller =  AppStoryboard.Dashboard.viewController(viewControllerClass:InvoiceShowPDFViewController.self)
                        controller.htmlString = response
                        UIView.animate(withDuration: 0.5) {
                            self.dimView?.alpha = 0.0
                            self.invoicePopView?.alpha = 0.0
                        } completion: { (action) in
                            self.invoicePopView?.removeFromSuperview()
                            self.dimView?.removeFromSuperview()
                            self.dimView = nil
                            self.invoicePopView = nil
                            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                            self.navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = infoColor()
                            self.navigationController?.navigationItem.backBarButtonItem?.tintColor = infoColor()
                            self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor: infoColor() ?? UIColor.clear]
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
                    }
                    if let error = error {
                        self.showConfirmAlert(title: "", message: error.localizedDescription, buttonTitle: "Okey", buttonStyle: .cancel, confirmAction: nil)
                    }
                }
            }
        })
        
        invoicePopView?.table.tableFooterView = nil
        invoicePopView?.table.delegate = self
        invoicePopView?.table.dataSource = self
        invoicePopView?.table.separatorStyle = .none
        
        
        if paid == "Paid" {
            let overAllHeight = CGFloat((payCount*20)+(invoiceCount*50)+80+68)
            invoicePopView?.tableHeight.constant =  overAllHeight
        }else{
            let overAllHeight = CGFloat((payCount*20)+(invoiceCount*50)+68)
            invoicePopView?.tableHeight.constant = overAllHeight
        }
                
        UIView.animate(withDuration: 0.5) {
            self.dimView?.alpha = 1.0
            self.invoicePopView?.alpha = 1.0
            self.invoicePopView?.layoutIfNeeded()
        }
        getTopWindow()?.bringSubviewToFront(dimView!)
        getTopWindow()?.bringSubviewToFront(invoicePopView!)
        
        
        self.dimView?.contentView.setClickListener {
            UIView.animate(withDuration: 0.5) {
                self.dimView?.alpha = 0.0
                self.invoicePopView?.alpha = 0.0
                self.invoicePopView?.layoutIfNeeded()
            } completion: { (action) in
                self.invoicePopView?.removeFromSuperview()
                self.dimView?.removeFromSuperview()
                self.dimView = nil
                self.invoicePopView = nil
            }
        }
        
        invoicePopView?.setClickListener {
            UIView.animate(withDuration: 0.5) {
                self.dimView?.alpha = 0.0
                self.invoicePopView?.alpha = 0.0
                self.invoicePopView?.layoutIfNeeded()
            } completion: { (action) in
                self.invoicePopView?.removeFromSuperview()
                self.dimView?.removeFromSuperview()
                self.dimView = nil
                self.invoicePopView = nil
            }
        }
    }
    
    func timeConversion12(time24:String, formate: String, getFormate: String)->String {
        let formatter = DateFormatter()
        formatter.dateFormat = getFormate
        if let date = dateFromString(dateString: time24, format: formate) {
            let Str_date = formatter.string(from: date)
            return Str_date
        }
        return ""
    }
    
    func dateFromString(dateString:String, format: String)->Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = .current
        if let date = dateFormatter.date(from: dateString) {
            return date
        }else{
            return nil
        }
    }
}


extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var startOfMonth: Date {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        
        return  calendar.date(from: components)!
    }
    
    func isMonday() -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday == 2
    }
}
