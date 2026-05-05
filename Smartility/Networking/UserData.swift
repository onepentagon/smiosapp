//
//  UserData.swift
//  Smartility
//
//  Created by Mani on 7/9/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import Foundation
import UIKit

class UserData {
    private static var privateSharedInstance: UserData?
    static var shared: UserData {
        if privateSharedInstance == nil {
            privateSharedInstance = UserData()
        }
        return privateSharedInstance!
    }
    
    var modelData: [CommunityModel]? = nil
        
    func getAuthorizedParams()->[String:Any]{
        var getAuthorizedParams = [String:Any]()
        getAuthorizedParams.updateValue(UserDefaults.user_id, forKey: "user_id")
        getAuthorizedParams.updateValue(UserDefaults.ApiKey+UserDefaults.user_id, forKey: "api_key")
        getAuthorizedParams.updateValue("iOS", forKey: "device_os")
        getAuthorizedParams.updateValue(UIDevice.current.systemVersion, forKey: "device_os_ver")
        getAuthorizedParams.updateValue("Apple", forKey: "device_make")
        getAuthorizedParams.updateValue(UIDevice.current.modelName, forKey: "device_model")
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        getAuthorizedParams.updateValue(appVersion, forKey: "app_ver")
        getAuthorizedParams.updateValue(UIDevice.current.identifierForVendor?.uuidString ?? "", forKey: "user_device_id")
        return getAuthorizedParams
    }
    
}
