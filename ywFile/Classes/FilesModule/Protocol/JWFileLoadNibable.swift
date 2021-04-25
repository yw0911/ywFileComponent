//
//  JWFileNib.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/12.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import Foundation
import UIKit


protocol JWFileLoadNibable {
    
}


extension JWFileLoadNibable where Self : UIView {
    
    static func loadFromNib(_ nibName: String? = nil) -> Self {
        
        let loadName = nibName == nil ? "\(self)" : nibName!
        
        return Bundle.currentBundle()?.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
    
}
