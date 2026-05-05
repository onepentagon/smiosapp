//
//  InvitedTableCell.swift
//  Smartility
//
//  Created by Mani on 7/14/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import MaterialComponents

class InvitedTableCell: UITableViewCell {
    
    @IBOutlet weak var containerVIew: MDCCard!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var statusBtn: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var cat_name: UILabel!
    @IBOutlet weak var rolename: UILabel!        
    @IBOutlet weak var callContainer: MDCCard!
    @IBOutlet weak var callBtn: UIButton!
    
    @IBOutlet weak var deletBtn: UIButton!
    @IBOutlet weak var editeBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var setReminder: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        callContainer.cornerRadius = callContainer.frame.size.height/2
        
        statusBtn.layer.cornerRadius = 5
        statusBtn.layer.masksToBounds = true
        
        containerVIew.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        containerVIew.layer.cornerRadius = 5.0
        containerVIew.layer.shadowOffset = CGSize(width: -1,height: 1)
        containerVIew.layer.shadowOpacity = 0.2
        
        let shadowPath = UIBezierPath(rect: containerVIew.layer.bounds)
        containerVIew.layer.shouldRasterize = true
        containerVIew.layer.shadowPath = shadowPath.cgPath
        
    }

}
