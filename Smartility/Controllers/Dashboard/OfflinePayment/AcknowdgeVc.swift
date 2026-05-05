//
//  AcknowdgeVc.swift
//  Smartility
//
//  Created by Mani on 2/28/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import Lottie

class AcknowdgeVc: UIViewController {
    
    
    @IBOutlet weak var lotieView: UIView!
    @IBOutlet weak var paymentDesctiptionLabel: UILabel!
    @IBOutlet weak var dashBoartBtn: UIButton!

    private var progressView: AnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()
                              
        progressView = .init(name: "Offline_Payment_Success")
        progressView!.frame = lotieView.bounds
        progressView!.contentMode = .scaleAspectFit        
        lotieView.addSubview(progressView!)
        progressView?.loopMode = .loop
        progressView!.play()
        
        self.navigationController?.navigationBar.isHidden = true
        
        dashBoartBtn.backgroundColor = infoColor()
        dashBoartBtn.setTitleColor(.white, for: .normal)
        dashBoartBtn.setTitle("DONE", for: .normal)
        dashBoartBtn.mk_addTapHandler { (button) in
            NotificationCenter.default.post(name: NSNotification.Name("UpdateActions"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name("LoadingInvoices"), object: nil)
            if let destinationViewController = self.navigationController?.viewControllers
                                                                    .filter(
                                                  {$0 is Invoice_Payment_ViewController})
                                                                    .first {
                self.navigationController?.popToViewController(destinationViewController, animated: true)
            }
        }
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    override func viewDidLayoutSubviews() {
        dashBoartBtn.layer.cornerRadius = 6
        dashBoartBtn.layer.masksToBounds = true
    }
}
