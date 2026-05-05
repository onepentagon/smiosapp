//
//  invoicePaymentCell.swift
//  Smartility
//
//  Created by Mani on 2/15/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit

class invoicePaymentCell: UITableViewCell {

    @IBOutlet weak var paidDescLabel: UILabel!
    @IBOutlet weak var paidImageView: UIImageView!
    @IBOutlet weak var editeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
