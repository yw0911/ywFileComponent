//
//  JWFileModuleLogin.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/1.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import Foundation

enum JWFileModuleLogin {
    case login(domain:String?, password:String, appsecret:String, app_ver:String, appKey:String, devicePlatform:String, email:String)
    
}

extension JWFileModuleLogin: RequestProtocol {
    
    var baseUrl: String {
        return JWNetworkingConfigureManager.default().host
        return "http://192.168.2.13:8888"
    }
    
    var path: String {
        switch self {
        case .login: return "/api2/account/login"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case.login:
            return .post
        default:
            break
        }
    }
    
    var parameter: [String : Any] {
        var para:[String:Any] = [:]
        switch self {
        case .login(let domain, let password, let appsecret, let app_ver, let appKey, let devicePlatform, let email):
            para["domain"] = domain
            para["password"] = password
            para["appsecret"] = appsecret
            para["app_ver"] = app_ver
            para["appkey"] = appKey
            para["devicePlatform"] = devicePlatform
            para["email"] = email
        default:
            break
        }
        return para
    }
    
    var header: [String : String] {
        return [:]
    }
    
//    var encoding: ParameterEncoding {
//        return URLEncoding.default
//    }
    
    
}
