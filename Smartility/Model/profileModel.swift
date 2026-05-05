//
//  profileModel.swift
//  Smartility
//
//  Created by Mani on 9/28/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import Foundation

struct profileModel {
    var address: String?
    var blood_group: String?
    var city : String?
    var contact_email : String?
    var contact_phone : String?
    var country : String?
    var cust_id : Int?
    var cust_name : String?
    var cust_since : String?
    var ecash: Int?
    var emergency_contact_name : String?
    var emergency_contact_relation : String?
    var emergency_phone : String?
    var gender : String?
    var gst_no : String?
    var hobbies : String?
    var occupation : String?
    var phone_country : String?
    var pin_code : String?
    var reg_mode : String?
    var state : String?
    var user_id : Int?
    var is_admin: Int?
    var is_mc_member: Int?
    var avatar_url: String?
    var hideContact : Int?
    var role_name: String?
    var country_code: String?
    
    
    init(address: String?,blood_group: String?,city : String?,contact_email : String?,contact_phone : String?,country : String?, cust_id : Int?,cust_name : String?,cust_since : String?,ecash: Int?,emergency_contact_name : String?,emergency_contact_relation : String?,emergency_phone : String?,gender : String?,gst_no : String?,hobbies : String?,occupation : String?, phone_country : String?, pin_code : String?, reg_mode : String?,state : String?,user_id : Int?,is_admin: Int?,is_mc_member: Int?,avatar_url: String?,hideContact:Int?, role_name:String?, country_code: String?) {
        self.address = address
        self.blood_group = blood_group
        self.city = city
        self.contact_email = contact_email
        self.contact_phone = contact_phone
        self.country = country
        self.cust_id = cust_id
        self.cust_name = cust_name
        self.cust_since = cust_since
        self.ecash = ecash
        self.emergency_contact_name = emergency_contact_name
        self.emergency_contact_relation = emergency_contact_relation
        self.emergency_phone = emergency_phone
        self.gender = gender
        self.gst_no = gst_no
        self.hobbies = hobbies
        self.occupation = occupation
        self.phone_country = phone_country
        self.pin_code = pin_code
        self.reg_mode = reg_mode
        self.state = state
        self.user_id = user_id
        
        self.is_admin = is_admin
        self.is_mc_member = is_mc_member
        self.avatar_url = avatar_url
        self.hideContact = hideContact
        self.role_name = role_name
        self.country_code = country_code
    }
}

