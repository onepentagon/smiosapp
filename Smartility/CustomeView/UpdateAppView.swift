//
//  UpdatedAppView.swift
//  Smartility
//
//  Created by Mani Kandan on 07/06/2021.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit

class UpdateAppView: UIView {
    
    @IBOutlet weak var updateVersionLabel: UILabel!
    @IBOutlet weak var updateNowBtn: UIButton!
    @IBOutlet weak var notNowBtn: UIButton!
    
    
    func setupUI(){
        updateVersionLabel.textColor = brandColor()
        notNowBtn.setTitleColor(brandColor(), for: .normal)
        updateNowBtn.backgroundColor = brandColor()
        notNowBtn.layer.borderWidth = 1.0
        notNowBtn.layer.borderColor = brandColor().cgColor
    }
    override func layoutSubviews() {
        notNowBtn.layer.cornerRadius = 6
        notNowBtn.layer.masksToBounds = true
        updateNowBtn.layer.cornerRadius = 6
        updateNowBtn.layer.masksToBounds = true
    }
}
