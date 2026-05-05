//
//  tabbarWidgetView.swift
//  Smartility
//
//  Created by Mani on 4/1/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit

class tabbarWidgetView: UIView {
    
    @IBOutlet weak var widgetCurveView: UIImageView!
    @IBOutlet weak var swipeContainerView: UIView!
    @IBOutlet weak var swipeBarView: UIView!
    @IBOutlet weak var VisitorBackView: UIView!
    @IBOutlet weak var visitorBgView: UIView!
    @IBOutlet weak var newInviteView: UIView!
    @IBOutlet weak var newEasyPassView: UIView!
    @IBOutlet weak var noticeBoardBgView: UIView!
    @IBOutlet weak var noticeTopView: UIView!
    @IBOutlet weak var noticeBottomView: UIView!
            
    func setupView(){
        
        swipeContainerView.layer.shadowColor = UIColor(red: 0.333, green: 0.184, blue: 0.933, alpha: 0.12).cgColor
        swipeContainerView.layer.shadowOpacity = 1
        swipeContainerView.layer.shadowRadius = 4
        swipeContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        newInviteView.addLine(position: .LINE_POSITION_BOTTOM, color: UIColor(hex: "#BDBDBD"), width: 1.0)
        [VisitorBackView, noticeBoardBgView].forEach { (view) in
            view?.backgroundColor = .clear
            view?.layer.masksToBounds = false
            view?.layer.shadowColor = UIColor(red: 0.333, green: 0.184, blue: 0.933, alpha: 0.12).cgColor
            view?.layer.shadowOpacity = 1
            view?.layer.shadowRadius = 4
            view?.layer.shadowOffset = CGSize(width: 0, height: 2)
        }        
        [visitorBgView,noticeTopView].forEach { (view) in
            view?.backgroundColor = brandColor()
            view?.roundCorners(corners: [.topRight,.topLeft], radius: 6)
            view?.layer.masksToBounds = true
        }
        [newEasyPassView, noticeBottomView].forEach { (view) in
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
