//
//  NoticeCollectionViewCell.swift
//  Smartility
//
//  Created by Mani on 4/2/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit

class NoticeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var noticeTitle: UILabel!
    @IBOutlet weak var noticeDescription: UILabel!
    @IBOutlet weak var noNotice: UILabel!
    
    override func layoutSubviews() {        
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
    }
}
