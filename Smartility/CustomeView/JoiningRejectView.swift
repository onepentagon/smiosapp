//
//  JoiningRejectView.swift
//  Smartility
//
//  Created by Mani on 1/22/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit

class JoiningRejectView: UIView {
    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var canceBtn: UIButton!
    @IBOutlet weak var okeyBtn: UIButton! 
    @IBOutlet weak var textBoxContainer: UIView!
    
    func setup(){
        textBoxContainer.layer.cornerRadius = 8
        textBoxContainer.layer.masksToBounds = true
        textBoxContainer.layer.borderWidth = 1
        textBoxContainer.layer.borderColor = UIColor(red: 0.31, green: 0.31, blue: 0.31, alpha: 1).cgColor
        textview.keyboardType = .default
        textview.keyboardAppearance = .dark
        canceBtn.setTitleColor(.white, for: .normal)
        okeyBtn.setTitleColor(accentColor(), for: .normal)
    }
}
