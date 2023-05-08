//
//  User.swift
//  LoginTest
//
//  Created by Rabialco Argana on 08/05/23.
//

import Foundation

struct User: Codable {
    var id : Int?
    var email: String?
    var firstName: String?
    var lastName: String?
    var avatar: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar
    }
}
