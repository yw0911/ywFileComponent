//
//  JWFileAllFilesHeader.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/3/29.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileAllFilesHeader: UIView,JWFileLoadNibable {
    
    
    var sortClosure:(() -> Void)?
    
    @IBAction func sort(_ sender: UIButton) {
        
        guard let closure = sortClosure else { return }
        closure()
    }
    
    @IBAction func multipleChoice(_ sender: UIButton) {
    }
}
