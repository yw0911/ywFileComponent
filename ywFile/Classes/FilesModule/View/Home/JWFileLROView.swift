//
//  JWFileLROView.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/3/26.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileLROView: UIView {
    
    lazy var leastRecentlyOpen: UILabel = {
        let lroLabel = UILabel()
        lroLabel.jw_File_configureLabel(text: "最近打开", fontName: PFSC_M, fontSize: 18, textColor: UIColor.init(hexString: "333333"))
        
        return lroLabel
    }()
    
    
    lazy var leastRecentlyOpenList: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize.init(width: 160, height: 130)
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0)
        layout.minimumLineSpacing = 8
        //        layout.minimumInteritemSpacing = 8
        
        let listView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        listView.backgroundColor = UIColor(hexString: "F6F6F6")
        listView.delegate = self
        listView.dataSource = self
        listView.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            listView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            
        }
        
        listView.register(JWFileLRONestCollectionViewCell.self, forCellWithReuseIdentifier: "JWFileLRONestCollectionViewCell")
        return listView
    }()
    
    var source: Array<Any>? {
        willSet {
            leastRecentlyOpenList.reloadData()
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        addSubview(leastRecentlyOpen)
        addSubview(leastRecentlyOpenList)
        leastRecentlyOpen.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(20);
        }
        
        leastRecentlyOpenList.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(leastRecentlyOpen.snp.bottom).offset(16)
            make.height.equalTo(130)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension JWFileLROView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return source?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: getReusedIndentifier(indexPath: indexPath), for: indexPath)
        dispatchDataToCell(indexPath: indexPath, data: source, cell: cell)
        
        return cell
    }
    
}


extension JWFileLROView: JWFileConfigureCollectionProtocol {
    
    
    func getReusedIndentifier(indexPath: IndexPath) -> String {
        return "JWFileLRONestCollectionViewCell"
    }
    
    func dispatchDataToCell(indexPath: IndexPath, data: Any?, cell: UICollectionViewCell) {
        
        if let model = source?[indexPath.row] {
            cell.configureModel(model: model)
        }
        
    }
    
}
