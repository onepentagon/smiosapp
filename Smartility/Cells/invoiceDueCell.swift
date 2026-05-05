//
//  invoiceDueCell.swift
//  Smartility
//
//  Created by Mani on 2/15/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit

class invoiceDueCell: UITableViewCell {
    
    @IBOutlet weak var dueAmount: UILabel!
    @IBOutlet weak var dueTitleLabel: UILabel!
    @IBOutlet weak var dueDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setup()
    }
    
    func setup(){
        dueAmount.textColor = UIColor(hex: "#4F4F4F")
        dueTitleLabel.textColor = UIColor(hex: "#4F4F4F")
        dueDesc.textColor = UIColor(hex: "#4F4F4F")
    }
    
}
