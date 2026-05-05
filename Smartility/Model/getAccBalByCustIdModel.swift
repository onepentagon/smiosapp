//
//  getAccBalByCustIdModel.swift
//  Smartility
//
//  Created by Mani on 3/4/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit

struct GetAccBALByCustIDModelElement : Codable {

    let coveringFrom : String?
    let coveringTill : String?
    let detail : [DetailModel]?
    let dueDt : String?
    let invAmount : Double?
    let invDt : String?
    let invNo : String?
    let invStatus : String?
    let invType : String?
    let payment : [PaymentModelData]?
    let pendingAmount : Double?
    let sourceRefId : Int?

        enum CodingKeys: String, CodingKey {
                case coveringFrom = "covering_from"
                case coveringTill = "covering_till"
                case detail = "detail"
                case dueDt = "due_dt"
                case invAmount = "inv_amount"
                case invDt = "inv_dt"
                case invNo = "inv_no"
                case invStatus = "inv_status"
                case invType = "inv_type"
                case payment = "payment"
                case pendingAmount = "pending_amount"
                case sourceRefId = "source_ref_id"
        }
    
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            coveringFrom = try values.decodeIfPresent(String.self, forKey: .coveringFrom) ?? ""
            coveringTill = try values.decodeIfPresent(String.self, forKey: .coveringTill) ?? ""
            detail = try values.decodeIfPresent([DetailModel].self, forKey: .detail) ?? []
            dueDt = try values.decodeIfPresent(String.self, forKey: .dueDt) ?? ""
            invAmount = try values.decodeIfPresent(Double.self, forKey: .invAmount) ?? 0.0
            invDt = try values.decodeIfPresent(String.self, forKey: .invDt) ?? ""
            invNo = try values.decodeIfPresent(String.self, forKey: .invNo) ?? ""
            invStatus = try values.decodeIfPresent(String.self, forKey: .invStatus) ?? ""
            invType = try values.decodeIfPresent(String.self, forKey: .invType) ?? ""
            payment = try values.decodeIfPresent([PaymentModelData].self, forKey: .payment) ?? []
            pendingAmount = try values.decodeIfPresent(Double.self, forKey: .pendingAmount) ?? 0.0
            sourceRefId = try values.decodeIfPresent(Int.self, forKey: .sourceRefId)
        }

}

struct PaymentModelData : Codable {        
    let payAmount : Double?
    let payDt : String?
    let payId : Int?
    let payStatus : String?
    let rejReason : String?
    
    enum CodingKeys: String, CodingKey {
        case payAmount = "pay_amount"
        case payDt = "pay_dt"
        case payId = "pay_id"
        case payStatus = "pay_status"
        case rejReason = "rej_reason"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        payAmount = try values.decodeIfPresent(Double.self, forKey: .payAmount) ?? 0.0
        payDt = try values.decodeIfPresent(String.self, forKey: .payDt) ?? ""
        payId = try values.decodeIfPresent(Int.self, forKey: .payId)
        payStatus = try values.decodeIfPresent(String.self, forKey: .payStatus) ?? ""
        rejReason = try values.decodeIfPresent(String.self, forKey: .rejReason) ?? ""
    }
    
}


struct DetailModel : Codable {
        let invId : Int?
        let lineAmount : Double?
        let lineDesc : String?
        let lineSubDesc : String?
        let sourceRefId : Int?
        enum CodingKeys: String, CodingKey {
                case invId = "inv_id"
                case lineAmount = "line_amount"
                case lineDesc = "line_desc"
                case lineSubDesc = "line_sub_desc"
                case sourceRefId = "source_ref_id"
        }
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                invId = try values.decodeIfPresent(Int.self, forKey: .invId) ?? nil
            lineAmount = try values.decodeIfPresent(Double.self, forKey: .lineAmount) ?? 0.0
                lineDesc = try values.decodeIfPresent(String.self, forKey: .lineDesc) ?? ""
                lineSubDesc = try values.decodeIfPresent(String.self, forKey: .lineSubDesc) ?? ""
                sourceRefId = try values.decodeIfPresent(Int.self, forKey: .sourceRefId)
        }

}
