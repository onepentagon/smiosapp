//
//  OnlinePaymentViewController.swift
//  Smartility
//
//  Created by Mani on 5/21/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import AppInvokeSDK
import Toast_Swift
import KRProgressHUD


struct OrderDetails {
    var orderID: String
    var mid: String
    init(orderID: String,mid: String) {
        self.orderID = orderID
        self.mid = mid
    }
}

class OnlinePaymentViewController: UIViewController, KeyboardNotificationsDelegate, AIDelegate {
    
    func openPaymentWebVC(_ controller: UIViewController?) {
        if let vc = controller {
            DispatchQueue.main.async {[weak self] in
                self?.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    func didFinish(with status: AIPaymentStatus, response: [String : Any]) {
        var params = ["order_id": self.order?.orderID ?? ""]
        params.updateValue(community.community_id, forKey: "comm_id")
        params.updateValue(self.order?.mid ?? "", forKey: "mid")
        params.updateValue(UserDefaults.user_id, forKey: "user_id")
        
        Networking.shared.Order_status(url: EndPoint.Order_status, perams: params) { response, error in
            SpinnerClass.shared.removeActivityIndicator()
            if let respo = response, let info = respo["resultInfo"] as? [String:Any], let resultStatus = info["resultStatus"] as? String {
                if resultStatus == "TXN_SUCCESS" {
                    let controller = AppStoryboard.PaymentResult.viewController(viewControllerClass: PaymentSuccessController.self)
                    if let lineItems = respo["lineitems"] as? NSArray {
                        controller.listData = lineItems
                    }
                    controller.amount = "\(countryCurrencyFormate(amount:self.paidAmount ?? 0.0))"
                    controller.orderIDDate = respo["txnDate"] as? String
                    controller.orderIDString = respo["orderId"] as? String
                    self.navigationController?.pushViewController(controller, animated: true)
                }else if resultStatus == "TXN_FAILURE" {
                    let controller = AppStoryboard.PaymentResult.viewController(viewControllerClass: FailureController.self)
                    controller.amount = "\(countryCurrencyFormate(amount:self.paidAmount ?? 0.0))"
                    controller.errorMessageString = info["resultMsg"] as? String
                    controller.pending = false
                    controller.orderIDDate = respo["txnDate"] as? String
                    controller.orderIDString = respo["orderId"] as? String
                    self.navigationController?.pushViewController(controller, animated: true)
                }else if resultStatus == "PENDING" {
                    let controller = AppStoryboard.PaymentResult.viewController(viewControllerClass: FailureController.self)
                    controller.amount = "\(countryCurrencyFormate(amount:self.paidAmount ?? 0.0))"
                    controller.errorMessageString = info["resultMsg"] as? String
                    controller.pending = true
                    controller.orderIDDate = respo["txnDate"] as? String
                    controller.orderIDString = respo["orderId"] as? String
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
            if let error = error {
                self.showConfirmAlert(title: "", message: error.localizedDescription, buttonTitle: "Ok", buttonStyle: .default) { com in
                    let controller = AppStoryboard.PaymentResult.viewController(viewControllerClass: PaymentTimeoutController.self)
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }
    
    @IBOutlet weak var menuHeight: NSLayoutConstraint!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var backBgView: UIView!
    @IBOutlet weak var totalAmounDueContainer: UIView!
    @IBOutlet weak var totalInvoiceAmtLabel: UILabel!
    @IBOutlet weak var totalInvoiceAmt: UILabel!
    @IBOutlet weak var totalAmountPaidLabel: UILabel!
    @IBOutlet weak var totalAmountPaid: UILabel!
    @IBOutlet weak var totalAmont: UILabel!
    @IBOutlet weak var passDueAmount: UILabel!
    @IBOutlet weak var pasDuePaymentLable: UILabel!
    @IBOutlet weak var TotalAmountDueLabel: UILabel!
    @IBOutlet weak var bottomContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var invoiceTotalContainerView: UIView!
    var editeEnable: Bool?
    var responseNSarray: NSArray?
    var checkBoxList: [Bool]?
    var lastTextEdits: [String]?
    var orginalAmountList: [String]?
    var paidAmount: Double?
    var paymentTextArray =  [String]()
    var selectedIndexPath: IndexPath?
    var Total_invoice_amount = Double()
    var Past_balanced =  Double()
    private var appInvoke : AIHandler = AIHandler()
    var order: OrderDetails?
    var pay_gl_acc_id: String?
    
    
    private lazy var keyboard = KeyboardNotifications(notifications: [.willHide, .willShow], delegate: self)
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboard.isEnabled = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        keyboard.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = infoColor()
        navigationController?.navigationItem.backBarButtonItem?.tintColor = infoColor()
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor: infoColor() ?? UIColor.clear]
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        guard   let userInfo = notification.userInfo as? [String: Any],
                let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        table.contentInset.bottom = keyboardFrame.height
        table.scrollVerticallyToFirstResponderSubview(keyboardFrameHight: keyboardFrame.height)
    }
    func keyboardWillHide(notification: NSNotification) {
        table.contentInset.bottom = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bottomContainerHeight.constant = 0
        
        backBtn.setTitleColor(infoColor(), for: .normal)
        backBtn.layer.borderWidth = 1
        backBtn.layer.borderColor = infoColor()?.cgColor
        backBtn.mk_addTapHandler { [weak self] (back) in
            self?.navigationController?.popViewController(animated: true)
        }
        proceedBtn.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        proceedBtn.backgroundColor = infoColor()
        [proceedBtn,backBtn].forEach { (btns) in
            btns?.layer.cornerRadius = 6
            btns?.layer.masksToBounds = true
        }
        backBgView.setClickListener { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        proceedBtn.setClickListener { [unowned self] in
            self.getMerchantDetails()
        }
        
        checkBoxList = [Bool]()
        lastTextEdits = [String]()
        
        invoiceTotalContainerView.layer.masksToBounds = false
        invoiceTotalContainerView.layer.shadowRadius = 6
        invoiceTotalContainerView.layer.shadowOpacity = 1
        invoiceTotalContainerView.layer.shadowColor = UIColor(red: 0.098, green: 0.098, blue: 0.098, alpha: 0.15).cgColor
        invoiceTotalContainerView.layer.shadowOffset = CGSize(width: 0 , height: -1)
        table.contentInset = UIEdgeInsets(top: -36, left: 0, bottom: 0, right: 0);
        table.separatorStyle = .none
        for i in invoiceTotalContainerView.subviews {
            i.isHidden = true
        }
        KRProgressHUD.showOn(self).show()
        Networking.shared.getJSONArray(URL:EndPoint.getBankCashAccountsLiteByCommId, perams: ["user_id": UserDefaults.user_id,"comm_id":community.community_id]) { (result, erro) in
            KRProgressHUD.dismiss()
            if let result = result {
                print(result)
                let bidx = result.first { dict in
                    if let data = dict as? [String:Any], let accountType = data["bc_acc_type"] as? String {
                        return (accountType == "Bank")
                    }else{
                        return false
                    }
                }as NSArray.Element
                print(bidx)
                if let dict = bidx as? [String:Any], let pay_gl_acc_id = dict["gl_acc_id"] as? Int  {
                    self.pay_gl_acc_id = "\(pay_gl_acc_id)"
                    self.updateTheAmount()
                    for i in self.invoiceTotalContainerView.subviews {
                        i.isHidden = false
                    }
                }else{
                    self.showConfirmAlert(title: "", message: "No bank account configured to perform this transaction", buttonTitle: "Ok", buttonStyle: .default) { com in
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            if let error = erro {
                self.view.makeToast(error.localizedDescription)
            }
        }
        
        view.bringSubviewToFront(menuView)
        menuView.layer.shadowColor = UIColor(red: 0.049, green: 0.019, blue: 0.167, alpha: 0.2).cgColor
        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowRadius = 1
        menuView.layer.shadowOffset = CGSize(width: 0, height: 1)
        
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
    }
    
    func updateTheAmount(){
        
        if let responseNSarray = responseNSarray {
            
            print(responseNSarray)
            Total_invoice_amount = responseNSarray.filter {
                let rootArray = $0 as? [String:Any]
                let pay_towards = rootArray?["pay_towards"] as? String
                return pay_towards == "I"
            }.map {
                let rootArray = $0 as? [String:Any]
                if let peningAmount = rootArray?["pending_amount"] as? Double {
                    return peningAmount
                }else if let peningAmount = rootArray?["pending_amount"] as? Int {
                    return Double(peningAmount)
                }
                return 0.0
            }.reduce(0) { $0 + $1 }
            
            Past_balanced = responseNSarray.filter {
                let rootArray = $0 as? [String:Any]
                let pay_towards = rootArray?["pay_towards"] as? String
                return pay_towards != "I"
            } .map {
                let rootArray = $0 as? [String:Any]
                if let peningAmount = rootArray?["pending_amount"] as? Double {
                    return peningAmount
                }else if let peningAmount = rootArray?["pending_amount"] as? Int {
                    return Double(peningAmount)
                }
                return 0.0
            }.reduce(0) { $0 + $1 }
            
            if self.Total_invoice_amount != 0 && self.Past_balanced != 0 {
                self.totalAmounDueContainer.backgroundColor = UIColor(hex: "#F2F2F2")
                self.totalInvoiceAmtLabel.text = "TOTAL INVOICE AMOUNT"
                self.totalInvoiceAmt.text = "\(countryCurrencyFormate(amount:self.Total_invoice_amount))"
                
                self.passDueAmount.text = "\(countryCurrencyFormate(amount: Past_balanced))"
                
                if self.Past_balanced < 0 {
                    self.pasDuePaymentLable.text = "PAST OVERPAYMENT"
                    self.pasDuePaymentLable.textColor = UIColor(hex: "27AE60")
                    self.passDueAmount.textColor = UIColor(hex: "27AE60")
                }else if self.Past_balanced > 0 {
                    self.pasDuePaymentLable.text = "PREVIOUS BALANCE"
                    self.pasDuePaymentLable.textColor = UIColor(hex: "EE552F")
                    self.passDueAmount.textColor = UIColor(hex: "EE552F")
                    self.passDueAmount.text = "+ "+countryCurrencyFormate(amount: self.Past_balanced)
                }
                
                self.bottomContainerHeight.constant = 258
            }else{
                self.totalAmounDueContainer.backgroundColor = .white
                self.totalInvoiceAmtLabel.text = ""
                self.pasDuePaymentLable.text = ""
                self.passDueAmount.text = ""
                self.totalInvoiceAmt.text = ""
                self.bottomContainerHeight.constant = 136
            }
            
            totalAmountPaid.textColor = brandColor()
            totalAmountPaidLabel.textColor = brandColor()
            
            let amount = (self.Total_invoice_amount+self.Past_balanced)
            self.totalAmont.text = "\(countryCurrencyFormate(amount: amount))"
            self.totalAmountPaid.text = "\(countryCurrencyFormate(amount:amount))"
            paidAmount = amount
            
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            
        }
        if let data = responseNSarray {
            for i in data {
                let dict = i as? [String:Any]
                if let amount = dict?["pending_amount"] as? Double {
                    paymentTextArray.append(amount.clean)
                    lastTextEdits?.append(amount.clean)
                    checkBoxList?.append(true)
                }
            }
        }
        orginalAmountList = lastTextEdits
        table.delegate = self
        table.dataSource = self
        table.reloadWithAnimation()
    }
    
    
    func getMerchantDetails(){
        
        
        var params = [String:Any]()
        params.updateValue(community.community_id, forKey: "comm_id")
        params.updateValue(self.paidAmount ?? 0.0, forKey: "cons_pay_amount")
        params.updateValue(true, forKey: "is_self_payment")
        params.updateValue(UserDefaults.user_id, forKey: "user_id")
        params.updateValue(UnitDetails.shared.unitName, forKey: "party_name")
        params.updateValue("offline", forKey: "pay_action")
        params.updateValue("R", forKey: "pay_cat")
        
        if let stro = pay_gl_acc_id  {
            params.updateValue(stro, forKey: "pay_gl_acc_id")
        }
        
        params.updateValue(UserDefaults.user_name ,forKey: "pay_from")
        
        if let response = self.responseNSarray, let payment =  response.value(forKey: "payment") as? NSArray {
            for i in 0..<payment.count {
                if let NSdict = payment[i] as? NSArray, let dict = NSdict.firstObject as? [String:Any] {
                    params.updateValue(dict["pay_dt"] as? String ?? "", forKey: "pay_dt")
                    params.updateValue(dict["pay_mode"] as? String ?? "", forKey: "pay_mode")
                    params.updateValue(dict["pay_note"] as? String ?? "", forKey: "pay_note")
                    params.updateValue(dict["tran_ref_no"] as? String ?? "", forKey: "tran_ref_no")
                    params.updateValue(dict["file_name"] as? String ?? "", forKey: "file_name")
                    params.updateValue(dict["file_url"] as? String ?? "", forKey: "file_url")
                }
            }
        }
        
        params.updateValue(UnitDetails.shared.unitID, forKey: "unit_id")
        
        let rootArray = self.responseNSarray?.firstObject as? [String:Any]
        if  let gl_acc_name = rootArray?["gl_acc_name"] as? String, let gl_acc_id = rootArray?["gl_acc_id"] as? Int{
            params.updateValue(gl_acc_name , forKey: "gl_acc_name")
            params.updateValue(gl_acc_id , forKey: "gl_acc_id")
        }else{
            params.updateValue("" , forKey: "gl_acc_name")
            params.updateValue("" , forKey: "gl_acc_id")
        }        
        
        let amountList = self.orginalAmountList?.compactMap(Double.init) ?? [0.0]
        let originalTotalPendingamount = amountList.reduce(0.0) { $0 + $1 }
        params.updateValue(originalTotalPendingamount, forKey: "tot_pending_amount")
        params.updateValue([], forKey: "pay_gl_acc_id_list")
        
        var lineitems = [[String:Any]]()
        if let responseNSarray = self.responseNSarray {
            for anyData in 0..<responseNSarray.count {
                if let keyVal = responseNSarray[anyData] as? [String:Any] {
                    let dueDate = keyVal["due_dt"] as? String ?? ""
                    let gl_acc_id = keyVal["gl_acc_id"] as? Int ?? 0
                    let gl_acc_name = keyVal["gl_acc_name"] as? String ?? ""
                    let inv_amount = keyVal["inv_amount"] as? Double ?? 0.0
                    let inv_dt = keyVal["inv_dt"] as? String ?? ""
                    let inv_no = keyVal["inv_no"] as? String ?? ""
                    let inv_status =  keyVal["inv_status"] as? String ?? ""
                    var payAmount = 0.0
                    if let payAmountString = lastTextEdits?[anyData] {
                        payAmount = Double(payAmountString) ?? 0.0
                    }
                    let pay_desc = keyVal["pay_desc"] as? String ?? ""
                    let pay_status = keyVal["pay_status"] as? String ?? ""
                    let pay_towards = keyVal["pay_towards"] as? String ?? ""
                    let pending_amount = keyVal["pending_amount"] as? Double ?? 0.0
                    let source_ref_id = keyVal["source_ref_id"] as? Int ?? 0
                    let tot_pay_amount = keyVal["tot_pay_amount"] as? Double ?? 0.0
                    
                    var itemsAdd = [String:Any]()
                    itemsAdd.updateValue(dueDate, forKey: "due_dt")
                    itemsAdd.updateValue(gl_acc_id, forKey: "gl_acc_id")
                    itemsAdd.updateValue(gl_acc_name, forKey: "gl_acc_name")
                    itemsAdd.updateValue(inv_amount, forKey: "inv_amount")
                    itemsAdd.updateValue(inv_dt, forKey: "inv_dt")
                    itemsAdd.updateValue(inv_no, forKey: "inv_no")
                    itemsAdd.updateValue(inv_status, forKey: "inv_status")
                    itemsAdd.updateValue(payAmount, forKey: "pay_amount")
                    itemsAdd.updateValue(pay_desc, forKey: "pay_desc")
                    itemsAdd.updateValue(pay_status, forKey: "pay_status")
                    itemsAdd.updateValue(pay_towards, forKey: "pay_towards")
                    itemsAdd.updateValue(pending_amount, forKey: "pending_amount")
                    itemsAdd.updateValue(source_ref_id, forKey: "source_ref_id")
                    itemsAdd.updateValue(tot_pay_amount, forKey: "tot_pay_amount")
                    lineitems.append(itemsAdd)
                }
            }
        }
        params.updateValue(lineitems , forKey: "lineitems")
        print(params)
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: params,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            print("JSON string = \(theJSONText!)")
        }
        
        SpinnerClass.shared.createSpinnerView(controller: self)
        Networking.shared.createPayOnline(url: EndPoint.createOnlinePayment, perams: params) { response, error in
            if let response = response {
                print(response)
                let orderID = response["order_id"] as? String ?? ""
                let mid = response["mid"] as? String ?? ""
                let callbackurl = response["callbackurl"] as? String ?? ""
                print(orderID)
                print(mid)
                self.order = OrderDetails(orderID: orderID, mid: mid)
                var params2 = [String:Any]()
                params2.updateValue(UserDefaults.user_id, forKey: "user_id")
                params2.updateValue(community.community_id, forKey: "comm_id")
                params2.updateValue(self.paidAmount ?? 0.0, forKey: "txn_amount")
                params2.updateValue(orderID, forKey: "order_id")
                params2.updateValue(mid, forKey: "mid")
                params2.updateValue(UserDefaults.cust_id, forKey: "cust_id")
                print(params2)
                
                Networking.shared.createInitTransAction(url: EndPoint.createInitTransAction, perams: params2) { response, error in
                    if let response = response {
                        if let responseSuccess = response["resultInfo"] as? [String:Any], (responseSuccess["resultStatus"] as? String ?? "") == "S" {
                            let token = response["txnToken"] as? String ?? ""
                            self.appInvoke.openPaytm(merchantId: self.order?.mid ?? "", orderId: self.order?.orderID ?? "", txnToken: token, amount: "\(self.paidAmount ?? 0.0)", callbackUrl: callbackurl, delegate: self, environment: .production, urlScheme: "Smartility.uts.ios")
                        }else{
                            if let responseSuccess = response["resultInfo"] as? [String:Any] {
                                let resultMessage = (responseSuccess["resultMsg"] as? String ?? "")
                                self.showConfirmAlert(title: "", message: resultMessage, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                            }
                            SpinnerClass.shared.removeActivityIndicator()
                        }
                    }
                    if let error = error {
                        self.showConfirmAlert(title: "", message: error.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                        SpinnerClass.shared.removeActivityIndicator()
                    }
                }
            }
            if let error = error {
                self.showConfirmAlert(title: "", message: error.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                SpinnerClass.shared.removeActivityIndicator()
            }
        }
    }
        
        func refreshPaidAmount(){
            let amountList = self.lastTextEdits?.compactMap(Double.init) ?? [0.0]
            var finalAmount = 0.0
            for i in 0..<amountList.count {
                if (self.checkBoxList?[i] ?? true){
                    finalAmount += amountList[i]
                }
            }
            self.paidAmount = finalAmount
            self.totalAmountPaid.text = "\(countryCurrencyFormate(amount: finalAmount))"
            
            self.proceedBtn.isEnabled = (self.paidAmount ?? 0.0) > 0
            
            if (self.paidAmount ?? 0.0) > 0 {
                self.proceedBtn.alpha = 1.0
            }else{
                self.proceedBtn.alpha = 0.6
            }
        }
    }
    
    extension OnlinePaymentViewController : UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return responseNSarray?.count ?? 0
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "invoiceEditeUpdateCell", for: indexPath) as? invoiceEditeUpdateCell
            if let data = responseNSarray?[indexPath.row] {
                let dict = data as? [String:Any]
                let type = dict?["inv_type"] as? String ?? ""
                let no = dict?["inv_no"] as? String ?? ""
                
                let joinedString = NSMutableAttributedString()
                let attributedString : NSAttributedString = NSAttributedString(string: type, attributes:  [NSAttributedString.Key.foregroundColor : UIColor.black])
                joinedString.append(attributedString)
                if no.count != 0 {
                    let attributedString2 : NSAttributedString = NSAttributedString(string: " ("+"INV# "+no+")", attributes:  [NSAttributedString.Key.foregroundColor : UIColor.gray])
                    joinedString.append(attributedString2)
                }
                cell?.titileLabel.attributedText = joinedString
            }
            
            
            if let bool = checkBoxList?[indexPath.row] {
                cell?.CheckBox.setOn(bool, animated: true)
                if !bool {
                    cell?.invoiceDescLabel.text = "This invoice amount will be excluded in payment"
                    cell?.doneBtnWidth.constant = 0
                    cell?.doneBtn.alpha = 0
                    cell?.editBtn.alpha = 0.0
                }else{
                    cell?.invoiceDescLabel.text = ""
                    cell?.editBtn.alpha = 1.0
                    cell?.doneBtnWidth.constant = 0
                    cell?.doneBtn.alpha = 0.0
                    cell?.editBtn.alpha = 1.0
                }
            }
            
            let amountList = paymentTextArray
            let doubleList = amountList.compactMap(Double.init)
            let doubles = doubleList.map { (value) -> String in
                return String(format: "%.2f", value)
            }
            cell?.textFeildTextEdit.text = doubles[indexPath.row]
            
            cell?.textFeildTextEdit.delegate = self
            cell?.textFeildTextEdit.addDoneButtonOnKeyboard()
            cell?.textFeildTextEdit.autocorrectionType = .no
            cell?.textFeildTextEdit.keyboardType = .decimalPad
            cell?.textFeildTextEdit.keyboardAppearance = .dark
            
            cell?.doneBtn.setTitleColor(.white, for: .normal)
            cell?.textFeildTextEdit.isUserInteractionEnabled = false
            cell?.CheckBox.onTintColor = brandColor()
            cell?.CheckBox.onCheckColor = .white
            cell?.CheckBox.onFillColor = brandColor()
            
            cell?.CheckBox.setClickListener({
                cell?.textFeildTextEdit.textColor = UIColor(hex: "828282")
                cell?.textFeildTextEdit.resignFirstResponder()
                if cell?.CheckBox.on == true {
                    tableView.beginUpdates()
                    cell?.invoiceDescLabel.text = "This invoice amount will be excluded in payment"
                    self.selectedIndexPath = indexPath
                    cell?.doneBtnWidth.constant = 0
                    cell?.doneBtn.alpha = 0
                    cell?.editBtn.alpha = 0
                    self.editeEnable = nil
                    cell?.CheckBox.setOn(false, animated: true)
                    self.checkBoxList?[indexPath.row] = false
                    self.lastTextEdits?[indexPath.row] = "0"
                    
                    tableView.endUpdates()
                }else{
                    tableView.beginUpdates()
                    self.checkBoxList?[indexPath.row] = true
                    cell?.invoiceDescLabel.text = ""
                    self.selectedIndexPath = nil
                    cell?.doneBtnWidth.constant = 0
                    cell?.doneBtn.alpha = 0
                    cell?.editBtn.alpha = 1.0
                    self.editeEnable = true
                    cell?.CheckBox.setOn(true, animated: true)
                    self.lastTextEdits?[indexPath.row] = cell?.textFeildTextEdit.text ?? ""
                    self.paymentTextArray[indexPath.row] = cell?.textFeildTextEdit.text ?? ""
                    tableView.endUpdates()
                }
                
                self.refreshPaidAmount()
                cell?.textFeildTextEdit.isUserInteractionEnabled = false
                UIView.animate(withDuration: 0.5) {
                    cell?.layoutIfNeeded()
                }
            })
            cell?.editBtn.mk_addTapHandler(action: { (btn) in
                cell?.textFeildTextEdit.textColor = infoColor()
                cell?.textFeildTextEdit.isUserInteractionEnabled = true
                cell?.textFeildTextEdit.becomeFirstResponder()
                cell?.doneBtnWidth.constant = 100
                cell?.doneBtn.alpha = 1.0
                self.editeEnable = true
                self.selectedIndexPath = indexPath
                cell?.editBtn.alpha = 0.0
                UIView.animate(withDuration: 0.5) {
                    cell?.layoutIfNeeded()
                }
            })
            cell?.doneBtn.mk_addTapHandler(action: { (btn) in
                cell?.textFeildTextEdit.textColor = UIColor(hex: "828282")
                cell?.textFeildTextEdit.resignFirstResponder()
                cell?.textFeildTextEdit.isUserInteractionEnabled = false
                cell?.doneBtnWidth.constant = 0
                cell?.doneBtn.alpha = 1.0
                cell?.editBtn.alpha = 1.0
                self.editeEnable = false
                self.refreshPaidAmount()
                UIView.animate(withDuration: 0.5) {
                    cell?.layoutIfNeeded()
                }
            })
            return cell ?? UITableViewCell()
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            return setupLabel(tableView: tableView, title: "Online Payment for "+UnitDetails.shared.unitName.uppercased())
        }
        
        func setupLabel(tableView: UITableView, title: String)->UIView?{
            var headerView: UIView?
            headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
            var label: UILabel?
            label = UILabel()
            headerView?.addSubview(label!)
            label?.layoutAnchor(top: nil, left: headerView?.leftAnchor, bottom: nil, right: label?.rightAnchor, centerX: headerView?.centerXAnchor, centerY: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 40, enableInsets: true)
            headerView?.backgroundColor = .clear
            label?.backgroundColor = .clear
            label?.textAlignment = .left
            label?.text = title
            label?.textColor = UIColor(hex: "#333333")
            label?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            return headerView
        }
        
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
            if let selectedIndexPath = selectedIndexPath {
                if let cell = table.cellForRow(at: selectedIndexPath) as? invoiceEditeUpdateCell {
                    if textField == cell.textFeildTextEdit {
                        var str:NSString = textField.text! as NSString
                        str = str.replacingCharacters(in: range, with: string) as NSString
                        let arrayOfString = str.components(separatedBy: ".")
                        if arrayOfString.count > 2 {
                            return false
                        }
                        if !["1","2","3","4","5","6","7","8","9","0","","."].contains(string) {
                            return false
                        }
                        lastTextEdits?[selectedIndexPath.row] = str as String
                        self.paymentTextArray[selectedIndexPath.row] = str as String
                    }
                }
            }
            return true
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 40
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
        
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            print("ScrollDid")
            selectedIndexPath = nil
            editeEnable = false
            view.endEditing(true)
        }
    }
