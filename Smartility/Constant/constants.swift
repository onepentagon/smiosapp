//
//  constants.swift
//  Smartility
//
//  Created by Mani on 7/6/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import Foundation
import Alamofire


struct URLValue {
    static var Main_URL:String { return "https://myapp.smartility.com.my:9443/" }
}




struct EndPoint {
    
    static var authorizeEndPoints:String { return URLValue.Main_URL+"authorize-api-key" }
    
    static var imageURL:String { return "https://myapp.smartility.com.my/static/" }
    
    static var get_available_community:String { return URLValue.Main_URL+"getAvailableCommunity" }
    static var otp_send:String { return URLValue.Main_URL+"otp/send" }
    static var otp_verify:String { return URLValue.Main_URL+"otp/verify" }
    static var getUserByPhone:String { return URLValue.Main_URL+"getUserByPhone" }
    
    static var getCommByName:String { return URLValue.Main_URL+"getCommByName" }
    
    static var getUserHistoryByPhone:String { return URLValue.Main_URL+"getUserHistoryByPhone" }
    static var getRolesByCommId:String { return URLValue.Main_URL+"getRolesByCommId" }
    
    static var getBlocksByCommId:String { return URLValue.Main_URL+"getBlocksByCommId" }
    static var getUnitsByBlockId:String { return URLValue.Main_URL+"getUnitsByBlockId" }
    
    static var residentCreate:String { return URLValue.Main_URL+"resident/create" }
    
    static var delete_record:String { return URLValue.Main_URL+"otp/delete-joinee" }
    
    
    static var getCommByUserId:String { return URLValue.Main_URL+"getCommByUserId" }
    static var getUnitsByUserId:String { return URLValue.Main_URL+"getUnitsByUserId" }
    
    static var getMyVisitorByPeriodAndStatus:String { return URLValue.Main_URL+"getMyVisitorByPeriodAndStatus" }
    
    static var getMyInvitedVisitor:String { return URLValue.Main_URL+"getMyInvitedVisitor" }
    
    static var getMyEasyPassHolders:String { return URLValue.Main_URL+"getMyEasyPassHolders" }
    
    static var deleteInvite:String { return URLValue.Main_URL+"myvisitor/delete-invite" }
    
    static var deletePass:String { return URLValue.Main_URL+"myvisitor/delete-pass" }
    
    static var getUserByID:String { return URLValue.Main_URL+"getUserByID" }
    
    static var create_invite:String { return URLValue.Main_URL+"myvisitor/create-invite" }
    
    static var create_easy_Pass:String { return URLValue.Main_URL+"myvisitor/create-pass" }
    
    static var getVisitorNotifySettingsByUnitId:String { return URLValue.Main_URL+"getVisitorNotifySettingsByUnitId" }
    
    static var registerNotifications:String { return URLValue.Main_URL+"push-sub" }
    
    static var approveURL:String { return URLValue.Main_URL+"visitor/approve-action" }
    
    static var testPush:String { return URLValue.Main_URL+"myvisitor/test-push" }
    
    static var rejectURL:String { return URLValue.Main_URL+"visitor/reject-action" }
    
    static var saveSettings:String { return URLValue.Main_URL+"myvisitor/visitor-notify-settings" }
    
    static var sendReminder:String { return URLValue.Main_URL+"myvisitor/remind-invite" }
    
    static var update_invite:String { return URLValue.Main_URL+"myvisitor/update-invite" }
    
    static var update_easyPass:String { return URLValue.Main_URL+"myvisitor/update-pass" }
    static var profileByUserID: String { return URLValue.Main_URL+"getCustByUserId"  }
    
    static var saveURL: String{ return URLValue.Main_URL+"resident/update"}
    
    
    static var notice: String { return URLValue.Main_URL+"getNoticesByCommId" }
    static var getNoticesByCommIdAndStatus: String { return URLValue.Main_URL+"getNoticesByCommIdAndStatus" }
    
    static var getAttachmentByNoticeId: String { return URLValue.Main_URL+"getAttachmentByNoticeId" }
    static var notice_create: String { return URLValue.Main_URL+"notice/create" }
    static var notice_delete: String { return URLValue.Main_URL+"notice/delete" }
    
    static var notice_update: String { return URLValue.Main_URL+"notice/update" }
    static var notice_publish: String { return URLValue.Main_URL+"notice/publish" }
    
    static var getTotalNoticesByStatus: String { return URLValue.Main_URL+"getTotalNoticesByStatus" }
    static var getUserCountByCommId: String { return URLValue.Main_URL+"getUserCountByCommId" }
    
    static var getJoiningRequest: String { return URLValue.Main_URL+"getJoiningRequest" }
    static var rejectJoin: String { return URLValue.Main_URL+"admin/reject-req" }
    static var acceptJoin: String { return URLValue.Main_URL+"admin/accept-req" }
    
    //Invoice
    static var getAccBalByCustId: String { return URLValue.Main_URL+"getAccBalByCustId" }
    
    static var getInvoiceForPDFByInvID: String { return URLValue.Main_URL+"getInvoiceForPDFByInvID" }
    static var getPaymentsForPDFByPayID: String { return URLValue.Main_URL+"getPaymentsForPDFByPayID" }
    
    static var getAccStmtByUnitId: String { return URLValue.Main_URL+"getAccStmtByUnitId" }
    static var getPaymentByPayId: String { return URLValue.Main_URL+"getPaymentByPayId" }
    static var GetInvoiceByInvId: String { return URLValue.Main_URL+"getInvoiceByInvId" }
    static var getMinReqAppVersion: String { return URLValue.Main_URL+"getMinReqAppVersion" }
    
    static var getBankCashAccountsLiteByCommId: String { return URLValue.Main_URL+"getBankCashAccountsLiteByCommId" }
    static var getResidentsByUnitGlAccId: String { return URLValue.Main_URL+"getResidentsByUnitGlAccId" }
    
    static var createPay: String { return URLValue.Main_URL+"invpay/create-pay" }
    static var updatePay: String { return URLValue.Main_URL+"invpay/update-pay" }
    static var deletePay: String { return URLValue.Main_URL+"invpay/delete-pay" }
    
    
    //Paytm
    static var createOnlinePayment: String { return URLValue.Main_URL+"pgpt/create-pg-inprog" }
    static var createInitTransAction: String { return URLValue.Main_URL+"pgpt/init-trans" }
    static var Order_status: String { return URLValue.Main_URL+"pgpt/order-status" }
    
    
}


struct community {
    static var community_id = ""
    static var community_name = ""
    static var cust_location = ""
    static var cust_unitId = ""
}

struct CommunityData {
    static var support_email = ""
    static var sms_for_invite: Int?
    static var sms_for_easypass: Int?
    static var ivr_for_visitor: Int?
}

enum FontFamily: String {
    
//    SF Pro Text
//    == SFProText-Regular
//    == SFProText-RegularItalic
//    == SFProText-Ultralight
//    == SFProText-UltralightItalic
//    == SFProText-Thin
//    == SFProText-ThinItalic
//    == SFProText-Light
//    == SFProText-LightItalic
//    == SFProText-Medium
//    == SFProText-MediumItalic
//    == SFProText-Semibold
//    == SFProText-SemiboldItalic
//    == SFProText-Bold
//    == SFProText-BoldItalic
//    == SFProText-Heavy
//    == SFProText-HeavyItalic
//    == SFProText-Black
//    == SFProText-BlackItalic
    
    case Regular = "SFProText-Regular"
    case RegularItalic = "SFProText-RegularItalic"
    case Ultralight = "SFProText-Ultralight"
    case Thin = "SFProText-Thin"
    case ThinItalic = "SFProText-ThinItalic"
    case Light = "SFProText-Light"
    case LightItalic = "SFProText-LightItalic"
    case Medium = "SFProText-Medium"
    case MediumItalic = "SFProText-MediumItalic"
    case Semibold = "SFProText-Semibold"
    case SemiboldItalic = "SFProText-SemiboldItalic"
    case Bold = "SFProText-Bold"
    case BoldItalic = "SFProText-BoldItalic"
    case Heavy = "SFProText-Heavy"
    case HeavyItalic = "SFProText-HeavyItalic"
    case Black = "SFProText-Black"
    case BlackItalic = "SFProText-BlackItalic"
}

func SFFont(font: FontFamily, size: CGFloat) -> UIFont {
    return UIFont(name: font.rawValue, size: size)!
}


class UnitDetails {
    static let shared = UnitDetails()
    var getAccModel = [GetAccBALByCustIDModelElement]()
    var unitName = String()
    var unitID = String()
}


func infoColor()-> UIColor?{
//    return UIColor(hex: "00aad4")
//    return UIColor(hex:"#2F80ED")
    return UIColor(hex:"#552FEE")
}
func lightInfoColor()-> UIColor{
    return UIColor(hex: "00ccff")
}

func brandColor()-> UIColor{
//    return UIColor(hex: "0088aa")
    return UIColor(hex: "#5445D3")
}

func accentColor()-> UIColor{
//    return UIColor(hex: "ffd42a") 
    return UIColor(hex:"5445D3")
}

func secondaryColor()->UIColor{
    return UIColor(hex:"#E26557")
}

func warningColor()->UIColor{
    return UIColor(hex:"#FBCE2F")
}

func successColor()-> UIColor{
    return UIColor(hex:"#27AE60")
}

class navigationControllerClass {
    static let shared = navigationControllerClass()
    var navigationController: UINavigationController?
}

func countryCurrencyFormate(amount: Double) -> String{
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.minimumFractionDigits = 2
    var localeCode = ""
    if UserDefaults.UserContry == "MY" {
        localeCode = "en_MY"
    }else{
        localeCode = "en-in"
    }
    currencyFormatter.locale = Locale(identifier: localeCode)
    currencyFormatter.numberStyle = .currency
    let priceString = currencyFormatter.string(from: NSNumber(value: amount)) ?? ""
    return priceString
}




enum GitRouter {
    case GetInvoiceByInvId
    
    var baseURL: String {
        switch self {
        case .GetInvoiceByInvId:
            return "https://myapp.smartility.com.my:9443"
        }
    }
    
    var path: String {
        switch self {
        case .GetInvoiceByInvId:
            return "/GetInvoiceByInvId"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .GetInvoiceByInvId:
            return .get
        }
    }
    
    var parameters: [String:String]? {
      switch self {
      case .GetInvoiceByInvId:
        return perams?.perams
      }
    }
}

var perams: Perams?

struct Perams {
    var perams: [String:String] = [:]
            
    init(radius: [String:String]) {
        self.perams = radius
        setRadius(radius: radius)
    }
    mutating func setRadius(radius: [String:String]) {
        self.perams = radius
    }
}

// MARK: - URLRequestConvertible
extension GitRouter: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        if method == .get {
            request = try URLEncodedFormParameterEncoder()
                .encode(parameters, into: request)
        } else if method == .post {
            request = try JSONParameterEncoder().encode(parameters, into: request)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
        }
        return request
    }
}
