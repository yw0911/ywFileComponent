//
//  JWFileSegment.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/12.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileSegment: UIView {
    
    lazy var segmentCollection: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.white
        
        collection.register(JWFileSegmentCollectionViewCell.self, forCellWithReuseIdentifier: "JWFileSegmentCollectionViewCell")
        return collection
    }()
    
    init() {
        super.init(frame: .zero)
        addSubview(segmentCollection)
        segmentCollection.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var _items: Array<JWFileSegmentItem>?
    var items:Array<JWFileSegmentItem>? {
        
        willSet {
            _items = newValue
            segmentCollection.reloadData()
        }
    }
    
    var segmentOption:JWFileSegmentOption = JWFileSegmentOption()
    var didSegmentSelectedIndex: Int = -1 {
        didSet {
            if didSegmentSelectedIndex != oldValue {
                segmentCollection.reloadData()
                segmentCollection.selectItem(at: IndexPath(item: didSegmentSelectedIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            }
        }
    }
    
    var segmentDidSelectedClosure: ((Int)->Void)?
}


extension JWFileSegment: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JWFileSegmentCollectionViewCell", for: indexPath) as! JWFileSegmentCollectionViewCell
        cell.configure(item: _items![indexPath.row], option: segmentOption, select: indexPath.row == didSegmentSelectedIndex)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSegmentSelectedIndex = indexPath.row
        guard let closure = segmentDidSelectedClosure else { return }
        closure(indexPath.row)
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let element = _items?[indexPath.row] else {
            return .zero
        }
        
        let label = UILabel()
        label.text = element.title
        label.sizeToFit()
        return CGSize(width: label.bounds.width, height: segmentCollection.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
}


struct JWFileSegmentItem {
    
    var title:String
    
}

struct JWFileSegmentState {
    var titleFont: UIFont
    var titleTextColor: UIColor
    init(titleFont: UIFont = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize), titleTextColor:UIColor = .black) {
        
        self.titleFont = titleFont
        self.titleTextColor = titleTextColor
    }
}

typealias JWFileSegmentStates = (defaultState:JWFileSegmentState, selectedState:JWFileSegmentState)

struct JWFileSegmentOption {
    
    var segmentStates:JWFileSegmentStates
    
    init(segmentStates:JWFileSegmentStates = JWFileSegmentStates(defaultState:JWFileSegmentState(), selectedState:JWFileSegmentState())) {
        
        self.segmentStates = segmentStates
    }
}



