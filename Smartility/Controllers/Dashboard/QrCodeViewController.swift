//
//  QrCodeViewController.swift
//  Smartility
//
//  Created by Mani on 12/26/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import MaterialComponents

class QrCodeViewController: UIViewController {

    @IBOutlet weak var backArrow: UIView!
    @IBOutlet weak var titleBack: UILabel!
    @IBOutlet weak var qrCodeTableviewCell: UITableView!
    @IBOutlet weak var menuHeight: NSLayoutConstraint!
    @IBOutlet weak var navigationBar: UIView!
    
    var easypass_update = false
    var invite_update = false
    var invite_easyPass = ""
    var user_name = ""
    var glad_text = ""
    var blockandUnit = ""
    var wasSent: Int?
    var otpInvite = ""
    var shareFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        
        self.view.bringSubviewToFront(navigationBar)
        navigationBar.backgroundColor = .white
        navigationBar.layer.shadowColor = UIColor(red: 0.049, green: 0.019, blue: 0.167, alpha: 0.2).cgColor
        navigationBar.layer.shadowOpacity = 1
        navigationBar.layer.shadowRadius = 1
        navigationBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        qrCodeTableviewCell.tableFooterView = UIView()
        qrCodeTableviewCell.delegate = self
        qrCodeTableviewCell.dataSource = self
        qrCodeTableviewCell.reloadData()
                
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
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
  
    
    @objc
    func shareContainerObjc(){
        if let cell = qrCodeTableviewCell.cellForRow(at: IndexPath(row: 0, section: 0)) as? QRcodeTableViewCell {
            let image = cell.containerView.asImage()
            let activityItem: [UIImage] = [image]
            let activity = UIActivityViewController(activityItems: activityItem as [UIImage], applicationActivities: [])
            activity.popoverPresentationController?.sourceView  = self.view
            self.present(activity, animated: true, completion: nil)
        }
    }
    
    @objc
    func backClicked(){
//        if shareFrom == "" {
        guard let allVC = self.navigationController?.viewControllers else { return }
            if  let InvitedVisitor = allVC[allVC.count - 3] as? InvitedVisitorController {
                self.navigationController!.popToViewController(InvitedVisitor, animated: true)
            }else{
                if let EasyPass = allVC[allVC.count - 3] as? EasyPassViewController {
                    self.navigationController?.popToViewController(EasyPass, animated: true)
                }else{
                    if let _ = allVC[allVC.count - 2] as? InvitedVisitorController {
                        self.navigationController?.popViewController(animated: true)
                    }else if let _ = allVC[allVC.count - 2] as? EasyPassViewController {
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
//        }else{
//            self.navigationController?.popViewController(animated: true)
//        }
    }
    
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: .ascii)

        // Generate the code image with CIFilter
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")

        // Scale it up (because it is generated as a tiny image)
        let scale = UIScreen.main.scale
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        guard let output = filter.outputImage?.transformed(by: transform) else { return nil }

        // Change the color using CIFilter
        let colorParameters = [
            "inputColor0": CIColor(color: UIColor.black), // Foreground
            "inputColor1": CIColor(color: UIColor.clear) // Background
        ]
        let colored = output.applyingFilter("CIFalseColor", parameters: colorParameters)

        return UIImage(ciImage: colored)
    }      

}


extension QrCodeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QRcodeTableViewCell", for: indexPath) as? QRcodeTableViewCell else { return UITableViewCell() }
        cell.shareContainer.backgroundColor = .white
        cell.shareContainer.layer.cornerRadius = 8
        cell.shareContainer.layer.masksToBounds = true
        cell.shareContainer.layer.borderColor = brandColor().cgColor
        cell.shareContainer.layer.borderWidth = 1.0
        
        cell.shareContainer.isUserInteractionEnabled = true
        backArrow.isUserInteractionEnabled = true
        backArrow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backClicked)))
        
        cell.shareContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shareContainerObjc)))
        
        cell.smartilityLogoContainer.backgroundColor = .white
        cell.smartilityLogoContainer.layer.cornerRadius = 17.5
        cell.smartilityLogoContainer.layer.masksToBounds = true
        cell.smartilityLogoContainer.layer.borderWidth = 2
        cell.smartilityLogoContainer.layer.borderColor = brandColor().cgColor
        
        if invite_easyPass == "invite" {
//            cell.smartilityLogo.image = UIImage(named: "invite_sm_logo")
            cell.subContainer.backgroundColor = .white
            cell.containerView.backgroundColor = brandColor()
            cell.gladText.text = glad_text+". Show/tell below OTP at gate for seamless entry."
            if !invite_update {
                if shareFrom == "Share" {
                    titleBack.text = "Share Invite"
                    cell.titleCard.text = "Invite"
                }
                                                
                if wasSent == 0 {
                    if shareFrom == "Share" {
                        cell.staticText.text = ""
                    }else{
                        let attrStri = NSMutableAttributedString.init(string:"Invite has beeen created successfully. Please share it to concerned person.")
                        let nsRange = NSString(string: "Invite has beeen created successfully. Please share it to concerned person.").range(of: "Please share it to concerned person.", options: String.CompareOptions.regularExpression)
                        attrStri.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.red as Any], range: nsRange)
                        cell.staticText.attributedText = attrStri
                    }
                }else{
                    if shareFrom == "Share" {
                        cell.staticText.text = ""
                    }else{
                        cell.staticText.text = "Invite has been sent via SMS. You may share it to concerned person any time as needed."
                    }
                }
            }else{
                if shareFrom == "Share" {
                    titleBack.text = "Share Invite"
                    cell.titleCard.text = "Invite"
                }else{
                    titleBack.text = "Update Invite"
                    cell.titleCard.text = "Invite"
                }
                if wasSent == 0 {
                    if shareFrom == "Share" {
                        cell.staticText.text = ""
                    }else{
                        let attrStri = NSMutableAttributedString.init(string:"Invite has beeen updated successfully. Please share it to concerned person.")
                        let nsRange = NSString(string: "Invite has been updated successfully. Please share it to concerned person.").range(of: "Please share it to concerned person.", options: String.CompareOptions.regularExpression)
                        attrStri.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.red as Any], range: nsRange)
                        cell.staticText.attributedText = attrStri
                    }
                }else{
                    if shareFrom == "Share" {
                        cell.staticText.text = ""
                    }else{
                        cell.staticText.text = "Invite has been sent via SMS. You may share it to concerned person any time as needed."
                    }
                }
            }
        }else{
//            cell.smartilityLogo.image = UIImage(named: "easypass_sm_logo")
            cell.subContainer.backgroundColor = .white
            cell.containerView.backgroundColor = UIColor(hex: "00d455")
            cell.gladText.text = glad_text
            titleBack.text = "New EasyPass"
            cell.titleCard.text = "EasyPass"
            if !easypass_update {
                if shareFrom == "Share" {
                    titleBack.text = "Share EasyPass"
                    cell.titleCard.text = "EasyPass"
                }
                if wasSent == 0 {
                    if shareFrom == "Share" {
                        cell.staticText.text = ""
                    }else{
                        let attrStri = NSMutableAttributedString.init(string:"Easypass has beeen created successfully. Please share it to concerned person.")
                        let nsRange = NSString(string: "Easypass has beeen created successfully. Please share it to concerned person.").range(of: "Please share it to concerned person.", options: String.CompareOptions.regularExpression)
                        attrStri.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.red as Any], range: nsRange)
                        cell.staticText.attributedText = attrStri
                    }
                }else{
                    if shareFrom == "Share" {
                        cell.staticText.text = ""
                    }else{
                        cell.staticText.text = "Easypass has been sent via SMS. You may share it to concerned person any time as needed."
                    }
                }
            }else{
                if shareFrom == "" {
                    titleBack.text = "New EasyPass"
                    cell.titleCard.text = "EasyPass"
                }else{
                    titleBack.text = "Update EasyPass"
                    cell.titleCard.text = "EasyPass"
                }
                if wasSent == 0 {
                    if shareFrom == "Share" {
                        cell.staticText.text = ""
                    }else{
                        let attrStri = NSMutableAttributedString.init(string:"Easypass has beeen updated successfully. Please share it to concerned person.")
                        let nsRange = NSString(string: "Easypass has beeen updated successfully. Please share it to concerned person.").range(of: "Please share it to concerned person.", options: String.CompareOptions.regularExpression)
                        attrStri.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.red as Any], range: nsRange)
                        cell.staticText.attributedText = attrStri
                    }
                }else{
                    if shareFrom == "Share" {
                        cell.staticText.text = ""
                    }else{
                        cell.staticText.text = "Easypass has been sent via SMS. You may share it to concerned person any time as needed."
                    }
                }

            }
        }
        
    
                
        cell.qrCodeNumber.text = otpInvite
        
        if blockandUnit.count == 0 {
            cell.location.text = community.community_name
        }else{
            cell.location.text = blockandUnit+" "+"@ "+community.community_name
        }
        cell.name.text = user_name
        cell.qrcodeImage.image = generateQRCode(from: otpInvite)
             
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}

extension UIImage {
    
    /// place the imageView inside a container view
    /// - parameter superView: the containerView that you want to place the Image inside
    /// - parameter width: width of imageView, if you opt to not give the value, it will take default value of 100
    /// - parameter height: height of imageView, if you opt to not give the value, it will take default value of 30
    func addToCenter(of superView: UIView, width: CGFloat = 100, height: CGFloat = 30) {
        let overlayImageView = UIImageView(image: self)
        
        overlayImageView.translatesAutoresizingMaskIntoConstraints = false
        overlayImageView.contentMode = .scaleAspectFit
        superView.addSubview(overlayImageView)
        
        let centerXConst = NSLayoutConstraint(item: overlayImageView, attribute: .centerX, relatedBy: .equal, toItem: superView, attribute: .centerX, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: overlayImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        let height = NSLayoutConstraint(item: overlayImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        let centerYConst = NSLayoutConstraint(item: overlayImageView, attribute: .centerY, relatedBy: .equal, toItem: superView, attribute: .centerY, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([width, height, centerXConst, centerYConst])
    }
}

