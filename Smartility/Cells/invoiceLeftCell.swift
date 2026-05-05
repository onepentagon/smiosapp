//
//  invoiceLeftCell.swift
//  Smartility
//
//  Created by Mani on 2/17/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit

class invoiceLeftCell: UITableViewCell {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var invoiceTitle: UILabel!
    @IBOutlet weak var invoiceDate: UILabel!
    @IBOutlet weak var invoiceNo: UILabel!
    @IBOutlet weak var invoiceAmount: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setup()
    }
    
    func setup(){
        activityIndicator.style = .gray
        activityIndicator.color = brandColor()
        activityIndicator.hidesWhenStopped = true
        invoiceAmount.textColor = brandColor()
    }
    
    override func layoutSubviews() {
        viewContainer.layer.cornerRadius = 6
        viewContainer.layer.masksToBounds = true
        viewContainer.layer.borderWidth = 1.0
        viewContainer.layer.borderColor = UIColor(hex: "#BDBDBD").cgColor
        
    }
    
}
