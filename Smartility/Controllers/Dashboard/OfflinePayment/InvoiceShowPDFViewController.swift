//
//  InvoiceShowPDFViewController.swift
//  Smartility
//
//  Created by Mani on 2/20/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import PDFKit

class InvoiceShowPDFViewController: UIViewController {
    
    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var backBgView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuHeight: NSLayoutConstraint!
    var htmlString: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        
        backBgView.setClickListener {
            self.navigationController?.popViewController(animated: true)
        }
        
        self.view.bringSubviewToFront(menuView)
        menuView.backgroundColor = .white
        menuView.layer.shadowColor = UIColor(red: 0.049, green: 0.019, blue: 0.167, alpha: 0.2).cgColor
        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowRadius = 1
        menuView.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        self.title = "Invoice & Payments"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = infoColor()
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.view.backgroundColor = .white        
        if #available(iOS 11.0, *) {
            pdfView.layoutAnchor(top: menuView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: true)
            pdfView.autoScales = true
            do{
                let data = try Data(contentsOf: htmlString!)
                let pdfDOC = PDFDocument(data: data)
                pdfView?.displayMode = .singlePageContinuous
                pdfView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                pdfView?.displaysAsBook = true
                pdfView?.displayDirection = .vertical
                pdfView?.document = pdfDOC
                pdfView?.autoScales = true
                pdfView?.maxScaleFactor = 4.0
                pdfView?.minScaleFactor = pdfView!.scaleFactorForSizeToFit
            }catch let err{
                print(err.localizedDescription)
            }
            
        } else {
            // Fallback on earlier versions
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
//        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = infoColor()
//        navigationController?.navigationItem.backBarButtonItem?.tintColor = infoColor()
//        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
