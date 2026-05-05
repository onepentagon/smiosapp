//
//  invoicePopUp.swift
//  Smartility
//
//  Created by Mani on 2/19/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import LTHRadioButton

class invoicePopUp: UIView {
    
    @IBOutlet weak var pastDue: UILabel!
    @IBOutlet weak var dueToday: UILabel!
    @IBOutlet weak var unPaid: UILabel!
    @IBOutlet weak var paritiallyPaid: UILabel!
    
    @IBOutlet weak var invoiceShapView: invoiceShapeView!
    @IBOutlet weak var containerTopView: maintanaceShapView!
    @IBOutlet weak var invoiceType: UILabel!
    
    @IBOutlet weak var ivoiceAmount: UILabel!
    @IBOutlet weak var ivoiceNo: UILabel!
    @IBOutlet weak var invDate: UILabel!
    @IBOutlet weak var DueDate: UILabel!
    
    @IBOutlet weak var fromDate: UILabel!
    @IBOutlet weak var tillDate: UILabel!
    
    @IBOutlet weak var downloadInvoiceBtn: UIButton!
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
            
    @IBOutlet weak var invDateBtb: LTHRadioButton!
    @IBOutlet weak var dueDtBtn: LTHRadioButton!
    @IBOutlet weak var billingPeriod: UILabel!
    
    func updateData(){
        dueDtBtn.backgroundColor = .white
        invDateBtb.backgroundColor = .clear
        invDateBtb.selectedColor = UIColor(hex: "#6FCF97")
        dueDtBtn.selectedColor = UIColor(hex: "#6FCF97")
        invDateBtb.select()
                
        invDateBtb.select()
        containerTopView.roundCorners(corners: [.topLeft,.topRight], radius: 6)
        containerTopView.layer.masksToBounds = true
        invoiceType.textColor = infoColor()
        ivoiceAmount.textColor = infoColor()
        
        downloadInvoiceBtn.layer.cornerRadius = 6
        downloadInvoiceBtn.layer.masksToBounds = true
        downloadInvoiceBtn.layer.borderWidth = 1
        downloadInvoiceBtn.layer.borderColor = infoColor()?.cgColor
        downloadInvoiceBtn.setTitleColor(infoColor(), for: .normal)
    }   
}
