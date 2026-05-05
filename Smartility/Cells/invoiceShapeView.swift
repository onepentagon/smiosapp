//
//  invoiceShapeView.swift
//  Smartility
//
//  Created by Mani on 2/15/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit

class invoiceShapeView: UIView {
    
    var path: UIBezierPath = UIBezierPath()
    var circleYPosition: CGFloat = 137 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
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

@IBDesignable class DottedHorizontal: UIView {

    @IBInspectable var dotColor: UIColor = UIColor.red
    @IBInspectable var lowerHalfOnly: Bool = false

    override func draw(_ rect: CGRect) {

        let path = UIBezierPath()

        path.move(to: CGPoint(x: 5, y: 5))
        path.addLine(to: CGPoint(x: 5, y: frame.origin.y + bounds.size.height))

        path.lineWidth = 1

        let dashes: [CGFloat] = [2, 2]
        path.setLineDash(dashes, count: dashes.count, phase: 0)

        dotColor.setStroke()
        path.stroke()
    }
}

class maintanaceShapView: UIView{
    
    var path: UIBezierPath = UIBezierPath()
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        UIBezierPath(roundedRect: rect, byRoundingCorners: [.topRight,.topLeft], cornerRadii: CGSize(width: 6, height: 6)).addClip()
        path.move(to: CGPoint(x: 0, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        path.close()
        UIColor(hex: "#E0E0E0").setFill()
        path.fill()
    }
}
