//
//  SpinnerClass.swift
//  Smartility
//
//  Created by Mani on 12/29/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import Foundation

class SpinnerClass {
    private static var privateSharedInstance: SpinnerClass?
    static var shared: SpinnerClass {
        if privateSharedInstance == nil {
            privateSharedInstance = SpinnerClass()
        }
        return privateSharedInstance!
    }
 
    let child = SpinnerViewController()
    func createSpinnerView(controller: UIViewController) {
        controller.addChild(child)
        child.view.frame = controller.view.frame
        controller.view.addSubview(child.view)
        child.didMove(toParent: controller)
    }
    func removeActivityIndicator(){
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}
