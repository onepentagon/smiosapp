//
//  InvoicePayementDetailsCell.swift
//  Smartility
//
//  Created by Mani on 2/21/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit

class InvoicePayementDetailsCell: UITableViewCell {
    @IBOutlet weak var ContainerViewFeild: UIView!
    @IBOutlet weak var topLabel: PaddingLabel!
    @IBOutlet weak var textFild: UITextField!
    @IBOutlet weak var containerViewArrow: UIView!
    @IBOutlet weak var arrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setup()
    }
    
    func setup(){
        textFild.setLeftPaddingPoints(10)
        ContainerViewFeild.layer.cornerRadius = 6
        ContainerViewFeild.layer.masksToBounds = true
        ContainerViewFeild.layer.borderWidth = 1.0
        ContainerViewFeild.layer.borderColor = UIColor(hex: "#4F4F4F").cgColor
    }
    
}

class PaddingLabel: UILabel {
    
    var topInset: CGFloat = 0.0
    var bottomInset: CGFloat = 0.0
    var leftInset: CGFloat = 5.0
    var rightInset: CGFloat = 5.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    
    override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}
