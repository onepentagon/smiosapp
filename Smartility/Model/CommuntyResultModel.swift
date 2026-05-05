//
//  CommuntyResultModel.swift
//  Smartility
//
//  Created by Mani on 7/12/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import Foundation

struct CommuntyResultModel:Codable {
    var comm_id: Int?
    var comm_name:String?
    var country_code:String?
    var gst_no:String?
    var hide_contact:Int?
    var is_active:Int?
    var is_admin:Int?
    var is_inv_class:Int?
    var is_mc_member:Int?
    var is_other_user:Int?
    var is_tax_app:Int?
    var new_role_id:Int?
    var non_tax_inv_class:String?
    var old_role_id:Int?
    var rej_reason_if_other_user:String?
    var rel_status_if_other_user :String?
    var role_id:Int?
    var role_name:String?
    var tax_inv_class:String?
    var user_id: Int?    
    var support_email: String?
    var sms_for_invite: Int?
    var sms_for_easypass: Int?
    var ivr_for_visitor: Int?
}
