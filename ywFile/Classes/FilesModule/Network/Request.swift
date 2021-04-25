//
//  Request.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/1.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import Foundation
//import Alamofire
import HandyJSON

public protocol RequestProtocol {
    
    var baseUrl:String { get }
    var path:String { get }
    var method:HTTPMethod { get }
    var parameter:[String:Any] { get }
    var header:[String:String] { get }
    //    var encoding:ParameterEncoding { get }
}






public let SessionManager = JWFileSessionManager()

public class JWFileSessionManager {
    typealias Parameters = [String:Any]
    public enum ResponeStatus {
        case success
        case fail
    }
    
    typealias Method = HTTPMethod
    
    private var _manager:JWInternalAPIManager!
    init() {
        
    }
    
    /**
     //    private func request<M:JWFileDeserializerProtocol>(baseUrl:String, relativeUrl:String, method:Method, encoding:ParameterEncoding = URLEncoding.default, parameters:Parameters, header:[String:String], completionHandler:((_ respone: (statusCode:Int, data:M?)) -> Void)?) {
     //
     //        let url = baseUrl + relativeUrl
     //        var encoding:Alamofire.ParameterEncoding = encoding
     //        switch method {
     //        case .get:
     //            break
     //        case .post:
     //            break
     //            encoding = JSONEncoding.default
     //            break
     //        default:
     //            break
     //        }
     //
     //        var headers: HTTPHeaders = []
     //        for (k, v) in header {
     //            headers.add(name: k, value: v)
     //        }
     //
     //
     //        let request = _manager.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers, interceptor: nil, requestModifier: {$0.timeoutInterval = 20})
     //
     //        request.responseData { (respone) in
     //
     //            print(respone)
     //            guard let completion = completionHandler else {
     //                return
     //            }
     //
     //            guard let data = respone.data else {
     //                completion((respone.response?.statusCode ?? -1, nil))
     //                return
     //            }
     //            let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
     //            let model = M.JWFileDeserializerFromJSON(json: jsonObj as? [String : Any])
     //            completion((respone.response!.statusCode, model))
     //
     //        }
     //
     //
     //    }
     
     */
    private func request<M:JWFileDeserializerProtocol>(baseUrl:String, relativeUrl:String, method:Method, parameters:Parameters, header:[String:String], completionHandler:((_ respone: (statusCode:ResponeStatus, data:M?)) -> Void)?) {
        
        let url = relativeUrl
        
        var requestType: CTAPIManagerRequestType = .get
        switch method {
        case .get:
            break
        case .post:
            requestType = .post
        default:
            break
        }
        
        JWInternalAPIManager.init(requestUrl: url, type: requestType, params: parameters).loadDataWithoutCacheWithCompletionBlock(success: { (apimanager) in
            self.dealWithRespone(apiManager: apimanager as! JWInternalAPIManager, statusCode: .success, completionHandler: completionHandler)
        }) { (apimanager) in
            self.dealWithRespone(apiManager: apimanager as! JWInternalAPIManager, statusCode: .success, completionHandler: completionHandler)
        }
        
    }
    
    
    
    
    func dealWithRespone<M:JWFileDeserializerProtocol>(apiManager:JWInternalAPIManager, statusCode:ResponeStatus, completionHandler:((_ respone: (statusCode:ResponeStatus, data:M?)) -> Void)?) {
        
        
        guard let completion = completionHandler else {
            return
        }
        
        guard let data = apiManager.response.responseData else {
            completion((statusCode, nil))
            return
        }
        
        let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        let model = M.JWFileDeserializerFromJSON(json: jsonObj as? [String : Any])
        completion((statusCode, model))
        
        
        
    }
    
}

extension JWFileSessionManager {
    
    
    public func request<API:RequestProtocol, M:JWFileDeserializerProtocol>(api:API, serializeClass:M.Type, completionHandler:((_ respone:(statusCode:ResponeStatus, data:M?)) -> Void)?) {
        
        request(baseUrl:api.baseUrl, relativeUrl: api.path, method: api.method, parameters: api.parameter, header: api.header, completionHandler: completionHandler)
    }
    
}
