//
//  InvoiceView.swift
//  Smartility
//
//  Created by Mani on 2/9/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit

class InvoiceView: UIView {
    @IBOutlet weak var invoiceView: UIView!
    @IBOutlet weak var invoiceRoundedView: UIView!
    @IBOutlet weak var invoicePendingContainerView: UIView!
    @IBOutlet weak var invoiceStatusLabel: UILabel!
    @IBOutlet weak var invoiceStatusPendingLabel: UILabel!
    
    @IBOutlet weak var invoiceNameLabel: UILabel!
    @IBOutlet weak var invoiceTotalAmount: UILabel!
    @IBOutlet weak var invoicePendingCountLabel: UILabel!
    @IBOutlet weak var invoicePayNowBtn: UIButton!
    @IBOutlet weak var invoiceIcon: UIImageView!
}
