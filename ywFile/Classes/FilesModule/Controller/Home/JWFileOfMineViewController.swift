//
//  JWFileOfMineViewController.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/7.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

public class JWFileOfMineViewController: JWFileBaseViewController {
    
    
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
            
            filesCollection.reloadSections(IndexSet(integer: 1))
            filesCollection.backgroundColor = isGridLayout ? UIColor(hexString: "f6f6f6") : UIColor.white
        }
    }
    
    var sources:Array<Array<Any>> = [[JWFilePlaceHolderModel()]]
    
    var accessToken: String?
    var scrollViewDidScrollClosure: ((_ scrollView:UIScrollView) -> Void)?
    var segmentItemSwitchClosure: ((JWFileTopItemBar.ItemType) -> Void)?
    var sortOption: JWFileSortOption = .init(sort: .JWFileSort_Updated_at, seq: .JWFileSeq_DESC, type: .FileMeta_All)
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSubView()
        loadData()
        
        didSelectedClosure = { [weak self] (listView, indexPath, data)in
            
            JWFileLog(messgae: "didSelectedClosure")
            if data is JWFileContactOfShare {
                //                let contactFilesVC = JWFileDetailFileListViewController()
                //                contactFilesVC.dirName = (data as!JWFileContactOfShare).name
                //                self?.navigationController?.pushViewController(contactFilesVC, animated: true)
            } else if data is JWFileModel {
                
                let fileModel = data as!JWFileModel
                guard fileModel.file_type == .Dir else { return }
                let contactFilesVC = JWFileDetailFileListViewController()
                contactFilesVC.dirName = fileModel.name
                contactFilesVC.accessToken = self?.accessToken
                contactFilesVC.folderID = fileModel.id
                contactFilesVC.searchFilterConfigure = JWFileSearchFilterConfigure.init(route: .Dir, dimension: .FD_FileType_Owner, fileSpace: .FileSpace_Own)
                //                contactFilesVC.currentFileSpace = .FileSpace_Own
                //                contactFilesVC.isSubDir = true
                self?.navigationController?.pushViewController(contactFilesVC, animated: true)
                
            }
        }
        
    }
    
    override func configureSubView() {
        
        view.addSubview(filesCollection)
        filesCollection.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    
    
    func loadData() {
        guard let token = accessToken else { return }
        reqestMyFile(token: token)
    }
    
    func reqestMyFile(token:String) {
        
        JWFileLog(messgae: "========================================")
        var lroFiles: Array<Any>!
        var allFiles: Array<Any>!
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "JWFilesList.request", qos: .userInteractive, attributes: .concurrent)
        group.enter()
        queue.async(group: group) {
            
            JWFileLog(messgae: "task 1 start")
            self.requestLROList(token: token) { (element) in
                
                lroFiles = element
                group.leave()
                JWFileLog(messgae: "task 1 finshed")
            }
        }
        group.enter()
        queue.async(group: group) {
            JWFileLog(messgae: "task 2 start")
            self.requestFileList(token: token) { (element) in
                
                allFiles = element
                group.leave()
                JWFileLog(messgae: "task 2 finshed")
            }
            
        }
        
        group.notify(queue: DispatchQueue.main) {
            
            self.appendDataInArray(remoteSource: [[JWFilePlaceHolderModel(),lroFiles], allFiles as Any])
            JWFileLog(messgae: "reload")
            
        }
    }
    
    func resetSortOption() {
        
        sortOption = JWFileSortOption.init(sort: .JWFileSort_Updated_at, seq: .JWFileSeq_DESC, type: .FileMeta_All)
    }
    
    
}

extension JWFileOfMineViewController {
    
    //MARK: 最近打开的文件
    func requestLROList(token:String, completeClosure:@escaping (Array<Any>)->Void)  {
        
        var temp : Array<Any> = []
        SessionManager.request(api: JWFileModuleAPI.getLROFiles(token: token), serializeClass: JWFileListModel.self) { (respone) in
            
            JWFileLog(messgae: respone.data)
            
            if respone.statusCode == .success {
                
                if let files = respone.data?.JMFiles {
                    temp = files
                }
                //                guard let files = respone.data?.JMFiles else {
                ////                    self.sources.append([])
                ////                    temp = files
                //                    return temp
                //                }
                //                self.sources.append(files)
            }
            completeClosure(temp)
        }
        
    }
    
    //MARK: 文件list
    func requestFileList(token:String, completeClosure:@escaping (Array<Any>)->Void)   {
        
        var temp : Array<Any> = []
        SessionManager.request(api: JWFileModuleAPI.getMyFiles(
            token: token,
            sort: sortOption.sort.rawValue,
            seq: sortOption.seq.rawValue,
            type: sortOption.type.rawValue,
            folder_id: nil,
            pageno: currentPage,
            pagesize: pageSize),
                               serializeClass: JWFileListModel.self) { (respone) in
                                print(respone)
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
extension JWFileOfMineViewController: JWFileListRefreshProtocol {
    
    typealias E = Array<Any>?
    
    func appendDataInArray(remoteSource: E) {
        guard let element = remoteSource, element.count != 0  else {
            //没有更多数据
            filesCollection.mj_footer?.endRefreshingWithNoMoreData()
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
        guard let token = accessToken else { return }
        requestFileList(token: token) { (element) in
            self.appendDataInArray(remoteSource: element)
        }
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
extension JWFileOfMineViewController: JWFileListFlowLayoutDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: JWFileListFlowLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard sources.count != 0 else { return .zero }
        let element = sources[indexPath.section][indexPath.row]
        if element is JWFilePlaceHolderModel {
            return CGSize(width: screenWidth, height: 88)
        } else if element is Array<Any> {
            return CGSize(width: screenWidth, height: 211)
        } else if element is JWFileModel {
            if (element as! JWFileModel).file_type == .Dir {
                return isGridLayout ?  CGSize(width: (screenWidth - 38)/2, height: 60) :  CGSize(width: (screenWidth - 30), height: 60)
            }
            return isGridLayout ?  CGSize(width: (screenWidth - 38)/2, height: 146) :  CGSize(width: screenWidth-30, height: 60)
        }
        
        return .zero
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: JWFileListFlowLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return .zero
        }
        return CGSize(width: screenWidth, height: 75)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: JWFileListFlowLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return .zero
        }
        return UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: JWFileListFlowLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //        print(#function)
        if section == 0 {
            return 10
        }
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: JWFileListFlowLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        //        print(#function)
        
        if section == 0 {
            return 0
        }
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
extension JWFileOfMineViewController: JWFileConfigureCollectionProtocol {
    
    
    func getReusedIndentifier(indexPath: IndexPath) -> String {
        var cell:String!
        cell = "JWFileTopSegmentCollectionViewCell"
        guard sources.count != 0 else { return cell }
        let element = sources[indexPath.section][indexPath.row]
        if element is JWFilePlaceHolderModel {
            cell = "JWFileTopSegmentCollectionViewCell"
        } else if element is Array<Any> {
            cell = "JWFileLROCollectionViewCell"
        } else if element is JWFileModel {
            if (element as! JWFileModel).file_type == .Dir {
                cell = "JWFileDirCollectionViewCell"
            } else {
                cell = isGridLayout ? "JWFileItemGridCollectionViewCell" : "JWFileItemCollectionViewCell"
            }
        }
        
        return cell
    }
    
    func dispatchDataToCell(indexPath: IndexPath, data: Any?, cell: UICollectionViewCell) {
        
        
        guard let sourceArr = data as? Array<Array<Any>>, sourceArr.count != 0 else {
            return
        }
        
        if cell is JWFileTopSegmentCollectionViewCell {
            (cell as! JWFileTopSegmentCollectionViewCell).segmentItemClickClosure = segmentItemSwitchClosure
            (cell as! JWFileTopSegmentCollectionViewCell).currentItemType = .File
        }
        
        if sourceArr[indexPath.section].count != 0 {
            let model = sources[indexPath.section][indexPath.row]
            cell.configureModel(model: model)
        }
        
    }
    
    
}

//MARK: UICollectionViewDataSource UICollectionViewDelegate
extension JWFileOfMineViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        print(#function)
        return sources.count
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(#function)
        //        if section == 0 {
        //            return sources[]s
        //        }
        return sources[section].count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //        print(#function)
        JWFileLog(messgae: getReusedIndentifier(indexPath: indexPath))
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: getReusedIndentifier(indexPath: indexPath), for: indexPath)
        
        dispatchDataToCell(indexPath: indexPath, data: sources, cell: cell)
        
        
        return cell
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        JWFileLog(messgae: "didSelectItemAt\(indexPath.section) - \(indexPath.row)")
        guard let closure = didSelectedClosure else { return }
        guard sources.count != 0, indexPath.section <= sources.count-1, sources[indexPath.section].count != 0, indexPath.row <= sources[indexPath.section].count-1  else { return }
        closure(collectionView, indexPath, sources[indexPath.section][indexPath.row])
    }
    
    
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //        print(#function)
        var v = UICollectionReusableView()
        if kind == UICollectionView.elementKindSectionHeader {
            v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "JWFileCollectionReusableViewHeader", for: indexPath) as! JWFileCollectionReusableViewHeader
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
    
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let closure = scrollViewDidScrollClosure else { return }
        closure(scrollView)
        
    }
    
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        
        JWFileLog(messgae: "scrollViewWillBeginDragging")
        
    }
    
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        JWFileLog(messgae: "scrollViewDidEndDragging - willDecelerate")
        
    }
    
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
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
