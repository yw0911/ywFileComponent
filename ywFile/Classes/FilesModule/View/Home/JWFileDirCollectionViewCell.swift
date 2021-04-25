//
//  JWFileDirCollectionViewCell.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/3/26.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit
import SnapKit

class JWFileDirCollectionViewCell: JWFileBaseCollectionViewCell {
    
    lazy var dirImage: UIImageView = {
        let dirImage = UIImageView()
        dirImage.image = UIImage.image(JWFNamed: "file_dir")
        return dirImage
    }()
    lazy var dirName: UILabel = {
        let dirName = UILabel()
        dirName.jw_File_configureLabel(fontName: PFSC_R, fontSize: 15, textColor: UIColor(hexString: "666666"))
        
        return dirName
    }()
    lazy var op: UIButton = {
        let op = UIButton.init(type: .custom)
        op.setImage(UIImage.image(JWFNamed: "file_more"), for: .normal)
        return op
    }()
    
    lazy var favourite: UIImageView = {
        let favourite = UIImageView()
        favourite.image = UIImage.image(JWFNamed: "file_collection_s")
        return favourite
    }()
    
    lazy var updateTime: UILabel = {
        let updateTime = UILabel()
        updateTime.jw_File_configureLabel(fontName: PFSC_R, fontSize: 12, textColor: UIColor(hexString: "999999"))
        return updateTime
    }()
    
    
    var isGridLayout:Bool = true {
        willSet{
            print(newValue)
            reLayoutSubView(isGrid: newValue)
        }
        didSet{
            print(oldValue)
            
        }
    }
    
    
    var inset:UIEdgeInsets = .zero {
        willSet {
            updateInset(inset: newValue)
        }
    }
    
    var hightlightChar:String?
    
    var dirNameTopConstraint:Constraint!
    var dirNameCenterYConstraint:Constraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSubView()
        backgroundColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureSubView() {
        
        contentView.addSubview(dirImage)
        contentView.addSubview(dirName)
        contentView.addSubview(op)
        contentView.addSubview(favourite)
        contentView.addSubview(updateTime)
        
        dirImage.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(22)
            make.height.equalTo(18)
        }
        
        dirName.snp.makeConstraints { (make) in
            make.left.equalTo(dirImage.snp.right).offset(12)
            dirNameTopConstraint = make.top.equalToSuperview().offset(11).constraint
            dirNameCenterYConstraint = make.centerY.equalToSuperview().constraint
            make.right.lessThanOrEqualTo(op.snp.left).offset(-5)
            dirNameTopConstraint.deactivate()
        }
        
        op.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.width.height.equalTo(15)
            make.centerY.equalToSuperview()
        }
        favourite.isHidden = isGridLayout
        favourite.snp.makeConstraints { (make) in
            make.left.equalTo(dirName)
            make.top.equalTo(dirName.snp.bottom).offset(3)
            make.width.equalTo(12)
            make.height.equalTo(11)
        }
        updateTime.isHidden = isGridLayout
        updateTime.snp.makeConstraints { (make) in
            make.left.equalTo(favourite.snp.right).offset(8)
            make.top.equalTo(dirName.snp.bottom)
            make.right.lessThanOrEqualTo(op.snp.left).offset(-5)
        }
    }
    
    
    func reLayoutSubView(isGrid:Bool) {
        
        if isGrid {
            dirNameTopConstraint.deactivate()
            dirNameCenterYConstraint.activate()
        } else {
            dirNameTopConstraint.activate()
            dirNameCenterYConstraint.deactivate()
        }
        
        favourite.isHidden = isGrid
        updateTime.isHidden = isGrid
    }
    
    func updateInset(inset:UIEdgeInsets)  {
        
        dirImage.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(inset.left)
        }
        
        op.snp.updateConstraints { (make) in
            make.right.equalToSuperview().offset(-inset.right)
        }
        
    }
    
    
    override func configureModel(model: Any) {
        if let fileModel = model as? JWFileModel {
            dirName.text = fileModel.name
            //            favourite.isHidden = (fileModel.favorate_flag == 1)
            updateTime.text = fileModel.updated_at.toString()
            
            guard let content = fileModel.name, hightlightChar != nil else { return }
            
            guard let attributeString = locateHightLightCharOfIndex(from: content, keyWord: hightlightChar!) else {
                dirName.attributedText = nil
                return }
            dirName.attributedText = attributeString
        }
    }
    
    
    func locateHightLightCharOfIndex(from content:String, keyWord:String) -> NSAttributedString? {
        
        if content.contains(keyWord) {
            
            let index = content.range(of: keyWord)!
            let startIndex = content.distance(from: content.startIndex, to: index.lowerBound)
            let attributeString = NSMutableAttributedString.init(string: content)
            attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: "157efb") as Any, range: NSMakeRange(startIndex, keyWord.count))
            attributeString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: PFSC_R, size: 15) as Any, range: NSMakeRange(startIndex, keyWord.count))
            return (attributeString.copy() as! NSAttributedString)
        } else {
            
            return NSAttributedString(string: content, attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "666666") as Any, NSAttributedString.Key.font : UIFont(name: PFSC_R, size: 15) as Any])
        }
        
    }
    
}
