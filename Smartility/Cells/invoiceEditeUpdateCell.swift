//
//  invoiceEditeUpdateCell.swift
//  Smartility
//
//  Created by Mani on 2/21/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit

class invoiceEditeUpdateCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titileLabel: UILabel!
    @IBOutlet weak var textBoxContainer: UIView!
    @IBOutlet weak var invoiceDescLabel: UILabel!
    @IBOutlet weak var textFeildTextEdit: UITextField!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var doneBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var CheckBox: BEMCheckBox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setup()        
    }
    func setup(){
        self.backgroundColor = UIColor.clear
        setupCorners()
        CheckBox.boxType = .square
    }
    
    func setupCorners(){
        textFeildTextEdit.textColor = UIColor(hex: "828282")
        textFeildTextEdit.setLeftPaddingPoints(20)
//        doneBtnWidth.constant = 0
//        doneBtn.alpha = 0
//        editBtn.alpha = 0
        doneBtn.backgroundColor = infoColor()
        textBoxContainer.layer.cornerRadius = 6
        textBoxContainer.layer.masksToBounds = true
        containerView.layer.cornerRadius = 10
        
        layer.shadowRadius = 10
        layer.shadowColor = UIColor(red: 0.333, green: 0.184, blue: 0.933, alpha: 0.12).cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}

