//
//  JWFileSearchListHeader.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/12.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileSearchListHeader: UICollectionReusableView {
    
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.jw_File_configureLabel(fontName: PFSC_L, fontSize: 14, textColor: UIColor(hexString: "999999"))
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
