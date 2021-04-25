//
//  JWFileSearchHistoryViewController.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/9.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileSearchHistoryViewController: JWFileBaseViewController {

    lazy var titleView: JWFileNaviTextFiled = {
        let titleView = JWFileNaviTextFiled.init(frame: CGRect(x: 0, y: 0, width: screenWidth-82, height: 36), placeHolder: "搜索", image: UIImage.image(JWFNamed: "file_search_s"), placeHolderColor: UIColor(hexString: "b0b0b0"), background: UIColor(hexString: "f1f1f1"))
        titleView.setCornerRadius(radius: 8)
        return titleView
    }()
    
    lazy var historyCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
//        let layout = JWFileListFlowLayout.init(delegate: self)
        
        let filesCollection = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        filesCollection.delegate = self
        filesCollection.dataSource = self
        
        filesCollection.register(JWFileSearchListHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "JWFileSearchListHeader")
        filesCollection.registerCellClassFromStrings(strings: ["JWFileSearchHistoryCollectionViewCell", "JWFileItemCollectionViewCell"])
        
        filesCollection.backgroundColor = UIColor.white
        filesCollection.keyboardDismissMode = .onDrag
        filesCollection.alwaysBounceVertical = true
        
        return filesCollection
    }()
    
    let searchVC = JWFileSearchViewController()
    
    var sources: Array<Array<Any>> = []
    var accessToken:String? {
        didSet {
            searchVC.accessToken = accessToken
        }
    }
    var search:String? {
        willSet {
            searchVC.search = newValue
           
        }
    }
//    //MARK: 共享人分享file list 搜索进入
//    var isFromShareFileList: Bool = false {
//        didSet {
//            searchVC.isFromShareFileList = isFromShareFileList
//        }
//    }
//    //MARK: 文件夹 搜索进入
//    var isSubDir: Bool = false {
//        didSet {
//            searchVC.isSubDir = isSubDir
//        }
//    }
//    var currentFileSpace: JWFileSearchViewController.FileSpaceType = .FileSpace_All {
//        didSet {
//            searchVC.currentFileSpace = currentFileSpace
//        }
//    }
    
    var searchFilterConfigure:JWFileSearchFilterConfigure = JWFileSearchFilterConfigure.init(route: .Home, dimension: .FD_All, fileSpace: .FileSpace_All)  {
        didSet {
            searchVC.searchFilterConfigure = searchFilterConfigure
        }
    }
    
    
    var timeStamp:Double = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        configureSubView()
        configureNaviBar()
        loadData()
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: titleView, queue: .main) { [weak self] (notification) in

            let obj = notification.object as? JWFileNaviTextFiled

            let currentTimeStamp = round(Date().timeIntervalSince1970)
//            JWFileLog(messgae: "currentTimeStamp:\(currentTimeStamp)")
            if currentTimeStamp - (self?.timeStamp ?? -1) < 0.3 {
                NSObject.cancelPreviousPerformRequests(withTarget: self!)
            }
            self?.perform(#selector(self?.setSearchText(text:)), with: obj?.text, afterDelay: 1.0)

            self?.timeStamp = round(Date().timeIntervalSince1970)
            
            self?.searchVC.view.isHidden = obj?.text == nil || obj?.text!.count == 0

        }
    }
    
    
    @objc func setSearchText(text:String) {
        search = text
    }
    
    override func configureSubView() {
        
       
        navigationItem.titleView = titleView
        navigationController?.navigationBar.isTranslucent = false
        
        
        view.addSubview(historyCollection)
        historyCollection.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        addChild(searchVC)
        view.addSubview(searchVC.view)
        searchVC.view.isHidden = true
        searchVC.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    func configureNaviBar() {
        
        let cancelLabel = UILabel()
        
        cancelLabel.jw_File_configureLabel(text: "取消", fontName: PFSC_R, fontSize: 16, textColor: UIColor(hexString: "333333"))
        let cancelItem = UIBarButtonItem.init(title: "取消", style:.plain, target: self, action: #selector(cancel))
        cancelItem.tintColor = UIColor(hexString: "333333")
        navigationItem.rightBarButtonItems = [cancelItem];
    }
    
    @objc func cancel() {
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    func loadData() {
        guard let token = accessToken else { return }
        requestHistoryData(token: token)
    }
    
}


//MARK: Request
extension JWFileSearchHistoryViewController {
    
    
    //MARK: 最近打开的文件
    func requestLROList(token:String, completeClosure:@escaping (Array<Any>)->Void)  {
        
        var temp : Array<Any> = []
        SessionManager.request(api: JWFileModuleAPI.getLROFiles(token: token), serializeClass: JWFileListModel.self) { (respone) in
            
            JWFileLog(messgae: respone.data)
            
            if respone.statusCode == .success {
                
                if let files = respone.data?.JMFiles {
                    temp = files
                }
 
            }
            completeClosure(temp)
        }
        
    }
    
    
    func requestHistory(token:String, completeClosure:@escaping (Array<Any>) -> Void)  {
        
        SessionManager.request(api: JWFileModuleSearchAPI.getHistoryOfSearch(token: token), serializeClass: JWFileSearchRecord.self) { (respone) in
            var temp : Array<Any> = []
            JWFileLog(messgae: respone.data)
            if respone.statusCode == .success {
                if let histories = respone.data?.JMSearchRecord {
                    temp = histories
                }
            }
            completeClosure(temp)
        }
        
    }
    
    
    func requestHistoryData(token:String) {
        
        var lroFiles: Array<Any>!
        var historise: Array<Any>!
        let group = DispatchGroup()
        let queue = DispatchQueue.init(label: "JWFilesList.request.history", qos: .default, attributes: .concurrent)
        group.enter()
        queue.async(group: group) {
            self.requestLROList(token: token) { (element) in
                
                lroFiles = element
                group.leave()
            }
        }
        
        group.enter()
        queue.async(group: group) {
            self.requestHistory(token: token) { (element) in
                historise = element
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            
            self.sources.append(historise)
            self.sources.append(lroFiles)
            self.historyCollection.reloadData()
        }
    }
    
}

/**
   下拉刷新

//MARK: JWFileListRefreshProtocol
extension JWFileSearchHistoryViewController: JWFileListRefreshProtocol {
    
    typealias E = Array<Any>?
    
    func appendDataInArray(remoteSource: E) {
        guard let element = remoteSource, element.count != 0  else {
            //没有更多数据
            historyCollection.mj_footer?.endRefreshingWithNoMoreData()
            return
        }
        
        self.endReFresh()
        
        if currentPage == 0 {
            sources = element as! Array<Array<Any>>
        } else {
            
            if sources.count <= 1 {
                sources.append(element)
            } else {
                sources[1].append(contentsOf: element)
            }
        }
        historyCollection.reloadData()
    }
    
    
    func refresh() {
        historyCollection.mj_footer?.resetNoMoreData()
        endReFresh()
        currentPage = 0
//        loadData()
    }
    
    func loadMore() {
        currentPage += 1
        guard let token = accessToken else { return }
//        requestFileList(token: token) { (element) in
//            self.appendDataInArray(remoteSource: element)
//        }
    }
    
    func endReFresh() {
    
        if (historyCollection.mj_header != nil) {
            historyCollection.mj_header?.endRefreshing()
        }
        if (historyCollection.mj_footer != nil) {
            historyCollection.mj_footer?.endRefreshing()
        }
    }
    
}

*/




//MARK: UICollectionViewDataSource UICollectionViewDelegate
extension JWFileSearchHistoryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print(#function)
        return sources.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(#function)
//        if section == 0 {
//            return sources[]s
//        }
        return sources[section].count > 3 ?  3 : sources[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        print(#function)
        JWFileLog(messgae: getReusedIndentifier(indexPath: indexPath))
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: getReusedIndentifier(indexPath: indexPath), for: indexPath)
        
        dispatchDataToCell(indexPath: indexPath, data: sources, cell: cell)
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        print(#function)
        var v = UICollectionReusableView()
        if kind == UICollectionView.elementKindSectionHeader {
            v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "JWFileSearchListHeader", for: indexPath)
            v.backgroundColor = UIColor.white
            v.clipsToBounds = true
            (v as! JWFileSearchListHeader).title.text = indexPath.section == 0 ? "搜索历史" : "最近浏览"
        }
        return v
 
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard sources.count != 0 else { return .zero }
        let element = sources[indexPath.section][indexPath.row]
        if element is String {
            return CGSize(width: screenWidth, height: 50)
        } else if element is JWFileModel {
            return CGSize(width: screenWidth-30, height: 60)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 1 {
            return UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if sources[section].count != 0 {
            return CGSize(width: screenWidth, height: 60)
        }
        return .zero
    }
    
}



//MARK: JWFileConfigureCollectionProtocol
extension JWFileSearchHistoryViewController: JWFileConfigureCollectionProtocol {
   
    func getReusedIndentifier(indexPath: IndexPath) -> String {
        var cell:String!
        cell = "JWFileSearchHistoryCollectionViewCell"
        guard sources.count != 0 else { return cell }
        let element = sources[indexPath.section][indexPath.row]
        if element is String {
            cell = "JWFileSearchHistoryCollectionViewCell"
        } else if element is JWFileModel {
            cell = "JWFileItemCollectionViewCell"
        } else if element is JWFileModel {
//            if (element as! JWFileModel).file_type == .Dir {
//                cell = "JWFileDirCollectionViewCell"
//            } else {
//                cell = isGridLayout ? "JWFileItemGridCollectionViewCell" : "JWFileItemCollectionViewCell"
//            }
        }
        
        return cell
    }
    
    func dispatchDataToCell(indexPath: IndexPath, data: Any?, cell: UICollectionViewCell) {
        
        
        guard let sourceArr = data as? Array<Array<Any>>, sourceArr.count != 0 else {
            return
        }
       
        if cell is JWFileSearchHistoryCollectionViewCell {
            (cell as! JWFileSearchHistoryCollectionViewCell).backgroundColor = UIColor.white
        }
        
        if sourceArr[indexPath.section].count != 0 {
            let model = sources[indexPath.section][indexPath.row]
            cell.configureModel(model: model)
        }
        
    }
    
}
