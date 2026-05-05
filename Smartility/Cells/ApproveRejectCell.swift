//
//  ApproveRejectCell.swift
//  Smartility
//
//  Created by Mani on 1/22/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import MaterialComponents

class ApproveRejectCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var blocknm: UILabel!
    @IBOutlet weak var ownership: UILabel!
    
    @IBOutlet weak var relationship: UILabel!
    @IBOutlet weak var contact_no: UILabel!
    @IBOutlet weak var email: UILabel!
   
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var containerView: MDCCard!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setup()
    }

    
    func setup(){
       
        containerView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        containerView.layer.cornerRadius = 5.0
        containerView.layer.shadowOffset = CGSize(width: -1,height: 1)
        containerView.layer.shadowOpacity = 0.2

        let shadowPath = UIBezierPath(rect: containerView.layer.bounds)
        containerView.layer.shouldRasterize = true
        containerView.layer.shadowPath = shadowPath.cgPath
        acceptBtn.setTitleColor(brandColor(), for: .normal)
    }
    
    func ApplyCell(data: joingRequestModel?){
        name.text = data?.cust_name
        var blockNm_un = ""
        if let bm = data?.block_nm {
            blockNm_un = bm
        }
        if let un = data?.unit_no {
            blockNm_un = blockNm_un + " "+un
        }
        blocknm.text = blockNm_un
        ownership.text = data?.ownership
        
        relationship.text = data?.role_name
        contact_no.text = data?.contact_phone
        email.text = data?.contact_email
    }
}
