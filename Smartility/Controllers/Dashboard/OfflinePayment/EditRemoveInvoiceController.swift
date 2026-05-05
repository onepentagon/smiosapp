//
//  EditRemoveInvoiceController.swift
//  Smartility
//
//  Created by Mani on 3/1/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import DropDown
import Photos
import KRProgressHUD
import Toast_Swift
import GSImageViewerController
import Kingfisher

class EditRemoveInvoiceController: UIViewController {
    
    @IBOutlet weak var offlineTable: UITableView!
    @IBOutlet weak var invoiceTotalContainerView: UIView!
    @IBOutlet weak var UpdateInvoiceBtn: UIButton!
    @IBOutlet weak var DeleteInvoiceBtn: UIButton!
    @IBOutlet weak var totalAmountPaidLabel: UILabel!
    @IBOutlet weak var totalAmountPaid: UILabel!
    private lazy var keyboard = KeyboardNotifications(notifications: [.willHide, .willShow], delegate: self)
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuHeight: NSLayoutConstraint!
    @IBOutlet weak var backBgView: UIView!
    @IBOutlet weak var navigationTitle: UILabel!
    
    
    var ownerShipDropDown = DropDown()
    var bankDetailsDropDown = DropDown()
    var paymentModeDropDown = DropDown()
    var bankAccount = [BankAccount]()
    var ownerShip = [OwnerShip]()
    var paymentDetails = [String]()
    var responseDict: [String:Any]?
    var lineitems: NSArray?
    var transID: String?
    var lastTextEdits: [String]?
    var paymentTextArray =  [String]()
    var file_name = ""
    var file_URL = ""
    var pay_gl_acc_id: Int?
    var feildTopLabel = ["Paid By","Mode","Payment Made to", "Date", "Trans Ref. No.","Note(Optional)"]
    var checkBoxList: [Bool]?
    var imageNameArray: [String] = []
    var imagePicker = UIImagePickerController()
    var selectedIndexPath: IndexPath?
    var editeEnable: Bool?
    var paidAmount: Double?
    var orginalAmountList: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        backBgView.setClickListener {
            self.navigationController?.popViewController(animated: true)
        }
        
        
        navigationTitle.textColor = brandColor()
        
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
               
        
        view.bringSubviewToFront(menuView)
        menuView.layer.shadowColor = UIColor(red: 0.049, green: 0.019, blue: 0.167, alpha: 0.2).cgColor
        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowRadius = 1
        menuView.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        self.tabBarController?.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        invoiceTotalContainerView.alpha = 0.0
        for i in self.invoiceTotalContainerView.subviews {
            i.alpha = 0.0
        }
        self.totalAmountPaidLabel.text = ""
        self.totalAmountPaid.text = ""
        view.bringSubviewToFront(invoiceTotalContainerView)
        
        DeleteInvoiceBtn.setTitleColor(infoColor(), for: .normal)
        DeleteInvoiceBtn.layer.borderWidth = 1
        DeleteInvoiceBtn.layer.borderColor = infoColor()?.cgColor
                
        UpdateInvoiceBtn.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        UpdateInvoiceBtn.backgroundColor = infoColor()
        
        self.title = "Invoice & Payments"
        
        UpdateInvoiceBtn.mk_addTapHandler { (button) in
            print("Update")
            self.updateClicked(button)
        }
        DeleteInvoiceBtn.mk_addTapHandler { (button) in
            print("Delete")
            self.deleteClicked(button)
        }
        for _ in 0..<feildTopLabel.count{
            paymentDetails.append("")
        }
        for i in self.invoiceTotalContainerView.subviews {
            i.isHidden = false
        }
        
        offlineTable.contentInset = UIEdgeInsets(top: -36, left: 0, bottom: 0, right: 0);
        offlineTable.register(UITableViewCell.self, forCellReuseIdentifier: "ImageCell")
        offlineTable.separatorStyle = .none
        prefetchingInformation()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        keyboard.isEnabled = true
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = infoColor()
        navigationController?.navigationItem.backBarButtonItem?.tintColor = infoColor()
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor: infoColor() ?? UIColor.clear]
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewDidLayoutSubviews() {
        
        [UpdateInvoiceBtn,DeleteInvoiceBtn].forEach { (btns) in
            btns?.layer.cornerRadius = 6
            btns?.layer.masksToBounds = true
        }
        
        invoiceTotalContainerView.layer.masksToBounds = false
        invoiceTotalContainerView.layer.shadowRadius = 6
        invoiceTotalContainerView.layer.shadowOpacity = 1
        invoiceTotalContainerView.layer.shadowColor = UIColor(red: 0.098, green: 0.098, blue: 0.098, alpha: 0.15).cgColor
        invoiceTotalContainerView.layer.shadowOffset = CGSize(width: 0 , height: -1)
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
        
        self.UpdateInvoiceBtn.isEnabled = (self.paidAmount ?? 0.0) > 0
        
        if (self.paidAmount ?? 0.0) > 0 {
            self.UpdateInvoiceBtn.alpha = 1.0
        }else{
            self.UpdateInvoiceBtn.alpha = 0.6
        }
    }
}
extension EditRemoveInvoiceController {
    
    func updateClicked(_ button: UIButton){
        let tran_ref_no = String(paymentDetails[4].filter { !" \n\t\r".contains($0) })
        if tran_ref_no.count == 0 {
            offlineTable.scrollToRow(at: IndexPath(row: 4, section: 1), at: .middle, animated: true)
            self.showConfirmAlert(title: "", message: "Please enter Trans. Reference Number", buttonTitle: "Ok", buttonStyle: .default) { (acton) in
                let cell = self.offlineTable.cellForRow(at: IndexPath(row: 4, section: 1)) as? InvoicePayementDetailsCell
                cell?.textFild.becomeFirstResponder()
            }
        }else{
            var params = [String:Any]()
            params.updateValue(community.community_id, forKey: "comm_id")
            params.updateValue(community.community_name, forKey: "comm_name")
            params.updateValue(self.paidAmount ?? 0.0, forKey: "cons_pay_amount")
            params.updateValue(file_name, forKey: "file_name")
            params.updateValue(file_URL, forKey: "file_url")
            params.updateValue(true, forKey: "is_self_payment")
            params.updateValue(UserDefaults.user_id, forKey: "user_id")
            params.updateValue(UnitDetails.shared.unitName, forKey: "party_name")
            params.updateValue("offline", forKey: "pay_action")
            params.updateValue("R", forKey: "pay_cat")
            params.updateValue(paymentDetails[3], forKey: "pay_dt")
            params.updateValue(paymentDetails[0], forKey: "pay_from")
            params.updateValue(paymentDetails[1], forKey: "pay_mode")
            params.updateValue(paymentDetails[5], forKey: "pay_note")
            

            let gl_acc_id = responseDict?["gl_acc_id"] as? Int
            params.updateValue(gl_acc_id ?? "" , forKey: "gl_acc_id")
            params.updateValue(self.pay_gl_acc_id ?? 0, forKey: "pay_gl_acc_id")
            params.updateValue(tran_ref_no, forKey: "tran_ref_no")
            
            params.updateValue("", forKey: "non_res_id")
            params.updateValue((responseDict?["pay_status"] as? String ?? ""), forKey: "pay_status")
            params.updateValue(paymentDetails[2], forKey: "payment_to_acc")
            params.updateValue((responseDict?["rej_reason"] as? String ?? ""), forKey: "rej_reason")
            params.updateValue((responseDict?["balance_amount"] as? Double ?? 0.0), forKey: "tot_pending_amount")
            params.updateValue(UnitDetails.shared.unitID, forKey: "unit_id")
            params.updateValue(UserDefaults.user_id, forKey: "user_id")
            params.updateValue("", forKey: "vendor_id")
            
            params.updateValue([], forKey: "pay_gl_acc_id_list")
                        
            params.updateValue(transID, forKey: "pay_id")
            
            let amountList = self.orginalAmountList?.compactMap(Double.init) ?? [0.0]
            let originalTotalPendingamount = amountList.reduce(0.0) { $0 + $1 }
            params.updateValue(originalTotalPendingamount, forKey: "tot_pending_amount")
//            
            var lineitems = [[String:Any]]()
            
            if let responseNSarray = self.responseDict {
                if let array = responseNSarray["lineitems"] as? NSArray {
                    for anyData in 0..<array.count {
                        if let keyVa = array[anyData] as? [String:Any] {
                            var itemsAdd = [String:Any]()
                            itemsAdd.updateValue(keyVa["inv_type"] as? String ?? "", forKey: "inv_type")
                            itemsAdd.updateValue(keyVa["inv_no"] as? String ?? "", forKey: "inv_no")
                            itemsAdd.updateValue(lastTextEdits?[anyData] ?? "", forKey: "pay_amount")
                            itemsAdd.updateValue(keyVa["pay_desc"] as? String ?? "", forKey: "pay_desc")
                            itemsAdd.updateValue(keyVa["pay_det_id"] as? Int ?? "", forKey: "pay_det_id")
                            itemsAdd.updateValue(keyVa["pay_id"] as? Int ?? "", forKey: "pay_id")
                            itemsAdd.updateValue(keyVa["pay_towards"] as? String ?? "", forKey: "pay_towards")
                            itemsAdd.updateValue(keyVa["pending_amount"] as? Double ?? "", forKey: "pending_amount")
                            itemsAdd.updateValue(keyVa["source_ref_id"] as? Int ?? "", forKey: "source_ref_id")
                            lineitems.append(itemsAdd)
                        }
                    }
                }
            }
            params.updateValue(lineitems , forKey: "lineitems")
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: params,
                options: []) {
                let theJSONText = String(data: theJSONData, encoding: .ascii)
                print("JSON string = \(theJSONText!)")
            }
            button.loadingIndicator(true, .black, "")
            Networking.shared.paymentUpload(URL: EndPoint.updatePay, perams: params) { (result, error) in
                button.loadingIndicator(false, .black, "Submit")
                if let error = error {
                    self.showConfirmAlert(title: "", message: error.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                }
                if let result = result {
                    print(result)
                    let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: AcknowdgeVc.self)
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }
    
    func deleteClicked(_ button: UIButton){
        let tran_ref_no = String(paymentDetails[4].filter { !" \n\t\r".contains($0) })
        if tran_ref_no.count == 0 {
            offlineTable.scrollToRow(at: IndexPath(row: 4, section: 1), at: .middle, animated: true)
            self.showConfirmAlert(title: "", message: "Please enter Trans. Reference Number", buttonTitle: "Ok", buttonStyle: .default) { (acton) in
                let cell = self.offlineTable.cellForRow(at: IndexPath(row: 4, section: 1)) as? InvoicePayementDetailsCell
                cell?.textFild.becomeFirstResponder()
            }
        }else{
            
            
            let amount = countryCurrencyFormate(amount: (self.paidAmount ?? 0.0))
            let alert = UIAlertController(title: "", message: "Sure, you want to delete the payment of \(amount)?", preferredStyle: .alert)
            
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                var params = [String:Any]()
                params.updateValue(community.community_id, forKey: "comm_id")
                params.updateValue(community.community_name, forKey: "comm_name")
                params.updateValue(self.paidAmount ?? 0.0, forKey: "cons_pay_amount")
                params.updateValue(self.file_name, forKey: "file_name")
                params.updateValue(self.file_URL, forKey: "file_url")
                params.updateValue(true, forKey: "is_self_payment")
                params.updateValue(UserDefaults.user_id, forKey: "user_id")
                params.updateValue(UnitDetails.shared.unitName, forKey: "party_name")
                params.updateValue("offline", forKey: "pay_action")
                params.updateValue("R", forKey: "pay_cat")
                params.updateValue(self.paymentDetails[3], forKey: "pay_dt")
                params.updateValue(self.paymentDetails[0], forKey: "pay_from")
                params.updateValue(self.paymentDetails[1], forKey: "pay_mode")
                params.updateValue(self.paymentDetails[5], forKey: "pay_note")
                
                let gl_acc_id = self.responseDict?["gl_acc_id"] as? Int
                params.updateValue(gl_acc_id ?? "" , forKey: "gl_acc_id")
                params.updateValue(self.pay_gl_acc_id ?? 0, forKey: "pay_gl_acc_id")
                params.updateValue(Int(tran_ref_no) ?? 0, forKey: "tran_ref_no")
                
                params.updateValue("", forKey: "non_res_id")
                params.updateValue((self.responseDict?["pay_status"] as? String ?? ""), forKey: "pay_status")
                params.updateValue(self.paymentDetails[2], forKey: "payment_to_acc")
                params.updateValue((self.responseDict?["rej_reason"] as? String ?? ""), forKey: "rej_reason")
                params.updateValue((self.responseDict?["balance_amount"] as? Double ?? 0.0), forKey: "tot_pending_amount")
                params.updateValue(UnitDetails.shared.unitID, forKey: "unit_id")
                params.updateValue(UserDefaults.user_id, forKey: "user_id")
                params.updateValue("", forKey: "vendor_id")
                params.updateValue(self.transID, forKey: "pay_id")
                var lineitems = [[String:Any]]()
                
                if let responseNSarray = self.responseDict {
                    if let array = responseNSarray["lineitems"] as? NSArray {
                        for anyData in 0..<array.count {
                            if let keyVa = array[anyData] as? [String:Any] {
                                var itemsAdd = [String:Any]()
                                itemsAdd.updateValue(keyVa["inv_type"] as? String ?? "", forKey: "inv_type")
                                itemsAdd.updateValue(keyVa["inv_no"] as? String ?? "", forKey: "inv_no")
                                itemsAdd.updateValue(self.lastTextEdits?[anyData] ?? "", forKey: "pay_amount")
                                itemsAdd.updateValue(keyVa["pay_desc"] as? String ?? "", forKey: "pay_desc")
                                itemsAdd.updateValue(keyVa["pay_det_id"] as? Int ?? "", forKey: "pay_det_id")
                                itemsAdd.updateValue(keyVa["pay_id"] as? Int ?? "", forKey: "pay_id")
                                itemsAdd.updateValue(keyVa["pay_towards"] as? String ?? "", forKey: "pay_towards")
                                itemsAdd.updateValue(keyVa["pending_amount"] as? Double ?? "", forKey: "pending_amount")
                                itemsAdd.updateValue(keyVa["source_ref_id"] as? Int ?? "", forKey: "source_ref_id")
                                lineitems.append(itemsAdd)
                            }
                        }
                    }
                }
                params.updateValue(lineitems , forKey: "lineitems")
                if let theJSONData = try? JSONSerialization.data(
                    withJSONObject: params,
                    options: []) {
                    let theJSONText = String(data: theJSONData, encoding: .ascii)
                    print("JSON string = \(theJSONText!)")
                }
                button.loadingIndicator(true, .black, "")
                Networking.shared.paymentUpload(URL: EndPoint.deletePay, perams: params) { (result, error) in
                    button.loadingIndicator(false, .black, "Delete")
                    if let result = result {
                        if (result as? String) == "Success" {
                            NotificationCenter.default.post(name: NSNotification.Name("UpdateActions"), object: nil)
                            NotificationCenter.default.post(name: NSNotification.Name("LoadingInvoices"), object: nil)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }else if let error = error{
                        self.showConfirmAlert(title: "", message: error.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                    }
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
}

extension EditRemoveInvoiceController {
    func prefetchingInformation(){
        
        [ownerShipDropDown, bankDetailsDropDown, paymentModeDropDown].forEach { (drop) in
            drop.selectionBackgroundColor = .white
            drop.backgroundColor = .white
            drop.cornerRadius = 10
        }
        
        guard let controller = getTopWindow()?.rootViewController else { return }
//        self.paymentDetails[1] = "NEFT/IMPS/RTGS"
//        self.paymentDetails[3] = Date().toString(dateFormat: "yyyy-MM-dd")
        
        let group = DispatchGroup()
        KRProgressHUD.showOn(controller).show()
      
        self.orginalAmountList = [String]()
        group.enter()
        Networking.shared.getPaymentByPayId(perams: ["pay_id":(transID ?? ""),"comm_id":community.community_id,"user_id":UserDefaults.user_id,"unit_id":UnitDetails.shared.unitID]) { (result, error) in
            print(result)
            if let result = result{
                self.responseDict = result
                if let lineitems = result["lineitems"] as? NSArray {
                    self.lineitems = lineitems
                    self.lastTextEdits = [String]()
                    self.checkBoxList = [Bool]()
                    for i in lineitems {
                        let dict = i as? [String:Any]
                        if let amount = dict?["pay_amount"] as? Double {
                            if  amount > 0 {
                                self.paymentTextArray.append(amount.clean)
                                self.lastTextEdits?.append(amount.clean)
                                self.checkBoxList?.append(true)
                            }else{
                                if let pending_amount = dict?["pending_amount"] as? Double {
                                    self.paymentTextArray.append(pending_amount.clean)
                                    self.lastTextEdits?.append(pending_amount.clean)
                                }
                                self.checkBoxList?.append(false)
                            }
                        }
                        if let amount = dict?["pending_amount"] as? Double {
                            self.orginalAmountList?.append(amount.clean)
                        }
                    }
                }
            }
            self.file_URL = result?["file_url"] as? String ?? ""
            let url = result?["file_url"] as? String ?? ""
            if url.count != 0 {
                self.imageNameArray.append(EndPoint.imageURL+url)
            }
            
            let gccID = result?["gl_acc_id"] as? Double ?? 0.0
            Networking.shared.getJSONArray(URL:EndPoint.getResidentsByUnitGlAccId, perams: ["gl_acc_id":"\(gccID)"]) { (result, erro) in
                
                if let result = result {
                    print(result)
                    self.ownerShip.removeAll()
                    for i in result {
                        let data = i as? [String:Any]
                        self.ownerShip.append(OwnerShip(cust_id: data?["cust_id"] as? Int ?? 0, cust_name: data?["cust_name"] as? String ?? "", ownership: data?["ownership"] as? String ?? ""))
                    }
                    self.ownerShipDropDown.dataSource = self.ownerShip.map { ($0.cust_name ?? "")+"("+($0.ownership ?? "")+")" }
                }
                group.leave()
            }
        }
        group.enter()
        let gccID = responseDict?["gl_acc_id"] as? Double ?? 0.0
        Networking.shared.getJSONArray(URL:EndPoint.getResidentsByUnitGlAccId, perams: ["gl_acc_id":"\(gccID)"]) { (result, erro) in
            
            if let result = result {
                print(result)
                self.ownerShip.removeAll()
                for i in result {
                    let data = i as? [String:Any]
                    self.ownerShip.append(OwnerShip(cust_id: data?["cust_id"] as? Int ?? 0, cust_name: data?["cust_name"] as? String ?? "", ownership: data?["ownership"] as? String ?? ""))
                }
                self.ownerShipDropDown.dataSource = self.ownerShip.map { ($0.cust_name ?? "")+"("+($0.ownership ?? "")+")" }
            }
            group.leave()
        }
        
        group.enter()
        Networking.shared.getJSONArray(URL:EndPoint.getBankCashAccountsLiteByCommId, perams: ["user_id": UserDefaults.user_id,"comm_id":community.community_id]) { (result, erro) in
            if let result = result {
                print(result)
                self.bankAccount.removeAll()
                for i in result {
                    let data = i as? [String:Any]
                    self.bankAccount.append(BankAccount(bc_acc_name: data?["bc_acc_name"] as? String ?? "", bc_acc_type: data?["bc_acc_type"] as? String ?? "", gl_acc_id: data?["gl_acc_id"] as? Int ?? 0))
                }
                self.bankDetailsDropDown.dataSource = self.bankAccount.map { $0.bc_acc_name ?? "" }
//                let Payame = self.bankAccount.first?.bc_acc_name ?? ""
//                self.pay_gl_acc_id = self.bankAccount.first?.gl_acc_id ?? 0
//                self.paymentDetails[2] = Payame
            }
            group.leave()
        }
        group.notify(queue: .main) {
            KRProgressHUD.dismiss()
            self.paymentModeDropDown.dataSource = ["Cash", "Cheque","Online Transfer","Payment Gateway","Others"]
                        
            let lastAppend = " ("+(self.ownerShip.first?.ownership ?? "")+")"
            let madeto = (self.ownerShip.first?.cust_name ?? "")+lastAppend
            let Payame = self.bankAccount.first?.bc_acc_name ?? ""

            
            let payFrom = self.responseDict?["pay_from"] as? String ?? ""
            let payment_to_acc = self.responseDict?["payment_to_acc"] as? String ?? ""
            let pay_mode = self.responseDict?["pay_mode"] as? String ?? ""
            let pay_dt = self.responseDict?["pay_dt"] as? String ?? ""
            let tran_ref_no = self.responseDict?["tran_ref_no"] as? String ?? ""
            let pay_note = self.responseDict?["pay_note"] as? String ?? ""
            let cons_pay_amount = self.responseDict?["cons_pay_amount"] as? Double ?? 0.0
            
            self.pay_gl_acc_id = self.responseDict?["pay_gl_acc_id"] as? Int
                        
            //self.pay_gl_acc_id = self.pay_gl_acc_id == nil ? (self.bankAccount.first?.gl_acc_id ?? 0) : self.pay_gl_acc_id
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            dateFormatter.timeZone = .current
            let date = dateFormatter.date(from: pay_dt)
            let dateString = date?.toString(dateFormat: "yyyy-MM-dd") ?? ""
            
            self.paymentDetails[0] = payFrom == "" ? madeto : payFrom
            self.paymentDetails[1] = pay_mode == "" ? "Online Transfer" : pay_mode
            self.paymentDetails[2] = payment_to_acc == "" ? Payame : payment_to_acc
            self.paymentDetails[3] = dateString == "" ? Date().toString(dateFormat: "yyyy-MM-dd") : dateString
            self.paymentDetails[4] = tran_ref_no == "" ? "" : tran_ref_no
            self.paymentDetails[5] = pay_note == "" ? "" : pay_note
            
            self.totalAmountPaid.textColor = brandColor()
            self.totalAmountPaidLabel.textColor = brandColor()
            
            self.invoiceTotalContainerView.alpha = 1.0
            for i in self.invoiceTotalContainerView.subviews {
                i.alpha = 1.0
            }
            self.paidAmount = cons_pay_amount
            self.totalAmountPaidLabel.text = "TOTAL AMOUNT PAID"
            self.totalAmountPaid.text = "\(countryCurrencyFormate(amount:cons_pay_amount))"
            
            self.offlineTable.delegate = self
            self.offlineTable.dataSource = self
            self.offlineTable.reloadWithAnimation()
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
extension EditRemoveInvoiceController: KeyboardNotificationsDelegate {
    func keyboardWillShow(notification: NSNotification) {
        guard   let userInfo = notification.userInfo as? [String: Any],
                let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        offlineTable.contentInset.bottom = keyboardFrame.height
        offlineTable.scrollVerticallyToFirstResponderSubview(keyboardFrameHight: keyboardFrame.height)
    }
    func keyboardWillHide(notification: NSNotification) {
        offlineTable.contentInset.bottom = 0
    }
}

extension EditRemoveInvoiceController:  UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return lineitems?.count ?? 0
        }else if section == 1 {
            return feildTopLabel.count
        }else{
            return imageNameArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "invoiceEditeUpdateCell", for: indexPath) as? invoiceEditeUpdateCell
            if let data = lineitems?[indexPath.row] {
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
            
            
             let amountList = paymentTextArray
                let doubleList = amountList.compactMap(Double.init)
                let doubles = doubleList.map { (value) -> String in
                    return String(format: "%.2f", value)
                }
                cell?.textFeildTextEdit.text = doubles[indexPath.row]
            
            
            if let bool = checkBoxList?[indexPath.row] {
                cell?.CheckBox.setOn(bool, animated: true)
                if !bool {
                    self.lastTextEdits?[indexPath.row] = "0"
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
            
            cell?.CheckBox.onTintColor = brandColor()
            cell?.CheckBox.onCheckColor = .white
            cell?.CheckBox.onFillColor = brandColor()
            
            cell?.textFeildTextEdit.delegate = self
            cell?.textFeildTextEdit.addDoneButtonOnKeyboard()
            cell?.textFeildTextEdit.autocorrectionType = .no
            cell?.textFeildTextEdit.keyboardType = .decimalPad
            cell?.textFeildTextEdit.keyboardAppearance = .dark
            
            cell?.doneBtn.setTitleColor(.white, for: .normal)
            cell?.textFeildTextEdit.isUserInteractionEnabled = false
            cell?.CheckBox.setClickListener({
                cell?.textFeildTextEdit.textColor = UIColor(hex: "828282")
                cell?.textFeildTextEdit.resignFirstResponder()
                if cell?.CheckBox.on == true {
                    tableView.beginUpdates()
                    cell?.invoiceDescLabel.text = "This invoice amount will be excluded in payment"
                    self.lastTextEdits?[indexPath.row] = "0"
                    self.selectedIndexPath = indexPath
                    cell?.doneBtnWidth.constant = 0
                    cell?.doneBtn.alpha = 0
                    cell?.editBtn.alpha = 0
                    self.editeEnable = nil
                    cell?.CheckBox.setOn(false, animated: true)
                    self.checkBoxList?[indexPath.row] = false
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
                    self.lastTextEdits?[indexPath.row] = cell?.textFeildTextEdit.text ?? ""
                    self.paymentTextArray[indexPath.row] = cell?.textFeildTextEdit.text ?? ""
                    cell?.CheckBox.setOn(true, animated: true)
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
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvoicePayementDetailsCell", for: indexPath) as? InvoicePayementDetailsCell
            cell?.topLabel.text = feildTopLabel[indexPath.row]
            cell?.ContainerViewFeild.tag = indexPath.row
            if indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 {
                cell?.textFild.isUserInteractionEnabled = true
                cell?.arrow.alpha = 0.0
            }else{
                cell?.arrow.alpha = 1.0
                cell?.textFild.isUserInteractionEnabled = false
            }
            cell?.textFild.isUserInteractionEnabled = (indexPath.row == 4 || indexPath.row == 5)
            cell?.arrow.alpha = (indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5) ? 0.0 : 1.0
            cell?.textFild.setupInvoiceRightImage(imageName: indexPath.row == 3 ? "calander" : "")
            
            cell?.textFild.delegate = self
            cell?.textFild.tag = indexPath.row
            cell?.textFild.keyboardAppearance = .dark
            cell?.textFild.addDoneButtonOnKeyboard()
            
            cell?.textFild.text = self.paymentDetails[indexPath.row]
            
            let tapRecognizer = UITapGestureRecognizer { recognizer in
                if let index = recognizer.view?.tag {
                    if index == 0 {
                        self.ownerShipDropDown.anchorView = cell?.ContainerViewFeild
                        self.ownerShipDropDown.width = cell?.ContainerViewFeild.frame.width
                        self.ownerShipDropDown.bottomOffset = CGPoint(x: 0, y:((cell?.ContainerViewFeild.plainView.bounds.height)!+5))
                        self.ownerShipDropDown.show()
                        self.ownerShipDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                            self.paymentDetails[indexPath.row] = item
                            cell?.textFild.text = item
                        }
                    }else if index == 1 {
                        self.paymentModeDropDown.anchorView = cell?.ContainerViewFeild
                        self.paymentModeDropDown.width = cell?.ContainerViewFeild.frame.width ?? self.view.frame.width
                        self.paymentModeDropDown.bottomOffset = CGPoint(x: 0, y:((cell?.ContainerViewFeild.plainView.bounds.height)!+5))
                        self.paymentModeDropDown.show()
                        self.paymentModeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                            cell?.textFild.text = item
                            paymentDetails[indexPath.row] = item
                        }
                    }else if index == 2 {
                        self.bankDetailsDropDown.anchorView = cell?.ContainerViewFeild
                        self.bankDetailsDropDown.width = cell?.ContainerViewFeild.frame.width ?? self.view.frame.width
                        self.bankDetailsDropDown.bottomOffset = CGPoint(x: 0, y:((cell?.ContainerViewFeild.plainView.bounds.height)!+5))
                        self.bankDetailsDropDown.show()
                        self.bankDetailsDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                            paymentDetails[indexPath.row] = item
                            self.pay_gl_acc_id = self.bankAccount[index].gl_acc_id
                            cell?.textFild.text = item
                        }
                    }else if index == 3 {
                        let selector = WWCalendarTimeSelector.instantiate()
                        selector.optionStyles.showTime(false)
                        selector.optionStyles.showDateMonth(false)
                        selector.optionStyles.showYear(false)
                        selector.delegate = self
                        selector.optionTopPanelTitle = "Choose Date"
                        self.present(selector, animated: true, completion: nil)
                    }
                }
            }
            cell?.ContainerViewFeild.addGestureRecognizer(tapRecognizer)
            return cell ?? UITableViewCell()
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath)
            
            if let url = URL(string: imageNameArray[indexPath.row]) {
                let withoutExt = url.deletingPathExtension()
                let extensionName = url.pathExtension
                let name = withoutExt.lastPathComponent.uppercased()+"."+extensionName
                print(name)
                file_name = withoutExt.lastPathComponent+"."+extensionName
                cell.textLabel?.text = name
            }else{
                cell.textLabel?.text = imageNameArray[indexPath.row]
            }
            cell.textLabel?.textColor = .black
            cell.textLabel?.textAlignment = .left
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return setupLabel(tableView: tableView, title: "UPDATE OFFLINE PAYMENT FOR \(UnitDetails.shared.unitName)".uppercased())
        }else if section == 1 {
            return setupLabel(tableView: tableView, title: "Payment Details")
        }else {
            var headerView: UIView?
            headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
            let eclipsRounded = UIImageView(frame: CGRect.zero)
            headerView?.addSubview(eclipsRounded)
            eclipsRounded.layoutAnchor(top: nil, left: headerView?.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: headerView?.centerYAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 24, height: 24, enableInsets: true)
            eclipsRounded.image = UIImage(named: "attachmentsBackground")
            
            let attachmentImage = UIImageView()
            headerView?.addSubview(attachmentImage)
            attachmentImage.layoutAnchor(top: nil, left: nil, bottom: nil, right: nil, centerX: eclipsRounded.centerXAnchor, centerY: eclipsRounded.centerYAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 14, height: 9, enableInsets: true)
            attachmentImage.image = UIImage(named: "attachmentsEcclips")
            
            let label = UILabel()
            headerView?.addSubview(label)
            label.layoutAnchor(top: nil, left: eclipsRounded.rightAnchor, bottom: nil, right: nil, centerX: nil, centerY: eclipsRounded.centerYAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: true)
            label.text = "Attachment if any(only images)"
            label.textAlignment = .left
            label.textColor = UIColor(hex: "#333333")
            headerView?.backgroundColor = .clear
            
            eclipsRounded.setClickListener {
                if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                    self.imagePicker.delegate = self
                    self.imagePicker.sourceType = .savedPhotosAlbum
                    self.imagePicker.allowsEditing = false
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            }
            
            return headerView
        }
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
}

extension EditRemoveInvoiceController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if editingStyle == .delete {
                imageNameArray.remove(at: indexPath.row)
                file_name = ""
                file_URL = ""
                offlineTable.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 2 {
            return true
        }else{
            return false
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2, let url = URL(string: imageNameArray.first ?? "") {
            KRProgressHUD.show()
            KingfisherManager.shared.downloader.downloadImage(with: url, options: .none, completionHandler:  { (result) in
                KRProgressHUD.dismiss()
                let cell = tableView.cellForRow(at: indexPath) ?? UITableViewCell()
                switch result {
                case .success(let image):
                    let imageInfo   = GSImageInfo(image: image.image, imageMode: .aspectFit)
                    let transitionInfo = GSTransitionInfo(fromView: cell)
                    let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
                    self.present(imageViewer, animated: true, completion: nil)
                case.failure(_):                                        
                    let data = Data(base64Encoded: self.file_URL) ?? Data()
                    let image = UIImage(data: data) ?? UIImage()
                    let imageInfo   = GSImageInfo(image: image, imageMode: .aspectFit)
                    let transitionInfo = GSTransitionInfo(fromView: cell)
                    let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
                    self.present(imageViewer, animated: true, completion: nil)
                }
            })
        }        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("ScrollDid")
        selectedIndexPath = nil
        editeEnable = false
        view.endEditing(true)
    }
}

extension EditRemoveInvoiceController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedFileName = ""
        if #available(iOS 11.0, *) {
            if let imageUrl = info[.imageURL] as? URL {
                selectedFileName = imageUrl.lastPathComponent
            }
        } else {
            if let imageURL = info[.referenceURL] as? URL {
                let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
                if let firstObject = result.firstObject {
                    selectedFileName = PHAssetResource.assetResources(for: firstObject).first?.originalFilename ?? ""
                }
            }
        }
        
        let array = selectedFileName.components(separatedBy: ".")
        let extensionValue = array.last ?? ""
        selectedFileName = "Image."+extensionValue
        file_name = selectedFileName
        
        file_URL = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)?.jpeg(.high)?.base64EncodedString() ?? ""
        imageNameArray.removeAll()
        imageNameArray.append(selectedFileName)
        offlineTable.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
}

extension EditRemoveInvoiceController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        if let selectedIndexPath = selectedIndexPath {
            if let cell = offlineTable.cellForRow(at: selectedIndexPath) as? invoiceEditeUpdateCell {
                if textField == cell.textFeildTextEdit {
                    var str:NSString = textField.text! as NSString
                    str = str.replacingCharacters(in: range, with: string) as NSString
                    let arrayOfString = str.components(separatedBy: ".")
                    if arrayOfString.count > 2 {
                        return false
                    }
                    paymentTextArray[selectedIndexPath.row] = str as String
                    lastTextEdits?[selectedIndexPath.row] = str as String
                }
            }
        }
        let index = textField.tag
        let indexPath = IndexPath(row: index, section: 1)
        if let cell = offlineTable.cellForRow(at: indexPath) as? InvoicePayementDetailsCell {
            if textField == cell.textFild {
                var str:NSString = textField.text! as NSString
                str = str.replacingCharacters(in: range, with: string) as NSString
                paymentDetails[indexPath.row] = str as String
            }
        }
        return true
    }
}


extension EditRemoveInvoiceController: WWCalendarTimeSelectorProtocol {
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        let cell = offlineTable.cellForRow(at: IndexPath(row: 3, section: 1)) as? InvoicePayementDetailsCell
        cell?.textFild.text = date.toString(dateFormat: "yyyy-MM-dd")
        paymentDetails[3] = date.toString(dateFormat: "yyyy-MM-dd")
    }
    
}
