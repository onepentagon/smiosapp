//
//  visitorRoundedCollectionViewCell.swift
//  Smartility
//
//  Created by Mani on 4/12/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit

class visitorRoundedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewRounded: UIImageView!
    @IBOutlet weak var roundedBgView: UIView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        rounded()
    }
    
    func rounded(){
        roundedBgView.layer.cornerRadius = roundedBgView.frame.height/2
        roundedBgView.layer.masksToBounds = true
        imageViewRounded.layer.cornerRadius = imageViewRounded.frame.height/2
        imageViewRounded.layer.masksToBounds = true
    }
    override func layoutSubviews() {
        rounded()
    }
    override func prepareForReuse() {
//        imageViewRounded.image = nil
    }
}
