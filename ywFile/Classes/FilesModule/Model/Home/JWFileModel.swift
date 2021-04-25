//
//  FileModel.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/3/29.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import Foundation
import HandyJSON

struct JWFileModel: HandyJSON, JWFileDeserializerProtocol {
    static func JWFileDeserializerFromJSON(json: [String : Any]?) -> JWFileModel? {
        let model = JSONDeserializer<Self>.deserializeFrom(dict: json)
        return model
    }
    
    enum JWFileType:String, HandyJSONEnum {
        case Dir = "jw_n_folder"
        case File = "jw_n_file"
    }
    
    var id: String?
    var file_type: JWFileType?
    var name: String?
    var lock_flag: Int = -1
    var favorate_flag: Int = -1
    var share_flag: Int = -1
    var owner_id: String?
    var file_size: String?
    var icon: String?
    var user: JWFileUser?
    var auth: JWFileAuth?
    var user_role:Int = -1
    var created_at:Int = -1
    var updated_at:Int = -1
    
}

struct JWFileUser: HandyJSON, JWFileDeserializerProtocol {
    
    static func JWFileDeserializerFromJSON(json: [String : Any]?) -> JWFileUser? {
        let model = JSONDeserializer<Self>.deserializeFrom(dict: json)
        return model
    }
    var id: String?
    var name: String?
    var avatar: JWFileAvatar?
}

struct JWFileAvatar: HandyJSON {
    var avatar_l: String?
    var avatar_s: String?
}

struct JWFileAuth: HandyJSON {
    var allow_download:Int?
    var allow_share_in:Int?
    var allow_share_out:Int?
    var allow_share_out_link:Int?
    var allow_delete:Int?
    var allow_create_copy:Int?
    var allow_move:Int?
    var allow_copy_link:Int?
    var allow_set_share:Int?
    var allow_rename:Int?
    var allow_add_description:Int?
    var allow_add_tag:Int?
    var allow_comment:Int?
    var allow_manage_share_objs:Int?
    
}








