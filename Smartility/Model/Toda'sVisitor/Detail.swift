/*
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation


struct Detail : Codable {
    /*
    let visit_id : Int?
    let visit_dt : String?
     */
    let in_time : String?
    let out_time : String?
    /*
    let comm_id : Int?
     */
    let visitor_name : String?
    let visitor_phone : String?
    let visitor_img_url : String?
    let visitor_type : String?
    /*
    let visitor_type : String?
    */
    let visitor_cat : String?
    let visitor_sub_cat : String?
    let visitor_org : String?
    /*
    let visiting_area : String?
    let vehicle_type : String?
    let vehicle_no : String?
    let purpose : String?
    let invite_id : String?
    let easypass_id : String?
    let is_pre_app : Int?
     */
    let visitor_status : String?
    /*
    let security_user_id : Int?
    let log_mode : String?
    let log_location : String?
    let offline_deviation : String?
    let smart_dev_id : String?
     */
    let approvals : [Approvals]?
 

    enum CodingKeys: String, CodingKey {

        /*
        case visit_id = "visit_id"
        case visit_dt = "visit_dt"
        */
        case in_time = "in_time"
        case out_time = "out_time"
        /*
        case comm_id = "comm_id"
        */
        case visitor_name = "visitor_name"
        case visitor_phone = "visitor_phone"
        case visitor_img_url = "visitor_img_url"
        case visitor_type = "visitor_type"
        /*
        case visitor_type = "visitor_type"
        */
        case visitor_cat = "visitor_cat"
        case visitor_sub_cat = "visitor_sub_cat"
        case visitor_org = "visitor_org"
        /*
        case visiting_area = "visiting_area"
        case vehicle_type = "vehicle_type"
        case vehicle_no = "vehicle_no"
        case purpose = "purpose"
        case invite_id = "invite_id"
        case easypass_id = "easypass_id"
        case is_pre_app = "is_pre_app"
        */
        
        case visitor_status = "visitor_status"
        /*
        case security_user_id = "security_user_id"
        case log_mode = "log_mode"
        case log_location = "log_location"
        case offline_deviation = "offline_deviation"
        case smart_dev_id = "smart_dev_id"
        */
        case approvals = "approvals"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)        
//        visit_id = try values.decodeIfPresent(Int.self, forKey: .visit_id)
//        visit_dt = try values.decodeIfPresent(String.self, forKey: .visit_dt)
        in_time = try values.decodeIfPresent(String.self, forKey: .in_time)
        out_time = try values.decodeIfPresent(String.self, forKey: .out_time)
//        comm_id = try values.decodeIfPresent(Int.self, forKey: .comm_id)
        visitor_name = try values.decodeIfPresent(String.self, forKey: .visitor_name)
        visitor_phone = try values.decodeIfPresent(String.self, forKey: .visitor_phone)
        visitor_img_url = try values.decodeIfPresent(String.self, forKey: .visitor_img_url)
        
        visitor_type = try values.decodeIfPresent(String.self, forKey: .visitor_type)
        
        visitor_cat = try values.decodeIfPresent(String.self, forKey: .visitor_cat)
        visitor_sub_cat = try values.decodeIfPresent(String.self, forKey: .visitor_sub_cat)
        visitor_org = try values.decodeIfPresent(String.self, forKey: .visitor_org)
        
//        visiting_area = try values.decodeIfPresent(String.self, forKey: .visiting_area)
//        vehicle_type = try values.decodeIfPresent(String.self, forKey: .vehicle_type)
//        vehicle_no = try values.decodeIfPresent(String.self, forKey: .vehicle_no)
//        purpose = try values.decodeIfPresent(String.self, forKey: .purpose)
//        invite_id = try values.decodeIfPresent(String.self, forKey: .invite_id)
//        easypass_id = try values.decodeIfPresent(String.self, forKey: .easypass_id)
//        is_pre_app = try values.decodeIfPresent(Int.self, forKey: .is_pre_app)
        visitor_status = try values.decodeIfPresent(String.self, forKey: .visitor_status)
//        security_user_id = try values.decodeIfPresent(Int.self, forKey: .security_user_id)
//        log_mode = try values.decodeIfPresent(String.self, forKey: .log_mode)
//        log_location = try values.decodeIfPresent(String.self, forKey: .log_location)
//        offline_deviation = try values.decodeIfPresent(String.self, forKey: .offline_deviation)
//        smart_dev_id = try values.decodeIfPresent(String.self, forKey: .smart_dev_id)
        approvals = try values.decodeIfPresent([Approvals].self, forKey: .approvals)
    }

}
