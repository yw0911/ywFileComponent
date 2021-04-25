//
//  JWFileMetaTypeEnum.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/21.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import Foundation

enum JWFileMetaType: String {
    case FileMeta_All = "all"
    case FileMeta_Doc = "doc"
    case FileMeta_Excel = "excel"
    case FileMeta_PPT = "ppt"
    case FileMeta_Image = "image"
    case FileMeta_Video = "video"
    case FileMeta_Audio = "audio"
    case FileMeta_Zip = "zip"
    case FileMeta_PDF = "pdf"
    case FileMeta_Other = "other"
}

enum JWFileSequnce: String {
    case JWFileSeq_ASC = "asc"
    case JWFileSeq_DESC = "desc"
}

enum JWFileSort: String {
    case JWFileSort_Created_at = "created_at"
    case JWFileSort_Updated_at = "updated_at"
}

