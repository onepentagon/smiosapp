//
//  EasyPassCell.swift
//  Smartility
//
//  Created by Mani on 7/11/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import MaterialComponents

class EasyPassCell: UITableViewCell {
    
    @IBOutlet weak var containerView: MDCCard!
    @IBOutlet weak var noneLabel: UILabel!
    @IBOutlet weak var newPassLabel: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var viewMoreLabel: UILabel!
    
    
    var data: EasyPassHolderModel?
    var gradientLayer: CAGradientLayer? = nil
    let layout = CenterFlowLayout()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collection.collectionViewLayout = layout
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.clear
        
        if gradientLayer == nil {
            let colorTop =  UIColor(hex:"44F16F").cgColor
            let colorBottom = UIColor.white.cgColor
            gradientLayer = CAGradientLayer()
            gradientLayer?.colors = [colorTop, colorBottom]
            gradientLayer?.locations = [0.5, 1.2]
            
            if UIDevice().userInterfaceIdiom == .phone {
                print(UIScreen.main.nativeBounds.height)
                switch UIScreen.main.nativeBounds.height {
                case 1136:
                    print("iPhone 5 or 5S or 5C")
                    gradientLayer?.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: 150)
                case 1334:
                    print("iPhone 6/6S/7/8")
                    gradientLayer?.frame = CGRect(x: 0, y: 0, width: containerView.frame.width-37, height: 150)
                case 1920, 2208:
                    print("iPhone 6+/6S+/7+/8+")
                    gradientLayer?.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: 150)
                case 2436:                    
                    print("iPhone X/ XS/ 11 Pro/ iPhone 12 mini")
                    gradientLayer?.frame = CGRect(x: 0, y: 0, width: containerView.frame.width-37, height: 150)
                case 2688:
                    print("iPhone XS Max/11 Pro Max")
                    gradientLayer?.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: 150)
                case 1792:
                    print("iPhone XR/ 11 ")
                    gradientLayer?.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: 150)
                case 2532:
                    print("iPhone 12")
                    gradientLayer?.frame = CGRect(x: 0, y: 0, width: containerView.frame.width-23, height: 150)
                case 2778:
                    print("iPhone 12 Pro Max")
                    gradientLayer?.frame = CGRect(x: 0, y: 0, width: containerView.frame.width+15, height: 150)
                default:
                    gradientLayer?.frame = CGRect(x: 0, y: 0, width: containerView.frame.width-37, height: 150)
                }
            }else{
                gradientLayer?.frame = CGRect(x: 0, y: 0, width: containerView.frame.width-37, height: 150)
            }
            containerView.layer.insertSublayer(gradientLayer!, at: 0)
        }
        
        
        collection.collectionViewLayout = layout
    }
    
    func setup(model:EasyPassHolderModel){
        self.data = model
        collection.delegate = self
        collection.dataSource = self
        collection.reloadData()
    }
    
}


extension EasyPassCell: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, UICollectionViewDelegate {
    
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
                    cell.icon.image = UIImage(named: "build_icon_black")
                }else{
                    cell._catagoryName.text = catagory
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



