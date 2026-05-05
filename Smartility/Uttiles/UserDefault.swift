//
//  UserDefault.swift
//  Smartility
//
//  Created by Mani on 7/11/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import Foundation


extension UserDefaults {
               
    class var ApiKey : String {
        get { return standard.value(forKey: "UniqueKey") as? String ?? "" }
        set {
            standard.set(newValue, forKey: "UniqueKey")
        }
    }
    
    
    class var cust_id : String {
        get { return standard.value(forKey: "cust_id") as? String ?? "" }
        set {
            standard.set(newValue, forKey: "cust_id")
        }
    }
    
    class var user_id : String {
        get { return standard.value(forKey: "user_id") as? String ?? "" }
        set {
            standard.set(newValue, forKey: "user_id")
        }
    }
    
    
    class var user_name : String {
        get { return standard.value(forKey: "user_name") as? String ?? "" }
        set {
            standard.set(newValue, forKey: "user_name")
        }
    }
    
    class var UserContry : String {
        get { return standard.value(forKey: "UserContry") as? String ?? "" }
        set {
            standard.set(newValue, forKey: "UserContry")
        }
    }
    
    
    class var isOtherUser : Int {
        get { return standard.value(forKey: "is_other_user") as? Int ?? 0 }
        set {
            standard.set(newValue, forKey: "is_other_user")
        }
    }
    
    class var isAdmin : Int {
          get { return standard.value(forKey: "is_admin") as? Int ?? 0 }
          set {
              standard.set(newValue, forKey: "is_admin")
          }
      }    
}


