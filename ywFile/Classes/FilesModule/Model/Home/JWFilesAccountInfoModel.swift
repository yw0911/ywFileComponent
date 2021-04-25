//
//  JWFilesAccountInfoModel.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/1.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import Foundation
import HandyJSON

struct JWFilesAccountInfoModel: HandyJSON, JWFileDeserializerProtocol {
    
    var JMStatus:JWFileAccountStatus?
    
    static func JWFileDeserializerFromJSON(json: [String : Any]?) -> JWFilesAccountInfoModel? {
        let model = JSONDeserializer<Self>.deserializeFrom(dict: json)
        return model
    }
}

struct JWFileAccountStatus: HandyJSON, JWFileDeserializerProtocol {
    
    var access_token: String?
    
    static func JWFileDeserializerFromJSON(json: [String : Any]?) -> JWFileAccountStatus? {
        let model = JSONDeserializer<Self>.deserializeFrom(dict: json)
        return model
    }
}
