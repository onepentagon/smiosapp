//
//  CommunityDropDownCell.swift
//  Smartility
//
//  Created by Mani on 4/7/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit

class CommunityDropDownCell: UITableViewCell {
    
    @IBOutlet weak var communityName: UILabel!
    @IBOutlet weak var selectedCheckMark: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
