//
//  JWFileCollectionReusableViewHeader.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/3/29.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileCollectionReusableViewHeader: UICollectionReusableView {
    
    
    let allFiles = JWFileAllFilesHeader.loadFromNib()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(allFiles)
        allFiles.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
