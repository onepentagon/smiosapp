//
//  InvoiceViewController.swift
//  Smartility
//
//  Created by Mani on 2/12/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import WebKit
import Toast_Swift


class InvoiceViewController: UIViewController {
    
    @IBOutlet weak var invoiceTable: UITableView!
    @IBOutlet weak var invoiceTotalContainerView: UIView!
    @IBOutlet weak var paidOnlineBtn: UIButton!
    @IBOutlet weak var paidOfflineBtn: UIButton!
    @IBOutlet weak var totalAmounDueContainer: UIView!
    
    @IBOutlet weak var bottomContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var totalInvoiceAmtLabel: UILabel!
    @IBOutlet weak var pasDuePaymentLable: UILabel!
    @IBOutlet weak var passDueAmount: UILabel!
    
    @IBOutlet weak var TotalAmountDueLabel: UILabel!
    @IBOutlet weak var totalAmont: UILabel!
    @IBOutlet weak var totalInvoiceAmt: UILabel!
    var Total_invoice_amount = Double()
    var Past_balanced =  Double()
    var responseNSarray: NSArray?
    var originalArray: NSArray?    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.bottomContainerHeight.constant = 0
        for i in invoiceTotalContainerView.subviews {
            i.isHidden = true
        }
        view.bringSubviewToFront(invoiceTotalContainerView)
        
        paidOfflineBtn.setTitleColor(infoColor(), for: .normal)
        paidOfflineBtn.layer.borderWidth = 1
        paidOfflineBtn.layer.borderColor = infoColor()?.cgColor
                
        paidOnlineBtn.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)        
        paidOnlineBtn.backgroundColor = infoColor()
        
        
        let xib = UINib(nibName: "invoiceDetailCell", bundle: .main)
        invoiceTable.register(xib, forCellReuseIdentifier: "invoiceDetailCell")
        
        invoiceTable.separatorStyle = .none
        invoiceTable.tableFooterView = UIView()
        invoiceTable.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: invoiceTable.frame.width, height: 0))
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("LoadingInvoices"), object: nil, queue: .main) { (notify) in
            self.setupApi()
        }
        
        paidOnlineBtn.mk_addTapHandler { (btn) in
//            self.view.makeToast("Sorry, this option is not available yet.")            
            let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: OnlinePaymentViewController.self)
            controller.responseNSarray = self.originalArray
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        paidOfflineBtn.mk_addTapHandler { (clickBtn) in
            let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: CreateInvoiceController.self)
            controller.responseNSarray = self.originalArray
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
   
    
    func setupApi(){
        var perams: [String:Any] = [:]
        perams.updateValue(UserDefaults.user_id, forKey: "user_id")
        perams.updateValue(UnitDetails.shared.unitID, forKey: "unit_id_list")
        perams.updateValue(UserDefaults.cust_id, forKey: "cust_id")
        perams.updateValue(community.community_id, forKey: "comm_id")
        perams.updateValue("true", forKey: "include_detail")
        invoiceTable.delegate = nil
        invoiceTable.dataSource = nil
        invoiceTable.reloadData()
        self.invoiceTable.showActivityIndicator()
        Networking.shared.getAccBalByCustId(URL: EndPoint.getAccBalByCustId, perams: perams) { (result, error) in
                                                
            if let result = result {
                self.originalArray = result
                self.responseNSarray =  result.filter {
                    let arrayData = $0 as? [String:Any]
                    let pay_towards = arrayData?["pay_towards"] as? String ?? ""
                    return pay_towards == "I"
                } as NSArray
                
                for i in self.invoiceTotalContainerView.subviews {
                    i.isHidden = false
                }
                self.Total_invoice_amount = result.filter {
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
                
                self.Past_balanced = result.filter {
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
                    self.totalInvoiceAmt.text = countryCurrencyFormate(amount: self.Total_invoice_amount)
                    
                    if self.Past_balanced < 0 {
                        self.pasDuePaymentLable.text = "PAST OVERPAYMENT"
                        self.pasDuePaymentLable.textColor = UIColor(hex: "#27AE60")
                        self.passDueAmount.textColor = UIColor(hex: "#27AE60")
                        self.passDueAmount.text = countryCurrencyFormate(amount: self.Past_balanced)
                    }else if self.Past_balanced > 0 {
                        self.pasDuePaymentLable.text = "PREVIOUS BALANCE"
                        self.pasDuePaymentLable.textColor = UIColor(hex: "#EE552F")
                        self.passDueAmount.textColor = UIColor(hex: "#EE552F")
                        self.passDueAmount.text = "+ "+countryCurrencyFormate(amount: self.Past_balanced)
                    }
                    self.bottomContainerHeight.constant = 213
                }else{
                    self.totalAmounDueContainer.backgroundColor = .white
                    self.totalInvoiceAmtLabel.text = ""
                    self.pasDuePaymentLable.text = ""
                    self.passDueAmount.text = ""
                    self.totalInvoiceAmt.text = ""
                    self.bottomContainerHeight.constant = 136
                }
                                
                self.totalAmont.text = countryCurrencyFormate(amount: (self.Total_invoice_amount+self.Past_balanced))
                
                if self.Total_invoice_amount+self.Past_balanced > 0 {
                    [self.paidOnlineBtn,self.paidOfflineBtn].forEach { (btn) in
                        btn?.isEnabled = true
                        btn?.alpha = 1.0
                    }
                }else{
                    [self.paidOnlineBtn,self.paidOfflineBtn].forEach { (btn) in
                        btn?.isEnabled = false
                        btn?.alpha = 0.6
                    }
                }
                            
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
                self.invoiceTable.delegate = self
                self.invoiceTable.dataSource = self
                self.invoiceTable.hideActivityIndicator()
                self.invoiceTable.reloadWithAnimation()
                NotificationCenter.default.post(name: NSNotification.Name("ShowNoDues"), object: nil, userInfo: ["NoDues":"Invoice"])
            }else{
                NotificationCenter.default.post(name: NSNotification.Name("ShowNoDues"), object: nil, userInfo: ["NoDues":"InvoiceNoDue"])
//                if let error = error {
//                    self.showConfirmAlert(title: "", message: error.localizedDescription, buttonTitle: "Okey", buttonStyle: .cancel, confirmAction: nil)
//                }
            }
        }
    }
    override func viewDidLayoutSubviews() {
                
        [paidOnlineBtn,paidOfflineBtn].forEach { (btns) in
            btns?.layer.cornerRadius = 6
            btns?.layer.masksToBounds = true
        }
                
        invoiceTotalContainerView.layer.masksToBounds = false
        invoiceTotalContainerView.layer.shadowRadius = 6
        invoiceTotalContainerView.layer.shadowOpacity = 1
        invoiceTotalContainerView.layer.shadowColor = UIColor(red: 0.098, green: 0.098, blue: 0.098, alpha: 0.15).cgColor
        invoiceTotalContainerView.layer.shadowOffset = CGSize(width: 0 , height: -1)
    }
}

extension InvoiceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseNSarray?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "invoiceDetailCell", for: indexPath) as? invoiceDetailCell        
        cell?.viewController = self
        cell?.setupData(response: responseNSarray?[indexPath.row] as? [String:Any])
        cell?.downloadPdf.mk_addTapHandler(action: { (btn) in
            if let array = self.responseNSarray, let data = array[indexPath.row] as? [String:Any], let invID = data["source_ref_id"] as? Int {
                            
                let perams = ["inv_id":invID, "convert_to_pdf":true,"comm_id":community.community_id,"user_id":UserDefaults.user_id,"unit_id":UnitDetails.shared.unitID] as [String : Any]
                btn.loadingIndicator(true, .black, "")
                Networking.shared.getInvoiceForPDFByInvID(perams: perams) { (response, error) in
                    if let response = response {
                        btn.loadingIndicator(false, .black, "Download Invoice")
                        let controller = AppStoryboard.Dashboard.viewController(viewControllerClass:InvoiceShowPDFViewController.self)
                        controller.htmlString = response
                        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                }
            }
        })
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
