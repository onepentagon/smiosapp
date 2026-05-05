//
//  invoicePopUpDetailsCell.swift
//  Smartility
//
//  Created by Mani on 2/20/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit

class invoicePopUpDetailsCell: UITableViewCell {

    @IBOutlet weak var dueTitleLabel: UILabel!
    @IBOutlet weak var dateFromT0: UILabel!
    @IBOutlet weak var dueAmount: UILabel!
    @IBOutlet weak var dueDesc: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
