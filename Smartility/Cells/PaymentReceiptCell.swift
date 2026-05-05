//
//  PaymentReceiptCell.swift
//  Smartility
//
//  Created by Mani on 2/20/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit

class PaymentReceiptCell: UITableViewCell {

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var amountDesc: UILabel!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkBoxImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setup()
    }
    func setup(){
//        descLabel.textColor = UIColor(hex: "#27AE60")
//        amountDesc.textColor = UIColor(hex: "#27AE60")
    }
}
