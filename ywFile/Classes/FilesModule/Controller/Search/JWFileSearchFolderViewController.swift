//
//  JWFileSearchFolderViewController.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/22.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileSearchFolderViewController: JWFileBaseViewController {
    
    lazy var titleView: JWFileNaviTextFiled = {
        let titleView = JWFileNaviTextFiled.init(frame: CGRect(x: 0, y: 0, width: screenWidth-82, height: 36), placeHolder: "搜索", image: UIImage.image(JWFNamed: "file_search_s"), placeHolderColor: UIColor(hexString: "b0b0b0"), background: UIColor(hexString: "f1f1f1"))
        titleView.setCornerRadius(radius: 8)
        return titleView
    }()
    
    lazy var dirTableView: UITableView = {
        let dirTableView = UITableView.init(frame: .zero, style: .plain)
        dirTableView.delegate = self
        dirTableView.dataSource = self
        dirTableView.tableFooterView = UIView()
        dirTableView.backgroundColor = UIColor(hexString: "e7e7e7")
        
        dirTableView.register(JWFileChoosePositionTableViewCell.self, forCellReuseIdentifier: "JWFileChoosePositionTableViewCell")
        dirTableView.mj_footer = MJRefreshBackStateFooter.init(refreshingBlock: { [weak self] in
            self?.loadMore()
        })
        
        return dirTableView
    }()
    
    var sources: Array<Any>?
    var accessToken:String?
    var folderID:String?
    var keyWord:String? {
        didSet {
            refresh()
        }
    }
    var determineCallBackClosure: ((JWFileSearchFolder) -> Void)?
    var rootPresentingVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNaviBar()
        configureSubView()
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: titleView, queue: .main) { [weak self] (notification) in
            
            let obj = notification.object as? JWFileNaviTextFiled
            self?.keyWord = obj?.text
        }
        
        didSelectedClosure = {[weak self] (tableView, indexPath, data) in
            
            self?.cancel()
            if let folder = data as? JWFileSearchFolder {
                guard let closure = self?.determineCallBackClosure else { return }
                closure(folder)
            }
            
        }
        
        
    }
    
    override func configureSubView() {
        
        view.addSubview(dirTableView)
        dirTableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    
    func configureNaviBar() {
        
        navigationItem.titleView = titleView
        navigationController?.navigationBar.isTranslucent = false
        
        let cancelLabel = UILabel()
        
        cancelLabel.jw_File_configureLabel(text: "取消", fontName: PFSC_R, fontSize: 16, textColor: UIColor(hexString: "333333"))
        let cancelItem = UIBarButtonItem.init(title: "取消", style:.plain, target: self, action: #selector(cancel))
        cancelItem.tintColor = UIColor(hexString: "333333")
        navigationItem.rightBarButtonItems = [cancelItem];
    }
    
    @objc func cancel() {
        
        rootPresentingVC?.dismiss(animated: true, completion: nil)
    }
    
    
    func loadData() {
        
        guard let token = accessToken else { return }
        
        fetchDirs(token: token)
    }
    
    
}



//MARK: Request
extension JWFileSearchFolderViewController {
    
    func fetchDirs(token:String) {
        
        SessionManager.request(api: JWFileModuleSearchAPI.getSubDir(
            token: token,
            category: nil,
            folder_name: keyWord,
            folder_id: folderID,
            pageno: currentPage,
            pagesize: pageSize),
                               serializeClass: JWFileSearchFolderListModel.self) { (respone) in
                                
                                JWFileLog(messgae: respone.data)
                                
                                if respone.statusCode == .success {
                                    
                                    self.appendDataInArray(remoteSource: respone.data?.JMSearchFolders)
                                }
        }
        
    }
    
    
    
}



//MARK: JWFileListRefreshProtocol
extension JWFileSearchFolderViewController: JWFileListRefreshProtocol {
    
    typealias E = Array<Any>?
    
    func appendDataInArray(remoteSource: E) {
        
        endReFresh()
        guard let element = remoteSource, element.count != 0  else {
            //没有更多数据
            dirTableView.mj_footer?.endRefreshingWithNoMoreData()
            return
        }
        
        if currentPage == 0 {
            sources = element
            dirTableView.reloadData()
        } else {
            
            var insertIndexs: Array<IndexPath> = []
            for idx in sources!.count ..< sources!.count.advanced(by: element.count) {
                insertIndexs.append(IndexPath.init(row: idx, section: 0))
            }
            sources?.append(contentsOf: element)
            dirTableView.insertRows(at: insertIndexs, with: .none)
        }
    }
    
    
    func refresh() {
        
        dirTableView.mj_footer?.resetNoMoreData()
        currentPage = 0
        loadData()
    }
    
    func loadMore() {
        currentPage += 1
        loadData()
    }
    
    func endReFresh() {
        
        if (dirTableView.mj_header != nil) {
            dirTableView.mj_header?.endRefreshing()
        }
        if (dirTableView.mj_footer != nil) {
            dirTableView.mj_footer?.endRefreshing()
        }
    }
    
}





//MARK: UITableViewDataSource UITableViewDelegate
extension JWFileSearchFolderViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "JWFileChoosePositionTableViewCell", for: indexPath)
        cell.selectionStyle = .none
        dispatchDataToCell(indexPath: indexPath, data: sources?[indexPath.row], cell: cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let closure = didSelectedClosure else { return }
        closure(tableView, indexPath, sources?[indexPath.row])
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

extension JWFileSearchFolderViewController: JWFileConfigureTableProtocol {
    func getReusedIndentifier(indexPath: IndexPath) -> String {
        return "JWFileChoosePositionTableViewCell"
    }
    
    func dispatchDataToCell(indexPath: IndexPath, data: Any?, cell: UITableViewCell) {
        
        guard let model = data else { return }
        if cell is JWFileChoosePositionTableViewCell {
            (cell as! JWFileChoosePositionTableViewCell).hightlightChar = keyWord
        }
        cell.configureModel(model: model)
        
    }
    
    
}
