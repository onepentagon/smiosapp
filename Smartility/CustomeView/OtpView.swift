//
//  OtpView.swift
//  Smartility
//
//  Created by Mani on 7/6/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import PhoneNumberKit

class OtpView: UIView {
    
    @IBOutlet weak var cancel_btn: UIButton!
    @IBOutlet weak var login_btn: UIButton!
    @IBOutlet weak var send_otp: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!        
    @IBOutlet weak var phoneNumberfeild: PhoneNumberTextField!
    @IBOutlet weak var otpViewContraint: NSLayoutConstraint!    
    @IBOutlet weak var otpfeild: SkyFloatingLabelTextField!
}
