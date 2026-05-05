//
//  NoticeModel.swift
//  Smartility
//
//  Created by Mani on 12/13/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import Foundation

struct noticeModel {
    
    let notice_text: String?
    let notice_title: String?
    let user_id: Int?
    let notice_status: String?
    let notice_id: Int?
    let notice_dt: String?
    let is_ack: Int?
    let expiry_dt: String?
    let comm_id: Int?
        
    init(notice_text:String?,notice_title: String?, user_id: Int?,notice_status: String?,notice_id: Int?,notice_dt: String?,is_ack: Int?,expiry_dt: String?,comm_id: Int?) {
        self.notice_text = notice_text
        self.notice_title = notice_title
        self.user_id = user_id
        self.notice_status = notice_status
        self.notice_id = notice_id
        self.notice_dt = notice_dt
        self.is_ack = is_ack
        self.expiry_dt = expiry_dt
        self.comm_id = comm_id
    }
}
