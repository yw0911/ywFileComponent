//
//  JWFileTrashCollectionViewCell.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/6.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileTrashCollectionViewCell: JWFileBaseCollectionViewCell {
    
    lazy var exclamation: UIImageView = {
        let exclamation = UIImageView()
        exclamation.image = UIImage(named: "file_exclamation")
        return exclamation
    }()
    
    lazy var exclamationTip: UILabel = {
        let tip = UILabel()
        tip.jw_File_configureLabel(fontName: PFSC_R, fontSize: 14, textColor: UIColor(hexString: "999999"))
        //        tip.text = "移至回收站后的文件在保存 30 天后将自动删除"
        return tip
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
        
        contentView.addSubview(exclamation)
        contentView.addSubview(exclamationTip)
        exclamation.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(20)
            make.width.height.equalTo(16)
        }
        
        exclamationTip.snp.makeConstraints { (make) in
            make.left.equalTo(exclamation.snp.right).offset(10)
            make.centerY.equalTo(exclamation)
            make.right.lessThanOrEqualToSuperview().offset(-20)
        }
    }
    
    override func configureModel(model: Any) {
        
        if let tipString = model as? String {
            exclamationTip.text = tipString
        }
    }
    
}
