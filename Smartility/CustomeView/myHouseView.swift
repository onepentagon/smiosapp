//
//  myHouseView.swift
//  Smartility
//
//  Created by Mani on 4/1/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import Kingfisher

class myHouseView: UIView {

    
    @IBOutlet weak var swipeContainerView: UIView!
    @IBOutlet weak var swipeBarView: UIView!
    @IBOutlet weak var rightArrowInvoice: UIImageView!
    @IBOutlet weak var rightArrowProfile: UIImageView!
    
    @IBOutlet weak var invoiceBgview: UIView!
    @IBOutlet weak var invoiceTopView: UIView!
    @IBOutlet weak var invoiceBottomView: UIView!
    
    @IBOutlet weak var profileBgview: UIView!
    @IBOutlet weak var profileTopView: UIView!
    @IBOutlet weak var profileBottomView: UIView!
    
    
    func setupView(){
        swipeContainerView.layer.shadowColor = UIColor(red: 0.333, green: 0.184, blue: 0.933, alpha: 0.12).cgColor
        swipeContainerView.layer.shadowOpacity = 1
        swipeContainerView.layer.shadowRadius = 4
        swipeContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        [invoiceBgview, profileBgview].forEach { (view) in
            view?.backgroundColor = .clear
            view?.layer.masksToBounds = false
            view?.layer.shadowColor = UIColor(red: 0.333, green: 0.184, blue: 0.933, alpha: 0.12).cgColor
            view?.layer.shadowOpacity = 1
            view?.layer.shadowRadius = 4
            view?.layer.shadowOffset = CGSize(width: 0, height: 2)
        }
        [invoiceTopView,profileTopView].forEach { (view) in
            view?.backgroundColor = brandColor()
            view?.roundCorners(corners: [.topRight,.topLeft], radius: 6)
            view?.layer.masksToBounds = true
        }
        [invoiceBottomView,profileBottomView].forEach { (view) in
            view?.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 6)
            view?.layer.masksToBounds = true
        }
        self.roundCorners(corners: [.topLeft,.topRight], radius: 6)
        self.layer.masksToBounds = true
        swipeBarView.layer.cornerRadius = 2
        swipeBarView.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        setupView()
    }

}
