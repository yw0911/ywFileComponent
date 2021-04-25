//
//  JWFileItemCollectionViewCell.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/3/29.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileItemCollectionViewCell: JWFileBaseCollectionViewCell {
    
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
    
    lazy var share: UIImageView = {
        let share = UIImageView()
        share.image = UIImage.image(JWFNamed: "file_shareMe_s")
        return share
    }()
    
    lazy var favourite: UIImageView = {
        let favourite = UIImageView()
        favourite.image = UIImage.image(JWFNamed: "file_collection_s")
        return favourite
    }()
    
    lazy var fileName: UILabel = {
        let fileName = UILabel()
        fileName.jw_File_configureLabel(fontName: PFSC_R, fontSize: 15, textColor: UIColor(hexString: "666666"))
        return fileName
    }()
    
    lazy var updateTime: UILabel = {
        let updateTime = UILabel()
        updateTime.jw_File_configureLabel(fontName: PFSC_R, fontSize: 12, textColor: UIColor(hexString: "999999"))
        updateTime.text = "2020.01.12 10:30 更新"
        return updateTime
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
    
    var inset:UIEdgeInsets = .zero {
        willSet {
            updateInset(inset: newValue)
        }
    }
    var hightlightChar:String?
    
    
    override func configureSubView() {
        container.addSubview(cover)
        container.addSubview(fileName)
        container.addSubview(share)
        container.addSubview(favourite)
        container.addSubview(updateTime)
        container.addSubview(op)
        
        cover.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        fileName.snp.makeConstraints { (make) in
            make.left.equalTo(cover.snp.right).offset(17)
            make.top.equalToSuperview().offset(11)
            make.right.lessThanOrEqualTo(op.snp.left).offset(-5)
        }
        
        share.snp.makeConstraints { (make) in
            make.left.equalTo(fileName)
            make.top.equalTo(fileName.snp.bottom).offset(4)
            make.width.equalTo(16)
            make.height.equalTo(10)
        }
        
        favourite.snp.makeConstraints { (make) in
            make.left.equalTo(share.snp.right).offset(8)
            make.top.equalTo(fileName.snp.bottom).offset(3)
            make.width.height.equalTo(12)
        }
        
        updateTime.snp.makeConstraints { (make) in
            make.left.equalTo(favourite.snp.right).offset(8)
            make.top.equalTo(fileName.snp.bottom)
            make.right.lessThanOrEqualTo(op.snp.left).offset(-5)
        }
        
        op.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(15)
            make.right.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func updateInset(inset:UIEdgeInsets)  {
        
        cover.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(inset.left)
        }
        
        op.snp.updateConstraints { (make) in
            make.right.equalToSuperview().offset(-inset.right)
        }
        
    }
    
    
    
    override func configureModel(model: Any) {
        if let fileModel = model as? JWFileModel {
            fileName.text = fileModel.name
            //            favourite.isHidden = !fileModel.favorate_flag
            //            share.isHidden = !fileModel.share_flag
            updateTime.text = fileModel.updated_at.toString()
            
            guard let content = fileModel.name, hightlightChar != nil else { return }
            
            guard let attributeString = locateHightLightCharOfIndex(from: content, keyWord: hightlightChar!) else {
                fileName.attributedText = nil
                return }
            fileName.attributedText = attributeString
            
        }
    }
    
    
    func locateHightLightCharOfIndex(from content:String, keyWord:String) -> NSAttributedString? {
        
        if content.contains(keyWord) {
            
            let index = content.range(of: keyWord)!
            let startIndex = content.distance(from: content.startIndex, to: index.lowerBound)
            
            //            UIColor(hexString: "666666")
            let attributeString = NSMutableAttributedString.init(string: content)
            attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSMakeRange(startIndex, keyWord.count))
            return (attributeString.copy() as! NSAttributedString)
        } else {
            
            return NSAttributedString(string: content, attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "666666") as Any, NSAttributedString.Key.font : UIFont(name: PFSC_R, size: 15) as Any])
        }
        
    }
    
    
    
    
}
