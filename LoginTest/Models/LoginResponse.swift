//
//  LoginResponse.swift
//  LoginTest
//
//  Created by Rabialco Argana on 08/05/23.
//

import Foundation

struct LoginResponse : Decodable {
    var token: String?
}

struct LoginResponseError : Decodable {
    var error: String?
}
