//
//  RequestUrl.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/1.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import Foundation
//import Alamofire


enum JWFileModuleAPI {
    case getMyFiles(token:String, sort:String?, seq:String?, type:String?, folder_id:String?, pageno:Int, pagesize:Int) // 我的文件
    case getLROFiles(token:String) //最近打开
    case getAccoutListOfshare(token:String) // 共享人list
    case getShareFiles(token:String, sort:String?, seq:String?, type:String?, folder_id:String?, pageno:Int, pagesize:Int) // 共享文件
    case getFavouriteFile(token:String, sort:String?, seq:String?, type:String?, folder_id:String?, pageno:Int, pagesize:Int) // 我的收藏
    case getTrashFile(token:String, sort:String?, seq:String?, type:String?, folder_id:String?, pageno:Int, pagesize:Int) // 回收站
    case getSubDirFile(token:String, sort:String?, seq:String?, type:String?, folder_id:String?, pageno:Int, pagesize:Int) //获取子目录
    
    
}

extension JWFileModuleAPI: RequestProtocol {
  

    var baseUrl: String {
        return JWNetworkingConfigureManager.default().host
        return "http://192.168.2.13:8888"
    }
    
    var path: String {
        switch self {
        case .getMyFiles: return "/api/files/list/my"
        case .getLROFiles: return "/api/files/list/lately"
        case .getAccoutListOfshare: return "/api/files/shared/users"
        case .getShareFiles: return "/api/files/list/share"
        case .getFavouriteFile: return "/api/files/list/favorite"
        case .getTrashFile: return "/api/files/list/recycle"
        case .getSubDirFile: return "/api/files/list/folder"
            
            
        }
    }
    
    var method: HTTPMethod {
        switch self {
            
        case .getMyFiles, .getLROFiles, .getAccoutListOfshare, .getShareFiles, .getFavouriteFile, .getTrashFile, .getSubDirFile:
            return .get
        default:
            break
        }
    }
    
    var parameter: [String : Any] {
        var para:[String:Any] = [:]
        switch self {
        case .getMyFiles(let token, let sort, let seq, let type, let folder_id, let pageno, let pagesize):
            para["access_token"] = token
            para["sort"] = sort
            para["seq"] = seq
            para["type"] = type
            para["folder_id"] = folder_id
            para["pageno"] = pageno
            para["pagesize"] = pagesize
        case .getLROFiles(let token):
            para["access_token"] = token
        case .getAccoutListOfshare(let token):
            para["access_token"] = token
        case .getShareFiles(let token, let sort, let seq, let type, let folder_id, let pageno, let pagesize):
            para["access_token"] = token
            para["sort"] = sort
            para["seq"] = seq
            para["type"] = type
            para["folder_id"] = folder_id
            para["pageno"] = pageno
            para["pagesize"] = pagesize
        case .getFavouriteFile(let token, let sort, let seq, let type, let folder_id, let pageno, let pagesize):
            para["access_token"] = token
            para["sort"] = sort
            para["seq"] = seq
            para["type"] = type
            para["folder_id"] = folder_id
            para["pageno"] = pageno
            para["pagesize"] = pagesize
        case .getTrashFile(let token, let sort, let seq, let type, let folder_id, let pageno, let pagesize):
            para["access_token"] = token
            para["sort"] = sort
            para["seq"] = seq
            para["type"] = type
            para["folder_id"] = folder_id
            para["pageno"] = pageno
            para["pagesize"] = pagesize
        case .getSubDirFile(let token, let sort, let seq, let type, let folder_id, let pageno, let pagesize):
            para["access_token"] = token
            para["sort"] = sort
            para["seq"] = seq
            para["type"] = type
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
    
}
