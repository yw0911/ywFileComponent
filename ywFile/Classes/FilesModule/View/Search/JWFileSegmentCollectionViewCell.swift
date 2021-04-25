//
//  JWFileSegmentCollectionViewCell.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/12.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileSegmentCollectionViewCell: UICollectionViewCell {
    
    let title: UILabel = {
        let title = UILabel()
        return title
    }()
    
    let line: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.black
        return line
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(title)
        contentView.addSubview(line)
        
        
        title.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        line.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(3)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(item:JWFileSegmentItem, option:JWFileSegmentOption, select:Bool) {
        
        title.text = item.title
        title.textColor = select ? option.segmentStates.selectedState.titleTextColor : option.segmentStates.defaultState.titleTextColor
        title.font = select ? option.segmentStates.selectedState.titleFont : option.segmentStates.defaultState.titleFont
        line.isHidden = !select
    }
    
    
}
