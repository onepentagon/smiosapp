//
//  ProfileTableCell.swift
//  Smartility
//
//  Created by Mani on 9/28/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import MaterialComponents.MDCCard
import PhoneNumberKit

class ProfileTableCell: UITableViewCell {

    
    @IBOutlet weak var edite_image: UIImageView!
    @IBOutlet weak var bgProfileImage: MDCCard!
    @IBOutlet weak var camBtn: UIImageView!    
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var phoneNumber: PhoneNumberTextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var checkBox: BEMCheckBox!
    @IBOutlet weak var hideLabel: UILabel!
    @IBOutlet weak var emergencyPhone: UITextField!
    @IBOutlet weak var contactName: UITextField!
    @IBOutlet weak var contactRelation: UITextField!
    @IBOutlet weak var bloodGrp: UITextField!
    @IBOutlet weak var occupation: UITextField!
    @IBOutlet weak var hobbies: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var pinCode: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var gstIdentificationNo: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var isAdminBtn: UIButton!
    @IBOutlet weak var presidentBt: UIButton!
    
    @IBOutlet weak var presidentContraint: NSLayoutConstraint!
    @IBOutlet weak var adminConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var sendOTPConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendOTPBtn: UIButton!
    @IBOutlet weak var mobileVerificationContainer: MDCCard!
    @IBOutlet weak var mobileVerificationConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var otpFeild: UITextField!
    @IBOutlet weak var registerNumber: UIButton!
    @IBOutlet weak var otpDescLabel: UILabel!
    
    
    @IBOutlet weak var raxinfo: UILabel!
    @IBOutlet weak var hideConstaint: NSLayoutConstraint!
    
    @IBOutlet weak var persidentHeight: NSLayoutConstraint!
    @IBOutlet weak var adminHeigh: NSLayoutConstraint!        
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        phoneNumber.withFlag = true
        phoneNumber.withExamplePlaceholder = true
        
        mobileVerificationContainer.layer.cornerRadius = 2
        mobileVerificationContainer.layer.masksToBounds = true
                
        registerNumber.layer.cornerRadius = 2
        registerNumber.layer.masksToBounds = true
        
        registerNumber.layer.borderWidth = 1.0
        registerNumber.layer.borderColor = UIColor.lightGray.cgColor
        
        profileIcon.contentMode = .scaleToFill
        profileIcon.layer.cornerRadius = profileIcon.frame.size.height/2
        profileIcon.layer.masksToBounds = true
        
        bgProfileImage.cornerRadius = bgProfileImage.frame.size.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
