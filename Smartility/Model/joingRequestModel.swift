//
//  joingRequestModel.swift
//  Smartility
//
//  Created by Mani on 1/22/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import Foundation


struct joingRequestModel:Encodable {
    
    let address: String?
    let block_nm: String?
    let blood_group: String?
    let city: String?
    let comm_id: Int?
    let comm_name: String?
    let contact_email: String?
    let contact_phone: String?
    let country: String?
    let cust_id: Int?
    let cust_name: String?
    let cust_since: String?
    let ecash: Int?
    let emergency_contact_name: String?
    let emergency_contact_relation: String?
    let emergency_phone: String?
    let gender: String?
    let hide_contact: Int?
    let hobbies: String?
    let is_active: Int?
    let is_admin: Int?
    let is_mc_member: Int?
    let is_other_user: Int?
    let new_role_id: Int?
    let occupation: String?
    let old_role_id: Int?
    let ownership: String?
    let phone_country: String?
    let pin_code: String?
    let reg_mode: String?
    let rej_reason: String?
    let rej_reason_if_other_user: Int?
    let rel_status: String?
    let rel_status_if_other_user: Int?
    let role_id: Int?
    let role_name: String?
    let state: String?
    let unit_id: Int?
    let unit_no: String?
    let user_id: Int?
    
}
