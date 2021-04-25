//
//  JWFileSearchViewController.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/13.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileSearchViewController: JWFileBaseViewController {
    
    lazy var filesCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        let filesCollection = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        filesCollection.delegate = self
        filesCollection.dataSource = self
        
        filesCollection.register(JWFileSearchListHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "JWFileSearchListHeader")
        filesCollection.registerCellClassFromStrings(strings: [
            "JWFileDirCollectionViewCell", "JWFileItemCollectionViewCell"])
        filesCollection.backgroundColor = UIColor(hexString: "e7e7e7")
        filesCollection.keyboardDismissMode = .onDrag
        filesCollection.alwaysBounceVertical = true
        
//        filesCollection.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] in
//            
//            self?.refresh()
//        })
        
        filesCollection.mj_footer = MJRefreshBackStateFooter.init(refreshingBlock: { [weak self] in
            
            self?.loadMore()
        })
        
        
        return filesCollection
    }()
    
    
    lazy var segmentHeader: JWFileSearchSegmentContainer = {
        let segmentHeader = JWFileSearchSegmentContainer.init()
        
        segmentHeader.switchSegmentClosure = { [weak self] (index) in
            
            JWFileLog(messgae: index)
            
            self?.changeConfigure(index: index, configure: self!.searchFilterConfigure)
            self?.refresh()
            
        }
        
        segmentHeader.filterClosure = { [weak self] in
            
            UIApplication.shared.keyWindow?.endEditing(true)
            
            let filterVC = JWFileFilterViewController()
            
            filterVC.currentFileMetaType = self!.currentFileMetaType
            //            filterVC.currentFileOwners = self.currentFileOwners
            filterVC.currentFilePosition = self!.currentFilePosition
            filterVC.searchFilterConfigure = self!.searchFilterConfigure
            filterVC.accessToken = self!.accessToken
            filterVC.filterConditionChangeCallBackClosure = { (fileType, position, owner) in
                
                JWFileLog(messgae: fileType)
                self!.currentFileMetaType = fileType
                self!.currentFilePosition = position
                //                self!.currentFileOwners = owner as! Array<Any>
                self!.refresh()
            }
            
            filterVC.modalPresentationStyle = .overFullScreen
            self?.present(filterVC, animated: true, completion: nil)
            
        }
        return segmentHeader
    }()
    
    
    var sources: Array<Array<Any>> = [[],[]]
    var accessToken:String?
    var search:String? {
        didSet {
            refresh()
        }
    }
    
    //    var currentFileSpace: FileSpaceType = .FileSpace_All {
    //        didSet {
    //            guard oldValue != currentFileSpace else { return }
    //            guard search != nil else { return }
    //            searchRequest()
    //        }
    //    }
    var currentFileMetaType: JWFileMetaType = .FileMeta_All
    //    var isFromShareFileList: Bool = false
    //    var isSubDir: Bool = false {
    //        didSet {
    //
    //        }
    //    }
    var currentFileOwners: Array<Any>?
    var currentFilePosition: JWFileSearchFolder?
    var searchFilterConfigure:JWFileSearchFilterConfigure = JWFileSearchFilterConfigure.init(route: .Home, dimension: .FD_All, fileSpace: .FileSpace_All)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSubView()
//        loadData()
        
        didSelectedClosure = { [weak self] (listView, indexPath, data) in
            
            if data is JWFileModel {
                let fileModel = data as!JWFileModel
                guard fileModel.file_type == .Dir else { return }
                let contactFilesVC = JWFileDetailFileListViewController()
                contactFilesVC.dirName = fileModel.name
                contactFilesVC.folderID = fileModel.id
                contactFilesVC.accessToken = self?.accessToken
                var searchFilterConfigure = self!.searchFilterConfigure
                searchFilterConfigure.changeRoute(route: .Dir)
                contactFilesVC.searchFilterConfigure = searchFilterConfigure
                self?.navigationController?.pushViewController(contactFilesVC, animated: true)
                
            }
        }
        
        
    }
    
    override func configureSubView() {
        
        view.addSubview(segmentHeader)
        segmentHeader.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(50)
        }
        
        view.addSubview(filesCollection)
        filesCollection.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(segmentHeader.snp.bottom)
        }
        
        configureSegmentHeader(configure: searchFilterConfigure)
        
    }
    
    
    
    
    func configureSegmentHeader(configure:JWFileSearchFilterConfigure)  {
        
        segmentHeader.segmentOption = JWFileSegmentOption.init(segmentStates: JWFileSegmentStates(defaultState:JWFileSegmentState.init(titleFont: UIFont(name: PFSC_R, size: 14)!, titleTextColor: UIColor(hexString: "999999")), selectedState: JWFileSegmentState.init(titleFont: UIFont(name: PFSC_R, size: 14)!, titleTextColor: UIColor(hexString: "333333"))))
        
        segmentHeader.items = generateSegmentItems(configure: searchFilterConfigure)
        if configure.route == .Home {
            segmentHeader.didSegmentSelectedIndex = 0
        } else {
            segmentHeader.didSegmentSelectedIndex = 1
        }
    }
    
    
    
    
    
    func generateSegmentItems(configure:JWFileSearchFilterConfigure) -> Array<JWFileSegmentItem>  {
        
        var temp: Array<JWFileSegmentItem> = []
        temp.append(JWFileSegmentItem.init(title: "全部"))
        
        switch configure.route {
        case .Home:
            temp.append(JWFileSegmentItem.init(title: "我的文件"))
            temp.append(JWFileSegmentItem.init(title: "共享给我的"))
        case .Share:
            temp.append(JWFileSegmentItem.init(title: "共享给我的"))
        case .Dir:
            temp.append(JWFileSegmentItem.init(title: "当前文件夹"))
        }
        
        return temp
        
    }
    
    
    func changeConfigure(index:Int, configure:JWFileSearchFilterConfigure) {
        
        switch index {
        case 0:
            self.searchFilterConfigure.changeFileSpace(space: .FileSpace_All)
            self.searchFilterConfigure.changeDimension(dimension: .FD_All)
        case 1:
            
            if configure.route == .Dir {
                self.searchFilterConfigure.changeFileSpace(space: .FileSpace_Own)
                self.searchFilterConfigure.changeDimension(dimension: .FD_FileType_Owner)
            } else if configure.route == .Share {
                self.searchFilterConfigure.changeFileSpace(space: .FileSpace_Share)
                
                self.searchFilterConfigure.changeDimension(dimension: .FD_FileType)
            } else if configure.route == .Home {
                self.searchFilterConfigure.changeFileSpace(space: .FileSpace_Own)
                self.searchFilterConfigure.changeDimension(dimension: .FD_FileType_Position)
            }
        case 2:
            self.searchFilterConfigure.changeFileSpace(space: .FileSpace_Share)
            self.searchFilterConfigure.changeDimension(dimension: .FD_All)
        default:
            self.searchFilterConfigure.changeFileSpace(space: .FileSpace_unKonw)
        }
        
    }
    
    func loadData()  {
        guard let token = accessToken else { return }
        self.searchRequest(token: token)
    }
    
    
}

//MARK: Request
extension JWFileSearchViewController {
    
    func searchRequest(token:String) {
        
        SessionManager.request(api: JWFileModuleSearchAPI.fileSearch(
            token: token,
            category: searchFilterConfigure.fileSpace.rawValue,
            type: currentFileMetaType.rawValue,
            owner: nil,
            share_uid: nil,
            folder_id: currentFilePosition?.folder_id,
            folder_flag: nil,
            search: search,
            pageno: currentPage,
            pagesize: pageSize),
                               serializeClass: JWFileListModel.self) { (respone) in
                                
                                JWFileLog(messgae: respone.data)
                                if respone.statusCode == .success {
                                    self.appendDataInArray(remoteSource: respone.data?.JMFiles)
                                }
        }
    }
    
    func organizeFiles(list:Array<JWFileModel>) -> (Array<JWFileModel>, Array<JWFileModel>)  {
        
        let dirList = list.filter { $0.file_type == .Dir }
        let fileList = list.filter { $0.file_type != .Dir }
        return (fileList, dirList)
        
    }
    
}


//MARK: JWFileListRefreshProtocol
extension JWFileSearchViewController: JWFileListRefreshProtocol {
    
    typealias E = Array<Any>?
    
    func appendDataInArray(remoteSource: E) {
        
        endReFresh()
        guard let element = remoteSource, element.count != 0  else {
            //没有更多数据
            filesCollection.mj_footer?.endRefreshingWithNoMoreData()
            return
        }
        
        
        let tuple = organizeFiles(list: element as! Array<JWFileModel>)
        if currentPage == 0 {
            sources[0] = tuple.0
            sources[1] = tuple.1
            filesCollection.reloadData()
        } else {
            
            let fileCount = tuple.0.count
            var insertIndexs: Array<IndexPath> = []
            
            for idx in sources[0].count ..< sources[0].count.advanced(by: fileCount) {
                insertIndexs.append(IndexPath.init(row: idx, section: 0))
            }
            
            let dirCount = tuple.1.count
            for idx in sources[1].count ..< sources[1].count.advanced(by: dirCount) {
                insertIndexs.append(IndexPath.init(row: idx, section: 1))
            }
            sources[0].append(contentsOf: tuple.0)
            sources[1].append(contentsOf: tuple.1)
            filesCollection.insertItems(at: insertIndexs)
        }
        
    }
    
    
    func refresh() {
        
        filesCollection.mj_footer?.resetNoMoreData()
        currentPage = 0
        loadData()
    }
    
    func loadMore() {
        currentPage += 1
        loadData()
    }
    
    func endReFresh() {
        
        if (filesCollection.mj_header != nil) {
            filesCollection.mj_header?.endRefreshing()
        }
        if (filesCollection.mj_footer != nil) {
            filesCollection.mj_footer?.endRefreshing()
        }
    }
    
}




//MARK: UICollectionViewDataSource UICollectionViewDelegate
extension JWFileSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sources[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: getReusedIndentifier(indexPath: indexPath), for: indexPath)
        
        dispatchDataToCell(indexPath: indexPath, data: sources, cell: cell)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var v = UICollectionReusableView()
        if kind == UICollectionView.elementKindSectionHeader {
            v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "JWFileSearchListHeader", for: indexPath)
            v.backgroundColor = UIColor.white
            v.clipsToBounds = true
            (v as! JWFileSearchListHeader).title.text = indexPath.section == 0 ? "文件" : "文件夹"
            v.backgroundColor = UIColor(hexString: "e7e7e7")
        }
        return v
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let closure = didSelectedClosure else { return }
        guard sources[indexPath.section].count != 0 else { return }
        closure(collectionView, indexPath, sources[indexPath.section][indexPath.row])
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth, height: 60)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if sources[section].count == 0 {
            return .zero
        }
        return CGSize(width: screenWidth, height: 49)
    }
    
}

extension JWFileSearchViewController: JWFileConfigureCollectionProtocol {
    
    func getReusedIndentifier(indexPath: IndexPath) -> String {
        
        var cell:String!
        cell = "JWFileDirCollectionViewCell"
        guard sources[indexPath.section].count >= indexPath.row+1 else {
            return cell
        }
        guard let element = sources[indexPath.section][indexPath.row] as? JWFileModel else { return cell }
        if element.file_type == .Dir {
            cell = "JWFileDirCollectionViewCell"
        } else {
            cell = "JWFileItemCollectionViewCell"
        }
        
        return cell
    }
    
    func dispatchDataToCell(indexPath: IndexPath, data: Any?, cell: UICollectionViewCell) {
        
        guard sources[indexPath.section].count >= indexPath.row+1 else { return }
        let element = sources[indexPath.section][indexPath.row]
        
        if cell is JWFileDirCollectionViewCell {
            (cell as! JWFileDirCollectionViewCell).inset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 15)
            (cell as! JWFileDirCollectionViewCell).hightlightChar = search
        } else if cell is JWFileItemCollectionViewCell {
            (cell as! JWFileItemCollectionViewCell).inset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 15)
            (cell as! JWFileItemCollectionViewCell).hightlightChar = search
        }
        
        cell.configureModel(model: element)
    }
    
    
    
    
}
