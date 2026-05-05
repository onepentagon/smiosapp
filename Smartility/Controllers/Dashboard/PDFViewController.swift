//
//  PDFViewController.swift
//  Smartility
//
//  Created by Mani on 12/19/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import PDFKit
import Alamofire

class PDFViewController: UIViewController {
    
    @IBOutlet weak var menuContainer: UIView!
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var backVIew: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var fileURL: URL?
    var file_name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        
        backVIew.setClickListener {
            self.navigationController?.popViewController(animated: true)
        }
        
        
        self.view.bringSubviewToFront(menuContainer)
        menuContainer.backgroundColor = .white
        menuContainer.layer.shadowColor = UIColor(red: 0.049, green: 0.019, blue: 0.167, alpha: 0.2).cgColor
        menuContainer.layer.shadowOpacity = 1
        menuContainer.layer.shadowRadius = 1
        menuContainer.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        self.tabBarController?.tabBar.isHidden = true
                   
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                heightConstraint.constant = 60
            case 1334:
                print("iPhone 6/6S/7/8")
                heightConstraint.constant = 80
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
            default:
                heightConstraint.constant = 90
            }
        }else{
            heightConstraint.constant = 90
        }
        
        fileNameLabel.adjustsFontSizeToFitWidth = true
        fileNameLabel.text = file_name
        if #available(iOS 11.0, *) {
            var pdfView: PDFView? = nil
            pdfView = PDFView(frame: view.bounds)
            view.addSubview(pdfView!)
            pdfView?.layoutAnchor(top: menuContainer.bottomAnchor, left: menuContainer.leftAnchor, bottom: view.bottomAnchor, right: menuContainer.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: true)
            pdfView?.autoScales = true
            pdfView?.document = PDFDocument(url: fileURL!)            
        } else {
            // Fallback on earlier versions
        }
    }       
}


