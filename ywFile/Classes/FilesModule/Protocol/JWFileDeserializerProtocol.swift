//
//  JWFileDeserializerProtocol.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/1.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import Foundation
import HandyJSON
public protocol JWFileDeserializerProtocol {
    
    static func JWFileDeserializerFromJSON(json:[String:Any]?) -> Self?
}


