//
//  InvoiceEditUpdateController.swift
//  Smartility
//
//  Created by Mani on 2/20/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import DropDown
import Photos
import KRProgressHUD
import Toast_Swift

class CreateInvoiceController: UIViewController, WWCalendarTimeSelectorProtocol {
    
    @IBOutlet weak var offlineTable: UITableView!
    @IBOutlet weak var invoiceTotalContainerView: UIView!
    @IBOutlet weak var SubmitBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var totalAmounDueContainer: UIView!
    @IBOutlet weak var bottomContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var totalInvoiceAmtLabel: UILabel!
    @IBOutlet weak var pasDuePaymentLable: UILabel!
    @IBOutlet weak var passDueAmount: UILabel!
    @IBOutlet weak var TotalAmountDueLabel: UILabel!
    @IBOutlet weak var totalAmont: UILabel!
    @IBOutlet weak var totalInvoiceAmt: UILabel!
    @IBOutlet weak var totalAmountPaidLabel: UILabel!
    @IBOutlet weak var totalAmountPaid: UILabel!
    private lazy var keyboard = KeyboardNotifications(notifications: [.willHide, .willShow], delegate: self)
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuHeight: NSLayoutConstraint!
    @IBOutlet weak var backBgView: UIView!
    
    
    var Total_invoice_amount = Double()
    var Past_balanced =  Double()
    var responseNSarray: NSArray?
    var selectedIndexPath: IndexPath?
    var editeEnable: Bool?
    var lastTextEdits: [String]?
    var paymentTextArray =  [String]()
    var feildTopLabel = ["Paid By","Mode","Payment Made to", "Date", "Trans Ref. No.","Note(Optional)"]
    var ownerShipDropDown = DropDown()
    var bankDetailsDropDown = DropDown()
    var paymentModeDropDown = DropDown()
    var bankAccount = [BankAccount]()
    var ownerShip = [OwnerShip]()
    var paymentDetails = [String]()
    var imagePicker = UIImagePickerController()
    var imageNameArray: [String] = []
    var paidAmount: Double?
    var checkBoxList: [Bool]?
    var file_name = ""
    var file_URL = ""
    var pay_gl_acc_id: Int?
    var orginalAmountList: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
             
        
        backBgView.setClickListener {
            self.navigationController?.popViewController(animated: true)
        }
        
        self.bottomContainerHeight.constant = 0
        
        view.bringSubviewToFront(invoiceTotalContainerView)
        
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

        backBtn.setTitleColor(infoColor(), for: .normal)
        backBtn.layer.borderWidth = 1
        backBtn.layer.borderColor = infoColor()?.cgColor
        
      
        backBtn.mk_addTapHandler { (back) in
            self.navigationController?.popViewController(animated: true)
        }
        
        SubmitBtn.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        SubmitBtn.backgroundColor = infoColor()
        
        for _ in 0..<feildTopLabel.count{
            paymentDetails.append("")
        }
        
        for i in self.invoiceTotalContainerView.subviews {
            i.isHidden = false
        }
        checkBoxList = [Bool]()
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
        lastTextEdits = [String]()
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
        
        self.title = "Invoice & Payments"
        offlineTable.register(UITableViewCell.self, forCellReuseIdentifier: "ImageCell")
        offlineTable.contentInset = UIEdgeInsets(top: -36, left: 0, bottom: 0, right: 0);
        offlineTable.separatorStyle = .none
        loadPaidBy()
        
        
        SubmitBtn.mk_addTapHandler { (button) in
            self.upLoadTheData(button)
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboard.isEnabled = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        keyboard.isEnabled = true
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = infoColor()
        navigationController?.navigationItem.backBarButtonItem?.tintColor = infoColor()
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor: infoColor() ?? UIColor.clear]
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        
        [SubmitBtn,backBtn].forEach { (btns) in
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
        
        self.SubmitBtn.isEnabled = (self.paidAmount ?? 0.0) > 0
        
        if (self.paidAmount ?? 0.0) > 0 {
            self.SubmitBtn.alpha = 1.0
        }else{
            self.SubmitBtn.alpha = 0.6
        }
    }
    
    
    func loadPaidBy(){
        
        [ownerShipDropDown, bankDetailsDropDown, paymentModeDropDown].forEach { (drop) in
            drop.selectionBackgroundColor = .white
            drop.backgroundColor = .white
            drop.cornerRadius = 10
        }
        
        guard let controller = getTopWindow()?.rootViewController else { return }
        self.paymentDetails[1] = "Online Transfer"
        self.paymentDetails[3] = Date().toString(dateFormat: "yyyy-MM-dd")
        
        let group = DispatchGroup()
        group.enter()
        KRProgressHUD.showOn(controller).show()
        let data = self.responseNSarray?[0] as? [String:Any] ?? [String:Any]()
        let gccID = data["gl_acc_id"] as? Double ?? 0.0
        Networking.shared.getJSONArray(URL:EndPoint.getResidentsByUnitGlAccId, perams: ["gl_acc_id":"\(gccID)"]) { (result, erro) in
            
            if let result = result {
                print(result)
                self.ownerShip.removeAll()
                for i in result {
                    let data = i as? [String:Any]
                    self.ownerShip.append(OwnerShip(cust_id: data?["cust_id"] as? Int ?? 0, cust_name: data?["cust_name"] as? String ?? "", ownership: data?["ownership"] as? String ?? ""))
                }
                self.ownerShipDropDown.dataSource = self.ownerShip.map { ($0.cust_name ?? "")+"("+($0.ownership ?? "")+")" }
                                
                let madto = self.ownerShip.first { (model) -> Bool in
                    model.cust_id == Int(UserDefaults.cust_id)
                }
                if let name = madto?.cust_name,let lastAppnd = madto?.ownership {
                    self.paymentDetails[0] = name+"("+lastAppnd+")"
                }else{
                    let lastAppend = " ("+(self.ownerShip.first?.ownership ?? "")+")"
                    let madeto = (self.ownerShip.first?.cust_name ?? "")+lastAppend
                    self.paymentDetails[0] = madeto
                }
                //
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
                let Payame = self.bankAccount.first?.bc_acc_name ?? ""
                self.pay_gl_acc_id = self.bankAccount.first?.gl_acc_id ?? 0
                self.paymentDetails[2] = Payame
            }
            group.leave()
        }
        group.notify(queue: .main) {
            KRProgressHUD.dismiss()
                        
            self.paymentModeDropDown.dataSource = ["Cash", "Cheque","Online Transfer","Payment Gateway","Others"]
            self.offlineTable.delegate = self
            self.offlineTable.dataSource = self
            self.offlineTable.reloadWithAnimation()
        }
    }
}

extension CreateInvoiceController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return responseNSarray?.count ?? 0
        }else if section == 1 {
            return feildTopLabel.count
        }else{
            return imageNameArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
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
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvoicePayementDetailsCell", for: indexPath) as? InvoicePayementDetailsCell
            cell?.topLabel.text = feildTopLabel[indexPath.row]
            cell?.ContainerViewFeild.tag = indexPath.row
            
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
            cell.textLabel?.text = imageNameArray[indexPath.row]
            cell.textLabel?.textColor = .black
            cell.textLabel?.textAlignment = .left
            return cell
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("ScrollDid")
        selectedIndexPath = nil
        editeEnable = false
        view.endEditing(true)
    }
    
    
    func upLoadTheData(_ button: UIButton){
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
            params.updateValue(UnitDetails.shared.unitID, forKey: "unit_id")
            
            let rootArray = self.responseNSarray?.firstObject as? [String:Any]
            if  let gl_acc_name = rootArray?["gl_acc_name"] as? String, let gl_acc_id = rootArray?["gl_acc_id"] as? Int{
                params.updateValue(gl_acc_name , forKey: "gl_acc_name")
                params.updateValue(gl_acc_id , forKey: "gl_acc_id")
            }else{
                params.updateValue("" , forKey: "gl_acc_name")
                params.updateValue("" , forKey: "gl_acc_id")
            }
            params.updateValue(self.pay_gl_acc_id ?? 0, forKey: "pay_gl_acc_id")
            params.updateValue(tran_ref_no, forKey: "tran_ref_no")
                
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
//            print(params)
            
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: params,
                options: []) {
                let theJSONText = String(data: theJSONData, encoding: .ascii)
                print("JSON string = \(theJSONText!)")
            }

            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: params,
                options: []) {
                let theJSONText = String(data: theJSONData,
                                           encoding: .ascii)
                print("JSON string = \(theJSONText!)")
            }
            
            button.loadingIndicator(true, .black, "")
            Networking.shared.paymentUpload(URL: EndPoint.createPay, perams: params) { (result, error) in
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
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        let cell = offlineTable.cellForRow(at: IndexPath(row: 3, section: 1)) as? InvoicePayementDetailsCell
        cell?.textFild.text = date.toString(dateFormat: "yyyy-MM-dd")
        paymentDetails[3] = date.toString(dateFormat: "yyyy-MM-dd")
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return setupLabel(tableView: tableView, title: "RECORD PAYMENT FOR "+UnitDetails.shared.unitName.uppercased())
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
            label.textColor = UIColor(hex: "333333")
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

extension CreateInvoiceController: UITableViewDelegate, UITextFieldDelegate, KeyboardNotificationsDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
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
                    if !["1","2","3","4","5","6","7","8","9","0","","."].contains(string) {
                        return false
                    }
                    lastTextEdits?[selectedIndexPath.row] = str as String
                    self.paymentTextArray[selectedIndexPath.row] = str as String
                }
            }
        }
        let index = textField.tag
        let indexPath = IndexPath(row: index, section: 1)
        if let cell = offlineTable.cellForRow(at: indexPath) as? InvoicePayementDetailsCell {
            guard let textFieldText = textField.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            
            if textField == cell.textFild {
                var str:NSString = textField.text! as NSString
                str = str.replacingCharacters(in: range, with: string) as NSString
                paymentDetails[indexPath.row] = str as String
            }
            return count <= 100
        }
        return true
    }
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


extension CreateInvoiceController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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
}


struct BankAccount {
    var bc_acc_name: String?
    var bc_acc_type: String?
    var gl_acc_id: Int?
    init(bc_acc_name: String, bc_acc_type: String, gl_acc_id: Int) {
        self.bc_acc_name = bc_acc_name
        self.bc_acc_type = bc_acc_type
        self.gl_acc_id = gl_acc_id
    }
}

struct OwnerShip {
    var cust_id: Int?
    var cust_name: String?
    var ownership: String?
    
    init(cust_id: Int?,
         cust_name: String?,
         ownership: String?) {
        self.cust_id = cust_id
        self.cust_name = cust_name
        self.ownership = ownership
    }
}
