//
//  JWFileConfigureTableProtocol.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/2.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import Foundation

@objc protocol JWFileConfigureTableProtocol {
    
    func getReusedIndentifier(indexPath:IndexPath)->String
    func dispatchDataToCell(indexPath:IndexPath, data:Any?, cell:UITableViewCell)
    //    @objc optional func appendDataInArray(data:Array<Any>?)
    
}

@objc protocol JWFileConfigureCollectionProtocol {
    
    func getReusedIndentifier(indexPath:IndexPath)->String
    func dispatchDataToCell(indexPath:IndexPath, data:Any?, cell:UICollectionViewCell)
    //    @objc optional func appendDataInArray(data:Array<Any>?)
    
    
}


