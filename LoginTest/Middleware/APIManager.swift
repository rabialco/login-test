//
//  APIManager.swift
//  LoginTest
//
//  Created by Rabialco Argana on 08/05/23.
//

import Foundation
import Moya

public enum APIManager {
    case login([String : Any])
    case getUsers
}

let apiManager = MoyaProvider<APIManager>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])

extension APIManager: TargetType {
    public var baseURL: URL { URL(string: "https://reqres.in/")! }
    
    public var path: String {
        switch self {
        case .login:
            return "api/login"
        case .getUsers:
            return "api/users"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .getUsers:
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .login(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getUsers:
            var params: [String: Any] = [:]
            params["page"] = "2"
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String: String]? {
        return nil
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}
