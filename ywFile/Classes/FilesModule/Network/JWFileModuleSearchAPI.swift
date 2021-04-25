//
//  JWFileModuleSearchAPI.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/20.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import Foundation

enum JWFileModuleSearchAPI {
    case getHistoryOfSearch(token:String) // 搜索历史
    case fileSearch(token:String, category:String, type:String, owner:Array<String>?, share_uid:String?, folder_id:String?, folder_flag:Int?, search:String?, pageno:Int, pagesize:Int) // 搜索
    case getSubDir(token:String, category:String?, folder_name:String?, folder_id:String?, pageno:Int, pagesize:Int) //获取文件夹子目录
}

extension JWFileModuleSearchAPI: RequestProtocol {

    
    
    var baseUrl: String {
        return JWNetworkingConfigureManager.default().host
        return "http://192.168.2.13:8888"
    }
    
    var path: String {
        switch self {
        case .getHistoryOfSearch: return "/api/files/search/record"
        case .fileSearch: return "/api/files/files/search"
        case .getSubDir: return "/api/files/folder/search"
            
        }
    }
    
    var method: HTTPMethod {
        switch self {
            
        case .getHistoryOfSearch, .fileSearch, .getSubDir:
            return .get
        default:
            break
        }
    }
    
    var parameter: [String : Any] {
        var para:[String:Any] = [:]
        switch self {
        case .getHistoryOfSearch(let token):
            para["access_token"] = token
        case .fileSearch(let token, let category, let type, let owner, let share_uid, let folder_id, let folder_flag, let search, let pageno, let pagesize):
            para["access_token"] = token
            para["category"] = category
            para["type"] = type
            para["owner"] = owner
            para["share_uid"] = share_uid
            para["folder_id"] = folder_id
            para["folder_flag"] = folder_flag
            para["search"] = search
            para["pageno"] = pageno
            para["pagesize"] = pagesize
            
        case .getSubDir(let token, let category, let folder_name, let folder_id, let pageno, let pagesize):
            para["access_token"] = token
            para["category"] = category
            para["folder_name"] = folder_name
            para["folder_id"] = folder_id
            para["pageno"] = pageno
            para["pagesize"] = pagesize
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
//
}
