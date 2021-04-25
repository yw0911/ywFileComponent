//
//  JWFileChoosePositionViewController.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/20.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileChoosePositionViewController: JWFileBaseViewController {
        
    lazy var searchView: JWFileSearchBar = {
        
        let search = JWFileSearchBar(searchTip: "搜索")
        search.backgroundColor = UIColor(hexString: "f1f1f1")
        search.setCornerRadius(radius: 8)
        search.tapClosure = { [weak self] in
            
            let searchFolderVC = JWFileSearchFolderViewController()
            searchFolderVC.accessToken = self?.accessToken
            searchFolderVC.folderID = self?.folder_id
            searchFolderVC.determineCallBackClosure = self?.determineCallBackClosure
            searchFolderVC.rootPresentingVC = self?.navigationController?.presentingViewController
            let containerNaviVC = UINavigationController.init(rootViewController: searchFolderVC)
            containerNaviVC.modalPresentationStyle = .fullScreen
            self?.present(containerNaviVC, animated: true, completion: nil)
        }
        return search
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
    
    lazy var headerViewTitle: UILabel = {
        let headerViewTitle = UILabel()
        headerViewTitle.text = "我的文件"
        headerViewTitle.jw_File_configureLabel(fontName: PFSC_R, fontSize: 16, textColor: UIColor(hexString: "b0b0b0"))
        return headerViewTitle
    }()
    
    lazy var footerViewButton: UIButton = {
        let footerViewButton = UIButton.init(type: .custom)
        footerViewButton.backgroundColor = UIColor(hexString: "333333")
        footerViewButton.setTitle("确定", for: .normal)
        footerViewButton.setTitleColor(UIColor.white, for: .normal)
        footerViewButton.addTarget(self, action: #selector(determine), for: .touchUpInside)
        return footerViewButton
    }()
    
    lazy var bottomView: UIView = {
        let bottomView = configureBottomView()
        return bottomView
    }()
    
    
    var sources: Array<Any>?
    var accessToken:String?
    var folder_id:String? {
        didSet {
            refresh()
        }
    }
    var category:String?
    var folder: JWFileSearchFolder? {
        didSet {
            headerViewTitle.text = folder?.folder_name
        }
    }
    
    
    var determineCallBackClosure: ((JWFileSearchFolder) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        configureNaviBar()
        configureSubView()
        
        didSelectedClosure = {[weak self] (tableView, indexPath, data) in
            
            if let folderModel = data as? JWFileSearchFolder {
                
                self?.pushChooseDirVC(token: self?.accessToken, folder: folderModel)
            }
            
        }
        
        guard folder != nil else {
            configureDefaultSource()
            dirTableView.mj_footer = nil
            return
        }
    }
    
    func configureNaviBar() {
        
        
        let titleLabel = UILabel()
        titleLabel.jw_File_configureLabel(text: "选择目标文件夹", fontName: PFSC_B, fontSize: 19, textColor: UIColor(hexString: "333333"))
        navigationItem.titleView = titleLabel
        
        let cancelLabel = UILabel()
        cancelLabel.jw_File_configureLabel(text: "取消", fontName: PFSC_R, fontSize: 16, textColor: UIColor(hexString: "333333"))
        let cancelItem = UIBarButtonItem.init(title: "取消", style:.plain, target: self, action: #selector(cancel))
        cancelItem.tintColor = UIColor(hexString: "333333")
        navigationItem.rightBarButtonItems = [cancelItem];
    }
    
    override func configureSubView() {
        
        view.addSubview(searchView)
        view.addSubview(dirTableView)
        
        
        searchView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(2)
            make.right.equalToSuperview().offset(-1)
            make.height.equalTo(36)
        }
        
        dirTableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        guard folder != nil else { return }
        
        
        let tableHeaderView = configureTableHeaderView()
        tableHeaderView.backgroundColor = UIColor.white
        tableHeaderView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 56)
        dirTableView.tableHeaderView = tableHeaderView
        
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(49)
        }
        
        dirTableView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
    }
    
    func configureTableHeaderView() -> UIView {
        
        let headerView = UIView()
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor(hexString: "e7e7e7")
        headerView.addSubview(headerViewTitle)
        headerView.addSubview(bottomLine)
        headerViewTitle.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(17)
        }
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        return headerView
    }
    
    
    func configureBottomView() -> UIView {
        
        let bottomView = UIView()
        bottomView.addSubview(footerViewButton)
        footerViewButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return bottomView
    }
    
    
    @objc func cancel() {
        
        navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    
    @objc func determine() {
        
        cancel()
        guard let closure = determineCallBackClosure else { return }
        closure(folder!)
    }
    
    
    func configureDefaultSource() {
        
        
        sources = [JWFileSearchFolder(folder_id: "my", folder_name: "我的文件", category: "my"),
                   JWFileSearchFolder( folder_id: "share", folder_name: "共享给我的", category: "share")]
    }
    
    
    func pushChooseDirVC(token:String?, folder:JWFileSearchFolder?) {
        
        let chooseVC = JWFileChoosePositionViewController()
        chooseVC.accessToken = token
        chooseVC.category = folder?.category
        chooseVC.folder_id = folder?.folder_id
        chooseVC.folder = folder
        chooseVC.determineCallBackClosure = determineCallBackClosure
        navigationController?.pushViewController(chooseVC, animated: true)
        
    }
    
    func loadData()  {
        guard let token = accessToken else { return }
        fetchDirs(token: token)
    }
    
}





//MARK: Request
extension JWFileChoosePositionViewController {
    
    func fetchDirs(token:String) {
        
        
        
        SessionManager.request(api: JWFileModuleSearchAPI.getSubDir(
            token: token,
            category: folder?.category,
            folder_name:nil,
            folder_id: folder?.folder_id,
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
extension JWFileChoosePositionViewController: JWFileListRefreshProtocol {
    
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
extension JWFileChoosePositionViewController: UITableViewDataSource, UITableViewDelegate {
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




extension JWFileChoosePositionViewController: JWFileConfigureTableProtocol {
    func getReusedIndentifier(indexPath: IndexPath) -> String {
        return "JWFileChoosePositionTableViewCell"
    }
    
    func dispatchDataToCell(indexPath: IndexPath, data: Any?, cell: UITableViewCell) {
        
        guard let model = data else { return }
        cell.configureModel(model: model)
        
    }
    
}

