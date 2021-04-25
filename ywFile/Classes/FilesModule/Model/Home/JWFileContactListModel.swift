//
//  JWFileContactList.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/2.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import Foundation
import HandyJSON

struct JWFileContactList: HandyJSON, JWFileDeserializerProtocol {
    
    static func JWFileDeserializerFromJSON(json: [String : Any]?) -> JWFileContactList? {
        let model = JSONDeserializer<Self>.deserializeFrom(dict: json)
        return model
    }
    
    var JMSharedUsers: Array<JWFileContactOfShare>?
}


struct JWFileContactOfShare: HandyJSON, JWFileDeserializerProtocol {
    
    static func JWFileDeserializerFromJSON(json: [String : Any]?) -> JWFileContactOfShare? {
        let model = JSONDeserializer<Self>.deserializeFrom(dict: json)
        return model
    }
    
    var id: String?
    var name: String?
    var alias: String?
    var email: String?
    var avatar: JWFileAvatar?
}



