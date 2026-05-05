/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation

struct InvitedDetail : Codable {
    
	let invite_id : Int?
	let invite_dt : String?
	let user_id : Int?
	let unit_id : Int?
	let comm_id : Int?
	let is_official : Int?
	let visitor_name : String?
	let visitor_phone : String?
	let visitor_cat : String?
	let visitor_org : String?
	let is_exp_shortly : Int?
	let invited_dt : String?
	let invited_time : String?
	let invited_otp : String?
//	let otp_exp : String?
    let invite_issued_by : String?
    let block_and_unit : String?
	let invite_text : String?
	let invite_status : String?
	let invited_dt_time : String?
	let invited_when : String?

	enum CodingKeys: String, CodingKey {
        
		case invite_id = "invite_id"
		case invite_dt = "invite_dt"
		case user_id = "user_id"
		case unit_id = "unit_id"
		case comm_id = "comm_id"
		case is_official = "is_official"
		case visitor_name = "visitor_name"
		case visitor_phone = "visitor_phone"
		case visitor_cat = "visitor_cat"
		case visitor_org = "visitor_org"
		case is_exp_shortly = "is_exp_shortly"
		case invited_dt = "invited_dt"
		case invited_time = "invited_time"
		case invited_otp = "invited_otp"
//		case otp_exp = "otp_exp"
        case invite_issued_by = "invite_issued_by"
        case block_and_unit = "block_and_unit"
		case invite_text = "invite_text"
		case invite_status = "invite_status"
		case invited_dt_time = "invited_dt_time"
		case invited_when = "invited_when"
        
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		invite_id = try values.decodeIfPresent(Int.self, forKey: .invite_id)
		invite_dt = try values.decodeIfPresent(String.self, forKey: .invite_dt)
		user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
		unit_id = try values.decodeIfPresent(Int.self, forKey: .unit_id)
		comm_id = try values.decodeIfPresent(Int.self, forKey: .comm_id)
		is_official = try values.decodeIfPresent(Int.self, forKey: .is_official)
		visitor_name = try values.decodeIfPresent(String.self, forKey: .visitor_name)
		visitor_phone = try values.decodeIfPresent(String.self, forKey: .visitor_phone)
		visitor_cat = try values.decodeIfPresent(String.self, forKey: .visitor_cat)
		visitor_org = try values.decodeIfPresent(String.self, forKey: .visitor_org)
		is_exp_shortly = try values.decodeIfPresent(Int.self, forKey: .is_exp_shortly)
		invited_dt = try values.decodeIfPresent(String.self, forKey: .invited_dt)
		invited_time = try values.decodeIfPresent(String.self, forKey: .invited_time)
		invited_otp = try values.decodeIfPresent(String.self, forKey: .invited_otp)
//		otp_exp = try values.decodeIfPresent(String.self, forKey: .otp_exp)
		invite_text = try values.decodeIfPresent(String.self, forKey: .invite_text)
		invite_status = try values.decodeIfPresent(String.self, forKey: .invite_status)
		invited_dt_time = try values.decodeIfPresent(String.self, forKey: .invited_dt_time)
		invited_when = try values.decodeIfPresent(String.self, forKey: .invited_when)
        block_and_unit = try values.decodeIfPresent(String.self, forKey: .block_and_unit)
        invite_issued_by = try values.decodeIfPresent(String.self, forKey: .invite_issued_by)
	}
}
