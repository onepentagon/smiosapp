//
//  VisitoControllerCell.swift
//  Smartility
//
//  Created by Mani on 7/13/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import MaterialComponents

class VisitoControllerCell: UITableViewCell {
    
    
    @IBOutlet weak var containerView: MDCCard!
    
    @IBOutlet weak var person_image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var catagory_image: UIImageView!
    @IBOutlet weak var visitorCatagory: UILabel!
    @IBOutlet weak var catagoryOrf: UILabel!
    @IBOutlet weak var status_label: UILabel!
        
    
    @IBOutlet weak var inDate: UILabel!
    @IBOutlet weak var outDate: UILabel!
    @IBOutlet weak var telephoneBtn: UIButton!
    @IBOutlet weak var telephonecontainer: MDCCard!
    @IBOutlet weak var withConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightArrow: UIImageView!
    
    @IBOutlet weak var leftArrow: UIImageView!
    @IBOutlet weak var tableData: UITableView!
    var data = [String]()
    var type = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        rightArrow.image = UIImage(named: "right_arrow")?.imageWithColor(color1: UIColor(hex: "#E26557"))
        leftArrow.image = UIImage(named: "left_arrow")?.imageWithColor(color1: UIColor(hex: "#E26557"))
        
        telephonecontainer.cornerRadius = telephonecontainer.frame.size.height/2
        person_image.layer.cornerRadius = person_image.frame.size.height/2
        person_image.layer.masksToBounds = true
                            
        containerView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        containerView.layer.cornerRadius = 5.0
        containerView.layer.shadowOffset = CGSize(width: -1,height: 1)
        containerView.layer.shadowOpacity = 0.2
        
        tableData.layer.cornerRadius = 5.0
        tableData.layer.masksToBounds = true
        
        let shadowPath = UIBezierPath(rect: containerView.layer.bounds)
        containerView.layer.shouldRasterize = true
        containerView.layer.shadowPath = shadowPath.cgPath
    }
    
    func setupColor(_ color: UIColor,_ str: String){
        status_label.backgroundColor = color
        status_label.text = str
        status_label.textColor = .white
        status_label.layer.cornerRadius = 5
        status_label.layer.masksToBounds = true
    }
    
    func passData(stArr:[String], type: String){
        self.type = type
        data = stArr
//        tableData.isUserInteractionEnabled = true
        tableData.delegate = self
        tableData.dataSource = self
        tableData.reloadData()
    }

}

extension VisitoControllerCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "approveTableCell", for: indexPath) as! approveTableCell
        let text = data[indexPath.row]
        if text == "invite" {
            cell.labelTex.text = "Invite"
        }else if text == "easypass" {
            cell.labelTex.text = "EasyPass"
        }else{
            cell.labelTex.text = text
        }            
        cell.labelTex.textAlignment = .left
        cell.labelTex.textColor = .black
        if self.type != "normal" {
            cell.labelTex.font = UIFont.italicSystemFont(ofSize: 12)
        }else{
            cell.labelTex.font = UIFont.systemFont(ofSize: 12)
        }
        cell.labelTex.textColor = UIColor.gray
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {       
        return 20
    }
}

