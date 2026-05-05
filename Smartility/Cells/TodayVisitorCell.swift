//
//  TodayVisitorCell.swift
//  Smartility
//
//  Created by Mani on 7/11/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import MaterialComponents
import Kingfisher

class TodayVisitorCell: UITableViewCell {
    
    @IBOutlet weak var none_label: UILabel!
    @IBOutlet weak var containerView: MDCCard!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heighConstarint: NSLayoutConstraint!
    @IBOutlet weak var tapSeeLabel: UILabel!
    @IBOutlet weak var arrow: UIButton!
    @IBOutlet weak var taptoSeecontainer: UIView!
   
    @IBOutlet weak var viewMoreLabel: UILabel!
    
    
    var data: TodaysVisitor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        setupLay()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundColor = UIColor.clear
        setupLay()
      
    }
    
    
    func setupLay(){
        collectionView.bringSubviewToFront(none_label)
        collectionView.bringSubviewToFront(tapSeeLabel)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = CenterFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        collectionView.collectionViewLayout = layout
    }
    
    func setup(data: TodaysVisitor?){
        self.data = data
        collectionView.reloadData()            
    }
    
}

extension TodayVisitorCell: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, UICollectionViewDelegate {
            
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = data?.stats?.count, count != 0 {
            none_label.text = ""
            heighConstarint.constant = 0
            taptoSeecontainer.isHidden = true
            
            if count > 3 {
                viewMoreLabel.isHidden = false
            }else{
                viewMoreLabel.isHidden = true
            }
            
            return count
        }else{
            viewMoreLabel.isHidden = true
            taptoSeecontainer.isHidden = false
            heighConstarint.constant = 22
            none_label.text = "None"
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionTodayVisitorCell", for: indexPath) as! CollectionTodayVisitorCell
                          
        if let dynamic = data?.stats?[safe: indexPath.row] {
                                                
            if let status = data?.detail?[indexPath.row].visitor_status {

                if status == "Waiting" {
                    cell._image_container_view.backgroundColor =  UIColor(hex: "#FBB35E")
                }else if status == "Inside" {
                    cell._image_container_view.backgroundColor =  UIColor(hex: "#68FD89")
                }else if status == "Left" {
                    cell._image_container_view.backgroundColor = UIColor(hex: "#E0E0E0")
                }else if status == "Not Allowed" {
                    cell._image_container_view.backgroundColor = UIColor.lightGray
                }
                
            }
                        
            if let urlStr = data?.detail?[indexPath.row].visitor_img_url {
                let url_st = EndPoint.imageURL+urlStr
                let url = URL(string: url_st)
                let processor = DownsamplingImageProcessor(size: cell._image_view.bounds.size)
                    |> RoundCornerImageProcessor(cornerRadius: 20)
                cell._image_view.kf.indicatorType = .activity
                cell._image_view.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "proflie_icon"),
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ], completionHandler:
                        {
                            result in
                            switch result {
                            case .success(let value):
                                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                            case .failure(let error):
                                print("Job failed: \(error.localizedDescription)")
                            }
                        })
            }
            
            
            
            if let count = dynamic.tot_rec {
                cell._count.text = "\(count)"
            }
            
            if let visitor_cat = dynamic.visitor_cat {
                cell._catgoryName.text = visitor_cat
            }
            
        }                
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 80, height: collectionView.frame.size.height)
    }
}


