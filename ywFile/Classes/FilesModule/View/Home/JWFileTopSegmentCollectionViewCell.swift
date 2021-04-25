//
//  JWFileTopSegmentCollectionViewCell.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/3/29.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileTopSegmentCollectionViewCell: JWFileBaseCollectionViewCell {
    
    lazy var segmentBar: JWFileTopItemBar = {
        let segmentBar = JWFileTopItemBar()
        segmentBar.notClearSelectedState = true
        
        //        segmentBar.itemClickClosure = {(type) in
        //            print("item type is \(type.rawValue)")
        //        }
        
        return segmentBar
    }()
    
    var segmentItemClickClosure: ((JWFileTopItemBar.ItemType)-> Void)? {
        willSet {
            segmentBar.itemClickClosure = newValue
        }
    }
    
    var currentItemType:JWFileTopItemBar.ItemType = .File {
        willSet{
            //            segmentBar.didSeletedWithType(type: newValue)
            switch newValue {
            case .File:
                segmentBar.files.isSelected = true
            case .Share:
                segmentBar.share.isSelected = true
            case .Collection:
                segmentBar.collection.isSelected = true
            case .Trash:
                segmentBar.trash.isSelected = true
            case .Unknow:
                break
            }
            
        }
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        configureSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureSubView() {
        contentView.addSubview(segmentBar)
        segmentBar.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    
}
