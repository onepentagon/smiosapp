/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation

struct Approvals : Codable {
    let approval_user_id : Int?
    let approved_by : String?
    let approval_status : String?
    let approval_mode : String?
    let denied_due_to : String?

    enum CodingKeys: String, CodingKey {

        case approval_user_id = "approval_user_id"
        case approved_by = "approved_by"
        case approval_status = "approval_status"
        case approval_mode = "approval_mode"
        case denied_due_to = "denied_due_to"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        approval_user_id = try values.decodeIfPresent(Int.self, forKey: .approval_user_id)
        approved_by = try values.decodeIfPresent(String.self, forKey: .approved_by)
        approval_status = try values.decodeIfPresent(String.self, forKey: .approval_status)
        approval_mode = try values.decodeIfPresent(String.self, forKey: .approval_mode)
        denied_due_to = try values.decodeIfPresent(String.self, forKey: .denied_due_to)
    }

}
