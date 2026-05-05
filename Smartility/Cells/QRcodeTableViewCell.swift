//
//  QRcodeTableViewCell.swift
//  Smartility
//
//  Created by Mani on 12/29/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import MaterialComponents

class QRcodeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: MDCCard!
    @IBOutlet weak var subContainer: UIView!
    @IBOutlet weak var shareContainer: UIView!
    @IBOutlet weak var smartilityLogoContainer: UIView!
    @IBOutlet weak var smartilityLogo: UIImageView!
    @IBOutlet weak var qrcodeImage: UIImageView!
    
    @IBOutlet weak var staticText: UILabel!
    @IBOutlet weak var titleCard: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var gladText: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var qrCodeNumber: UILabel!
    @IBOutlet weak var locationimage: UIImageView!
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        setup()
    }
    
    override func layoutSubviews() {
        setup()
    }

    
    func setup(){
        locationimage.image = UIImage(named: "location")?.imageWithColor(color1: .white)
        containerView.cornerRadius = 25
        subContainer.layer.cornerRadius = 25
        subContainer.layer.masksToBounds = true
    }
}
