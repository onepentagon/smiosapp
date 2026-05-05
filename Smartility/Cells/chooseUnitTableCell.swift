//
//  chooseUnitTableCell.swift
//  Smartility
//
//  Created by Mani on 2/12/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit

class chooseUnitTableCell: UITableViewCell {
    
    @IBOutlet weak var unitName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setup()
    }
    func setup(){
        self.backgroundColor = .clear        
    }
}
