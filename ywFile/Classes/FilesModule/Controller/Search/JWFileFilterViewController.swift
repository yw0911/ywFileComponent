//
//  JWFileFilterViewController.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/13.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileFilterViewController: JWFileBaseViewController {
    
    let filterConditionView: JWFileFilterConditionView = {
        let conditionView = JWFileFilterConditionView()
        conditionView.backgroundColor = UIColor.white
        conditionView.clipsToBounds = true
        return conditionView
    }()
    
    
    //    var headerFileTypeOptions:Array<JWFileConditionOptionItem>?
    //    var otherConditionOptions:Array<JWFileFilterPositionOrOwnerItem>?
    //    var currentFileSpace: JWFileSearchFilterConfigure.FileSpaceType = .FileSpace_All {
    //        didSet {
    //
    //        }
    //    }
    var accessToken:String?
    var currentFileMetaType: JWFileMetaType = .FileMeta_All
    var currentFileOwners: Array<Any>?
    var currentFilePosition: JWFileSearchFolder?
    var searchFilterConfigure:JWFileSearchFilterConfigure = JWFileSearchFilterConfigure.init(route: .Home, dimension: .FD_All, fileSpace: .FileSpace_All)
    var filterConditionChangeCallBackClosure:((_ fileMetaType:JWFileMetaType, _ filePosition:JWFileSearchFolder?, _ fileOwner:Any?) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        configureSubView()
        filterConditionView.filterConditionItems = generateFilterOptionItems()
        filterConditionView.filterOption = JWFileConditionOption.init(state: JWFileFilterStates(defaultState: JWFileFilterOptionState(titleFont: UIFont(name: PFSC_R, size: 14)!, titleTextColor: UIColor(hexString: "666666"), backgroud: UIColor(hexString: "f5f5f5")), selectedState:JWFileFilterOptionState(titleFont: UIFont(name: PFSC_R, size: 14)!, titleTextColor: UIColor(hexString: "ffffff"), backgroud: UIColor.black)))
        
        filterConditionView.positionOrOwnerClickClosure = { [weak self] (index, callBack) in
            JWFileLog(messgae: index)
            
            switch self!.searchFilterConfigure.dimension {
                
            case .FD_FileType:
                break
            case .FD_Owner:
                break
            case .FD_Position:
                break
            case .FD_FileType_Owner:
                break
            case .FD_FileType_Position:
                self?.modalDirChooseController(callBack: callBack)
            case .FD_All:
                
                if index == 0 {
                    
                } else {
                    self?.modalDirChooseController(callBack: callBack)
                }
                
                
            }
            
            
        }
        
        filterConditionView.bottomDetermineClickClosure = { [weak self] in
            
            self?.presentingViewController?.dismiss(animated: true, completion: nil)
            guard let closure = self?.filterConditionChangeCallBackClosure else { return }
            guard let fileMetaTypesItem = self?.filterConditionView.filterConditionItems else { return }
            let currentFileType = fileMetaTypesItem[self!.filterConditionView.didConditionSelectedIndex].fileType
            let currentFilePosition = self?.filterConditionView.currentFilePosition
            let currentFileOwners = self?.filterConditionView.currentFileOwners
            closure(currentFileType, currentFilePosition, currentFileOwners)
        }
        
        
        filterConditionView.didConditionSelectedIndex = getCurrentFileTypeIndex(items: filterConditionView.filterConditionItems, type: currentFileMetaType)
        
        filterConditionView.filterPositionOrOwnerItems = generateFilterPositionOrOwnerItems(configure: searchFilterConfigure)
        
        
    }
    
    
    override func configureSubView() {
        
        view.addSubview(filterConditionView)
        filterConditionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func generateFilterOptionItems() -> Array<JWFileConditionOptionItem> {
        
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
    
    func generateFilterPositionOrOwnerItems(configure:JWFileSearchFilterConfigure) -> Array<JWFileFilterPositionOrOwnerItem> {
        
        var temp: Array<JWFileFilterPositionOrOwnerItem> = []
        
        
        switch configure.dimension {
            
        case .FD_FileType:
            break
        case .FD_Owner:
            break
        case .FD_Position:
            break
        case .FD_FileType_Owner:
            temp.append(generateFileOwnerItem(owners: self.currentFileOwners))
        case .FD_FileType_Position:
            temp.append(generateFilePosition(filePosition: self.currentFilePosition))
        case .FD_All:
            temp.append(generateFileOwnerItem(owners: self.currentFileOwners))
            temp.append(generateFilePosition(filePosition: self.currentFilePosition))
        }
        
        return temp
    }
    
    func modalDirChooseController(callBack:@escaping ((JWFileSearchFolder) -> Void)) {
        
        let choosePositionVC = JWFileChoosePositionViewController()
        choosePositionVC.accessToken = accessToken
        choosePositionVC.determineCallBackClosure = callBack
        let choosePositionNV = UINavigationController.init(rootViewController: choosePositionVC)
        choosePositionNV.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(choosePositionNV, animated: true, completion: nil)
        }
    }
    
    //    func generateFilterPositionOrOwnerItems(configure:JWFileSearchFilterConfigure) -> Array<JWFileFilterPositionOrOwnerItem> {
    //
    //        var temp: Array<JWFileFilterPositionOrOwnerItem> = []
    //
    //        if configure.route == .Dir {
    //            temp.append(generateFileOwnerItem(owners: self.currentFileOwners))
    //
    //        }
    //
    //        switch configure.fileSpace {
    //
    //        case .FileSpace_Own:
    //
    ////            temp.append(generateFilePosition(filePosition: self.currentFilePosition))
    //            temp.append(generateFileOwnerItem(owners: self.currentFileOwners))
    //        case .FileSpace_Share:
    //            temp.append(generateFileOwnerItem(owners: self.currentFileOwners))
    //            temp.append(generateFilePosition(filePosition: self.currentFilePosition))
    //        case .FileSpace_All:
    //            temp.append(generateFileOwnerItem(owners: self.currentFileOwners))
    //            temp.append(generateFilePosition(filePosition: self.currentFilePosition))
    //        case .FileSpace_unKonw:
    //            break
    //        }
    //
    //        return temp
    //    }
    
    
    func generateFileOwnerItem(owners:Array<Any>?) -> JWFileFilterPositionOrOwnerItem {
        
        guard let arr = owners else { return JWFileFilterPositionOrOwnerItem(title: "所属人", placeHolder: "全部", type: .Owner, entries: nil)}
        
        if arr.count > 1 {
            return JWFileFilterPositionOrOwnerItem(title: "所属人", placeHolder: "全部", type: .Owner, entries: "\(arr[0])等\(arr.count)人")
        } else {
            return JWFileFilterPositionOrOwnerItem(title: "所属人", placeHolder: "全部", type: .Owner, entries: "\(arr[0])")
        }
    }
    
    func generateFilePosition(filePosition:Any?) -> JWFileFilterPositionOrOwnerItem {
        
        guard let position = filePosition else { return JWFileFilterPositionOrOwnerItem(title: "位置", placeHolder: "全部", type: .Position) }
        
        return JWFileFilterPositionOrOwnerItem(title: "位置", placeHolder: "全部", type: .Position, entries: position)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let rectCorner = UIRectCorner.init(rawValue: UIRectCorner.topLeft.rawValue | UIRectCorner.topRight.rawValue)
        filterConditionView.addCornerLayer(rectCorner: rectCorner, radius: 10)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
