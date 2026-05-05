//
//  EasyPassTableCell.swift
//  Smartility
//
//  Created by Mani on 7/15/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import MaterialComponents

class EasyPassTableCell: UITableViewCell {

    @IBOutlet weak var containerVIew: MDCCard!
    
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var catName: UILabel!
    @IBOutlet weak var date: UILabel!
        
    @IBOutlet weak var verified: UILabel!
    @IBOutlet weak var otherCard: UILabel!
        
    @IBOutlet weak var issuesByLabel: UILabel!
    @IBOutlet weak var notPassibleLable: UILabel!
    
    @IBOutlet weak var telephoneContainer: MDCCard!
    @IBOutlet weak var callBtnC: UIButton!
    @IBOutlet weak var stackBtn: UIStackView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var editeBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
            
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        telephoneContainer.cornerRadius = telephoneContainer.frame.size.height/2
        
        containerVIew.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        containerVIew.layer.cornerRadius = 5.0
        containerVIew.layer.shadowOffset = CGSize(width: -1,height: 1)
        containerVIew.layer.shadowOpacity = 0.2
        
        let shadowPath = UIBezierPath(rect: containerVIew.layer.bounds)
        containerVIew.layer.shouldRasterize = true
        containerVIew.layer.shadowPath = shadowPath.cgPath
        
        issuesByLabel.adjustsFontSizeToFitWidth = true
        profileIcon.layer.cornerRadius = profileIcon.frame.height/2
        profileIcon.layer.masksToBounds = true
        
        verified.textColor = UIColor(hex: "#219653")
        otherCard.adjustsFontSizeToFitWidth = true
        otherCard.layer.cornerRadius = 5
        otherCard.layer.masksToBounds = true
        otherCard.backgroundColor = UIColor(hex: "#E0E0E0")
    }

}
