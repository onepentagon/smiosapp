//
//  PaymentTimeoutController.swift
//  Smartility
//
//  Created by Mani on 5/22/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import Lottie


class PaymentTimeoutController: UIViewController {

    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var noteContainer: UIView!
    @IBOutlet weak var noteSubContainer: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    private var progressView: AnimationView?
    @IBOutlet weak var lotieView: LottieView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        progressView = .init(name: "Payment_failure")
        progressView!.frame = lotieView.bounds
        progressView!.contentMode = .scaleAspectFit
        progressView!.loopMode = .loop        
        lotieView.addSubview(progressView!)
        progressView!.play()
        
        doneBtn.setTitle("OK", for: .normal)
        doneBtn.layer.cornerRadius = 6
        doneBtn.layer.masksToBounds = true
        doneBtn.backgroundColor = brandColor()
        doneBtn.setClickListener {
            self.navigationController?.popViewController(animated: true)
        }
        
        noteContainer.layer.cornerRadius = 6
        noteContainer.layer.masksToBounds = true
        noteContainer.layer.borderWidth = 1
        noteContainer.layer.borderColor = UIColor(hex: "#2D9CDB").cgColor
        noteSubContainer.addLine(position: .LINE_POSITION_BOTTOM, color: UIColor(hex: "#2D9CDB"), width: 1.0)
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
