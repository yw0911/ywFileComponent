//
//  JWFileShareContactNestCollectionViewCell.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/3/31.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileShareContactNestCollectionViewCell: JWFileBaseCollectionViewCell {
    
    lazy var avatar: UIImageView = {
        let avatar = UIImageView()
        avatar.contentMode = .scaleAspectFit
        avatar.setCornerRadius(radius: 30)
        avatar.backgroundColor = UIColor.orange
        return avatar
    }()
    
    lazy var name: UILabel = {
        let name = UILabel()
        name.jw_File_configureLabel(fontName: PFSC_R, fontSize: 12, textColor: UIColor(hexString: "666666"))
        return name
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureSubView() {
        contentView.addSubview(avatar)
        contentView.addSubview(name)
        
        avatar.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        name.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview().offset(0)
            make.top.equalTo(avatar.snp.bottom).offset(10)
        }
        
    }
    
    override func configureModel(model: Any) {
        if let contact = model as? JWFileContactOfShare {
            
            name.text = contact.name
        }
    }
    
}
