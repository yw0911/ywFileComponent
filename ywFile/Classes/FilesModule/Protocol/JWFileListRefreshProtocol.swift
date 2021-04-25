//
//  JWFileListRefreshProtocol.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/21.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import Foundation


protocol JWFileListRefreshProtocol {
    
    associatedtype E
    func appendDataInArray(remoteSource:E)
    func refresh()
    func loadMore()
    func endReFresh()
}
