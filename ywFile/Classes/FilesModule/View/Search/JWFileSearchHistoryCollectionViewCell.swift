//
//  JWFileSearchHistoryCollectionViewCell.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/12.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileSearchHistoryCollectionViewCell: JWFileBaseCollectionViewCell {
    
    
    let icon: UIImageView = {
        let icon = UIImageView(image: UIImage(named: "file_history"))
        return icon
    }()
    
    let content: UILabel = {
        let content = UILabel()
        content.jw_File_configureLabel(fontName: PFSC_R, fontSize: 16, textColor: UIColor(hexString: "333333"))
        return content
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func configureSubView() {
        
        contentView.addSubview(icon)
        contentView.addSubview(content)
        
        icon.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        content.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(16)
            make.centerY.equalTo(icon)
            make.right.lessThanOrEqualToSuperview().offset(-15)
        }
    }
    
    override func configureModel(model: Any) {
        if model is String {
            content.text = (model as! String)
        }
    }
    
}
