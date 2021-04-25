//
//  JWFileItemCollectionViewCell.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/3/29.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileItemGridCollectionViewCell: JWFileBaseCollectionViewCell {
    
    
    lazy var container: UIView = {
        let container = UIView()
        return container
    }()
    
    lazy var cover: UIImageView = {
        let cover = UIImageView()
        cover.contentMode = .scaleAspectFill
        cover.image = UIImage.image(JWFNamed: "file_testbg")
        cover.clipsToBounds = true
        return cover
    }()
    
    lazy var typeIcon: UIImageView = {
        let typeIcon = UIImageView()
        typeIcon.image = UIImage.image(JWFNamed: "file_PDF")
        return typeIcon
    }()
    
    lazy var fileName: UILabel = {
        let fileName = UILabel()
        fileName.jw_File_configureLabel(fontName: PFSC_R, fontSize: 15, textColor: UIColor(hexString: "666666"))
        return fileName
    }()
    
    lazy var op: UIButton = {
        let op = UIButton.init(type: .custom)
        op.setImage(UIImage.image(JWFNamed: "file_more"), for: .normal)
        return op
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubView()
        backgroundColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureSubView() {
        container.addSubview(cover)
        container.addSubview(typeIcon)
        container.addSubview(fileName)
        container.addSubview(op)
        
        cover.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(106)
        }
        
        typeIcon.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(cover.snp.bottom).offset(12)
            //            make.bottom.equalToSuperview().offset(-12)
            make.width.height.equalTo(16)
        }
        
        fileName.snp.makeConstraints { (make) in
            make.left.equalTo(typeIcon.snp.right).offset(12)
            make.centerY.equalTo(typeIcon)
        }
        
        op.snp.makeConstraints { (make) in
            make.centerY.equalTo(typeIcon)
            make.left.greaterThanOrEqualTo(fileName.snp.right)
            make.right.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureModel(model: Any) {
        if let fileModel = model as? JWFileModel {
            fileName.text = fileModel.name
            //            favourite.isHidden = !fileModel.isFavourite
            //            updateTime.text = fileModel.updated_at.toString()
        }
    }
    
}
