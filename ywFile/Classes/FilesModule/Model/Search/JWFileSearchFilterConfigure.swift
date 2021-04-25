//
//  JWFileSearchFilterConfigure.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/16.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import Foundation

struct JWFileSearchFilterConfigure {
    
    enum FileSpaceType: String {
        case FileSpace_Own = "my"
        case FileSpace_Share = "share"
        case FileSpace_All = "all"
        case FileSpace_unKonw = ""
    }
    
    enum EnterRoute {
        case Home
        case Share
        case Dir
    }
    
    enum FilterDimension: UInt {
        case FD_FileType
        case FD_Owner
        case FD_Position
        case FD_FileType_Owner
        case FD_FileType_Position
        case FD_All
    }
    
    var route: EnterRoute
    var dimension: FilterDimension
    var fileSpace: FileSpaceType
    
    mutating func changeFileSpace(space: FileSpaceType) {
        self.fileSpace = space
    }
    
    mutating func changeDimension(dimension: FilterDimension) {
        self.dimension = dimension
    }
    
    mutating func changeRoute(route: EnterRoute) {
        self.route = route
    }
    
}
