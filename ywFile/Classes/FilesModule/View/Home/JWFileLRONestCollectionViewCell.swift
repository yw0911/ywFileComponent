//
//  JWFileLROCollectionViewCell.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/3/26.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileLRONestCollectionViewCell: JWFileBaseCollectionViewCell {
    
    
    lazy var container = UIView()
    lazy var cover: UIImageView = {
        let cover = UIImageView()
        cover.contentMode = .scaleAspectFill
        cover.image = UIImage.image(JWFNamed: "file_testbg")
        cover.clipsToBounds = true
        return cover
    }()
    lazy var fileTypeIcon: UIImageView = {
        let typeIcon = UIImageView()
        typeIcon.image = UIImage.image(JWFNamed: "file_PDF")
        return typeIcon
    }()
    lazy var fileNameLabel: UILabel = {
        let fileNameLabel = UILabel();
        fileNameLabel.jw_File_configureLabel(fontName: PFSC_L, fontSize: 13, textColor: UIColor(hexString: "494949"))
        return fileNameLabel
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureSubView() {
        container.addSubview(cover)
        container.addSubview(fileTypeIcon)
        container.addSubview(fileNameLabel)
        cover.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(90)
        }
        
        fileTypeIcon.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(11)
            make.top.equalTo(cover.snp.bottom).offset(12)
            make.width.height.equalTo(16)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        fileNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(fileTypeIcon)
            make.left.equalTo(fileTypeIcon.snp.right).offset(7)
            make.right.equalToSuperview().offset(-11)
            
        }
        
        contentView.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        container.backgroundColor = UIColor.black
    }
    
    
}
