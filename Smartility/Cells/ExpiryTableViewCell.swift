//
//  ExpiryTableViewCell.swift
//  Smartility
//
//  Created by Mani on 12/13/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import Kingfisher
import GSImageViewerController



class ExpiryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var adLabel: UILabel!
    @IBOutlet weak var noticeTitleLabel: UILabel!
    @IBOutlet weak var provideLabel: UILabel!
    @IBOutlet weak var startDate: UIButton!
    @IBOutlet weak var expiredBtn: UIButton!
    @IBOutlet weak var noticeDescriptionLabel: UILabel!
    @IBOutlet weak var stackEdit: NSLayoutConstraint!
    @IBOutlet weak var arrow: UIImageView!
    
    @IBOutlet weak var tapContainer: UIView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var editeBtn: UIButton!
    @IBOutlet weak var publishBtn: UIButton!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var documentTable: UITableView!        
    
    var modelData: [String:[documentModel]]?
    
    var  imagePDFDelegate: ImagePDFDelegate? = nil
    
    //    var modelData = ["Image Attachments":[documentModel](),"Other Attachments":[documentModel]()]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        publishBtn.setTitleColor(accentColor(), for: .normal)
        tapContainer.isUserInteractionEnabled = true
        documentTable.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
    }
    
    
    func cellData(modelData: [String:[documentModel]]){
        self.modelData = modelData
        documentTable.delegate = self
        documentTable.dataSource = self
        documentTable.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
        adLabel.layer.masksToBounds = true
        adLabel.layer.cornerRadius = adLabel.frame.height/2
        
        [startDate,expiredBtn].forEach { (view) in
            view?.setTitleColor(.lightGray, for: .normal)
            view?.layer.borderWidth = 1
            view?.layer.borderColor = UIColor.lightGray.cgColor
            view?.layer.cornerRadius = 10
            view?.layer.masksToBounds = true
        }
    }
    
}

extension ExpiryTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.modelData?["Image Attachments"]?.count != 0 && self.modelData?["Other Attachments"]?.count != 0 {
            return 2
        }else if self.modelData?["Image Attachments"]?.count != 0 {
            return 1
        }else if self.modelData?["Other Attachments"]?.count != 0 {
            return 1
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.modelData?["Image Attachments"]?.count != 0 && self.modelData?["Other Attachments"]?.count != 0 {
            if section == 0 {
                if let imgCount = modelData?["Image Attachments"]?.count, imgCount != 0 {
                    return imgCount
                }else{
                    return 0
                }
            }else {
                if let imgCount = modelData?["Other Attachments"]?.count, imgCount != 0 {
                    return imgCount
                }else{
                    return 0
                }
            }
        }else if self.modelData?["Image Attachments"]?.count != 0 {
            if let imgCount = modelData?["Image Attachments"]?.count, imgCount != 0 {
                return imgCount
            }else{
                return 0
            }
        }else if self.modelData?["Other Attachments"]?.count != 0 {
            if let imgCount = modelData?["Other Attachments"]?.count, imgCount != 0 {
                return imgCount
            }else{
                return 0
            }
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if self.modelData?["Image Attachments"]?.count != 0 && self.modelData?["Other Attachments"]?.count != 0 {
            return getView(section: section,width:tableView.frame.width)
        }else if self.modelData?["Image Attachments"]?.count != 0 {
            return nil
        }else if self.modelData?["Other Attachments"]?.count != 0 {
            return nil
        }else{
            return nil
        }
    }
    
    func getView(section:Int, width:CGFloat)-> UIView?{
        let sectionHeader = UIView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: 30))
        let sectionText = UILabel()
        sectionText.frame = CGRect.init(x: 0, y: 0, width: sectionHeader.frame.width, height: sectionHeader.frame.height)
        if section == 0 {
            sectionText.text = "---- Image Attachments ----"
        }else{
            sectionText.text = "---- Other Attachments ----"
        }
        sectionText.textAlignment = .center
//        sectionText.sizeToFit()
        sectionText.font = .systemFont(ofSize: 10, weight: .bold) // my custom font
        sectionText.textColor = .lightGray // my custom colour
        sectionHeader.addSubview(sectionText)
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.modelData?["Image Attachments"]?.count != 0 && self.modelData?["Other Attachments"]?.count != 0 {
            return 25
        }else if self.modelData?["Image Attachments"]?.count != 0 {
            return 0
        }else if self.modelData?["Other Attachments"]?.count != 0 {
            return 0
        }else{
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.modelData?["Image Attachments"]?.count != 0 && self.modelData?["Other Attachments"]?.count != 0 {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "imageViewCell", for: indexPath) as? imageViewCell
                if let fileURL = modelData?["Image Attachments"]?[safe: indexPath.row]?.file_url {
                    let urlNew:String = fileURL.replacingOccurrences(of: " ", with: "%20")
                    let profurl = URL(string: urlNew)
                    cell?.docImage.contentMode = .scaleAspectFit
                    cell?.docImage.kf.indicatorType = .activity
                    cell?.docImage.kf.setImage(
                        with: profurl,
                        options: nil, completionHandler:
                            {
                                result in
                                switch result {
                                case .success(let value):
                                    print(value)
                                case .failure(let error):
                                    print(error)
                                }
                            })
                }
                return cell!
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "pdfTableViewCell", for: indexPath) as? pdfTableViewCell
                if let fileURL = modelData?["Other Attachments"]?[indexPath.row].file_url.removeWhitespace() {
                    
                    if let range = fileURL.range(of: "/", options: .backwards)  {
                        let extensionValue = fileURL[range.upperBound...]
                        cell?.pdfCell.text = String(extensionValue)
                    }
                    if let label = cell?.pdfCell {
                        var rect: CGRect = label.frame //get frame of label
                        rect.size = (label.text?.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: label.font.fontName , size: label.font.pointSize)!]))! //Calculate as per label font
                        cell?.pdfCell_width.constant = rect.width+60 // set width to Constraint outlet
                    }

                    cell?.pdfCell.textColor = .black
                }
                return cell!
            }
        }else if self.modelData?["Image Attachments"]?.count != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageViewCell", for: indexPath) as? imageViewCell
            if let fileURL = modelData?["Image Attachments"]?[safe: indexPath.row]?.file_url {
                let urlNew:String = fileURL.replacingOccurrences(of: " ", with: "%20")
                let profurl = URL(string: urlNew)
                cell?.docImage.contentMode = .scaleAspectFit
                cell?.docImage.kf.indicatorType = .activity
                cell?.docImage.kf.setImage(
                    with: profurl,
                    options: nil, completionHandler:
                        {
                            result in
                            switch result {
                            case .success(let value):
                                print(value)
                            case .failure(let error):
                                print(error)
                            }
                        })
            }
            return cell!
        }else if self.modelData?["Other Attachments"]?.count != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "pdfTableViewCell", for: indexPath) as? pdfTableViewCell
            
            if let fileURL = modelData?["Other Attachments"]?[indexPath.row].file_url.removeWhitespace() {
                if let range = fileURL.range(of: "/", options: .backwards)  {
                    let extensionValue = fileURL[range.upperBound...]
                    cell?.pdfCell.text = String(extensionValue)
                }
                if let label = cell?.pdfCell {
                    var rect: CGRect = label.frame //get frame of label
                    rect.size = (label.text?.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: label.font.fontName , size: label.font.pointSize)!]))! //Calculate as per label font
                    cell?.pdfCell_width.constant = rect.width+60 // set width to Constraint outlet
                }

                cell?.pdfCell.textColor = .black
            }
            return cell!
        }else{
            return UITableViewCell()
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.modelData?["Image Attachments"]?.count != 0 && self.modelData?["Other Attachments"]?.count != 0 {
            if indexPath.section == 0 {
                return 100
            }else{
                return 35
            }
        }else if self.modelData?["Image Attachments"]?.count != 0 {
            return 100
        }else if self.modelData?["Other Attachments"]?.count != 0 {
            return 35
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("index")
        
        if self.modelData?["Image Attachments"]?.count != 0 && self.modelData?["Other Attachments"]?.count != 0 {
            if indexPath.section == 0 {
                guard let cell = documentTable.cellForRow(at: indexPath) as? imageViewCell else { return }
                let fileURL = modelData?["Image Attachments"]?[indexPath.row].file_url
                if let model = fileURL {
                    let urlNew:String = model.replacingOccurrences(of: " ", with: "%20")
                    if let profurl = URL(string: urlNew) {
                        cell.docImage.contentMode = .scaleAspectFit
                        cell.docImage.kf.indicatorType = .activity
                        cell.docImage.kf.setImage(
                            with: profurl,
                            options: nil, completionHandler:
                                {
                                    result in
                                    switch result {
                                    case .success(let value):
                                        print(value)
                                        let imageInfo   = GSImageInfo(image: value.image, imageMode: .aspectFit)
                                        let transitionInfo = GSTransitionInfo(fromView: cell.docImage)
                                        let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
                                        self.window?.rootViewController?.present(imageViewer, animated: true, completion: nil)
                                    case .failure(let error):
                                        print(error)
                                    }
                                })
                    }
                }
            }else{
                let fileURL = modelData?["Other Attachments"]?[indexPath.row].file_url
                
                if let model = fileURL {
                    let urlNew:String = model.replacingOccurrences(of: " ", with: "%20")
                    if let profurl = URL(string: urlNew) {
                        
                        if let range = model.range(of: "/", options: .backwards)  {
                            let extensionValue = model[range.upperBound...]
                            imagePDFDelegate?.imagePDF(type: "PDF", fileURL:  profurl, file_name: String(extensionValue))
                        }
                    }
                }
            }
        }else if self.modelData?["Image Attachments"]?.count != 0 {
            guard let cell = documentTable.cellForRow(at: indexPath) as? imageViewCell else { return }
            let fileURL = modelData?["Image Attachments"]?[indexPath.row].file_url
            if let model = fileURL {
                let urlNew:String = model.replacingOccurrences(of: " ", with: "%20")
                if let profurl = URL(string: urlNew) {
                    cell.docImage.contentMode = .scaleAspectFit
                    cell.docImage.kf.indicatorType = .activity
                    cell.docImage.kf.setImage(
                        with: profurl,
                        options: nil, completionHandler:
                            {
                                result in
                                switch result {
                                case .success(let value):
                                    print(value)
                                    let imageInfo   = GSImageInfo(image: value.image, imageMode: .aspectFit)
                                    let transitionInfo = GSTransitionInfo(fromView: cell.docImage)
                                    let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
                                    self.window?.rootViewController?.present(imageViewer, animated: true, completion: nil)
                                case .failure(let error):
                                    print(error)
                                }
                            })
                }
            }
        }else if self.modelData?["Other Attachments"]?.count != 0 {
            let fileURL = modelData?["Other Attachments"]?[indexPath.row].file_url
            
            if let model = fileURL {
                let urlNew:String = model.replacingOccurrences(of: " ", with: "%20")
                if let profurl = URL(string: urlNew) {
                    
                    if let range = model.range(of: "/", options: .backwards)  {
                        let extensionValue = model[range.upperBound...]
                        imagePDFDelegate?.imagePDF(type: "PDF", fileURL:  profurl, file_name: String(extensionValue))
                    }
                }
            }
        }
    }
}







struct documentModel {
    var file_url: String
    var notice_id: Int
    init(file_url:String,notice_id: Int) {
        self.file_url = file_url
        self.notice_id = notice_id
    }
}
