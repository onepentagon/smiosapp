//
//  EasyPassTableViewCell.swift
//  Smartility
//
//  Created by Mani on 7/21/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import LTHRadioButton
import PhoneNumberKit

class EasyPassTableViewCell: UITableViewCell {

    
    @IBOutlet weak var descContainer: UIView!
    @IBOutlet weak var descLable: UILabel!
    
    @IBOutlet weak var personalRadio: LTHRadioButton!
    @IBOutlet weak var officialRadio: LTHRadioButton!
    @IBOutlet weak var officialLabel: UILabel!    
    @IBOutlet weak var personalLabel: UILabel!
    
    
    @IBOutlet weak var profile_icon: UIImageView!
    @IBOutlet weak var attachLable: UILabel!
    @IBOutlet weak var profileCamBtn: UIButton!
    
    @IBOutlet weak var unitFeild: UITextField!
    @IBOutlet weak var issuedForFeild: UITextField!
    
    @IBOutlet weak var mobileFeild: PhoneNumberTextField!
    
    @IBOutlet weak var visitorName: UITextField!
    @IBOutlet weak var gender: UITextField!
    
    @IBOutlet weak var vehicleNumber: UITextField!
    @IBOutlet weak var vehicleType: UITextField!
        
    @IBOutlet weak var Noexpiry: UIButton!
    @IBOutlet weak var ExpiryBtn: UIButton!
    
    @IBOutlet weak var expiryFeild: UITextField!
    @IBOutlet weak var verifiedIDType: UITextField!
        
    @IBOutlet weak var verified_image: UIImageView!
    @IBOutlet weak var verifiedCamBtn: UIButton!
    @IBOutlet weak var notAvailabeLabel: UILabel!
        
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var easyPassBtn: UIButton!
    
    @IBOutlet weak var unitHieght: NSLayoutConstraint!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var hightSpace: NSLayoutConstraint!
    @IBOutlet weak var sendBtnWidthConstaint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if #available(iOS 11.0, *) {
            mobileFeild.withDefaultPickerUI = true
        } else {
            // Fallback on earlier versions
        }
        mobileFeild.withExamplePlaceholder = true
        mobileFeild.withFlag = true
        
        personalRadio.selectedColor = brandColor()
        officialRadio.selectedColor = brandColor()
        
        visitorName.addDoneButtonOnKeyboard()
        vehicleNumber.addDoneButtonOnKeyboard()
//        mobileFeild.addDoneButtonOnKeyboard()
//        mobileFeild.setLeftPaddingPoints(5)
        mobileFeild.keyboardType = .phonePad
        
        cancelBtn.layer.cornerRadius = 10
        cancelBtn.layer.masksToBounds = true
        
        easyPassBtn.layer.cornerRadius = 10
        easyPassBtn.layer.masksToBounds = true
        
        Noexpiry.layer.cornerRadius = 10
        Noexpiry.layer.masksToBounds = true
        
        ExpiryBtn.layer.cornerRadius = 10
        ExpiryBtn.layer.masksToBounds = true
        
        descContainer.layer.cornerRadius = 5
        descContainer.layer.borderColor = UIColor(hex: "#2D9CDB").cgColor
        descContainer.layer.borderWidth = 1.0

        descLable.textColor = .black
        
        unitFeild.setupRightImage(imageName: "dropDown")
        issuedForFeild.setupRightImage(imageName: "dropDown")
        gender.setupRightImage(imageName: "dropDown")
        vehicleType.setupRightImage(imageName: "dropDown")
        verifiedIDType.setupRightImage(imageName: "dropDown")
        
        unitFeild.addLine(position: .LINE_POSITION_BOTTOM, color: .lightGray, width: 1.0)
        issuedForFeild.addLine(position: .LINE_POSITION_BOTTOM, color: .lightGray, width: 1.0)
        mobileFeild.addLine(position: .LINE_POSITION_BOTTOM, color: .lightGray, width: 1.0)
        visitorName.addLine(position: .LINE_POSITION_BOTTOM, color: .lightGray, width: 1.0)
        gender.addLine(position: .LINE_POSITION_BOTTOM, color: .lightGray, width: 1.0)
        
        vehicleNumber.addLine(position: .LINE_POSITION_BOTTOM, color: .lightGray, width: 1.0)
        vehicleType.addLine(position: .LINE_POSITION_BOTTOM, color: .lightGray, width: 1.0)
        
        expiryFeild.addLine(position: .LINE_POSITION_BOTTOM, color: .lightGray, width: 1.0)
        verifiedIDType.addLine(position: .LINE_POSITION_BOTTOM, color: .lightGray, width: 1.0)
        
        
        cancelBtn.backgroundColor = UIColor.clear
        easyPassBtn.backgroundColor = UIColor.clear//UIColor(hex: "00AAD4")
        
//        cancelBtn.layer.borderColor = UIColor(hex: "00AAD4").cgColor
//        cancelBtn.layer.borderWidth = 1.0
        cancelBtn.layer.cornerRadius = 4.0
        cancelBtn.layer.masksToBounds = true
                
        easyPassBtn.layer.cornerRadius = 4.0
        easyPassBtn.layer.masksToBounds = true
        
        profile_icon.layer.borderColor = brandColor().cgColor
        profile_icon.layer.borderWidth = 1.0
        
        verified_image.layer.borderColor = brandColor().cgColor
        verified_image.layer.borderWidth = 1.0              
    }

}
