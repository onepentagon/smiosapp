//
//  CustomeError.swift
//  Smartility
//
//  Created by Mani on 7/6/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import Foundation
import UIKit

protocol ErrorProtocol:LocalizedError {
    var title: String? { get }
    var code: Int { get }
}
struct customeError: ErrorProtocol{
    var title:String?
    var code:Int
    var errorDescription: String? { return description }
    var failureReason: String? { return description }
    
    private var description:String
    
    init(titile:String?,descrition:String,code:Int) {
        self.title = title ?? "Error"
        self.description = descrition
        self.code = code
    }
}
