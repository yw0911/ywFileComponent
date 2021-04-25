//
//  JWFileListModel.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/1.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import Foundation
import HandyJSON

struct JWFileListModel: HandyJSON, JWFileDeserializerProtocol {
    
    static func JWFileDeserializerFromJSON(json: [String : Any]?) -> JWFileListModel? {
        let model = JSONDeserializer<Self>.deserializeFrom(dict: json)
        return model
    }
    var JMFiles:[JWFileModel]?
}
