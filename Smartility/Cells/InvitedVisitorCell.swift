//
//  InvitedVisitorCell.swift
//  Smartility
//
//  Created by Mani on 7/11/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import Kingfisher
import MaterialComponents

class InvitedVisitorCell: UITableViewCell {

    @IBOutlet weak var containerVivew: MDCCard!
    @IBOutlet weak var noneLabel: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var newIntviteClicked: UILabel!
    @IBOutlet weak var viewMoreLabel: UILabel!
    
        
    var data: InvitedVisitorModel?
    var gradientLayer: CAGradientLayer? = nil
    var newInviteClosure: (()-> Void)?
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundColor = UIColor.clear
        containerVivew.backgroundColor = UIColor.clear
        
        let layout = CenterFlowLayout()
        collection.collectionViewLayout = layout
        newIntviteClicked.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(newInviteClicked)))
                         
    }
    
    
    @objc func newInviteClicked(){
        newInviteClosure?()
    }
    
    
    func setup(model:InvitedVisitorModel){
        self.data = model
        collection.delegate = self
        collection.dataSource = self
        collection.reloadData()
    }

}


extension InvitedVisitorCell: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = data?.stats?.count, count != 0 {
            noneLabel.text = ""
            if count > 3 {
                viewMoreLabel.isHidden = false
            }else{
                viewMoreLabel.isHidden = true
            }
            return count
        }else{
            viewMoreLabel.isHidden = true
            noneLabel.text = "None"
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionInvitedVisitorCell", for: indexPath) as! CollectionInvitedVisitorCell
        if let dynamic = data?.stats?[safe: indexPath.row] {
            
            if let catagory = dynamic.visitor_cat {
                                
                if catagory == "Daily Helper" {
                    cell.icon.image = UIImage(named: "people_Black")
                    cell._catagoryName.text = "Daily Helper"
                }else if catagory == "Cab" {
                    cell._catagoryName.text = "Cab"
                    cell.icon.image = UIImage(named: "Cab_Black")
                }else if catagory == "Guest" {
                    cell._catagoryName.text = "Guest"
                    cell.icon.image = UIImage(named: "faceIconBlack")
                }else if catagory == "Delivery" {
                    cell.icon.image = UIImage(named: "shopping_cartBlack")
                    cell._catagoryName.text = "Delivery"
                }else if catagory == "Vendor" {
                    cell._catagoryName.text = "Vendor"
                    cell.icon.image = UIImage(named: "build_icon_black")
                }else{
                    cell._catagoryName.text = "Guest"
                    cell.icon.image = UIImage(named: "person_icon")
                }
            }
            if let count = dynamic.tot_rec {
                cell._count.text = "\(count)"
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 100, height: collectionView.frame.size.height)
    }
}

