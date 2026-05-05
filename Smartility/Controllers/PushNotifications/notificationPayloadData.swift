//
//  notificationPayloadData.swift
//  Smartility
//
//  Created by Mani on 8/25/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import Foundation


class notificationSingletone {
    private static var privateSharedInstance: notificationSingletone?
    static var shared: notificationSingletone {
        if privateSharedInstance == nil {
            privateSharedInstance = notificationSingletone()
        }
        return privateSharedInstance!
    }
    
    var payload: notificationPayloadData?
    
    var tokenStore = ""
    
}




struct notificationPayloadData {
    var notificationIdentifire : String?
    var visitor_name : String?
    var visitor_img_url : String?
    var visitor_cat : String?
    var Visitor_sub_cat: String?
    var visitor_org : String?
    var is_visitor_mask_on : String?
    var visitor_temp : String?
    var approval_user_id : String?
    var comm_id : String?
    var visit_id : String?
    var notif_sound: String?
    init(notificationIdentifire: String?,visitor_name : String?, visitor_img_url : String?,visitor_cat : String?,Visitor_sub_cat: String?,visitor_org : String?,is_visitor_mask_on : String?,visitor_temp : String?,approval_user_id : String?, comm_id : String?, visit_id : String?, notif_sound: String) {
        self.notificationIdentifire = notificationIdentifire
        self.visitor_name = visitor_name
        self.visitor_img_url = visitor_img_url
        self.visitor_cat = visitor_cat
        self.Visitor_sub_cat =  Visitor_sub_cat
        self.visitor_org = visitor_org
        self.is_visitor_mask_on = is_visitor_mask_on
        self.visitor_temp = visitor_temp
        self.approval_user_id = approval_user_id
        self.comm_id = comm_id
        self.visit_id = visit_id
        self.notif_sound = notif_sound
    }
}
