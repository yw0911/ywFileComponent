//
//  Bundle.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/3/29.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import Foundation

extension Bundle {
    
        static func currentBundle() -> Bundle? {
            
            guard var path = Bundle(for: JWFileBaseViewController.self).resourcePath else { return nil }
            path.append(contentsOf: "/\(Bundle(for: JWFileBaseViewController.self).infoDictionary?["CFBundleExecutable"] as! String).bundle")
            return Bundle(path: path)
        }
    
}
