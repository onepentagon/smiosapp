//
//  invoiceDetailCell.swift
//  Smartility
//
//  Created by Mani on 2/12/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import LTHRadioButton


class invoiceDetailCell: UITableViewCell {
    
    @IBOutlet weak var maintananceView: maintanaceShapView!
    
    @IBOutlet weak var maintananceLabel: UILabel!
    @IBOutlet weak var unPaidLabel: UILabel!
    @IBOutlet weak var partiallyPaidLabel: UILabel!
    
    @IBOutlet weak var pasDueLabel: UILabel!
    @IBOutlet weak var dueTodayLabel: UILabel!
    
    @IBOutlet weak var invDtLabel: UILabel!
    @IBOutlet weak var dueDtLabel: UILabel!
    
    @IBOutlet weak var invDt: UILabel!
    @IBOutlet weak var dueDt: UILabel!
    
    @IBOutlet weak var inv_Amount: UILabel!
    @IBOutlet weak var inv_no: UILabel!
    @IBOutlet weak var invoiceBakgroundView: invoiceShapeView!
    
    @IBOutlet weak var billingPeriodLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBOutlet weak var invoiceDetailTableHeight: NSLayoutConstraint!
    @IBOutlet weak var invoiceDetailTable: UITableView!
    
    @IBOutlet weak var invDtBtn: LTHRadioButton!
    @IBOutlet weak var dueDtBtn: LTHRadioButton!
    @IBOutlet weak var downloadPdf: UIButton!
    @IBOutlet weak var payfeeDetails: UILabel!
    @IBOutlet weak var paydesc: UILabel!
    
    
    
    
    var viewController: UIViewController?
    
    var invoiceRootArray: [String:Any]?
    var invoiceDetailsArray: NSArray?
    var paymentArray: NSArray?    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        setupColor()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setup()
        setupColor()
    }
    func setup(){
        invoiceDetailTable.scrollToTop()
        invoiceDetailTable.separatorStyle = .none
        invoiceDetailTable.tableFooterView = UIView()
        invoiceDetailTable.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: invoiceDetailTable.frame.width, height: 0))
        
        invoiceDetailTable.register(UINib(nibName: "invoicePaymentCell", bundle: .main), forCellReuseIdentifier: "invoicePaymentCell")
        invoiceDetailTable.register(UINib(nibName: "invoiceDueCell", bundle: .main), forCellReuseIdentifier: "invoiceDueCell")
        invoiceDetailTable.delegate = self
        invoiceDetailTable.dataSource = self
        invoiceDetailTable.reloadData()
        
        invoiceDetailTableHeight.constant = invoiceDetailTable.contentSizeHeight

        
        dueDtBtn.backgroundColor = .white
        invDtBtn.backgroundColor = .clear
        invDtBtn.selectedColor = UIColor(hex: "#6FCF97")
        invDtBtn.select()
        
        dueDtBtn.selectedColor = UIColor(hex: "#EB5757")        
        [pasDueLabel,dueTodayLabel,unPaidLabel,partiallyPaidLabel].forEach { (view) in
            view?.backgroundColor = secondaryColor()
            view?.textColor = .white
            view?.layer.cornerRadius = 10
            view?.layer.masksToBounds = true
        }
    }
    
    func setupColor(){
        invDtLabel.textColor = UIColor(hex: "#828282")
        dueDtLabel.textColor = UIColor(hex: "#828282")
        
        invDt.textColor = UIColor(hex: "#4F4F4F")
        dueDt.textColor = UIColor(hex: "#4F4F4F")
        
        inv_Amount.textColor = infoColor()
        inv_no.textColor = UIColor(hex: "#4F4F4F")
        maintananceLabel.textColor = infoColor()
        balanceLabel.textColor = secondaryColor()
    }
    
    func setupData(response: [String:Any]?){
        self.invoiceRootArray = nil
        self.invoiceRootArray?.removeAll()
        if let response = response {
            print(response)
            self.invoiceRootArray = response
        }
        balanceLabel.text = ""
        let detailArray = response?["detail"] as? NSArray
        let paymentArry = response?["payment"] as? NSArray
                                      
        let sizeInvoice = (detailArray?.count ?? 0)*40
        let paymentSize = (paymentArry?.count ?? 0)*20
        
        if paymentSize != 0 {
            if let balanceAmount = response?["pending_amount"] as? Double {
                balanceLabel.text = "Balance \(countryCurrencyFormate(amount: balanceAmount))"
            }
        }else{
            balanceLabel.text = ""
        }
        
//        if sizeInvoice == 0 && paymentSize == 0 {
//            invoiceDetailTableHeight.constant = 0
//        }else{
            let paymentSizeTotal = paymentSize != 0 ? paymentSize+30 : 0
            self.invoiceDetailsArray = detailArray
            self.paymentArray = paymentArry
            let totalSize = paymentSizeTotal+sizeInvoice
            invoiceDetailTableHeight.constant = CGFloat(totalSize)
//        }
//        }else{
//            invoiceDetailsArray = nil
//        }
        payfeeDetails.text = ""
        paydesc.text = ""
        [payfeeDetails,paydesc].forEach { label in
            label?.textColor = UIColor(hex: "#f09952")
        }
        if let late_fee_detail = response?["late_fee_detail"] as? [String:Any] {
            if let paymentAmount = late_fee_detail["late_fee"] as? Double {
                let amount = countryCurrencyFormate(amount: paymentAmount)
                payfeeDetails.text = "Late payment fee as on date is \(amount)* excluding tax. A new invoice for the same will be raised after successful payment of this outstanding invoice."
            }else{
                payfeeDetails.text = ""
            }
            if let late_fee_desc = late_fee_detail["late_fee_desc"] as? String {
                paydesc.text = "* "+late_fee_desc
            }else{
                paydesc.text = ""
            }
        }
        
        inv_no.text = "INV# "+(response?["inv_no"] as? String ?? "")
        invDt.text = timeConversion12(time24: (response?["inv_dt"] as? String) ?? "", formate: "yyyy-MM-dd HH:mm:ss", getFormate: "dd MMM yyyy")
        dueDt.text = timeConversion12(time24: (response?["due_dt"] as? String) ?? "", formate: "yyyy-MM-dd", getFormate: "dd MMM yyyy")
        
        if let inv_amount_Double = response?["inv_amount"] as? Double {
            inv_Amount.text = "\(countryCurrencyFormate(amount: inv_amount_Double))"
        }
        maintananceLabel.text = (response?["inv_type"] as? String)?.uppercased()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dateFormatt = DateFormatter()
        dateFormatt.dateFormat = "yyyy-MM-dd"
        dateFormatt.calendar = Calendar.current
        dateFormatt.timeZone = TimeZone.current
        dateFormatt.timeZone = TimeZone(abbreviation: "UTC")
                        
        let todayDate = dateFormatt.string(from: Date())
        let today = dateFormatt.date(from: todayDate) ?? Date()
        
        if let date = response?["due_dt"] as? String {
            if  let due_date = dateFormatt.date(from: date) {
                let compareResult = today.compare(due_date)
                switch compareResult {
                case .orderedAscending:
                    
                    dueDtBtn.deselect()
                    dueTodayLabel.isHidden = true
                    pasDueLabel.isHidden = true
                    print("Future Date")
                    
                case .orderedDescending:
                    
                    dueDtBtn.select()
                    dueTodayLabel.isHidden = true
                    pasDueLabel.isHidden = false
                    print("Earlier Date")
                    
                case .orderedSame:
                    
                    let numOfDays = today.daysBetweenDate(toDate: due_date)
                    if numOfDays == 0  {
                        dueDtBtn.select()
                        dueTodayLabel.isHidden = false
                        pasDueLabel.isHidden = true
                    }else{
                        dueDtBtn.select()
                        pasDueLabel.isHidden = false
                        dueTodayLabel.isHidden = true
                    }
                    print("Today")
                    
                default:
                    print("Today/Null Date Passed")
                    dueDtBtn.deselect()
                    dueTodayLabel.isHidden = true
                    pasDueLabel.isHidden = true
                }
            }
        }
        
        if let inv_status = response?["inv_status"] as? String {
            if inv_status == "Partially Paid"{
                partiallyPaidLabel.isHidden = false
            }else{
                partiallyPaidLabel.isHidden = true
            }
            if inv_status == "Unpaid"{
                unPaidLabel.isHidden = false
            }else{
                unPaidLabel.isHidden = true
            }
        }
        
        if let covering_from = response?["covering_from"] as? String, let covering_till = response?["covering_till"] as? String  {
            
            let from = timeConversion12(time24: covering_from, formate: "yyyy-MM-dd", getFormate: "dd MMM yyyy")
            let till = timeConversion12(time24: covering_till, formate: "yyyy-MM-dd", getFormate: "dd MMM yyyy")
            
            let attributedQuote = NSMutableAttributedString(string: "Billing Period ", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: "#828282"),NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)])
            let attributedQuote1 = NSMutableAttributedString(string: "\(from) - \(till)", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: "#4F4F4F"),NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)])
            attributedQuote.append(attributedQuote1)
            billingPeriodLabel.attributedText = attributedQuote
                        
        }else{
            billingPeriodLabel.text = ""
        }
        invoiceDetailTable.delegate = self
        invoiceDetailTable.dataSource = self
        invoiceDetailTable.reloadData()
        invoiceDetailTable.scrollToTop()
                        
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
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    
}


extension invoiceDetailCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return invoiceDetailsArray?.count ?? 0
        }else{
            return paymentArray?.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "invoiceDueCell", for: indexPath) as? invoiceDueCell
            cell?.dueTitleLabel.numberOfLines = 0
            cell?.dueDesc.numberOfLines = 0
            if let data = invoiceDetailsArray?[indexPath.row] as? [String:Any]{
                cell?.dueTitleLabel.text = data["line_desc"] as? String
                if let amount = data["line_amount"] as? Double {
                    cell?.dueAmount.text = countryCurrencyFormate(amount: amount)
                }                                                                
                cell?.dueDesc.text = data["line_sub_desc"] as? String
            }
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "invoicePaymentCell", for: indexPath) as? invoicePaymentCell
            if let data = paymentArray?[indexPath.row] as? [String:Any]{
                let pay_dt = data["pay_dt"] as? String ?? ""
                let from = timeConversion12(time24: pay_dt, formate: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormate: "dd MMM yyyy")
                let dataText = "Paid \(countryCurrencyFormate(amount: data["pay_amount"] as? Double ?? 0.0)) on \(from)"
                cell?.paidDescLabel.numberOfLines = 0
                let paidStatus = data["pay_status"] as? String ?? ""
                
                cell?.editeBtn.setTitleColor(UIColor(hex: "#2D9CDB"), for: .normal)
                cell?.editeBtn.alpha = 0
                if paidStatus == "Rejected" {
                    let rej_reason = data["rej_reason"] as? String ?? ""
                    cell?.paidDescLabel.text = "Paid \(data["pay_amount"] as? Double ?? 0.0) on \(from) (Rejected with reason \"\(rej_reason)\""
                    cell?.paidDescLabel.textColor = UIColor(hex: "#f09952")
                    cell?.paidImageView.image = UIImage(named: "Rejected")
                    cell?.editeBtn.alpha = 1
                }else if paidStatus == "Pending Receipt"{
                    cell?.paidDescLabel.textColor = UIColor(hex: "#27AE60")
                    cell?.paidDescLabel.text = dataText+" ("+paidStatus+")"
                    cell?.paidImageView.image = UIImage(named: "Pending")
                    cell?.paidDescLabel.textColor = UIColor(hex: "#f09952")
                    cell?.editeBtn.alpha = 1
                }else{
                    cell?.editeBtn.alpha = 0
                    cell?.paidDescLabel.textColor = UIColor(hex: "#27AE60")
                    cell?.paidDescLabel.text = dataText
                    cell?.paidImageView.image = UIImage(named: "checkBox")
                }
            }
            cell?.editeBtn.mk_addTapHandler(action: { (btn) in
                let contrller = AppStoryboard.Dashboard.viewController(viewControllerClass: EditRemoveInvoiceController.self)
                if let data = self.paymentArray?[indexPath.row] as? [String:Any]{
                    let payID = "\(data["pay_id"] as? Int ?? 0)"
                    contrller.transID = payID
                }
                self.viewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                self.viewController?.navigationController?.pushViewController(contrller, animated: true)
            })
            return cell ?? UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 10))
            returnedView.backgroundColor = .clear
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 10))
            returnedView.addSubview(label)
            return returnedView
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        }else{
            return 25
//            return UITableView.automaticDimension
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 10
        }
        return 0
    }
}

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}


extension UITableView {
    var contentSizeHeight: CGFloat {
        var height = CGFloat(0)
        for section in 0..<numberOfSections {
            height = height + rectForHeader(inSection: section).height
            let rows = numberOfRows(inSection: section)
            for row in 0..<rows {
                height = height + rectForRow(at: IndexPath(row: row, section: section)).height
            }
        }
        return height
    }
}
