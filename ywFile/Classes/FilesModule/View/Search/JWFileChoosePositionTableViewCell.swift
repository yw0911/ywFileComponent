//
//  JWFileChoosePositionTableViewCell.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/20.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileChoosePositionTableViewCell: UITableViewCell {
    
    let dirIcon: UIImageView = {
        let dirIcon = UIImageView()
        dirIcon.image = UIImage(named: "file_dir")
        return dirIcon
    }()
    
    
    let dirName: UILabel = {
        let dirName = UILabel()
        dirName.jw_File_configureLabel(fontName: PFSC_R, fontSize: 16, textColor: UIColor(hexString: "666666"))
        return dirName
    }()
    
    var hightlightChar:String?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func configureSubView() {
        
        contentView.addSubview(dirIcon)
        contentView.addSubview(dirName)
        
        dirIcon.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        
        dirName.snp.makeConstraints { (make) in
            make.left.equalTo(dirIcon.snp.right).offset(30)
            make.centerY.equalTo(dirIcon)
            make.right.lessThanOrEqualToSuperview().offset(-5)
        }
    }
    
    
    override func configureModel(model: Any) {
        
        
        if let name = model as? JWFileSearchPlaceHolder {
            dirName.text = name.dirName
        } else if let dirModel = model as? JWFileSearchFolder {
            dirName.text = dirModel.folder_name
            
            guard let content = dirModel.folder_name, hightlightChar != nil else { return }
            
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
            attributeString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: PFSC_R, size: 16) as Any, range: NSMakeRange(startIndex, keyWord.count))
            return (attributeString.copy() as! NSAttributedString)
        } else {
            
            return NSAttributedString(string: content, attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "666666") as Any, NSAttributedString.Key.font : UIFont(name: PFSC_R, size: 16) as Any])
        }
        
    }
    
}
