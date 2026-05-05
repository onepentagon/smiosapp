//
//  PaymentSuccessController.swift
//  Smartility
//
//  Created by Mani on 5/22/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import Lottie

class PaymentSuccessController: UIViewController {
    
    @IBOutlet weak var payment: UILabel!
    @IBOutlet weak var communityName: UILabel!
    @IBOutlet weak var orderIDLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var lotieView: UIView!
            
    var orderIDString: String?
    var orderIDDate: String?
    var amount: String?
    var listData: NSArray?
    private var progressView: AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView = .init(name: "Payment_Successfull")
        progressView!.frame = lotieView.bounds
        progressView!.contentMode = .scaleAspectFit
        progressView!.loopMode = .loop
        lotieView.addSubview(progressView!)
        progressView!.play()
        doneBtn.setTitle("DONE", for: .normal)
        doneBtn.layer.cornerRadius = 6
        doneBtn.layer.masksToBounds = true
        doneBtn.backgroundColor = brandColor()
        doneBtn.setClickListener {
            NotificationCenter.default.post(name: NSNotification.Name("UpdateActions"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name("LoadingInvoices"), object: nil)
            if let destinationViewController = self.navigationController?.viewControllers
                                                                    .filter(
                                                  {$0 is Invoice_Payment_ViewController})
                                                                    .first {
                self.navigationController?.popToViewController(destinationViewController, animated: true)
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }
        let attribute1 = NSMutableAttributedString(string: "Order ID ", attributes: [NSAttributedString.Key.font : SFFont(font: .Regular, size: 16), NSAttributedString.Key.foregroundColor: UIColor(hex: "#828282")])
                        
        let attribute2 = NSAttributedString(string: orderIDString ?? "", attributes: [NSAttributedString.Key.font : SFFont(font: .Semibold, size: 16), NSAttributedString.Key.foregroundColor: UIColor(hex: "#333333")])
        
        attribute1.append(attribute2)
        orderIDLabel.attributedText = attribute1
        communityName.text = community.community_name
        payment.text = amount
        orderDateLabel.text = "On "+timeConversion12(time24: (orderIDDate ?? ""))
                
        
        tableHeight.constant = CGFloat((listData?.count ?? 0) * 50)
        table.layer.cornerRadius = 10
        table.layer.masksToBounds = true
        table.layer.borderWidth = 1
        table.layer.borderColor = UIColor(hex: "#BDBDBD").cgColor
        
        table.delegate = self
        table.dataSource = self
        table.reloadWithAnimation()
    }
    func timeConversion12(time24:String)->String {
        if let date = dateFromString(dateString: time24) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy hh:mm a"
            let Str_date = formatter.string(from: date)
            return Str_date
        }
        return ""
    }
    func dateFromString(dateString:String)->Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
        dateFormatter.timeZone = .current
        
        if let date = dateFormatter.date(from: dateString) {
            return date
        }else{
            return nil
        }
    }
}

extension PaymentSuccessController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentCell", for: indexPath) as? paymentCell
        if let response = listData, let dict = response[indexPath.row] as? [String:Any] {
            cell?.desc.text = dict["pay_desc"] as? String
            if let amount = dict["pay_amount"] as? Double {
                cell?.pendingAmount.text = countryCurrencyFormate(amount: amount)
            }
        }
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}


class paymentCell: UITableViewCell {
    
    @IBOutlet weak var pendingAmount: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    
    override class func awakeFromNib() {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
    }
    
}
