//
//  JWFileSearchFolder.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/20.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import Foundation
import HandyJSON

struct JWFileSearchFolderListModel: HandyJSON, JWFileDeserializerProtocol {
    static func JWFileDeserializerFromJSON(json: [String : Any]?) -> JWFileSearchFolderListModel? {
        let model = JSONDeserializer<Self>.deserializeFrom(dict: json)
        return model
    }
    
    var JMSearchFolders: Array<JWFileSearchFolder>?
    
}


struct JWFileSearchFolder: HandyJSON {
    
    var folder_id: String?
    var folder_name: String?
    var parent_id: String?
    
    //MARK: 占位使用
    var category: String?
    
    
}
