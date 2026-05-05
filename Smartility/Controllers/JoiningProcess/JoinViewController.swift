//
//  JoinViewController.swift
//  Smartility
//
//  Created by Mani on 7/8/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit

class JoinViewController: UIViewController {
    
    let collection_view = CompletionView().loadNib() as? CompletionView
    @IBOutlet weak var customSubView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collection_view!)
        collection_view?.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 70, enableInsets: true)
        
        
        guard let v1 = collection_view?.v1 else { return }
        guard let v2 = collection_view?.v2 else { return }
        guard let v3 = collection_view?.v3 else { return }
        guard let v4 = collection_view?.v4 else { return }
        
        
        v1.backgroundColor = UIColor(hex: "#0285A6")
        
        v2.backgroundColor = .lightGray
        
        v3.backgroundColor = .lightGray
        
        v4.backgroundColor = .lightGray
        
        
        setup(round: [v1,v2,v3,v4])
        
        collection_view?.layer.shadowColor = UIColor.lightGray.cgColor
        collection_view?.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        collection_view?.layer.shadowOpacity = 0.6
        collection_view?.layer.shadowRadius = 2
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateInitial), name: NSNotification.Name("Update_init1"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(update_2), name: NSNotification.Name("Update_init2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(update_3), name: NSNotification.Name("Update_init3"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(update_4), name: NSNotification.Name("Update_init4"), object: nil)
        
        let controller = AppStoryboard.joinBoard.viewController(viewControllerClass: MobileValidationController.self)
        add(controller, frame: customSubView.bounds, customVIew: customSubView)
        
    }
    
    @objc func updateInitial(){
        let v1 = collection_view?.v1
        let v2 = collection_view?.v2
        let v3 = collection_view?.v3
        let v4 = collection_view?.v4
        
        let l1 = collection_view?.lab1
        let l2 = collection_view?.lab2
        let l3 = collection_view?.lab3
        let l4 = collection_view?.lab4
        
        l1?.text = "1"
        l2?.text = "2"
        l3?.text = "3"
        l4?.text = "4"
                                
        v1?.backgroundColor = brandColor()
        v2?.backgroundColor = .lightGray
        v3?.backgroundColor = .lightGray
        v4?.backgroundColor = .lightGray
    }
    
    
    @objc func update_2(){
        let v1 = collection_view?.v1
        let v2 = collection_view?.v2
        let v3 = collection_view?.v3
        let v4 = collection_view?.v4
        
        let l1 = collection_view?.lab1
        let l2 = collection_view?.lab2
        let l3 = collection_view?.lab3
        let l4 = collection_view?.lab4
        
        l1?.text = "✓"
        l2?.text = "2"
        l3?.text = "3"
        l4?.text = "4"
        
        v1?.backgroundColor = brandColor()
        v2?.backgroundColor = brandColor()
        v3?.backgroundColor = .lightGray
        v4?.backgroundColor = .lightGray
    }
    
    @objc func update_3(){
        let v1 = collection_view?.v1
        let v2 = collection_view?.v2
        let v3 = collection_view?.v3
        let v4 = collection_view?.v4
        
        let l1 = collection_view?.lab1
        let l2 = collection_view?.lab2
        let l3 = collection_view?.lab3
        let l4 = collection_view?.lab4
        
        l1?.text = "✓"
        l2?.text = "✓"
        l3?.text = "3"
        l4?.text = "4"
        
        v1?.backgroundColor = brandColor()
        v2?.backgroundColor = brandColor()
        v3?.backgroundColor = brandColor()
        v4?.backgroundColor = .lightGray
    }
    
    @objc func update_4(){
        let v1 = collection_view?.v1
        let v2 = collection_view?.v2
        let v3 = collection_view?.v3
        let v4 = collection_view?.v4
        
        let l1 = collection_view?.lab1
        let l2 = collection_view?.lab2
        let l3 = collection_view?.lab3
        let l4 = collection_view?.lab4
        
        l1?.text = "✓"
        l2?.text = "✓"
        l3?.text = "✓"
        l4?.text = "4"
        
        v1?.backgroundColor = brandColor()
        v2?.backgroundColor = brandColor()
        v3?.backgroundColor = brandColor()
        v4?.backgroundColor = brandColor()
    }
    
    
    func setup(round:[UIView]){
        _ = round.map {
            $0.layer.cornerRadius = $0.frame.height/2
            $0.layer.masksToBounds = true
        }
    }
    
}
