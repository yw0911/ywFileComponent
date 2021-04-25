//
//  JWFileConditionHeader.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/21.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileConditionHeader: UIView {
    
    let title: UILabel = {
        let title = UILabel()
        title.jw_File_configureLabel(text: "筛选", fontName: PFSC_M, fontSize: 20, textColor: UIColor(hexString: "333333"))
        return title
    }()
    
    
    lazy var conditionCollection: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.white
        
        collection.register(JWFileConditionOptionCell.self, forCellWithReuseIdentifier: "JWFileConditionOptionCell")
        return collection
    }()
    
    var conditionItems: Array<JWFileConditionOptionItem>? {
        didSet {
            conditionCollection.reloadData()
        }
    }
    var filterOption:JWFileConditionOption = JWFileConditionOption()
    
    var didConditionSelectedIndex: Int = -1 {
        didSet {
            if didConditionSelectedIndex != oldValue {
                conditionCollection.reloadData()
            }
        }
    }
    
    var didSelectedClosure:((Int, JWFileConditionOptionItem)->Void)?
    
    
    init() {
        super.init(frame: .zero)
        
        addSubview(title)
        addSubview(conditionCollection)
        
        title.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(40)
        }
        
        conditionCollection.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(title.snp.bottom).offset(20)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


//MARK: JWFileConditionHeader UICollectionViewDataSource UICollectionViewDelegate
extension JWFileConditionHeader: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return conditionItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JWFileConditionOptionCell", for: indexPath) as! JWFileConditionOptionCell
        guard let items = conditionItems else { return cell }
        cell.configure(item: items[indexPath.row], option: filterOption, select: didConditionSelectedIndex == indexPath.row)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didConditionSelectedIndex = indexPath.row
        guard let closure = didSelectedClosure else { return }
        guard let items = conditionItems else { return }
        closure(indexPath.row, items[indexPath.row])
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (screenWidth-16*2-11*2)/3, height: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
}


//MARK: JWFileConditionOptionCell
class JWFileConditionOptionCell: UICollectionViewCell {
    
    
    let title: UILabel = {
        let title = UILabel()
        title.jw_File_configureLabel(fontName: PFSC_R, fontSize: 14, textColor: UIColor(hexString: "666666"))
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview().offset(3)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(item:JWFileConditionOptionItem, option:JWFileConditionOption, select:Bool) {
        
        title.text = item.title
        title.textColor = select ? option.state.selectedState.titleTextColor : option.state.defaultState.titleTextColor
        title.font = select ? option.state.selectedState.titleFont : option.state.defaultState.titleFont
        backgroundColor = select ? option.state.selectedState.backgroudColor : option.state.defaultState.backgroudColor
    }
    
    
}
