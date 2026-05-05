//
//  CreateNoticeController.swift
//  Smartility
//
//  Created by Mani on 12/9/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import WebKit


class CreateNoticeController: UIViewController, UIDocumentPickerDelegate {
    
    @IBOutlet weak var menuHeight: NSLayoutConstraint!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var noticeTitileTextBox: UITextField!
    @IBOutlet weak var textCountLable: UILabel!
    @IBOutlet weak var noticeDescription: UITextView!
    @IBOutlet weak var noticeDescCount: UILabel!
    @IBOutlet weak var expiryDateFeild: UITextField!
    @IBOutlet weak var advertisementCheckBox: BEMCheckBox!
    @IBOutlet weak var adHeight: NSLayoutConstraint!
    @IBOutlet weak var adTextFeild: UITextField!
    @IBOutlet weak var attachmentBtn: UIButton!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var documentTable: UITableView!
    
    var imagePicker = UIImagePickerController()
    var files = [documentUploadModel]()
    var doc = [documentUpdateModel]()
    var original_data = [documentUpdateModel]()
        
    var expiredModel: NoticeExpiredModel?
    var boolUpdate = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backView.setClickListener {
            self.navigationController?.popViewController(animated: true)
        }
        
        self.view.bringSubviewToFront(menuView)
        menuView.backgroundColor = .white
        menuView.layer.shadowColor = UIColor(red: 0.049, green: 0.019, blue: 0.167, alpha: 0.2).cgColor
        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowRadius = 1
        menuView.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        self.tabBarController?.tabBar.isHidden = true

        documentTable.register(UITableViewCell.self, forCellReuseIdentifier: "docCell")
        documentTable.tableFooterView =  UIView()
        
        tableHeight.constant = 0
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                menuHeight.constant = 60
            case 1334:
                print("iPhone 6/6S/7/8")
                menuHeight.constant = 80
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
            default:
                menuHeight.constant = 90
            }
        }else{
            menuHeight.constant = 90
        }
        
        advertisementCheckBox.onCheckColor = .white
        advertisementCheckBox.onFillColor = brandColor()
        advertisementCheckBox.onTintColor = brandColor()
        advertisementCheckBox.lineWidth = 2.0
        advertisementCheckBox.boxType = .square
        advertisementCheckBox.delegate = self
        noticeTitileTextBox.delegate = self
        noticeTitileTextBox.addLine(position: .LINE_POSITION_BOTTOM, color: UIColor(hex: "#4F4F4F"), width: 1.0)
        expiryDateFeild.addLine(position: .LINE_POSITION_BOTTOM, color: UIColor(hex: "#4F4F4F"), width: 1.0)
        noticeDescription.placeholder = "Notice description"
        noticeDescription.delegate = self
        noticeDescription.layer.borderWidth = 1
        noticeDescription.layer.borderColor = UIColor(hex: "#4F4F4F").cgColor
        let expiryDateFeildTap = UITapGestureRecognizer(target: self, action: #selector(textClicked))
        expiryDateFeildTap.numberOfTouchesRequired = 1
        let expiryDateFeildLongTap = UILongPressGestureRecognizer(target: self, action: #selector(textClicked))
        
        //        expiryDateFeild.setupRight_icon(imageName: "event")
        let imageView = UIImageView(frame: CGRect(x: 35, y: 10, width: 20, height: 20))
        imageView.image = UIImage(named: "event")
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
        imageContainerView.addSubview(imageView)
        expiryDateFeild.rightView = imageContainerView
        expiryDateFeild.rightViewMode = .always
        expiryDateFeild.tintColor = UIColor(hex: "#4F4F4F")
        expiryDateFeild.addGestureRecognizer(expiryDateFeildLongTap)
        expiryDateFeild.addGestureRecognizer(expiryDateFeildTap)
        line.isHidden = true
        attachmentBtn.isUserInteractionEnabled = true
        let docTap = UITapGestureRecognizer(target: self, action: #selector(docPicker))
        docTap.numberOfTouchesRequired = 1
        attachmentBtn.addGestureRecognizer(docTap)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideView)))
        adTextFeild.delegate = self
        
        if !boolUpdate {
            advertisementCheckBox.setOn(false)
            documentTable.delegate = self
            documentTable.dataSource = self
        }else{
            
            if let data = expiredModel?.notice_text?.data(using: .utf8) {
                let attributedString = try? NSAttributedString(
                    data: data,
                    options: [.documentType: NSAttributedString.DocumentType.html],
                    documentAttributes: nil)
                noticeDescription.attributedText = attributedString
            }
            noticeTitileTextBox.text = expiredModel?.notice_title
                        
            UIView.transition(with: noticeDescCount!,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                self?.noticeDescCount.text = "\(self?.expiredModel?.notice_text?.htmlToString.count ?? 0)"+"\\5000".replacingOccurrences(of: "\\", with: "\\")
                              }, completion: nil)
            
            UIView.transition(with: textCountLable!,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                self?.textCountLable.text = "\(self?.expiredModel?.notice_title?.count ?? 0)"+"\\150".replacingOccurrences(of: "\\", with: "\\")
                              }, completion: nil)
            
            if let date = expiredModel?.expiry_dt {
                expiryDateFeild.text = timeConversion12(time24: date)
            }            
            adTextFeild.text = expiredModel?.ad_by
            
            if let ad = expiredModel?.is_ad {
                if ad == 0 {
                    UIView.animate(withDuration: 0.3) {
                        self.line.isHidden = true
                        self.adHeight.constant = 0
                        self.view.layoutIfNeeded()
                    }
                    advertisementCheckBox.setOn(false)
//                    advertisementCheckBox.onTintColor = UIColor.lightGray
                }else{
                    UIView.animate(withDuration: 0.3) {
                        self.adHeight.constant = 35
                        self.line.isHidden = false
                        self.view.layoutIfNeeded()
                    }
                    advertisementCheckBox.setOn(true)
//                    advertisementCheckBox.onTintColor = UIColor(hex: "FFD700")
                }
            }
            
            original_data = doc
            
            print(doc)
            
            documentTable.delegate = self
            documentTable.dataSource = self
            documentTable.reloadData()
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (complete: Bool) in
                self.tableHeight.constant = CGFloat(self.original_data.count*35)
            })
        }
        
    }
        
    
    @objc
    func hideView(){
        view.endEditing(true)
    }
    
    @objc func docPicker(){
        
        let alert = UIAlertController(title: "", message: "Picker", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Document", style: .default, handler: {
            _ in
            
                                        let types: [String] = [
                                            kUTTypeJPEG as String,
                                            kUTTypePNG as String,
                                            "com.microsoft.word.doc",
                                            "org.openxmlformats.wordprocessingml.document",
                                            kUTTypeRTF as String,
                                            "com.microsoft.powerpoint.​ppt",
                                            "org.openxmlformats.presentationml.presentation",
                                            kUTTypePlainText as String,
                                            "com.microsoft.excel.xls",
                                            "org.openxmlformats.spreadsheetml.sheet",
                                            kUTTypePDF as String,
                                            kUTTypeMP3 as String
                                        ]
                                        let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
                                        documentPicker.delegate = self
                                        self.present(documentPicker, animated: true, completion: nil)
                                                                            
//            self.documentPicker.present(from: self.view)
        }))
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            _ in self.cam_imageTapped()
        }))
        alert.addAction(UIAlertAction(title: "Photos", style: .default, handler: {
            _ in self.pick_imageTapped()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            _ in
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func dateFromString(dateString:String)->Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: dateString) {
            return date
        }else{
            return nil
        }
    }
    
    func timeConversion12(time24:String)->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFromString(dateString: time24) {
            let Str_date = formatter.string(from: date)
            return Str_date
        }
        return ""
    }
    
    @IBAction func saveClicked(_ sender: UIButton) {
                
        let title = noticeTitileTextBox.text
        let noticeDesc = noticeDescription.text
        let dateFeild = expiryDateFeild.text ?? ""
        let adText_Feild = adTextFeild.text
        var params = [String:Any]()
        
        if title?.count == 0 {
            self.showConfirmAlert(title: "", message: "Enter the notice title", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else if noticeDesc?.count == 0 {
            self.showConfirmAlert(title: "", message: "Notice description is empty", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else if dateFeild.count == 0 {
            self.showConfirmAlert(title: "", message: "Choose expiry date", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else{
            
            if advertisementCheckBox.on {
                if adText_Feild?.count == 0 {
                    self.showConfirmAlert(title: "", message: "Enter the ad", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                    return
                }else{
                    params.updateValue(adText_Feild ?? "", forKey: "ad_by")
                }
            }
            var url = ""
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let formatter_1 = DateFormatter()
            formatter_1.dateFormat = "HH:mm:ss"
            if let full_date = formatter.date(from: dateFeild), let full_time = formatter_1.date(from: "23:59:59"){
                let firstDate = full_date.toString(dateFormat: "yyyy-MM-dd'T'")
                let firstTime = full_time.toString(dateFormat: "HH:mm:ss.SSSZ")
                params.updateValue(firstDate+firstTime, forKey: "expiry_dt")
            }
            
            if !boolUpdate {
                                                               
                                
                url = EndPoint.notice_create
                
                if files.count != 0 {
                    do {
                        let jsonData = try JSONEncoder().encode(files)
                        let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
                        params.updateValue(json, forKey: "files")
                    } catch { print(error) }
                }else{
                    params.updateValue(files, forKey: "files")
                }
                params.updateValue("Owner", forKey: "role_name")
            }else{
//                params.updateValue(dateFeild+"T12:00:00.000Z", forKey: "expiry_dt")
                
//                let olDateFormatter = DateFormatter()
//                olDateFormatter.dateFormat = "yyyy-MM-dd"
//                olDateFormatter.timeZone = TimeZone(identifier: "UTC")
//                if let oldDate = olDateFormatter.date(from: dateFeild) {
//                    let convertDateFormatter = DateFormatter()
//                    convertDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
//                    convertDateFormatter.timeZone = TimeZone(identifier: "UTC")
//                    let date = convertDateFormatter.string(from: oldDate)
//                    params.updateValue(date, forKey: "expiry_dt")
//                }
                
                url = EndPoint.notice_update
                
                if doc.count != 0 {
                    do {
                        let jsonData = try JSONEncoder().encode(doc)
                        let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
                        params.updateValue(json, forKey: "files")
                    } catch { print(error) }
                }else{
                    params.updateValue(doc, forKey: "files")
                }
                                
                params.updateValue(expiredModel?.app_by ?? "", forKey: "app_by")
                params.updateValue(expiredModel?.app_dt ?? "", forKey: "app_dt")
                params.updateValue(expiredModel?.cust_name ?? "", forKey: "cust_name")
                params.updateValue(expiredModel?.notice_dt ?? "", forKey: "notice_dt")
                params.updateValue(expiredModel?.notice_id ?? "", forKey: "notice_id")
                params.updateValue("Draft", forKey: "notice_status")
                params.updateValue(expiredModel?.role_name ?? "", forKey: "role_name")
            }
            params.updateValue("img/\(community.community_id)/notice/", forKey: "attach_dir")
            params.updateValue(Int(community.community_id) ?? 0, forKey: "comm_id")
            params.updateValue(advertisementCheckBox.on ? 1 : 0 , forKey: "is_ad")
            params.updateValue(noticeDesc ?? "", forKey: "notice_text")
            params.updateValue(title ?? "", forKey: "notice_title")
            params.updateValue(Int(UserDefaults.user_id) ?? 0, forKey: "user_id")
            
//                •    ad_by: "Venkat"
//                •    app_by: null
//                •    app_dt: null
//                •    attach_dir: "img/338/notice/"
//                •    comm_id: 338
//                •    cust_name: "Venkat Selvaraj"
//                •    expiry_dt: "2020-12-19"
//                •    files: [{,…}, {,…}]
//                •    is_ad: 1
//                •    notice_dt: "2020-12-14T11:53:46.000Z"
//                •    notice_id: 461
//                •    notice_status: "Active"  //if publish notice_status:Active
//                •    notice_text: "<p>Hi Everyone please join the party hall...!</p>"
//                •    notice_title: "Birthday Party"
//                •    role_name: "Vendor"
//                •    user_id: 1
            
            let checker = JSONSerialization.isValidJSONObject(params)
            print(checker)
            
            SpinnerClass.shared.createSpinnerView(controller: self)
            Networking.shared.notice_create(URL: url,perams: params) { (status, error) in
                if status != nil {
                    if !self.boolUpdate {
                        NotificationCenter.default.post(name: NSNotification.Name("UpdateActions"), object: nil)
                        self.showConfirmAlert(title: "", message: "Notice draft created. Please review and publish", buttonTitle: "Ok", buttonStyle: .default) { [weak self] (acti) in
                            self?.redirectToNoticeViewController()
                        }
                    }else{
                        NotificationCenter.default.post(name: NSNotification.Name("UpdateActions"), object: nil)
                        NotificationCenter.default.post(name: NSNotification.Name("updateNotice"), object: self)
                        self.showConfirmAlert(title: "", message: "Notice updated and saved as draft. Please review and publish", buttonTitle: "Ok", buttonStyle: .default) { [weak self] (acti) in
                            SpinnerClass.shared.removeActivityIndicator()
                            self?.redirectToNoticeViewController()
                        }
                    }
                }else{
                    SpinnerClass.shared.removeActivityIndicator()
                    self.showConfirmAlert(title: "", message: error?.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                }
            }
        }
    }
    
    func redirectToNoticeViewController(){
        var data_params = [String:String]()
        var params = [String:Any]()
        params.updateValue(community.community_id, forKey: "comm_id")
        params.updateValue(UserDefaults.user_id, forKey: "user_id")
                
        let dispatch = DispatchGroup()
        dispatch.enter()
        print("1")
        params.updateValue("active", forKey: "notice_status")
        Networking.shared.getTotalNoticesByStatus(perams: params) { (model, error) in
            if let succes = model, let countArra = succes[0] as? [String:Any],let count = countArra["total"] as? Int {
                data_params.updateValue("Active (\(count))", forKey: "Active")
                dispatch.leave()
            }
        }
        dispatch.enter()
        params.updateValue("expired", forKey: "notice_status")
        Networking.shared.getTotalNoticesByStatus(perams: params) { (model, error) in
            if let succes = model,let countArra = succes[0] as? [String:Any],let count = countArra["total"] as? Int {
                data_params.updateValue("Expired (\(count))", forKey: "Expired")
                dispatch.leave()
            }
        }
        dispatch.enter()
        params.updateValue("drafts", forKey: "notice_status")
        Networking.shared.getTotalNoticesByStatus(perams: params) { (model, error) in
            if let succes = model,let countArra = succes[0] as? [String:Any],let count = countArra["total"] as? Int {
                data_params.updateValue("Draft (\(count))", forKey: "Draft")
                dispatch.leave()
            }
        }
        
        dispatch.notify(queue: .main) {
            print("Finish")
            SpinnerClass.shared.removeActivityIndicator()
            let controller = AppStoryboard.Dashboard.viewController(viewControllerClass: NoticeBoardViewController.self)
            controller.noticeTitle = data_params
            controller.noticeIndex = 2
            controller.status = NoticeBoardStatus.drafts
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func textClicked(){
        view.endEditing(true)
        let selector = WWCalendarTimeSelector.instantiate()    
        selector.optionStyles.showTime(false)
        //        selector.optionStyles.showDateMonth(false)
        //        selector.optionStyles.showYear(false)
        selector.delegate = self
        selector.optionTopPanelTitle = "Choose Date"
        self.present(selector, animated: true, completion: nil)
    }
    
    @objc func backClicked(){
        self.navigationController?.popViewController(animated: true)
    }
}


extension CreateNoticeController: BEMCheckBoxDelegate {
    func didTap(_ checkBox: BEMCheckBox) {
        if checkBox.on == false {
            UIView.animate(withDuration: 0.3) {
                self.line.isHidden = true
                self.adHeight.constant = 0
                self.view.layoutIfNeeded()
            }
            checkBox.setOn(false)
            print("false")
        }else{
            UIView.animate(withDuration: 0.3) {
                self.adHeight.constant = 35
                self.line.isHidden = false
                self.view.layoutIfNeeded()
            }
            checkBox.setOn(true)            
            print("true")
        }
    }
}

extension CreateNoticeController: WWCalendarTimeSelectorProtocol {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)
        do {
            if let url = urls[safe: 0] {
                let imageData = try Data(contentsOf: url)
                var file_name = ""
                if let range = url.absoluteString.range(of: "/", options: .backwards)  {
                    let extensionValue = url.absoluteString[range.upperBound...]
                    file_name = String(extensionValue)
                }
                if !boolUpdate {
                    self.files.append(documentUploadModel(file_name: file_name, file_url: imageData.base64EncodedString(), is_selected: true))
                }else{
                    self.original_data.append(documentUpdateModel(file_url: imageData.base64EncodedString(), file_name: file_name, is_selected: true, is_changed: true))
                    self.doc.append(documentUpdateModel(file_url: imageData.base64EncodedString(), file_name: file_name, is_selected: true, is_changed: true))
                }
                
                self.documentTable.reloadData()
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { (complete: Bool) in
                    if !self.boolUpdate {
                        self.tableHeight.constant = CGFloat(self.files.count*35)
                    }else{
                        self.tableHeight.constant = CGFloat(self.original_data.count*35)
                    }
                })
            }
        } catch {
            print("Unable to load data: \(error)")
        }
    }
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        expiryDateFeild.text = date.toString(dateFormat: "yyyy-MM-dd")
    }
    
    func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool{
        let order = NSCalendar.current.compare(Date(), to: date, toGranularity: .day)
        if order == .orderedDescending {
            return false
        } else {
            return true
        }
    }
}

extension CreateNoticeController: UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !boolUpdate {
            return files.count
        }else{
            return original_data.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "docCell", for: indexPath)
        if !boolUpdate {
            cell.textLabel?.text = files[indexPath.row].file_name
        }else{
            cell.textLabel?.text = original_data[indexPath.row].file_name
        }
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = .black
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if !boolUpdate {
                self.files.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { (complete: Bool) in
                    self.tableHeight.constant = CGFloat(self.files.count*35)
                })
            }else{
                
                
                self.doc[indexPath.row].is_selected = false
                self.original_data.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .automatic)
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { (complete: Bool) in
                    self.tableHeight.constant = CGFloat(self.original_data.count*35)
                })
            }
        }
    }
    @objc func pick_imageTapped(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func cam_imageTapped(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.cameraDevice = .front
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func randomAlphaNumericString(length: Int) -> String {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.count)
        var randomString = ""
        
        for _ in 0 ..< length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }
        
        return randomString
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if #available(iOS 11.0, *) {
            if picker.sourceType == .savedPhotosAlbum {
                if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL , let image = info[.originalImage] as? UIImage{
                    var file_name = ""
                    if let range = url.absoluteString.range(of: "/", options: .backwards)  {
                        let extensionValue = url.absoluteString[range.upperBound...]
                        file_name = String(extensionValue)
                    }
                    if !boolUpdate {
                        self.files.append(documentUploadModel(file_name: file_name, file_url: image.jpeg(.high)?.base64EncodedString(), is_selected: true, is_changed: true))
                        self.documentTable.reloadData()
                        UIView.animate(withDuration: 0.3, animations: {
                            self.view.layoutIfNeeded()
                        }, completion: { (complete: Bool) in
                            self.tableHeight.constant = CGFloat(self.files.count*35)
                        })
                    }else{
                        self.original_data.append(documentUpdateModel(file_url: image.jpeg(.high)?.base64EncodedString(), file_name: file_name, is_selected: true, is_changed: true))
                        self.doc.append(documentUpdateModel(file_url: image.jpeg(.high)?.base64EncodedString(), file_name: file_name, is_selected: true, is_changed: true))
                        self.documentTable.reloadData()
                        UIView.animate(withDuration: 0.3, animations: {
                            self.view.layoutIfNeeded()
                        }, completion: { (complete: Bool) in
                            self.tableHeight.constant = CGFloat(self.original_data.count*35)
                        })
                    }
                }
            }else if picker.sourceType == .camera {
                
                let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let fileURL = documentsDirectoryURL.appendingPathComponent("\(randomAlphaNumericString(length: 5)).png")
                guard let image = info[.originalImage] as? UIImage else {
                    return
                }
                if let imageData = image.pngData() {
                    if !FileManager.default.fileExists(atPath: fileURL.path) {
                        do {
                            try imageData.write(to: fileURL)
                            print("Image Added Successfully")
                            var file_name = ""
                            if let range = fileURL.absoluteString.range(of: "/", options: .backwards)  {
                                let extensionValue = fileURL.absoluteString[range.upperBound...]
                                file_name = String(extensionValue)
                            }
                            if !boolUpdate {
                                self.files.append(documentUploadModel(file_name: file_name, file_url: image.jpeg(.high)?.base64EncodedString(), is_selected: true, is_changed: true))
                                self.documentTable.reloadData()
                                UIView.animate(withDuration: 0.3, animations: {
                                    self.view.layoutIfNeeded()
                                }, completion: { (complete: Bool) in
                                    self.tableHeight.constant = CGFloat(self.files.count*35)
                                })
                            }else{
                                self.original_data.append(documentUpdateModel(file_url: image.jpeg(.low)?.base64EncodedString(), file_name: file_name, is_selected: true, is_changed: true))
                                self.doc.append(documentUpdateModel(file_url: image.jpeg(.low)?.base64EncodedString(), file_name: file_name, is_selected: true, is_changed: true))
                                self.documentTable.reloadData()
                                UIView.animate(withDuration: 0.3, animations: {
                                    self.view.layoutIfNeeded()
                                }, completion: { (complete: Bool) in
                                    self.tableHeight.constant = CGFloat(self.original_data.count*35)
                                })
                            }
                        } catch {
                            print(error)
                        }
                    } else {
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension CreateNoticeController: UITextFieldDelegate, UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print(text)
        guard let text = textView.text else { return false }
        
        if noticeDescription == textView {
            if text.count <= 5050 {
                let textChange = "\(text.count)"+"\\5000".replacingOccurrences(of: "\\", with: "\\")
                UIView.transition(with: noticeDescCount!,
                                  duration: 0.25,
                                  options: .transitionCrossDissolve,
                                  animations: { [weak self] in
                                    self?.noticeDescCount.text = textChange
                                  }, completion: nil)
                return true
            }else{
                return false
            }
        }else {
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(string)
        guard let text = textField.text else { return false }
        
        if noticeTitileTextBox == textField {
            if text.count <= 150 {
                let textChange = "\(text.count)"+"\\150".replacingOccurrences(of: "\\", with: "\\")
                UIView.transition(with: textCountLable!,
                                  duration: 0.25,
                                  options: .transitionCrossDissolve,
                                  animations: { [weak self] in
                                    self?.textCountLable.text = textChange
                                  }, completion: nil)
                return true
            }else{
                return false
            }
        }else if adTextFeild == textField {
            if text.count <= 50 {
                return true
            }else{
                return false
            }
        }else{
            return true
        }
    }
}


extension UITextView {
    
    private class PlaceholderLabel: UILabel { }
    
    private var placeholderLabel: PlaceholderLabel {
        if let label = subviews.compactMap( { $0 as? PlaceholderLabel }).first {
            return label
        } else {
            let label = PlaceholderLabel(frame: .zero)
            label.font = font
            label.textColor = UIColor(hex: "#4F4F4F")
            addSubview(label)
            return label
        }
    }
    
    @IBInspectable
    var placeholder: String {
        get {
            return subviews.compactMap( { $0 as? PlaceholderLabel }).first?.text ?? ""
        }
        set {
            let placeholderLabel = self.placeholderLabel
            placeholderLabel.text = newValue
            placeholderLabel.numberOfLines = 0
            let width = frame.width - textContainer.lineFragmentPadding * 2
            let size = placeholderLabel.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
            placeholderLabel.frame.size.height = size.height
            placeholderLabel.frame.size.width = width
            placeholderLabel.frame.origin = CGPoint(x: textContainer.lineFragmentPadding, y: textContainerInset.top)
            
            textStorage.delegate = self
        }
    }
    
}

extension UITextView: NSTextStorageDelegate {
    
    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
        if editedMask.contains(.editedCharacters) {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }
    
}


struct documentUploadModel: Encodable {
    var file_name: String?
    var file_url: String?
    var is_selected: Bool?
    var is_changed: Bool?
}

class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .whiteLarge)

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
