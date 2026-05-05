//
//  pdfTableViewCell.swift
//  Smartility
//
//  Created by Mani on 12/16/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit

class pdfTableViewCell: UITableViewCell {
    @IBOutlet weak var pdfCell: UILabel!
    
    @IBOutlet weak var pdfCell_width: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pdfCell.layer.cornerRadius = 10
        pdfCell.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
