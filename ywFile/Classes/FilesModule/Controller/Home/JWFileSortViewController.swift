//
//  JWFileSortViewController.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/21.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileSortViewController: JWFileBaseViewController {

    lazy var sortView: JWFileSortView = {
        let sortView = JWFileSortView()
        sortView.backgroundColor = UIColor.white
        sortView.bottomDetermineClickClosure = {[weak self] in
            self?.presentingViewController?.dismiss(animated: true, completion: nil)
            guard let closure = self?.determineClosure else { return }
            guard let fileMetaTypeItems = self?.sortView.sortConditionItems else { return }
            let currentType = fileMetaTypeItems[sortView.didFileTypeSelectedIndex].fileType
            let currentSort = self!.sortView.sortOfTimeItems![sortView.didSortSelectedIndex].sort
            var sortOption = JWFileSortOption.init(sort: currentSort , seq: .JWFileSeq_DESC, type: currentType)
            
            closure(sortOption)
        }
        return sortView
    }()
    
    var determineClosure: ((JWFileSortOption)-> Void)?
    var sortOption: JWFileSortOption = .init(sort: .JWFileSort_Updated_at, seq: .JWFileSeq_DESC, type: .FileMeta_All)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        configureSubView()
        sortView.sortConditionItems = generateSortOptionItems()
        sortView.sortOption  = JWFileConditionOption.init(state: JWFileFilterStates(defaultState: JWFileFilterOptionState(titleFont: UIFont(name: PFSC_R, size: 14)!, titleTextColor: UIColor(hexString: "666666"), backgroud: UIColor(hexString: "f5f5f5")), selectedState:JWFileFilterOptionState(titleFont: UIFont(name: PFSC_R, size: 14)!, titleTextColor: UIColor(hexString: "ffffff"), backgroud: UIColor.black)))
        sortView.sortOfTimeItems = generateTimeSortItems()
        sortView.didFileTypeSelectedIndex = getCurrentFileTypeIndex(items: sortView.sortConditionItems, type: sortOption.type)
        sortView.didSortSelectedIndex = getCurrentTimeSort(timeSort: sortOption.sort)
    }
    
    override func configureSubView() {
        
        view.addSubview(sortView)
        sortView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
        }
    }

    func generateSortOptionItems() -> Array<JWFileConditionOptionItem> {
        
        let options =  [
            ("所有文件", JWFileMetaType.FileMeta_All),
            ("文档", JWFileMetaType.FileMeta_Doc),
            ("表格", JWFileMetaType.FileMeta_Excel),
            ("幻灯片", JWFileMetaType.FileMeta_PPT),
            ("图片", JWFileMetaType.FileMeta_Image),
            ("视频", JWFileMetaType.FileMeta_Video),
            ("音频", JWFileMetaType.FileMeta_Audio),
            ("压缩包", JWFileMetaType.FileMeta_Zip),
            ("其他", JWFileMetaType.FileMeta_Other)
            ].map { (element) -> JWFileConditionOptionItem in
                return JWFileConditionOptionItem(title: element.0, fileType: element.1)
        }
        return options
    }
    
    func getCurrentFileTypeIndex(items: Array<JWFileConditionOptionItem>?, type:JWFileMetaType) -> Int {
        
        guard let filterConditionItems = items else { return 0 }
        var index = 0
        for (i, value) in filterConditionItems.enumerated() {
            if value.fileType == type {
                index = i
                break
            }
        }
        return index
    }
    
    
    func getCurrentTimeSort(timeSort:JWFileSort) -> Int {
        
        return (timeSort == JWFileSort.JWFileSort_Updated_at) ? 0 :1
    }
    
    
    
    func generateTimeSortItems() -> Array<JWFileTimeSortItem> {
        
        let items = [ JWFileTimeSortItem(title: "修改时间", sort: .JWFileSort_Updated_at),
                      JWFileTimeSortItem(title: "创建时间", sort: .JWFileSort_Created_at)
                    ]
        return items
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let rectCorner = UIRectCorner.init(rawValue: UIRectCorner.topLeft.rawValue | UIRectCorner.topRight.rawValue)
        sortView.addCornerLayer(rectCorner: rectCorner, radius: 10)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
}
