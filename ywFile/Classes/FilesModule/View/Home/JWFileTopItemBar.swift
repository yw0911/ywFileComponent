//
//  JWFileTopItemBar.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/3/26.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileTopItemBar: UIView {
    
    enum ItemType:Int {
        case File = 0
        case Share = 1
        case Collection = 2
        case Trash = 3
        case Unknow = -1
    }
    var isSelected = false
    var normalTextColor: UIColor = UIColor(hexString: "333333")
    var selectedTextColor: UIColor = UIColor(hexString: "333333")
    var notClearSelectedState:Bool = false
    var inset:UIEdgeInsets = .zero
    
    lazy var files: JWFileItem = {
        let files = JWFileItem.init()
        
        files.setImage(normalImage: UIImage.image(JWFNamed: "file_my"))
        files.setSelectedImage(selectedImage: UIImage.image(JWFNamed: "file_my_sel"))
        files.setTitle(normalTitle: "我的文件")
        files.setTitleTextColor(normalColor: UIColor(hexString: "333333", alpha: 0.4))
        files.setSelectedTitleTextColor(selectedColor: UIColor(hexString: "333333"))
        files.isSelected = false
        files.clickClosure = { [weak self] (item) in
            self?.reSetItems(item: item)
        }
        return files
    }()
    
    lazy var share: JWFileItem = {
        let share = JWFileItem.init()
        share.setImage(normalImage: UIImage(named: "file_shareMe"))
        share.setSelectedImage(selectedImage: UIImage(named: "file_shareMe_sel"))
        share.setTitle(normalTitle: "共享给我的")
        share.setTitleTextColor(normalColor: UIColor(hexString: "333333", alpha: 0.4))
        share.setSelectedTitleTextColor(selectedColor: UIColor(hexString: "333333"))
        share.clickClosure = { [weak self] (item) in
            self?.reSetItems(item: item)
        }
        return share
    }()
    
    lazy var collection: JWFileItem = {
        let collection = JWFileItem.init()
        collection.setImage(normalImage: UIImage(named: "file_collection"))
        collection.setSelectedImage(selectedImage: UIImage(named: "file_collection_sel"))
        collection.setTitle(normalTitle: "我的收藏")
        collection.setTitleTextColor(normalColor: UIColor(hexString: "333333", alpha: 0.4))
        collection.setSelectedTitleTextColor(selectedColor: UIColor(hexString: "333333"))
        collection.clickClosure = { [weak self] (item) in
            self?.reSetItems(item: item)
        }
        return collection
    }()
    
    lazy var trash: JWFileItem = {
        let trash = JWFileItem.init()
        trash.setImage(normalImage: UIImage(named: "file_trash"))
        trash.setSelectedImage(selectedImage: UIImage(named: "file_trash_sel"))
        trash.setTitle(normalTitle: "回收站")
        trash.setTitleTextColor(normalColor: UIColor(hexString: "333333", alpha: 0.4))
        trash.setSelectedTitleTextColor(selectedColor: UIColor(hexString: "333333"))
        trash.clickClosure = { [weak self] (item) in
            self?.reSetItems(item: item)
        }
        return trash
    }()
    
    var itemClickClosure: ((ItemType)-> Void)?
    
    private func reSetItems(item:JWFileItem) {
        var index = -1
        for element in [files, share, collection, trash] {
            index += 1
            if !notClearSelectedState {
                element.isSelected = element == item
            }
            if element == item {
                guard let closure = itemClickClosure else { return }
                closure(ItemType.init(rawValue: index)!)
            }
        }
        
    }
    
    func didSeletedWithType(type:ItemType) {
        
        for index in 0..<4 {
            [files, share, collection, trash][index].isSelected = type.rawValue == index
        }
    }
    
    init(inset:UIEdgeInsets = .zero) {
        self.inset = inset
        super.init(frame: .zero)
        
        addSubview(files)
        addSubview(share)
        addSubview(collection)
        addSubview(trash)
        
        files.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(inset.top)
            make.left.equalToSuperview().offset(inset.left)
            make.bottom.equalToSuperview().offset(inset.bottom)
            
        }
        share.snp.makeConstraints { (make) in
            make.left.equalTo(files.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(files)
        }
        
        collection.snp.makeConstraints { (make) in
            make.left.equalTo(share.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(files)
        }
        
        trash.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(inset.top)
            make.right.equalToSuperview().offset(-inset.right)
            make.bottom.equalToSuperview().offset(inset.bottom)
            make.left.equalTo(collection.snp.right)
            make.width.equalTo(files)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
