//
//  JWFileShareContactCollectionViewCell.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/3/31.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileShareContactCollectionViewCell: JWFileBaseCollectionViewCell {
    
    
    lazy var shareContact: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize.init(width: 60, height: 87)
        layout.sectionInset = UIEdgeInsets.init(top: 33, left: 19, bottom: 29, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumLineSpacing = 30
        let shareContact = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        shareContact.delegate = self
        shareContact.dataSource = self
        shareContact.showsHorizontalScrollIndicator = false
        shareContact.showsVerticalScrollIndicator = false
        shareContact.register(JWFileShareContactNestCollectionViewCell.self, forCellWithReuseIdentifier: "JWFileShareContactNestCollectionViewCell")
        shareContact.backgroundColor = UIColor(hexString: "f6f6f6")
        return shareContact
    }()
    
    var source:Array<Any>?
    var didSelectedClosure:((_ collectionView:UICollectionView, _ indexPath:IndexPath, _ data:Any?)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func configureSubView() {
        
        contentView.addSubview(shareContact)
        shareContact.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureModel(model: Any) {
        
        source = model as? Array<Any>
        
        shareContact.reloadData()
    }
    
    
}


extension JWFileShareContactCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return source?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: getReusedIndentifier(indexPath: indexPath), for: indexPath)
        dispatchDataToCell(indexPath: indexPath, data: source, cell: cell)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        JWFileLog(messgae: "didSelectItemAt\(indexPath.section) - \(indexPath.row)")
        guard source != nil else { return }
        guard let closure = didSelectedClosure else { return }
        closure(collectionView, indexPath, source?[indexPath.row])
    }
    
}


extension JWFileShareContactCollectionViewCell: JWFileConfigureCollectionProtocol {
    
    func getReusedIndentifier(indexPath: IndexPath) -> String {
        return "JWFileShareContactNestCollectionViewCell"
    }
    
    func dispatchDataToCell(indexPath: IndexPath, data: Any?, cell: UICollectionViewCell) {
        
        if let model = source?[indexPath.row] {
            cell.configureModel(model: model)
        }
    }
    
}
