/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct EasyPassHolderDetail : Codable {
    
	let easypass_id : Int?
	let easypass_dt : String?
	let user_id : Int?
	let unit_id : Int?
	let comm_id : Int?
	let is_official : Int?
	let visitor_name : String?
	let visitor_phone : String?
	let gender : String?
	let visitor_cat : String?
	let visitor_sub_cat : String?
	let visitor_org : String?
	let visitor_img_url : String?
    let block_and_unit : String?    
	let is_id_verified : Int?
	let id_type : String?
	let id_img_url : String?
	let vehicle_type : String?
	let vehicle_no : String?
	let easypass_no : String?
	let easypass_exp : String?
	let easypass_status : String?
	let maid_id : String?
	let is_no_expiry : Int?
	let time_limit : String?
	let user_name : String?
	let person_id : Int?
    
	enum CodingKeys: String, CodingKey {

		case easypass_id = "easypass_id"
		case easypass_dt = "easypass_dt"
		case user_id = "user_id"
		case unit_id = "unit_id"
		case comm_id = "comm_id"
		case is_official = "is_official"
		case visitor_name = "visitor_name"
		case visitor_phone = "visitor_phone"
		case gender = "gender"
		case visitor_cat = "visitor_cat"
		case visitor_sub_cat = "visitor_sub_cat"
		case visitor_org = "visitor_org"
		case visitor_img_url = "visitor_img_url"
		case is_id_verified = "is_id_verified"
		case id_type = "id_type"
		case id_img_url = "id_img_url"
		case vehicle_type = "vehicle_type"
		case vehicle_no = "vehicle_no"
		case easypass_no = "easypass_no"
		case easypass_exp = "easypass_exp"
		case easypass_status = "easypass_status"
		case maid_id = "maid_id"
		case is_no_expiry = "is_no_expiry"
		case time_limit = "time_limit"
		case user_name = "user_name"
		case person_id = "person_id"
        case block_and_unit = "block_and_unit"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		easypass_id = try values.decodeIfPresent(Int.self, forKey: .easypass_id)
		easypass_dt = try values.decodeIfPresent(String.self, forKey: .easypass_dt)
		user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
		unit_id = try values.decodeIfPresent(Int.self, forKey: .unit_id)
		comm_id = try values.decodeIfPresent(Int.self, forKey: .comm_id)
		is_official = try values.decodeIfPresent(Int.self, forKey: .is_official)
		visitor_name = try values.decodeIfPresent(String.self, forKey: .visitor_name)
		visitor_phone = try values.decodeIfPresent(String.self, forKey: .visitor_phone)
		gender = try values.decodeIfPresent(String.self, forKey: .gender)
		visitor_cat = try values.decodeIfPresent(String.self, forKey: .visitor_cat)
		visitor_sub_cat = try values.decodeIfPresent(String.self, forKey: .visitor_sub_cat)
		visitor_org = try values.decodeIfPresent(String.self, forKey: .visitor_org)
		visitor_img_url = try values.decodeIfPresent(String.self, forKey: .visitor_img_url)
		is_id_verified = try values.decodeIfPresent(Int.self, forKey: .is_id_verified)
		id_type = try values.decodeIfPresent(String.self, forKey: .id_type)
		id_img_url = try values.decodeIfPresent(String.self, forKey: .id_img_url)
		vehicle_type = try values.decodeIfPresent(String.self, forKey: .vehicle_type)
		vehicle_no = try values.decodeIfPresent(String.self, forKey: .vehicle_no)
		easypass_no = try values.decodeIfPresent(String.self, forKey: .easypass_no)
		easypass_exp = try values.decodeIfPresent(String.self, forKey: .easypass_exp)
		easypass_status = try values.decodeIfPresent(String.self, forKey: .easypass_status)
		maid_id = try values.decodeIfPresent(String.self, forKey: .maid_id)
		is_no_expiry = try values.decodeIfPresent(Int.self, forKey: .is_no_expiry)
		time_limit = try values.decodeIfPresent(String.self, forKey: .time_limit)
		user_name = try values.decodeIfPresent(String.self, forKey: .user_name)
		person_id = try values.decodeIfPresent(Int.self, forKey: .person_id)
        block_and_unit = try values.decodeIfPresent(String.self, forKey: .block_and_unit)
	}

}
