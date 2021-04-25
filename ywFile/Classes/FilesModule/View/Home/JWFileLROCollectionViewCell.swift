//
//  JWFileLROCollectionViewCell.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/3/29.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileLROCollectionViewCell: JWFileBaseCollectionViewCell {
    
    lazy var lroView: JWFileLROView = {
        let lroView = JWFileLROView()
        return lroView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubView()
        backgroundColor = UIColor(hexString: "f6f6f6")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureSubView() {
        
        contentView.addSubview(lroView)
        lroView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureModel(model: Any) {
        
        lroView.source = model as? Array<Any>
    }
}
