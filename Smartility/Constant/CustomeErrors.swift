//
//  CustomeErrors.swift
//  Smartility
//
//  Created by Mani on 7/7/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import Foundation

struct internet_Erro {
    static let internet_erro = customeError(titile: "", descrition: "Internet not available, Cross check your internet connectivity and try again", code: 0)
}


struct dataNil {
    static let wentWrong = customeError(titile: "", descrition: "Something went wrong!", code: 4)
}

struct doesNotExist {
    static let noUser = customeError(titile: "", descrition: "User not exist with this mobile number. Please join your community before trying to login", code: 4)

}

