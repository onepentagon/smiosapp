//
//  NotificationSettingsCell.swift
//  Smartility
//
//  Created by Mani on 9/25/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import MaterialComponents.MDCCard

class NotificationSettingsCell: UITableViewCell {
    
    @IBOutlet weak var notificationView: MDCCard!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
