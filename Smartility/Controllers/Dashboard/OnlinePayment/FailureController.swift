//
//  FailureController.swift
//  Smartility
//
//  Created by Mani on 5/21/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import Lottie


class FailureController: UIViewController {

    @IBOutlet weak var payAmount: UILabel!
    @IBOutlet weak var communityName: UILabel!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var orderID: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var noteContainer: UIView!
    @IBOutlet weak var noteSubContainer: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var lotieView: UIView!
    
    var errorMessageString: String?
    var orderIDString: String?
    var orderIDDate: String?
    var amount: String?
    var pending = false
    private var progressView: AnimationView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
              
        progressView = .init(name: pending == false ? "Payment_failure" : "Payment_pending")
        progressView!.frame = lotieView.bounds
        progressView!.contentMode = .scaleAspectFit
        progressView!.loopMode = .loop
        lotieView.addSubview(progressView!)
        progressView!.play()
        
        statusLabel.textColor = pending == false ? UIColor(hex: "#EB5757") : UIColor(hex: "#EA9345")
        statusLabel.text = pending == false ? "Payment Failed to" : "Payment Pending to"
        
        noteContainer.layer.cornerRadius = 6
        noteContainer.layer.masksToBounds = true
        noteContainer.layer.borderWidth = 1
        noteContainer.layer.borderColor = UIColor(hex: "#2D9CDB").cgColor
        noteSubContainer.addLine(position: .LINE_POSITION_BOTTOM, color: UIColor(hex: "#2D9CDB"), width: 1.0)
        doneBtn.setTitle("OK", for: .normal)
        doneBtn.layer.cornerRadius = 6
        doneBtn.layer.masksToBounds = true
        doneBtn.backgroundColor = brandColor()
        doneBtn.setClickListener {
            self.navigationController?.popViewController(animated: true)
        }
        communityName.text = community.community_name
        payAmount.text = amount
                
        let attribute1 = NSMutableAttributedString(string: "Order ID ", attributes: [NSAttributedString.Key.font : SFFont(font: .Regular, size: 16), NSAttributedString.Key.foregroundColor: UIColor(hex: "#828282")])
        let attribute2 = NSAttributedString(string: orderIDString ?? "", attributes: [NSAttributedString.Key.font : SFFont(font: .Semibold, size: 16), NSAttributedString.Key.foregroundColor: UIColor(hex: "#333333")])
        attribute1.append(attribute2)
        orderID.attributedText = attribute1
        errorMessage.text = errorMessageString
        
        
        orderDate.text = "On "+timeConversion12(time24: (orderIDDate ?? ""))
        
        let boldText  = "Don’t worry, your money is safe."
        let remndingString = """
            If any amount deducted, it will be verified and refunded within 2-3 working days.
            
            In case of any queries, please reach us out by tapping on "Contact Support" menu available in dashboard.
            """
        let boldString = NSMutableAttributedString(string: boldText, attributes:[NSAttributedString.Key.font : SFFont(font: .Semibold, size: 16), NSAttributedString.Key.foregroundColor: UIColor.black])
        let attrStri = NSMutableAttributedString.init(string:remndingString, attributes:[NSAttributedString.Key.font : SFFont(font: .Regular, size: 16), NSAttributedString.Key.foregroundColor: UIColor(hex: "#333333")])
        boldString.append(attrStri)
        descriptionLabel.attributedText = boldString
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
