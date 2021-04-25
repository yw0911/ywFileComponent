//
//  UIView.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/3/29.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import Foundation

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

func JWFileLog<T>(messgae: T, file: String = #file, method: String = #function, line: Int = #line){
    #if DEBUG
    print("\((file as NSString).lastPathComponent)[\(line)], \(method):\(messgae)")
    #endif
}

