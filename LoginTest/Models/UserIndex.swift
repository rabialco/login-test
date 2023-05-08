//
//  UserIndex.swift
//  LoginTest
//
//  Created by Rabialco Argana on 08/05/23.
//

import Foundation

struct UserIndex: Codable {
    let page: Int?
    let perPage: Int?
    let total: Int?
    let totalPages: Int?
    let data: [User]?
    
    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case total
        case totalPages = "total_pages"
        case data
    }
}
