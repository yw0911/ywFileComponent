//
//  JWFileSortView.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/21.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileSortView: UIView {
    
    lazy var sortTable: UITableView = {
        let sortTable = UITableView.init(frame: .zero, style: .plain)
        sortTable.delegate = self
        sortTable.dataSource = self
        sortTable.separatorStyle = .none
        sortTable.register(JWFileSortTableViewCell.self, forCellReuseIdentifier: "JWFileSortTableViewCell")
        return sortTable
    }()
    
    lazy var header: JWFileConditionHeader = {
        let header = JWFileConditionHeader()
        header.didSelectedClosure = { [weak self] (index, item) in
            
            self?.didFileTypeSelectedIndex = index
        }
        
        return header
    }()
    
    lazy var bottomView: JWFileFilterResetBottomView = {
        
        let bottomView = JWFileFilterResetBottomView()
        bottomView.backgroundColor = UIColor.white
        bottomView.addShadow(shadowColor: UIColor.black.withAlphaComponent(0.06), shadowOffset: CGSize(width: 0, height: -2), shadowRadius: 4)
        
        bottomView.resetClosure = { [weak self] in
            
            self?.didFileTypeSelectedIndex = 0
            self?.didSortSelectedIndex = 0
            
            
        }
        
        return bottomView
    }()
    
    
    //MARK: 文件类型element
    var sortConditionItems: Array<JWFileConditionOptionItem>? {
        didSet {
            header.conditionItems = sortConditionItems
        }
    }
    
    var sortOption: JWFileConditionOption = JWFileConditionOption() {
        
        didSet {
            header.filterOption = sortOption
        }
    }
    
    
    var sortOfTimeItems: Array<JWFileTimeSortItem>? {
        didSet {
            UIView.performWithoutAnimation {
                sortTable.reloadData()
            }
        }
    }
    
    var didFileTypeSelectedIndex: Int = 0 {
        didSet {
            header.didConditionSelectedIndex = didFileTypeSelectedIndex
        }
    }
    
    var didSortSelectedIndex: Int = 0 {
        didSet {
            sortTable.reloadData()
        }
    }
    
    var bottomDetermineClickClosure:(()->Void)? {
        didSet {
            bottomView.determineClosure = bottomDetermineClickClosure
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        header.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 214)
        sortTable.tableHeaderView = header
        addSubview(sortTable)
        addSubview(bottomView)
        
        sortTable.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(214 + 57*2 + 58)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(sortTable.snp.bottom).offset(20)
            make.height.equalTo(49)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}


extension JWFileSortView: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortOfTimeItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JWFileSortTableViewCell", for: indexPath) as! JWFileSortTableViewCell
        guard let sortItems = sortOfTimeItems else { return cell }
        cell.configure(sortModel: sortItems[indexPath.row], selected: indexPath.row == didSortSelectedIndex)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView()
        let headerTitle = UILabel()
        headerTitle.jw_File_configureLabel(text: "排序", fontName: PFSC_B, fontSize: 20, textColor: UIColor(hexString: "333333"))
        header.addSubview(headerTitle)
        headerTitle.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(30)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        didSortSelectedIndex = indexPath.row
    }
    
}


struct JWFileTimeSortItem {
    
    var title:String
    var sort: JWFileSort
}
