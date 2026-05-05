//
//  PaymentShapView.swift
//  Smartility
//
//  Created by Mani on 2/20/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import Foundation
import UIKit

class PaymentShapView: UIView {
    
    @IBOutlet weak var receiptTitle: UILabel!
    @IBOutlet weak var receiptAmount: UILabel!
    @IBOutlet weak var pendingReceiptLabel: UILabel!    
    @IBOutlet weak var receiptDateFromTO: UILabel!
    @IBOutlet weak var paidByName: UILabel!
    @IBOutlet weak var paidMode: UILabel!
    @IBOutlet weak var transferNo: UILabel!
    @IBOutlet weak var paymentDesc: UILabel!
    @IBOutlet weak var iconDesc: UIImageView!
    @IBOutlet weak var downloadReceipt: UIButton!
    @IBOutlet weak var downloadReceiptHeight: NSLayoutConstraint!
    @IBOutlet weak var downloadReceiptBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var receiptTable: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var paidTowardsLable: UILabel!
    
    var path: UIBezierPath = UIBezierPath()
    var circleYPosition: CGFloat = 219 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
                        
        receiptTitle.textColor = infoColor()
        downloadReceipt.layer.cornerRadius = 6
        downloadReceipt.layer.masksToBounds = true
        downloadReceipt.layer.borderWidth = 1
        downloadReceipt.layer.borderColor = infoColor()?.cgColor
        downloadReceipt.setTitleColor(infoColor(), for: .normal)
        
        receiptAmount.textColor = infoColor()
        self.contentMode = .redraw
        self.backgroundColor = UIColor.clear
        layer.shadowRadius = 10
        layer.shadowColor = UIColor(red: 0.333, green: 0.184, blue: 0.933, alpha: 0.12).cgColor
        layer.shadowOpacity = 1
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // 4 corners radious
        UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 12, height: 12)).addClip()
        // Left - right circle
        path.move(to: CGPoint(x: 0, y: self.frame.size.height))
        //left side
        path.addArc(withCenter: CGPoint(x: 0, y: self.circleYPosition - 15),
                    radius: 20,
                    startAngle: CGFloat((90 * Double.pi) / 180),
                    endAngle: CGFloat((270 * Double.pi) / 180),
                    clockwise: false)
        
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        
        path.move(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        
        //right side
        path.addArc(withCenter: CGPoint(x: self.frame.size.width, y: self.circleYPosition - 15),
                    radius: 20,
                    startAngle: CGFloat((270 * Double.pi) / 180),
                    endAngle: CGFloat((90 * Double.pi) / 180),
                    clockwise: false)
        
        
        path.close()
        UIColor.white.setFill()
        path.fill()
        
        // Center Dash path
        let dashPath = UIBezierPath()
        dashPath.move(to: CGPoint(x: self.bounds.minX + 20, y: self.circleYPosition - 15))
        dashPath.addLine(to: CGPoint(x: self.bounds.maxX - 20, y: self.circleYPosition - 15))
        dashPath.setLineDash([5,5], count: 2, phase: 0.0)
        dashPath.lineWidth = 1.0
        dashPath.lineCapStyle = .butt
        UIColor.lightGray.set()
        dashPath.stroke()
    }
    
}
