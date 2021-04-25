//
//  JWFileSearchRecord.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/12.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import Foundation
import HandyJSON

struct JWFileSearchRecord: HandyJSON, JWFileDeserializerProtocol {
    static func JWFileDeserializerFromJSON(json: [String : Any]?) -> JWFileSearchRecord? {
        let model = JSONDeserializer<Self>.deserializeFrom(dict: json)
        return model
    }
    var JMSearchRecord: Array<String>?
}


