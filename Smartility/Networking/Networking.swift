//
//  Networking.swift
//  Smartility
//
//  Created by Mani on 7/6/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import Foundation
import Alamofire

class NetworkState {
    class func isConnected() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class Networking {
    private static var privateSharedInstance: Networking?
    static var shared: Networking {
        if privateSharedInstance == nil {
            privateSharedInstance = Networking()
        }
        return privateSharedInstance!
    }
    
    
    func authorizeApi(completion: @escaping (String?,Error?) -> Void) {
        
        APIManager.shared.sessionManager.request(EndPoint.authorizeEndPoints,method: .post,parameters: UserData.shared.getAuthorizedParams(),encoding: JSONEncoding.default) .responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let data = response.data {
                    if response.response?.statusCode == 200 {
                        completion(String(decoding: data, as: UTF8.self), nil)
                    }else{
                        print(String(decoding: data, as: UTF8.self))
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }
                }else{
                    completion(nil, dataNil.wentWrong)
                }
            case .failure(let error):
                if let data = response.data {
                    completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                }else{
                    completion(nil, error)
                }
            }
        }
    }
    func updateToken(token: String){
        //        if UserDefaults.user_id != "nil" && UserDefaults.user_id != "" {
        var params = ["user_id": UserDefaults.user_id, "push_channel":"M", "push_sub": notificationSingletone.shared.tokenStore,"user_device_id": UIDevice.current.identifierForVendor?.uuidString ?? ""]
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                params.updateValue("granted", forKey: "sub_status")
                Networking.shared.registerNotification(perams: params) { (success, error) in
                    if success != nil {
                        
                    }else{
                        print("failure")
                    }
                }
            }else {
                params.updateValue("denied", forKey: "sub_status")
                Networking.shared.registerNotification(perams: params) { (success, error) in
                    if success != nil {
                        
                    }else{
                        print("failure")
                    }
                }
            }
        }
        //        }
    }
    
    func getLanguageData(contryCode:String, completion: @escaping ([String]?,Error?) -> Void) {
        
        if NetworkState.isConnected() {
            let params = ["country_code":contryCode]
            APIManager.shared.sessionManager.request(EndPoint.get_available_community,method: .get,parameters:params).response { (response) in
                switch response.result {
                case .success(_):
                    if response.data != nil {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: response.data!, options: []) as? NSArray {
                                var list = [String]()
                                for i in json {
                                    if let name = i as? [String:String] {
                                        list.append(name["comm_name"] ?? "")
                                    }
                                }
                                completion(list, nil)
                            }else{
                                completion(nil, dataNil.wentWrong)
                            }
                        }else{
                            completion(nil, dataNil.wentWrong)
                        }
                    }
                case .failure(let error):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, error)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
    }
    
    func otp_send(perams:[String:Any], completion: @escaping (String?,Error?) -> Void){
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.otp_send, method:.post, parameters: perams,encoding: JSONEncoding.default) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if response.response?.statusCode == 200 {
                        if let dat = response.data {
                            let str = String(decoding: dat, as: UTF8.self)
                            print(str)
                            completion(str, nil)
                        }
                    }else{
                        completion(nil, dataNil.wentWrong)
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else {
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
    }
    
    
    func getUserByPhone(phone_number: String, completion: @escaping ([String:Any]?,Error?) -> Void) {
        if NetworkState.isConnected() {
            
            let perams = ["contact_phone":phone_number]
            APIManager.shared.sessionManager.request(EndPoint.getUserByPhone,method: .get,parameters:perams).response { (response) in
                switch response.result {
                case .success(_):
                    if response.data != nil {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: response.data!, options: []) as? NSArray {
                                print(json)
                                var model = [String:Any]()
                                for i in 0..<json.count {
                                    let jso = json[i] as? [String:Any]
                                    //                                    if let url = jso?["avatar_url"] as? String {
                                    //                                        model.updateValue(url, forKey: "user_id")
                                    //                                    }
                                    if let cust_id = jso?["cust_id"] as? Int {
                                        model.updateValue(cust_id, forKey: "cust_id")
                                    }
                                    if let user_id = jso?["user_id"] as? Int {
                                        UserDefaults.user_id = "\(user_id)"
                                        model.updateValue(user_id, forKey: "user_id")
                                    }
                                }
                                if model.count != 0 {
                                    completion(model, nil)
                                }else{
                                    completion(nil, doesNotExist.noUser)
                                }
                            }
                        }else{
                            completion(nil, dataNil.wentWrong)
                        }
                    }
                case .failure(let error):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, error)
                    }
                }
            }
        }else {
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
    }
    
    func getCommByName(perams:[String:Any], completion: @escaping ([CommunityDetailsModel]?,Error?) -> Void){
        
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.getCommByName,method: .get,parameters:perams).response { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            var keyValue = [CommunityDetailsModel]()
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSArray {
                                print(json)
                                for i in 0..<json.count {
                                    let keyVa = json[i] as? [String:Any]
                                    
                                    let comm_id = keyVa?["comm_id"] as? Int
                                    let comm_name = keyVa?["comm_name"] as? String
                                    let comm_type = keyVa?["comm_type"] as? String
                                    let address = keyVa?["address"] as? String
                                    let city = keyVa?["city"] as? String
                                    let pin_code = keyVa?["pin_code"] as? Int
                                    let state = keyVa?["state"] as? String
                                    let country = keyVa?["country"] as? String
                                    let country_code = keyVa?["country_code"] as? String
                                    let contact_name = keyVa?["contact_name"] as? String
                                    let contact_desig = keyVa?["contact_desig"] as? String
                                    let contact_phone = keyVa?["contact_phone"] as? String
                                    let contact_email = keyVa?["contact_email"] as? String
                                    let comm_segment = keyVa?["comm_segment"] as? String
                                    let no_of_unit = keyVa?["no_of_unit"] as? String
                                    let cust_since = keyVa?["cust_since"] as? String
                                    let reg_mode = keyVa?["reg_mode"] as? String
                                    let bio_dev_slno = keyVa?["bio_dev_slno"] as? String
                                    let pg_status = keyVa?["pg_status"] as? String
                                    let merchant_id = keyVa?["merchant_id"] as? String
                                    let merchant_key = keyVa?["merchant_key"] as? String
                                    let bank_acc_no = keyVa?["bank_acc_no"] as? String
                                    let bank_acc_name = keyVa?["bank_acc_name"] as? String
                                    let is_tax_app = keyVa?["is_tax_app"] as? Int
                                    let gst_no = keyVa?["gst_no"] as? String
                                    let is_inv_class = keyVa?["is_inv_class"] as? Int
                                    let tax_inv_class = keyVa?["tax_inv_class"] as? String
                                    let non_tax_inv_class = keyVa?["non_tax_inv_class"] as? String
                                    let org_vendor_id = keyVa?["org_vendor_id"] as? Int
                                    let ms_face_person_group_id = keyVa?["ms_face_person_group_id"] as? String
                                    
                                    keyValue.append(CommunityDetailsModel(comm_id: comm_id, comm_name: comm_name, comm_type: comm_type, address: address, city: city, pin_code: pin_code, state: state, country: country, country_code: country_code, contact_name: contact_name, contact_desig: contact_desig, contact_phone: contact_phone, contact_email: contact_email, comm_segment: comm_segment, no_of_unit: no_of_unit, cust_since: cust_since, reg_mode: reg_mode, bio_dev_slno: bio_dev_slno, pg_status: pg_status, merchant_id: merchant_id, merchant_key: merchant_key, bank_acc_no: bank_acc_no, bank_acc_name: bank_acc_name, is_tax_app: is_tax_app, gst_no: gst_no, is_inv_class: is_inv_class, tax_inv_class: tax_inv_class, non_tax_inv_class: non_tax_inv_class, org_vendor_id: org_vendor_id, ms_face_person_group_id: ms_face_person_group_id))
                                }
                                
                                completion(keyValue, nil)
                            }
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
        
    }
    
    
    
    
    
    func getUserByID(user_id:String, completion: @escaping ([UserModel]?,Error?) -> Void){
        
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.getUserByID+"/"+user_id, method: .get).response { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        var keyValue = [UserModel]()
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSArray {
                            print(json)
                            for i in 0..<json.count {
                                let keyVa = json[i] as? [String:Any]
                                
                                let avatar_url = keyVa?["avatar_url"] as? String ?? ""
                                let cust_id = keyVa?["cust_id"] as? Int
                                let cust_name = keyVa?["cust_name"] as? String ?? ""
                                let gender = keyVa?["gender"] as? String ?? ""
                                let address = keyVa?["address"] as? String ?? ""
                                let city = keyVa?["city"] as? String ?? ""
                                let pin_code = keyVa?["pin_code"] as? String ?? ""
                                let state = keyVa?["state"] as? String ?? ""
                                let country = keyVa?["country"] as? String ?? ""
                                let contact_phone = keyVa?["contact_phone"] as? String ?? ""
                                let phone_country = keyVa?["phone_country"] as? String ?? ""
                                let contact_email = keyVa?["contact_email"] as? String ?? ""
                                let reg_mode = keyVa?["reg_mode"] as? String ?? ""
                                
                                keyValue.append(UserModel(avatar_url: avatar_url, cust_id: cust_id, cust_name: cust_name, gender: gender, address: address, pin_code: pin_code, city: city, state: state, country: country, contact_phone: contact_phone, reg_mode: reg_mode, contact_email: contact_email))
                                
                            }
                            completion(keyValue, nil)
                        }else{
                            completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
    }
    
    
    
    func otp_verify(perams:[String:Any], completion: @escaping (String?,Error?) -> Void){
        
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.otp_verify, method:.post, parameters: perams,encoding: JSONEncoding.default) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                            UserDefaults.ApiKey = json["api_key"] as? String ?? ""
                            completion(json["api_key"] as? String, nil)
                        }else{
                            completion(String(decoding: data, as: UTF8.self), nil)
                        }
                    }else{
                        completion(nil, dataNil.wentWrong)
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
    }
    
    
    
    
    func getUserHistory(perams:[String:Any], completion: @escaping ([CommunityModel]?,Error?) -> Void){
        
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.getUserHistoryByPhone,method: .get,parameters:perams).response { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            var keyValue = [CommunityModel]()
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSArray {
                                print(json)
                                for i in 0..<json.count {
                                    let keyVa = json[i] as? [String:Any]
                                    
                                    let address = keyVa?["address"] as? String ?? ""
                                    let blockId = keyVa?["block_id"] as? Int
                                    let blockNm = keyVa?["block_nm"] as? String ?? ""
                                    let bloodGroup = keyVa?["blood_group"] as? String ?? ""
                                    let city = keyVa?["city"] as?  String ?? ""
                                    let commId = keyVa?["comm_id"] as? Int
                                    let commName = keyVa?["comm_name"] as?  String ?? ""
                                    let contactEmail = keyVa?["contact_email"] as?  String ?? ""
                                    let contactPhone = keyVa?["contact_phone"] as?  String ?? ""
                                    let country = keyVa?["country"] as?  String ?? ""
                                    let custId = keyVa?["cust_id"] as?  Int
                                    let custName = keyVa?["cust_name"] as? String ?? ""
                                    let custSince = keyVa?["cust_since"] as?  String ?? ""
                                    let ecash = keyVa?["ecash"] as?  Int
                                    let emergencyContactName = keyVa?["emergency_contact_name"] as?  String ?? ""
                                    let emergencyContactRelation = keyVa?["emergency_contact_relation"] as?  String ?? ""
                                    let emergencyPhone = keyVa?["emergency_phone"] as? String ?? ""
                                    let gender = keyVa?["gender"] as?  String ?? ""
                                    let hobbies = keyVa?["hobbies"] as?  String ?? ""
                                    let isOtherUser = keyVa?["is_other_user"] as?  Bool
                                    let occupation = keyVa?["occupation"] as?  String ?? ""
                                    let ownership = keyVa?["ownership"] as?  String ?? ""
                                    let phoneCountry = keyVa?["phone_country"] as?  String ?? ""
                                    let pinCode = keyVa?["pin_code"] as?  String ?? ""
                                    let regMode = keyVa?["reg_mode"] as?  String ?? ""
                                    let relStatus = keyVa?["rel_status"] as?  String ?? ""
                                    let roleName = keyVa?["role_name"] as?  String ?? ""
                                    let state = keyVa?["state"] as?  String? ?? ""
                                    let unitId = keyVa?["unit_id"]  as? Int
                                    let unitNo = keyVa?["unit_no"] as? String
                                    let userId = keyVa?["user_id"] as? Int
                                    let joined_Flag = keyVa?["has_joined_to_comm"] as? Int
                                    
                                    if let gstNo_str = keyVa?["gst_no"] as? String {
                                        keyValue.append(CommunityModel(address: address, blockId: blockId, blockNm: blockNm, bloodGroup: bloodGroup, city: city, commId: commId, commName: commName, contactEmail: contactEmail, contactPhone: contactPhone, country: country, custId: custId, custName: custName, custSince: custSince, ecash: ecash, emergencyContactName: emergencyContactName, emergencyContactRelation: emergencyContactRelation, emergencyPhone: emergencyPhone, gender: gender, gstNo: gstNo_str, hobbies: hobbies, isOtherUser: isOtherUser, occupation: occupation, ownership: ownership, phoneCountry: phoneCountry, pinCode: pinCode, regMode: regMode, relStatus: relStatus, roleName: roleName, state: state, unitId: unitId, unitNo: unitNo, userId: userId, has_joined_to_comm: joined_Flag))
                                    }else if let gstNo_int = keyVa?["gst_no"] as? Int {
                                        let str = String(gstNo_int)
                                        keyValue.append(CommunityModel(address: address, blockId: blockId, blockNm: blockNm, bloodGroup: bloodGroup, city: city, commId: commId, commName: commName, contactEmail: contactEmail, contactPhone: contactPhone, country: country, custId: custId, custName: custName, custSince: custSince, ecash: ecash, emergencyContactName: emergencyContactName, emergencyContactRelation: emergencyContactRelation, emergencyPhone: emergencyPhone, gender: gender, gstNo: str, hobbies: hobbies, isOtherUser: isOtherUser, occupation: occupation, ownership: ownership, phoneCountry: phoneCountry, pinCode: pinCode, regMode: regMode, relStatus: relStatus, roleName: roleName, state: state, unitId: unitId, unitNo: unitNo, userId: userId,has_joined_to_comm: joined_Flag))
                                    }else{
                                        keyValue.append(CommunityModel(address: address, blockId: blockId, blockNm: blockNm, bloodGroup: bloodGroup, city: city, commId: commId, commName: commName, contactEmail: contactEmail, contactPhone: contactPhone, country: country, custId: custId, custName: custName, custSince: custSince, ecash: ecash, emergencyContactName: emergencyContactName, emergencyContactRelation: emergencyContactRelation, emergencyPhone: emergencyPhone, gender: gender, gstNo: "", hobbies: hobbies, isOtherUser: isOtherUser, occupation: occupation, ownership: ownership, phoneCountry: phoneCountry, pinCode: pinCode, regMode: regMode, relStatus: relStatus, roleName: roleName, state: state, unitId: unitId, unitNo: unitNo, userId: userId, has_joined_to_comm: joined_Flag))
                                    }
                                }
                            }
                            completion(keyValue, nil)
                        }
                    }else{
                        completion(nil, dataNil.wentWrong)
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
        
    }
    
    
    func getRolesByCommId(perams:[String:Any], completion: @escaping ([RoleModel]?,Error?) -> Void){
        
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.getRolesByCommId,method: .get,parameters:perams).response { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            var keyValue = [RoleModel]()
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSArray {
                                print(json)
                                for i in 0..<json.count {
                                    let keyVa = json[i] as? [String:Any]
                                    
                                    let role_id = keyVa?["role_id"] as? Int
                                    let comm_id = keyVa?["comm_id"] as? Int
                                    let role_name = keyVa?["role_name"] as? String
                                    let role_type = keyVa?["role_type"] as? String
                                    let role_desc = keyVa?["role_desc"] as? String
                                    let is_system_role = keyVa?["is_system_role"] as? Int
                                    let tot_users = keyVa?["tot_users"] as? Int
                                    keyValue.append(RoleModel(role_id: role_id, comm_id: comm_id, role_name: role_name, role_type: role_type, role_desc: role_desc, is_system_role: is_system_role, tot_users: tot_users))
                                }
                                print(keyValue)
                                completion(keyValue, nil)
                            }
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
        
    }
    
    func getBlocksByCommId(perams:[String:Any], completion: @escaping ([BlocksModel]?,Error?) -> Void){
        
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.getBlocksByCommId,method: .get,parameters:perams).response { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            var keyValue = [BlocksModel]()
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSArray {
                                print(json)
                                for i in 0..<json.count {
                                    let keyVa = json[i] as? [String:Any]
                                    let block_id = keyVa?["block_id"] as? Int
                                    let comm_id = keyVa?["comm_id"] as? Int
                                    let block_nm = keyVa?["block_nm"] as? String
                                    let floors = keyVa?["floors"]as? Int
                                    let flats = keyVa?["flats"] as? Int
                                    keyValue.append(BlocksModel(block_id: block_id, comm_id: comm_id, block_nm: block_nm, floors: floors, flats: flats))
                                }
                                print(keyValue)
                                completion(keyValue, nil)
                            }
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
        
    }
    
    
    func getUnitsByBlockId(perams:[String:Any], completion: @escaping ([UnitsModel]?,Error?) -> Void){
        
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.getUnitsByBlockId,method: .get,parameters:perams).response { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            var keyValue = [UnitsModel]()
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSArray {
                                print(json)
                                for i in 0..<json.count {
                                    let keyVa = json[i] as? [String:Any]
                                    let unit_id = keyVa?["unit_id"] as? Int
                                    let unit_no = keyVa?["unit_no"] as? String
                                    keyValue.append(UnitsModel(unit_id: unit_id, unit_no: unit_no))
                                }
                                print(keyValue)
                                completion(keyValue, nil)
                            }
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
        
    }
    
    func residentCreate(perams:[String:Any?], completion: @escaping (String?,Error?) -> Void){
        
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.residentCreate, method:.post, parameters: perams,encoding: JSONEncoding.default) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                            if let cust_id = json["cust_id"] as? Int, let user_id = json["user_id"] as? Int, let api_key = json["api_key"] as? String  {
                                UserDefaults.standard.removeObject(forKey: "topModel")
                                UserDefaults.standard.removeObject(forKey: "Index")
                                UserDefaults.cust_id = ""
                                UserDefaults.user_id = ""
                                UserDefaults.cust_id = "\(cust_id)"
                                UserDefaults.user_id =  "\(user_id)"
                                UserDefaults.ApiKey = api_key                                
                            }
                            print(UserDefaults.cust_id)
                            print(UserDefaults.user_id)
                            completion(String(decoding: data, as: UTF8.self), nil)
                        }else{
                            completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
    }
    
    func deleteTempRecor(perams:[String:Any?], completion: @escaping (String?,Error?) -> Void){
        
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.delete_record, method:.post, parameters: perams,encoding: JSONEncoding.default) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            let str = String(decoding: data, as: UTF8.self)
                            print(str)
                            completion(str, nil)
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
            
        }
        
    }
    
    func getCommByCustId(id:String, completion: @escaping ([CommuntyResultModel]?,Error?) -> Void){
        
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.getCommByUserId+"/"+id,method: .get).response { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSArray {
                            print(json)
                            var model = [CommuntyResultModel]()
                            for i in 0..<json.count {
                                let keyVa = json[i] as? [String:Any]
                                let user_id = keyVa?["user_id"] as? Int
                                let comm_id = keyVa?["comm_id"] as? Int
                                let role_id = keyVa?["role_id"] as? Int
                                let is_mc_member = keyVa?["is_mc_member"] as? Int
                                let is_other_user = keyVa?["is_other_user"] as? Int
                                let is_admin = keyVa?["is_admin"] as? Int
                                let rel_status_if_other_user = keyVa?["rel_status_if_other_user"] as? String
                                let hide_contact = keyVa?["hide_contact"] as? Int
                                let is_active = keyVa?["is_active"]  as? Int
                                let rej_reason_if_other_user = keyVa?["rej_reason_if_other_user"] as? String
                                let new_role_id = keyVa?["new_role_id"] as? Int
                                let old_role_id = keyVa?["old_role_id"] as? Int
                                let comm_name = keyVa?["comm_name"]  as? String
                                let is_tax_app = keyVa?["is_tax_app"] as? Int
                                let is_inv_class = keyVa?["is_inv_class"] as? Int
                                let gst_no = keyVa?["gst_no"] as? String
                                let tax_inv_class = keyVa?["tax_inv_class"] as? String
                                let non_tax_inv_class = keyVa?["non_tax_inv_class"] as? String
                                let country_code = keyVa?["country_code"] as? String
                                let role_name = keyVa?["role_name"] as? String
                                
                                let support_email = keyVa?["support_email"] as? String ?? ""
                                let sms_for_invite = keyVa?["sms_for_invite"] as? Int
                                let sms_for_easypass = keyVa?["sms_for_easypass"] as? Int
                                let ivr_for_visitor = keyVa?["ivr_for_visitor"] as? Int
                                
                                
                                model.append(CommuntyResultModel(comm_id: comm_id, comm_name: comm_name, country_code: country_code, gst_no: gst_no, hide_contact: hide_contact, is_active: is_active, is_admin: is_admin, is_inv_class: is_inv_class, is_mc_member: is_mc_member, is_other_user: is_other_user, is_tax_app: is_tax_app, new_role_id: new_role_id, non_tax_inv_class: non_tax_inv_class, old_role_id: old_role_id, rej_reason_if_other_user: rej_reason_if_other_user, rel_status_if_other_user: rel_status_if_other_user, role_id: role_id, role_name: role_name, tax_inv_class: tax_inv_class, user_id: user_id, support_email: support_email, sms_for_invite: sms_for_invite, sms_for_easypass: sms_for_easypass, ivr_for_visitor: ivr_for_visitor))
                                
                            }
                            completion(model, nil)
                        }else{
                            completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                        }
                    }else{
                        completion(nil, dataNil.wentWrong)
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
    }
    func getUnitsByUserId(id:String, completion: @escaping ([getUnitsByCustIdModel]?,Error?) -> Void){
        
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.getUnitsByUserId+"/"+id,method: .get).response { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSArray {
                                print(json)
                                var model = [getUnitsByCustIdModel]()
                                for i in 0..<json.count {
                                    
                                    let keyVa = json[i] as? [String:Any]
                                    let unit_id = keyVa?["unit_id"] as? Int
                                    let unit_no = keyVa?["unit_no"] as? String
                                    let comm_id = keyVa?["comm_id"] as? Int
                                    let block_id = keyVa?["block_id"] as? Int
                                    let acc_sqft = keyVa?["acc_sqft"] as? String
                                    let bhk = keyVa?["bhk"] as? String
                                    let is_vacant = keyVa?["is_vacant"] as? Int
                                    let is_rented = keyVa?["is_rented"] as? Int
                                    let spcl_cat = keyVa?["spcl_cat"] as? String
                                    let int_extn = keyVa?["int_extn"] as? String
                                    let gl_acc_id = keyVa?["gl_acc_id"] as? Int
                                    let is_billed_to_tenant = keyVa?["is_billed_to_tenant"] as? Int
                                    let cust_id = keyVa?["cust_id"] as? Int
                                    let ownership = keyVa?["ownership"] as? String
                                    let rel_status = keyVa?["rel_status"] as? String
                                    let rej_reason = keyVa?["rej_reason"] as? String
                                    let is_notif_gate_opted_out = keyVa?["is_notif_gate_opted_out"] as? Int
                                    let is_ivr_gate_opted_out = keyVa?["is_ivr_gate_opted_out"] as? Int
                                    let is_dont_disturb = keyVa?["is_dont_disturb"] as? Int
                                    let dont_disturb_from = keyVa?["dont_disturb_from"] as? String
                                    let dont_disturb_till = keyVa?["dont_disturb_till"] as? String
                                    let call_order = keyVa?["call_order"] as? String
                                    let block_nm = keyVa?["block_nm"] as? String
                                    let block_and_unit = keyVa?["block_and_unit"] as? String
                                    
                                    model.append(getUnitsByCustIdModel(unit_id: unit_id, unit_no: unit_no, comm_id: comm_id, block_id: block_id, acc_sqft: acc_sqft, bhk: bhk, is_vacant: is_vacant, is_rented: is_rented, spcl_cat: spcl_cat, int_extn: int_extn, gl_acc_id: gl_acc_id, is_billed_to_tenant: is_billed_to_tenant, cust_id: cust_id, ownership: ownership, rel_status: rel_status, rej_reason: rej_reason, is_notif_gate_opted_out: is_notif_gate_opted_out, is_ivr_gate_opted_out: is_ivr_gate_opted_out, is_dont_disturb: is_dont_disturb, dont_disturb_from: dont_disturb_from, dont_disturb_till: dont_disturb_till, call_order: call_order, block_nm: block_nm, block_and_unit: block_and_unit))
                                    
                                }
                                completion(model, nil)
                            }
                        }else{
                            completion(nil, dataNil.wentWrong)
                        }
                    }else{
                        completion(nil, dataNil.wentWrong)
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
        
    }
    
    
    func getMyVisitorByPeriodAndStatus(perams:[String:Any], completion: @escaping (TodaysVisitor?,Error?) -> Void){
        
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.getMyVisitorByPeriodAndStatus,method: .get, parameters: perams).response { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                                print(json)
                            }
                            guard let loginModel = try? JSONDecoder().decode(TodaysVisitor.self, from: data) else {
                                completion(nil, customeError(titile: "", descrition: "Something went wrong!", code: 4))
                                return
                            }
                            print(loginModel)
                            completion(loginModel, nil)
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
        
    }
    
    func getMyInvitedVisitor(perams:[String:Any], completion: @escaping (InvitedVisitorModel?,Error?) -> Void){
        
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.getMyInvitedVisitor,method: .get, parameters: perams).response { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                                print(json)
                            }
                            guard let loginModel = try? JSONDecoder().decode(InvitedVisitorModel.self, from: data) else {
                                completion(nil, customeError(titile: "", descrition: "Something went wrong!", code: 4))
                                return
                            }
                            print(loginModel)
                            completion(loginModel, nil)
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
        
    }
    
    
    func getMyEasyPassHolders(perams:[String:Any], completion: @escaping (EasyPassHolderModel?,Error?) -> Void){
        
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.getMyEasyPassHolders,method: .get, parameters: perams).response { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                                print(json)
                            }
                            guard let loginModel = try? JSONDecoder().decode(EasyPassHolderModel.self, from: data) else {
                                completion(nil, customeError(titile: "", descrition: "Something went wrong!", code: 4))
                                return
                            }
                            print(loginModel)
                            completion(loginModel, nil)
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
        
    }
    
    
    func deleteInvite(perams:[String:Any], completion: @escaping (String?,Error?) -> Void){
        
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.deleteInvite, method:.post, parameters: perams,encoding: JSONEncoding.default) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? String {
                                print(json)
                            }
                            completion("Succes", nil)
                        }
                    }
                case .failure(let erro):
                    completion(nil, erro)
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
        
    }
    
    
    func create_invite(parameters:[String:Any],completion: @escaping ([String:Any]?,Error?) -> Void){
        
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.create_invite, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                                completion(json, nil)
                            }
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
        
    }
    
    
    
    func update_invite(parameters:[String:Any],completion: @escaping ([String:Any]?,Error?) -> Void){
        
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.update_invite, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                                completion(json, nil)
                            }
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
        
    }
    
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func toBase64EncodedString(_ jsonString : String) -> String
    {
        let utf8str = jsonString.data(using: .utf8)
        
        let base64Encoded = utf8str?.base64EncodedString(options: [])
        
        return base64Encoded!
    }
    
    func myvisitor_create_pass(url:String, parameters:[String:Any], completion: @escaping ([String:Any]?,Error?) -> Void){
        
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let data = response.data {
                                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                                    print(json)
                                    completion(json, nil)
                                }
                            }
                            
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
        
    }
    
    
    func deletePass(perams:[String:Any], completion: @escaping (String?,Error?) -> Void){
        
        print(perams)
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.deletePass, method:.post, parameters: perams,encoding: JSONEncoding.default) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? String {
                                print(json)
                            }
                            completion("Succes", nil)
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
        
    }
    
    
    func getNotificationData(perams:[String:Any], completion: @escaping ([String:Any]?,Error?) -> Void){
        
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.getVisitorNotifySettingsByUnitId, method:.get, parameters: perams) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                                print(json)
                                completion(json, nil)
                            }else{
                                completion(nil, customeError.init(titile: "", descrition: "Something went wrong", code: 0))
                            }
                        }else{
                            completion(nil, customeError.init(titile: "", descrition: "Something went wrong", code: 0))
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
        
    }
    
    func registerNotification(perams:[String:Any], completion: @escaping (String?,Error?) -> Void){
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.registerNotifications, method:.post, parameters: perams,encoding: JSONEncoding.default) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? String {
                        }
                        completion("Succes", nil)
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
        
    }
    
    
    
    func approve_btn(perams:[String:Any], completion: @escaping (String?,Error?) -> Void){
        
        print(perams)
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.approveURL, method:.post, parameters: perams,encoding: JSONEncoding.default) .responseJSON { (response) in
                print(response.response)
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? String {
                                print(json)
                            }
                            completion("Succes", nil)
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
        
    }
    
    func rejectBtn(perams:[String:Any], completion: @escaping (String?,Error?) -> Void){
        
        print(perams)
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.rejectURL, method:.post, parameters: perams,encoding: JSONEncoding.default) .responseJSON { (response) in
                print(response.response)
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? String {
                                print(json)
                            }
                            completion("Succes", nil)
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
        
    }
    
    
    func testPush(perams:[String:Any], completion: @escaping (String?,Error?) -> Void){
        
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.testPush, method:.post, parameters: perams,encoding: JSONEncoding.default) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? String {
                                print(json)
                            }
                            completion("Succes", nil)
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
        
    }
    
    func  saveSettings(perams:[String:Any], completion: @escaping (String?,Error?) -> Void){
        
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.saveSettings, method:.post, parameters: perams,encoding: JSONEncoding.default) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? String {
                                print(json)
                            }
                            completion("Succes", nil)
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
            
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
        
    }
    
    func setReminder(perams:[String:Any], completion: @escaping (String?,Error?) -> Void) {
        
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.sendReminder, method:.post, parameters: perams,encoding: JSONEncoding.default) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? String {
                                print(json)
                            }else{
                                if let data = response.data {
                                    let reminder = String(decoding: data, as: UTF8.self)
                                    completion(reminder, nil)
                                }
                            }
                            completion("Succes", nil)
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
        
    }
    
    
    func
    profileByUserID(perams:[String:Any], completion: @escaping ([profileModel]?,Error?) -> Void){
        
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.profileByUserID,method: .get,parameters:perams).response { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSArray {
                                print(json)
                                var model = [profileModel]()
                                for i in 0..<json.count {
                                    guard let keyVa = json[i] as? [String:Any] else { return }
                                    
                                    let address = keyVa["address"] as? String
                                    let blood_group = keyVa["blood_group"] as? String
                                    let city = keyVa["city"] as? String
                                    let contact_email = keyVa["contact_email"] as? String
                                    let contact_phone = keyVa["contact_phone"] as? String
                                    let country = keyVa["country"] as? String
                                    let cust_id = keyVa["cust_id"] as? Int
                                    let cust_name = keyVa["cust_name"]as? String
                                    let cust_since = keyVa["cust_since"]as? String
                                    let ecash = keyVa["ecash"]as? Int
                                    let emergency_contact_name = keyVa["emergency_contact_name"]as? String
                                    let emergency_contact_relation = keyVa["emergency_contact_relation"]as? String
                                    let emergency_phone = keyVa["emergency_phone"]as? String
                                    let gender = keyVa["gender"]as? String
                                    let gst_no = keyVa["gst_no"]as? String
                                    let hobbies = keyVa["hobbies"]as? String
                                    let occupation = keyVa["occupation"]as? String
                                    let phone_country = keyVa["phone_country"]as? String
                                    let pin_code = keyVa["pin_code"]as? String
                                    let reg_mode = keyVa["reg_mode"]as? String
                                    let state = keyVa["state"]as? String
                                    let user_id = keyVa["user_id"]as? Int
                                    let country_code = keyVa["country_code"]as? String
                                    
                                    let is_admin = keyVa["is_admin"]as? Int
                                    let is_mc_member = keyVa["is_mc_member"]as? Int
                                    let avatar_url = keyVa["avatar_url"]as? String
                                    let hideContact = keyVa["hide_contact"]as? Int
                                    let roll_name = keyVa["role_name"] as? String
                                    model.append(profileModel(address: address, blood_group: blood_group, city: city, contact_email: contact_email, contact_phone: contact_phone, country: country, cust_id: cust_id, cust_name: cust_name, cust_since: cust_since, ecash: ecash, emergency_contact_name: emergency_contact_name, emergency_contact_relation: emergency_contact_relation, emergency_phone: emergency_phone, gender: gender, gst_no: gst_no, hobbies: hobbies, occupation: occupation, phone_country: phone_country, pin_code: pin_code, reg_mode: reg_mode, state: state, user_id: user_id, is_admin: is_admin, is_mc_member: is_mc_member, avatar_url: avatar_url,hideContact: hideContact, role_name: roll_name, country_code: country_code))
                                    
                                }
                                completion(model, nil)
                            }
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
            
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
        
    }
    
    func saveClicked(perams:[String:Any], completion: @escaping (String?,Error?) -> Void) {
        print(perams)
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.saveURL, method:.post, parameters: perams,encoding: JSONEncoding.default) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? String {
                                print(json)
                            }else{
                                if let data = response.data {
                                    let reminder = String(decoding: data, as: UTF8.self)
                                    completion(reminder, nil)
                                }
                            }
                            completion("Success", nil)
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
        
        
    }
    
    func getNoticeByCommId(perams:[String:Any], completion: @escaping ([noticeModel]?,Error?) -> Void){
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.notice,method: .get,parameters:perams).response { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSArray {
                                print(json)
                                var model = [noticeModel]()
                                for i in 0..<json.count {
                                    guard let keyVa = json[i] as? [String:Any] else { return }
                                    let notice_text = keyVa["notice_text"] as? String
                                    let notice_title = keyVa["notice_title"] as? String
                                    let user_id = keyVa["user_id"] as? Int
                                    let notice_status = keyVa["notice_status"] as? String
                                    let notice_id = keyVa["notice_id"] as? Int
                                    let notice_dt = keyVa["notice_dt"] as? String
                                    let is_ack = keyVa["is_ack"] as? Int
                                    let expiry_dt = keyVa["expiry_dt"] as? String
                                    let comm_id = keyVa["comm_id"] as? Int
                                    model.append(noticeModel(notice_text: notice_text, notice_title: notice_title, user_id: user_id, notice_status: notice_status, notice_id: notice_id, notice_dt: notice_dt, is_ack: is_ack, expiry_dt: expiry_dt, comm_id: comm_id))
                                }
                                
                                completion(model, nil)
                            }
                        }
                    }
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    
    
    func getNoticesByCommIdAndStatus(perams:[String:Any], completion: @escaping ([NoticeExpiredModel]?,Error?) -> Void){
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.getNoticesByCommIdAndStatus,method: .get,parameters:perams).response { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSArray {
                                print(json)
                                var model = [NoticeExpiredModel]()
                                for i in 0..<json.count {
                                    guard let keyVa = json[i] as? [String:Any] else { return }
                                    let ad_by = keyVa["ad_by"] as? String
                                    let app_by = keyVa["app_by"] as? String
                                    let app_dt = keyVa["app_dt"] as? String
                                    let cust_name = keyVa["cust_name"] as? String
                                    let is_ad = keyVa["is_ad"] as? Int
                                    let role_name = keyVa["role_name"] as? String
                                    let notice_text = keyVa["notice_text"] as? String
                                    let notice_title = keyVa["notice_title"] as? String
                                    let user_id = keyVa["user_id"] as? Int
                                    let notice_status = keyVa["notice_status"] as? String
                                    let notice_id = keyVa["notice_id"] as? Int
                                    let notice_dt = keyVa["notice_dt"] as? String
                                    let expiry_dt = keyVa["expiry_dt"] as? String
                                    let comm_id = keyVa["comm_id"] as? Int
                                    
                                    model.append(NoticeExpiredModel(ad_by: ad_by, app_by: app_by, app_dt: app_dt, comm_id: comm_id, cust_name: cust_name, expiry_dt: expiry_dt, is_ad: is_ad, notice_dt: notice_dt, notice_id: notice_id, notice_status: notice_status, notice_text: notice_text, notice_title: notice_title, role_name: role_name, user_id: user_id))
                                }
                                completion(model, nil)
                            }
                        }
                    }
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    
    func getAttachmentByNoticeId(perams:[String:Any], completion: @escaping (NSArray?,Error?) -> Void){
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.getAttachmentByNoticeId,method: .get,parameters:perams).response { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSArray {
                                completion(json, nil)
                            }
                        }}
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    func notice_create(URL:String, perams:[String:Any], completion: @escaping (String?,Error?) -> Void){
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(URL, method:.post, parameters: perams,encoding: JSONEncoding.default) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? String {
                                print(json)
                            }
                            completion("Succes", nil)
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
    }
    
    func notice_delete(perams:[String:Any], completion: @escaping (String?,Error?) -> Void){
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.notice_delete, method:.post, parameters: perams,encoding: JSONEncoding.default) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? String {
                                print(json)
                            }
                            completion("Succes", nil)
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
    }
    
    
    func notice_update(perams:[String:Any], completion: @escaping (String?,Error?) -> Void){
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.notice_update, method:.post, parameters: perams,encoding: JSONEncoding.default) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? String {
                                print(json)
                            }
                            completion("Succes", nil)
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
    }
    
    func notice_publish(perams:[String:Any], completion: @escaping (String?,Error?) -> Void){
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.notice_publish, method:.post, parameters: perams,encoding: JSONEncoding.default) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? String {
                                print(json)
                            }
                            completion("Succes", nil)
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
    }
    
    
    func getTotalNoticesByStatus(perams:[String:Any], completion: @escaping (NSArray?,Error?)-> Void){
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.getTotalNoticesByStatus, method:.get, parameters: perams) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSArray {
                                completion(json, nil)
                            }
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
    }
    
    
    func getUserCountByCommId(url_String:String, completion: @escaping (NSArray?,Error?)-> Void){
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(url_String, method:.get) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSArray {
                                completion(json, nil)
                            }
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
    }
    
    
    func getJoiningRequest(perams:[String:Any], completion: @escaping ([joingRequestModel]?,Error?)-> Void){
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.getJoiningRequest,method: .get,parameters:perams).response { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSArray {
                                print(json)
                                var model = [joingRequestModel]()
                                for i in 0..<json.count {
                                    if let data = json[i] as? [String:Any] {
                                        let address = data["address"] as? String
                                        let block_nm = data["block_nm"] as? String
                                        let blood_group = data["blood_group"] as? String
                                        let city = data["city"] as? String
                                        let comm_id = data["comm_id"] as? Int
                                        let comm_name = data["comm_name"] as? String
                                        let contact_email = data["contact_email"] as? String
                                        let contact_phone = data["contact_phone"] as? String
                                        let country = data["country"] as? String
                                        let cust_id = data["cust_id"] as? Int
                                        let cust_name = data["cust_name"] as? String
                                        let cust_since = data["cust_since"] as? String
                                        let ecash = data["ecash"] as? Int
                                        let emergency_contact_name = data["emergency_contact_name"] as? String
                                        let emergency_contact_relation = data["emergency_contact_relation"] as? String
                                        let emergency_phone = data["emergency_phone"] as? String
                                        let gender = data["gender"] as? String
                                        let hide_contact = data["hide_contact"] as? Int
                                        let hobbies = data["hobbies"] as? String
                                        let is_active = data["is_active"] as? Int
                                        let is_admin = data["is_admin"] as? Int
                                        let is_mc_member = data["is_mc_member"] as? Int
                                        let is_other_user = data["is_other_user"] as? Int
                                        let new_role_id = data["new_role_id"] as? Int
                                        let occupation = data["occupation"] as? String
                                        let old_role_id = data["old_role_id"] as? Int
                                        let ownership = data["ownership"] as? String
                                        let phone_country = data["phone_country"] as? String
                                        let pin_code = data["pin_code"] as? String
                                        let reg_mode = data["reg_mode"] as? String
                                        let rej_reason = data["rej_reason"] as? String
                                        let rej_reason_if_other_user = data["rej_reason_if_other_user"] as? Int
                                        let rel_status = data["rel_status"] as? String
                                        let rel_status_if_other_user = data["rel_status_if_other_user"] as? Int
                                        let role_id = data["role_id"] as? Int
                                        let role_name = data["role_name"] as? String
                                        let state = data["state"] as? String
                                        let unit_id = data["unit_id"] as? Int
                                        let unit_no = data["unit_no"] as? String
                                        let user_id = data["user_id"] as? Int
                                        
                                        model.append(joingRequestModel(address: address, block_nm: block_nm, blood_group: blood_group, city: city, comm_id: comm_id, comm_name: comm_name, contact_email: contact_email, contact_phone: contact_phone, country: country, cust_id: cust_id, cust_name: cust_name, cust_since: cust_since, ecash: ecash, emergency_contact_name: emergency_contact_name, emergency_contact_relation: emergency_contact_relation, emergency_phone: emergency_phone, gender: gender, hide_contact: hide_contact, hobbies: hobbies, is_active: is_active, is_admin: is_admin, is_mc_member: is_mc_member, is_other_user: is_other_user, new_role_id: new_role_id, occupation: occupation, old_role_id: old_role_id, ownership: ownership, phone_country: phone_country, pin_code: pin_code, reg_mode: reg_mode, rej_reason: rej_reason, rej_reason_if_other_user: rej_reason_if_other_user, rel_status: rel_status, rel_status_if_other_user: rel_status_if_other_user, role_id: role_id, role_name: role_name, state: state, unit_id: unit_id, unit_no: unit_no, user_id: user_id))
                                    }
                                }
                                completion(model, nil)
                            }
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
    }
    
    func ApproveReject(URL:String, perams:[String:Any], completion: @escaping (String?,Error?) -> Void){
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(URL, method:.post, parameters: perams,encoding: JSONEncoding.default) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? String {
                                print(json)
                            }
                            completion("Succes", nil)
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
    }
    
    
    func getAccBalByCustId(URL:String, perams:[String:Any], completion: @escaping (NSArray?,Error?) -> Void){
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(URL, method:.get, parameters: perams) .response { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSArray , json.count != 0 {
                            UnitDetails.shared.getAccModel = try! JSONDecoder().decode([GetAccBALByCustIDModelElement].self, from: data)
                            completion(json, nil)
                        }else{
                            completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
    }
    
    func getInvoiceForPDFByInvID(perams:[String:Any], completion: @escaping (URL?,Error?) -> Void){
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.getInvoiceForPDFByInvID, method:.get, parameters: perams) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any], let fileURL = json["file_url"] as? String {
                                let fileUrl = URL(string: EndPoint.imageURL+fileURL)
                                print(fileUrl)                                
                                completion(fileUrl, nil)
                            }
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
    }
    
    
    func getPaymentsForPDFByPayID(perams:[String:Any], completion: @escaping (URL?,Error?) -> Void){
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.getPaymentsForPDFByPayID, method:.get, parameters: perams) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any], let fileURL = json["file_url"] as? String {
                                let fileUrl = URL(string: EndPoint.imageURL+fileURL)
                                print(fileUrl)
                                completion(fileUrl, nil)
                            }
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
    }
    
    
    
    
    func getAccStmtByUnitId(perams:[String:Any], completion: @escaping (NSArray?,Error?) -> Void){
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.getAccStmtByUnitId, method:.get, parameters: perams) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSArray , json.count != 0 {
                                completion(json, nil)
                            }else{
                                completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                            }
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
    }
    
    
    func GetInvoiceByInvId(perams:[String:Any], completion: @escaping ([String:Any]?,Error?) -> Void){
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.GetInvoiceByInvId, method:.get, parameters: perams) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] , json.count != 0 {
                                completion(json, nil)
                            }else{
                                completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                            }
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
    }
    func getPaymentByPayId(perams:[String:Any], completion: @escaping ([String:Any]?,Error?) -> Void){
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(EndPoint.getPaymentByPayId, method:.get, parameters: perams) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] , json.count != 0 {
                            completion(json, nil)
                        }else{
                            completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
    }
    
    func checkUpdate(completion: @escaping ([String:Any]?,Error?) -> Void){
        if NetworkState.isConnected() {                                    
            APIManager.shared.sessionManager.request(EndPoint.getMinReqAppVersion, method:.get) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSArray , json.count != 0 {
                                for i in json {
                                    completion(i as? [String:Any], nil)
                                }
                            }else{
                                completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                            }
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
    }
    
    func getLiveVersionNumber(completion: @escaping (String?) -> Void){
        if let identifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String {
            if NetworkState.isConnected() {
                APIManager.shared.sessionManager.request( "http://itunes.apple.com/lookup?bundleId=\(identifier)", method:.get) .responseJSON { (response) in
                    switch response.result {
                    case .success(_):
                        if let data = response.data {
                            if response.response?.statusCode == 200 {
                                if let result = try? JSONDecoder().decode(LookupResult.self, from: data) , let info = result.results.first{
                                    completion(info.version)
                                }
                            }
                        }
                    case .failure(let erro):
                        if let data = response.data {
                            completion(nil)
                        }else{
                            completion(nil)
                        }
                    }
                }
            }
        }
    }
    
    func getJSONArray(URL:String,perams: [String:Any] ,completion: @escaping (NSArray?,Error?) -> Void){
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(URL, method:.get, parameters: perams) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSArray , json.count != 0 {
                                completion(json, nil)                                
                            }else{
                                completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                            }
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
    }
    
    func paymentUpload(URL:String,perams: [String:Any] ,completion: @escaping (Any?,Error?) -> Void){
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(URL, method:.post, parameters: perams, encoding: JSONEncoding.default) .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSArray , json.count != 0 {
                                completion(json, nil)
                            }else if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] , json.count != 0 {
                                completion(json, nil)
                            }else if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? String  {
                                completion(json, nil)
                            }else{
                                let string = String(decoding: data, as: UTF8.self)
                                if string.contains("Success"){
                                    completion("Success", nil)
                                }else{
                                    completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                                }
                            }
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
    }
    //Paytm
    func createPayOnline(url: String,perams: [String:Any],completion: @escaping ([String:Any]?,Error?) -> Void){
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(url, method:.post, parameters: perams, encoding: JSONEncoding.default).responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] , json.count != 0 {
                                print(json)
                                completion(json, nil)
                            }
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
    }
    
    func createInitTransAction(url: String,perams: [String:Any],completion: @escaping ([String:Any]?,Error?) -> Void){
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(url, method:.post, parameters: perams, encoding: JSONEncoding.default).responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] , json.count != 0 {
                                print(json)
                                completion(json, nil)
                            }
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 0))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
    }
    
    func Order_status(url: String,perams: [String:Any],completion: @escaping ([String:Any]?,Error?) -> Void){
        if NetworkState.isConnected() {
            APIManager.shared.sessionManager.request(url, method:.post, parameters: perams, encoding: JSONEncoding.default).responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        if response.response?.statusCode == 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] , json.count != 0 {
                                print(json)
                                completion(json, nil)
                            }
                        }
                    }
                case .failure(let erro):
                    if let data = response.data {
                        completion(nil, customeError(titile: "", descrition: String(decoding: data, as: UTF8.self), code: 10))
                    }else{
                        completion(nil, erro)
                    }
                }
            }
        }else{
            completion(nil,customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0))
        }
    }
}


//class CustomManager: Manager {
//    static public let manager = CustomManager.generateManager()
//    class func generateManager()-> CustomManager {
//        var defaultHeaders = Alamofire.Manager.defaultHTTPHeaders ?? [:]
//        defaultHeaders["x-token""] = "token"
//        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
//        configuration.HTTPAdditionalHeaders = defaultHeaders
//        let manager = CustomManager(configuration: configuration)
//        return manager
//    }
//}


class APIManager {
    
    static let shared = APIManager()
    
    
    
    
    let sessionManager: Session = {
        
        //        var af = AF.session.configuration.headers
        //        af["authorization"] = "Bearer \(UserDefaults.ApiKey+UserDefaults.user_id)"
        
        var configuration = URLSessionConfiguration.af.default//.default
        configuration.requestCachePolicy = .reloadRevalidatingCacheData
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        //        configuration.headers = af
        let responseCacher = ResponseCacher(behavior: .modify { _, response in
            let userInfo = ["date": Date()]
            return CachedURLResponse(
                response: response.response,
                data: response.data,
                userInfo: userInfo,
                storagePolicy: .allowed)
        })
        
        let networkLogger = GitNetworkLogger()
        let interceptor = GitRequestInterceptor()
        let serverTrustManager = ServerTrustManager(
            evaluators: [
                "myapp.smartility.com.my": DisabledTrustEvaluator()
            ]
        )
        
        return Session(
            configuration: configuration,
            interceptor: interceptor,
            serverTrustManager: serverTrustManager,
            cachedResponseHandler: responseCacher,
            eventMonitors: [networkLogger])
    }()
}

class GitNetworkLogger: EventMonitor {
    let queue = DispatchQueue(label: "com.raywenderlich.gitonfire.networklogger")
    
    func requestDidFinish(_ request: Request) {
        print(request.description)
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        guard let data = response.data else {
            return
        }
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
            print(json)
        }
    }
}


class GitRequestInterceptor: RequestInterceptor {
    let retryLimit = 1
    let retryDelay: TimeInterval = 0
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.setValue("Bearer \(UserDefaults.ApiKey+UserDefaults.user_id)", forHTTPHeaderField: "authorization")
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        let response = request.task?.response as? HTTPURLResponse
        //Retry for 5xx status codes
        if
            let statusCode = response?.statusCode,
            (500...599).contains(statusCode),
            request.retryCount < retryLimit {
            completion(.retryWithDelay(retryDelay))
        } else {
            return completion(.doNotRetry)
        }
    }
}
