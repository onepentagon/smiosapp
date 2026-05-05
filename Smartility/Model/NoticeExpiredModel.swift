//
//  NoticeExpiredModel.swift
//  Smartility
//
//  Created by Mani on 12/13/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import Foundation

struct NoticeExpiredModel {
    var ad_by: String?
    var app_by: String?
    var app_dt: String?
    var comm_id: Int?
    var cust_name: String?
    var expiry_dt: String?
    var is_ad: Int?
    var notice_dt: String?
    var notice_id: Int?
    var notice_status: String?
    var notice_text: String?
    var notice_title: String?
    var role_name: String?
    var user_id: Int?
        
    init(ad_by: String?,app_by: String?,app_dt: String?,comm_id: Int?,cust_name: String?,expiry_dt: String?,is_ad: Int?,notice_dt: String?,notice_id: Int?,notice_status: String?,notice_text: String?,notice_title: String?,role_name: String?,user_id: Int?) {
        self.ad_by = ad_by
        self.app_by = app_by
        self.app_dt = app_dt
        self.comm_id = comm_id
        self.cust_name = cust_name
        self.expiry_dt = expiry_dt
        self.is_ad = is_ad
        self.notice_dt = notice_dt
        self.notice_id = notice_id
        self.notice_status = notice_status
        self.notice_text = notice_text
        self.notice_title = notice_title
        self.role_name = role_name
        self.user_id = user_id
    }
}
