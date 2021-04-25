//
//  JWFileDetailFileListViewController.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/9.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileDetailFileListViewController: JWFileBaseViewController {
    
    
    lazy var searchBar: JWFileSearchBar = {
        let search = JWFileSearchBar(searchTip: "搜索")
        search.backgroundColor = UIColor.white
        search.addShadow(shadowColor: UIColor.black.withAlphaComponent(0.17), shadowOffset: CGSize(width: 0, height: 10), shadowRadius: 7)
        search.tapClosure = { [weak self] in
            
            let searchVC = JWFileSearchHistoryViewController()
            searchVC.accessToken = self?.accessToken
            //            searchVC.isFromShareFileList = self!.isFromShareFileList
            //            searchVC.isSubDir = self!.isSubDir
            //            searchVC.currentFileSpace = self!.currentFileSpace
            switch self!.searchFilterConfigure.route {
            case .Home:
                //                self!.searchFilterConfigure.changeDimension(dimension: )
                break
            case .Share:
                self!.searchFilterConfigure.changeDimension(dimension: .FD_FileType)
            case .Dir:
                self!.searchFilterConfigure.changeDimension(dimension: .FD_FileType_Owner)
            }
            
            searchVC.searchFilterConfigure = self!.searchFilterConfigure
            let searchNaviVC = UINavigationController(rootViewController: searchVC)
            searchNaviVC.modalPresentationStyle = .fullScreen
            searchNaviVC.modalTransitionStyle = .crossDissolve
            self?.present(searchNaviVC, animated: true, completion: nil)
        }
        return search
    }()
    
    
    lazy var filesCollection: UICollectionView = {
        //        let layout = UICollectionViewFlowLayout.init()
        let layout = JWFileListFlowLayout.init(delegate: self)
        
        let filesCollection = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        filesCollection.delegate = self
        filesCollection.dataSource = self
        
        filesCollection.register(JWFileCollectionReusableViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "JWFileCollectionReusableViewHeader")
        filesCollection.registerCellClassFromStrings(strings: ["JWFileDirCollectionViewCell", "JWFileTopSegmentCollectionViewCell", "JWFileItemCollectionViewCell", "JWFileItemGridCollectionViewCell", "JWFileLROCollectionViewCell"])
        
        filesCollection.backgroundColor = isGridLayout ? UIColor(hexString: "f6f6f6") : UIColor.white
        
        filesCollection.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] in
            
            self?.refresh()
            
        })
        
        filesCollection.mj_footer = MJRefreshBackStateFooter.init(refreshingBlock: { [weak self] in
            
            self?.loadMore()
        })
        return filesCollection
    }()
    
    
    var isGridLayout = true {
        willSet{
            print(newValue)
        }
        didSet{
            print(oldValue)
            
            filesCollection.reloadSections(IndexSet(integer: 0))
            filesCollection.backgroundColor = isGridLayout ? UIColor(hexString: "f6f6f6") : UIColor.white
        }
    }
    
    var sources:Array<Any> = Array<Any>()
    
    var accessToken: String?
    var scrollViewDidScrollClosure: ((_ scrollView:UIScrollView) -> Void)?
    var segmentItemSwitchClosure: ((JWFileTopItemBar.ItemType) -> Void)?
    var dirName:String?
    //    var isFromShareFileList: Bool = false
    //    var isSubDir: Bool = false
    //    var currentFileSpace: JWFileSearchViewController.FileSpaceType = .FileSpace_All
    var searchFilterConfigure:JWFileSearchFilterConfigure = JWFileSearchFilterConfigure.init(route: .Home, dimension: .FD_All, fileSpace: .FileSpace_All)
    var folderID:String?
    var sortOption: JWFileSortOption = .init(sort: .JWFileSort_Updated_at, seq: .JWFileSeq_DESC, type: .FileMeta_All)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviBar()
        configureSubView()
        loadData()
        
        didSelectedClosure = { [weak self] (listView, indexPath, data)in
            
            JWFileLog(messgae: "didSelectedClosure")
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
        view.backgroundColor = UIColor.white
        view.addSubview(filesCollection)
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(40)
        }
        
        filesCollection.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
        }
    }
    
    
    func configureNaviBar() {
        
        //        let searchItem = UIBarButtonItem.init(image: UIImage(named: "file_search")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(fileSearch))
        let title = UILabel()
        title.jw_File_configureLabel(fontName: PFSC_B, fontSize: 19, textColor: UIColor(hexString: "333333"))
        title.text = dirName
        let titleItem = UIBarButtonItem.init(customView: title)
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItems = [titleItem]
        let switchLayoutItem = UIBarButtonItem.init(image:  UIImage.image(JWFNamed: "file_gridLayout")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(switchLayout))
        navigationItem.rightBarButtonItems = [switchLayoutItem];
    }
    
    @objc func switchLayout() {
        
        isGridLayout = !isGridLayout
        return
    }
    
    
    func loadData() {
        
        guard let token = accessToken else { return }
        fetchSubDirFileList(token: token) { (element) in
            self.appendDataInArray(remoteSource: element)
        }
        
    }
    
    
}

//MARK: Request
extension JWFileDetailFileListViewController {
    
    
    func fetchSubDirFileList(token:String, completeClosure:@escaping(Array<Any>) -> Void)  {
        
        
        SessionManager.request(api: JWFileModuleAPI.getSubDirFile(
            token: token,
            sort: sortOption.sort.rawValue,
            seq: sortOption.seq.rawValue,
            type: sortOption.type.rawValue,
            folder_id: folderID,
            pageno: currentPage,
            pagesize: pageSize),
                               serializeClass: JWFileListModel.self) { (respone) in
                                var temp : Array<Any> = []
                                if respone.statusCode == .success {
                                    
                                    if let files = respone.data?.JMFiles {
                                        temp = files
                                    }
                                }
                                completeClosure(temp)
                                
        }
        
    }
    
    
}


//MARK: JWFileListRefreshProtocol
extension JWFileDetailFileListViewController: JWFileListRefreshProtocol {
    
    typealias E = Array<Any>?
    
    func appendDataInArray(remoteSource: E) {
        guard let element = remoteSource, element.count != 0  else {
            //没有更多数据
            filesCollection.mj_footer?.endRefreshingWithNoMoreData()
            return
        }
        
        self.endReFresh()
        
        if currentPage == 0 {
            sources = element
        } else {
            
            sources.append(contentsOf: element)
        }
        filesCollection.reloadData()
    }
    
    
    func refresh() {
        filesCollection.mj_footer?.resetNoMoreData()
        endReFresh()
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





//MARK: JWFileListFlowLayoutDelegate
extension JWFileDetailFileListViewController: JWFileListFlowLayoutDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: JWFileListFlowLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard sources.count != 0 else { return .zero }
        let element = sources[indexPath.row]
        
        if element is JWFileModel {
            if (element as! JWFileModel).file_type == .Dir {
                return isGridLayout ?  CGSize(width: (screenWidth - 38)/2, height: 60) :  CGSize(width: (screenWidth - 30), height: 60)
            }
            return isGridLayout ?  CGSize(width: (screenWidth - 38)/2, height: 146) :  CGSize(width: screenWidth-30, height: 60)
        }
        
        return .zero
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: JWFileListFlowLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: screenWidth, height: 65)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: JWFileListFlowLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: JWFileListFlowLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //        print(#function)
        //        if section == 0 {
        //            return 10
        //        }
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: JWFileListFlowLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        //        print(#function)
        
        //        if section == 0 {
        //            return 0
        //        }
        return 8
    }
    
    //
    var collectionHeaderView: UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.red
        return header
    }
    
    func collectionViewHeaderSize(_ collectionView: UICollectionView, layout collectionViewLayout: JWFileListFlowLayout) -> CGSize {
        return CGSize(width: screenWidth, height: 88)
    }
}

//MARK: JWFileConfigureCollectionProtocol
extension JWFileDetailFileListViewController: JWFileConfigureCollectionProtocol {
    
    func getReusedIndentifier(indexPath: IndexPath) -> String {
        var cell:String!
        cell = "JWFileTopSegmentCollectionViewCell"
        guard sources.count != 0 else { return cell }
        let element = sources[indexPath.row]
        if element is JWFileModel {
            if (element as! JWFileModel).file_type == .Dir {
                cell = "JWFileDirCollectionViewCell"
            } else {
                cell = isGridLayout ? "JWFileItemGridCollectionViewCell" : "JWFileItemCollectionViewCell"
            }
        }
        
        return cell
    }
    
    func dispatchDataToCell(indexPath: IndexPath, data: Any?, cell: UICollectionViewCell) {
        
        
        guard let sourceArr = data as? Array<Any>, sourceArr.count != 0 else {
            return
        }
        
        if cell is JWFileTopSegmentCollectionViewCell {
            (cell as! JWFileTopSegmentCollectionViewCell).segmentItemClickClosure = segmentItemSwitchClosure
            (cell as! JWFileTopSegmentCollectionViewCell).currentItemType = .File
        }
        
        if sourceArr.count != 0 {
            let model = sources[indexPath.row]
            cell.configureModel(model: model)
        }
        
    }
}

//MARK: UICollectionViewDataSource UICollectionViewDelegate
extension JWFileDetailFileListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(#function)
        //        if section == 0 {
        //            return sources[]s
        //        }
        return sources.count
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
            v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "JWFileCollectionReusableViewHeader", for: indexPath)
            v.clipsToBounds = true
            (v as! JWFileCollectionReusableViewHeader).allFiles.backgroundColor = isGridLayout ? UIColor(hexString: "f6f6f6") : UIColor.white
            (v as! JWFileCollectionReusableViewHeader).allFiles.sortClosure = {
                
                let sortVC = JWFileSortViewController()
                sortVC.modalPresentationStyle = .overFullScreen
                sortVC.sortOption = self.sortOption
                sortVC.determineClosure = { (sortOption) in
                    self.sortOption = sortOption
                    self.refresh()
                }
                self.present(sortVC, animated: true, completion: nil)
            }
        }
        return v
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        JWFileLog(messgae: "didSelectItemAt\(indexPath.section) - \(indexPath.row)")
        guard let closure = didSelectedClosure else { return }
        guard sources.count != 0, indexPath.row <= sources.count-1  else { return }
        closure(collectionView, indexPath, sources[indexPath.row])
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let closure = scrollViewDidScrollClosure else { return }
        closure(scrollView)
        
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        
        JWFileLog(messgae: "scrollViewWillBeginDragging")
        
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        JWFileLog(messgae: "scrollViewDidEndDragging - willDecelerate")
        
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        JWFileLog(messgae: targetContentOffset.pointee.y)
        JWFileLog(messgae: velocity.y)
        
        if velocity.y > 0 {
            
            
            //            topItemBar.snp.updateConstraints { (make) in
            //                make.top.equalToSuperview().offset(-88)
            //            }
            //
            //
        }else {
            
            //            topItemBar.snp.updateConstraints { (make) in
            //                make.top.equalToSuperview()
            //            }
            //            UIView.animate(withDuration: 0.5) {
            //                self.view.layoutIfNeeded()
            //            }
            
            
        }
        
    }
    
}
