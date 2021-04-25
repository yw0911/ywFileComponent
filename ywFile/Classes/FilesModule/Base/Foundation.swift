//
//  Foundation.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/1.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import Foundation

extension Int {
    
    func toString() -> String {
        return String(format: "%d", self)
    }
    
}


extension String {
    
    func classFormName<T>(type:T) -> T {
        
//        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String
        
        let namespace = Bundle.init(for: JWFileBaseViewController.self).infoDictionary!["CFBundleExecutable"] as? String
        
        let className = namespace! + "." + self
        
        let classT = NSClassFromString(className) as? T
        
        return classT!
    }
}
