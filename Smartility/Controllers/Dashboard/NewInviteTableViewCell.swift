//
//  NewInviteTableViewCell.swift
//  Smartility
//
//  Created by Mani on 7/20/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import LTHRadioButton
import PhoneNumberKit

class NewInviteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var personalRadio: LTHRadioButton!
    @IBOutlet weak var officialRadio: LTHRadioButton!
    
    @IBOutlet weak var officialLabel: UILabel!
    @IBOutlet weak var personalLabel: UILabel!
    
    @IBOutlet weak var unitIDFeild: UITextField!
    
    @IBOutlet weak var mobileNoFeild: PhoneNumberTextField!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var shortlyLabel: UILabel!
    
    @IBOutlet weak var dateFeild: UITextField!
    @IBOutlet weak var aroundFeild: UITextField!
    
    @IBOutlet weak var gladBckView: UIView!
    @IBOutlet weak var gladeText: UILabel!
    
    @IBOutlet weak var editeBack: UIView!
    @IBOutlet weak var laterLabel: UILabel!
    @IBOutlet weak var editeText: UITextView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sendInviteBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var editeLabel: UILabel!
    
    @IBOutlet weak var heightConsta: NSLayoutConstraint!
    
    @IBOutlet weak var spaceunitNoConstaint: NSLayoutConstraint!
    @IBOutlet weak var radioConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var officialHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var unitHeightConstraint: NSLayoutConstraint!
        
    @IBOutlet weak var sendBtnWidthConstaint: NSLayoutConstraint!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
        

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
                    
        if #available(iOS 11.0, *) {
            mobileNoFeild.withDefaultPickerUI = true
        } else {
            // Fallback on earlier versions
        }
        
        personalRadio.selectedColor = brandColor()
        officialRadio.selectedColor = brandColor()
        
        mobileNoFeild.withExamplePlaceholder = true
        mobileNoFeild.withFlag = true
        
        unitIDFeild.addLine(position: .LINE_POSITION_BOTTOM, color: .black, width: 0.5)
        mobileNoFeild.addLine(position: .LINE_POSITION_BOTTOM, color: .black, width: 0.5)
        name.addLine(position: .LINE_POSITION_BOTTOM, color: .black, width: 0.5)
        
        dateFeild.addLine(position: .LINE_POSITION_BOTTOM, color: .black, width: 0.5)
        aroundFeild.addLine(position: .LINE_POSITION_BOTTOM, color: .black, width: 0.5)
                        
        gladBckView.layer.borderWidth = 1.0
        gladBckView.layer.borderColor = UIColor(hex: "#2D9CDB").cgColor
        
        gladBckView.layer.borderWidth = 1.0
        gladeText.textColor = .black
                                        
//        cancelBtn.backgroundColor = UIColor.clear
//        sendInviteBtn.backgroundColor = UIColor(hex: "00AAD4")
        
        
//        cancelBtn.layer.borderColor = UIColor(hex: "00AAD4").cgColor
//        cancelBtn.layer.borderWidth = 1.0
        cancelBtn.layer.cornerRadius = 4.0
        cancelBtn.layer.masksToBounds = true
                
        sendInviteBtn.layer.masksToBounds = false
        sendInviteBtn.layer.cornerRadius = 4.0
        
    }
    
   
}
