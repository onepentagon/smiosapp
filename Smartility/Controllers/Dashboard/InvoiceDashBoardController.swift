//
//  InvoiceDashBoardController.swift
//  Smartility
//
//  Created by Mani on 2/13/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit

class InvoiceDashBoardController: UIViewController {
    @IBOutlet weak var invoiceViewShadow: UIView!
    @IBOutlet weak var invoiceView: UIView!
    @IBOutlet weak var invoicePendingContainerView: UIView!
    @IBOutlet weak var dueToday: UILabel!
    @IBOutlet weak var pastDueLabel: UILabel!
    
    @IBOutlet weak var invoiceNameLabel: UILabel!
    @IBOutlet weak var invoiceTotalAmount: UILabel!
    @IBOutlet weak var invoicePendingCountLabel: UILabel!
    @IBOutlet weak var invoicePayNowBtn: UIButton!
    @IBOutlet weak var invoiceIcon: UIImageView!
    @IBOutlet weak var stackViewStatus: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        self.view.backgroundColor = .clear
        NotificationCenter.default.addObserver(forName: NSNotification.Name("UpdateInvoice"), object: nil, queue: .main) { (notification) in
            if let result = notification.userInfo?["result"] as? NSArray {
                
                self.invoiceView.backgroundColor = UIColor(hex: "#FBCE2F")
                self.invoicePayNowBtn.setTitleColor(.white, for: .normal)
                self.invoicePayNowBtn.backgroundColor = brandColor()
                     
                var pending_amount = Double()
                var invoiceDate: [String] = []
                
                
                let resultArray =  result.filter {
                    let arrayData = $0 as? [String:Any]
                    let pay_towards = arrayData?["pay_towards"] as? String ?? ""
                    return pay_towards == "I"
                } as NSArray
                
                
                let total_invoice_amount = result.filter {
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
                }.reduce(0.0) { $0 + $1 }
                
                let past = result.filter {
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
                }.reduce(0.0) { $0 + $1 }
                
                pending_amount = (total_invoice_amount+past)
                                
                invoiceDate = resultArray.map({ (date) -> String in
                    if  let array = date as? [String:Any] , let invData = array["due_dt"] as? String {
                        return invData
                    }
                    return ""
                })
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.calendar = Calendar.current
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd"
                dateFormat.calendar = Calendar.current
                dateFormat.timeZone = TimeZone.current
                dateFormat.timeZone = TimeZone(abbreviation: "UTC")
                                                             
                let today = dateFormat.string(from: Date())
                let todayDta = dateFormat.date(from: today) ?? Date()
                print(todayDta)
                
                invoiceDate = invoiceDate.filter({ $0 != ""})
                   
                let TodayDate = invoiceDate.filter {                    
                    if  let due_date = dateFormatter.date(from: $0) {
                        let compareResult = todayDta.compare(due_date)
                        switch compareResult {
                        case .orderedAscending:
                            print("Future Date")
                            return false
                        case .orderedDescending:
                            print("Earlier Date")
                            return false
                        case .orderedSame:
                            let numOfDays = todayDta.daysBetweenDate(toDate: due_date)
                            print("Today")
                            if numOfDays == 0  {
                                return true
                            }else{
                                return false
                            }
                        default:
                            print("Today/Null Date Passed")
                            return false
                        }
                    }
                    return false
                }
                
                
                let pastDayes = invoiceDate.filter { (date) -> Bool in
                    
                    if  let due_date = dateFormatter.date(from: date) {
                        let compareResult = todayDta.compare(due_date)
                        switch compareResult {
                        case .orderedAscending:
                            print("Future Date")
                            return false
                        case .orderedDescending:
                            print("Earlier Date")
                            return true
                        case .orderedSame:
                            let numOfDays = todayDta.daysBetweenDate(toDate: due_date)
                            print("Today")
                            if numOfDays == 0  {
                                return false
                            }else{
                                return true
                            }
                        default:
                            print("Today/Null Date Passed")
                            return false
                        }
                    }
                    return false
                }
                
                
                if TodayDate.count != 0 {
                    self.dueToday.text = "\(TodayDate.count) Due Today"
                    self.dueToday.isHidden = false
                }else{
                    self.dueToday.isHidden = true
                }
                if pastDayes.count != 0 {
                    self.pastDueLabel.text = "\(pastDayes.count) Past Due"
                    self.pastDueLabel.isHidden = false
                }else{
                    self.pastDueLabel.isHidden = true
                }
                
                if TodayDate.count != 0 && pastDayes.count != 0 {
                    self.stackViewStatus.axis = .vertical
                }else{
                    self.stackViewStatus.axis = .horizontal
                }                                                
                                
                self.invoiceTotalAmount.text = countryCurrencyFormate(amount: pending_amount)                
                self.invoicePendingCountLabel.text = "\(resultArray.count) Invoice\(resultArray.count == 1 ? "": "s") Pending For Payment"
                
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }else{
//                self.invoiceView?.removeFromSuperview()
            }
        }
        
        invoicePayNowBtn.mk_addTapHandler { (act) in
            let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: Invoice_Payment_ViewController.self)
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        
        [self.invoicePendingContainerView, self.invoicePayNowBtn].forEach { (view) in
            view?.layer.cornerRadius = 6
            view?.layer.masksToBounds = true
        }
        self.dueToday.layer.cornerRadius = 10
        self.dueToday.layer.masksToBounds = true
        
        dueToday.textColor = .white
        pastDueLabel.textColor = .white
        dueToday.backgroundColor = UIColor(hex: "#EE552F")
        invoiceTotalAmount.textColor = UIColor(hex: "#EE552F")
        pastDueLabel.backgroundColor = UIColor(hex: "#EE552F")
        
        self.pastDueLabel.layer.cornerRadius = 10
        self.pastDueLabel.layer.masksToBounds = true
        
        invoiceNameLabel.textColor = .white
        invoiceView.backgroundColor = .clear
        invoiceViewShadow.backgroundColor = .clear
        invoiceViewShadow.makeCustomRound(shadow: false,backgroundColor: UIColor(hex: "#FBCE2F"), topLeft: 50, topRight: 6, bottomLeft: 6, bottomRight: 6)
    }
}


extension Date {
    func daysBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
        return components.day ?? 0
    }
}

extension Double {
    private static var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        return numberFormatter
    }()
        
    var delimiter: String {
        return Double.numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
