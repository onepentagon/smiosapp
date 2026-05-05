//
//  VisitorCollectionViewCell.swift
//  Smartility
//
//  Created by Mani on 4/11/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import Kingfisher

class VisitorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var visitorName: UILabel!
    @IBOutlet weak var visitorsCount: UILabel!
    @IBOutlet weak var visitorCollectionView: UICollectionView!
    var visitorImageList: [String]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _ = [visitorName,visitorsCount].map {  $0?.textColor = UIColor(hex: "#4F4F4F") }
        
        let layout = CollectionViewOverlappingLayout()
        visitorCollectionView.collectionViewLayout = layout
        
        visitorCollectionView.register(UINib(nibName: "visitorRoundedCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "visitorRoundedCollectionViewCell")
        visitorCollectionView.delegate = self
        visitorCollectionView.dataSource = self
        visitorCollectionView.reloadData()
    }
    
    func setup(visitorImageList: [String], typeVisitor: String){
        self.visitorImageList = visitorImageList
        //        if typeVisitor == "Daily Helper" {
        //            visitorCollectionView.frame.size.width = CGFloat((visitorImageList.count * 60)) + 70
        //        }else if typeVisitor == "Delivery"{
        //            visitorCollectionView.frame.size.width = CGFloat((visitorImageList.count * 60)) + 50
        //        }else if typeVisitor == "Vendor"{
        //            visitorCollectionView.frame.size.width = CGFloat((visitorImageList.count * 60)) + 50
        //        }else if typeVisitor == "Guest" {
        //            visitorCollectionView.frame.size.width = CGFloat((visitorImageList.count * 60)) + 0
        //        }else{
        //visitorCollectionView.frame.size.width = CGFloat((visitorImageList.count * 60))
        //        }
        self.visitorCollectionView.reloadData()
        //        visitorCollectionView.frame.size.width = visitorCollectionView.contentSize.width
    }
}

extension VisitorCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visitorImageList?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "visitorRoundedCollectionViewCell", for: indexPath) as? visitorRoundedCollectionViewCell
        if let urlStr = visitorImageList?[indexPath.row] {
            let url_st = EndPoint.imageURL+urlStr
            let url = URL(string: url_st)
            cell?.imageViewRounded.kf.indicatorType = .activity
            cell?.imageViewRounded.kf.setImage(
                with: url,
                placeholder: UIImage(named: "proflie_icon"),
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    
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
        
        return cell ?? UICollectionViewCell()
    }    
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        return collectionView.//CGSize(width: 60, height: 60)
    //    }
}


class CollectionViewOverlappingLayout: UICollectionViewFlowLayout {
    
    var overlap: CGFloat = 30
    
    override init() {
        super.init()
        self.scrollDirection = .horizontal
        self.minimumInteritemSpacing = 0
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var collectionViewContentSize: CGSize{
        let xSize = CGFloat(self.collectionView!.numberOfItems(inSection: 0)) * self.itemSize.width
        let ySize = CGFloat(self.collectionView!.numberOfSections) * self.itemSize.height
        var contentSize = CGSize(width: xSize, height: ySize)
        if self.collectionView!.bounds.size.width > contentSize.width {
            contentSize.width = self.collectionView!.bounds.size.width
        }
        if self.collectionView!.bounds.size.height > contentSize.height {
            contentSize.height = self.collectionView!.bounds.size.height
        }
        return contentSize
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let attributesArray = super.layoutAttributesForElements(in: rect)
        let numberOfItems = self.collectionView!.numberOfItems(inSection: 0)
        
        for attributes in attributesArray! {
            var xPosition = attributes.center.x
            let yPosition = attributes.center.y
            
            if attributes.indexPath.row == 0 {
                attributes.zIndex = Int(INT_MAX) // Put the first cell on top of the stack
            } else {
                xPosition -= self.overlap * CGFloat(attributes.indexPath.row)
                attributes.zIndex = numberOfItems - attributes.indexPath.row //Other cells below the first one
            }
            
            attributes.center = CGPoint(x: xPosition, y: yPosition)
        }
        
        return attributesArray
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return UICollectionViewLayoutAttributes(forCellWith: indexPath)
    }
}
