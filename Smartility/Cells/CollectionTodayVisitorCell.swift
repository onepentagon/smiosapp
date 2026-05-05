//
//  CollectionTodayVisitorCell.swift
//  Smartility
//
//  Created by Mani on 7/12/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit

class CollectionTodayVisitorCell: UICollectionViewCell {
         
    @IBOutlet weak var _image_view: UIImageView!
    @IBOutlet weak var _image_container_view: UIView!
    @IBOutlet weak var _catgoryName: UILabel!
    @IBOutlet weak var _count: UILabel!
    
    override func awakeFromNib() {
        
        _image_container_view.layer.cornerRadius = _image_container_view.frame.width/2
        _image_container_view.layer.masksToBounds = true
        
        _image_view.layer.cornerRadius = _image_view.frame.width/2
        _image_view.layer.masksToBounds = true
    }
    
    
}
