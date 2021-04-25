//
//  JWFileConditionTableViewCell.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/13.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileConditionTableViewCell: UITableViewCell {
    
    
    let conditionOption: UILabel = {
        let conditionOption = UILabel()
        conditionOption.jw_File_configureLabel(fontName: PFSC_R, fontSize: 16, textColor: UIColor(hexString: "333333"))
        return conditionOption
    }()
    
    let condition: UILabel = {
        let condition = UILabel()
        condition.jw_File_configureLabel(fontName: PFSC_R, fontSize: 16, textColor: UIColor(hexString: "666666"))
        return condition
    }()
    
    let indicator: UIImageView = {
        let indicator = UIImageView()
        indicator.image = UIImage(named: "file_indicator")
        return indicator
    }()
    
    let separator:UIView = {
        let separator = UIView()
        return separator
    }()
    
    
    let entries: JWFileConditionEntriesView = {
        let entries = JWFileConditionEntriesView()
        entries.backgroundColor = UIColor.black
        entries.setCornerRadius(radius: 14)
        
        return entries
    }()
    
    var clearOwnerEntriesClosure:((JWFileConditionTableViewCell)->Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(conditionOption)
        contentView.addSubview(condition)
        contentView.addSubview(indicator)
        contentView.addSubview(separator)
        contentView.addSubview(entries)
        
        conditionOption.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
        }
        
        condition.snp.makeConstraints { (make) in
            make.left.greaterThanOrEqualTo(conditionOption.snp.right).offset(5)
            make.right.equalTo(indicator.snp.left).offset(-10)
            make.centerY.equalTo(conditionOption)
        }
        
        indicator.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(conditionOption)
        }
        
        separator.snp.makeConstraints { (make) in
            make.top.equalTo(conditionOption.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        entries.snp.makeConstraints { (make) in
            make.right.equalTo(indicator.snp.left).offset(-10)
            make.centerY.equalTo(conditionOption)
            make.height.equalTo(27)
        }
        
        entries.clearOwnerEntriesClosure = { [weak self] in
            
            guard let closure = self?.clearOwnerEntriesClosure else { return }
            closure(self!)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(item:JWFileFilterPositionOrOwnerItem) {
        entries.title.text = nil
        condition.text = nil
        conditionOption.text = item.title
        condition.text = item.placeHolder
        separator.backgroundColor = UIColor(hexString: "e7e7e7")
        
        if item.type == .Owner && item.entries != nil {
            
            entries.title.text = item.entries as? String
        } else if item.type == .Position && item.entries != nil {
            if let folder = item.entries as? JWFileSearchFolder {
                condition.text = folder.folder_name
            } else {
                condition.text = item.entries as? String
            }
        }
        
        entries.isHidden = item.entries == nil || item.type == .Position
        
    }
    
    
}
