//
//  JWFileFilterconditionView.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/13.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileFilterConditionView: UIView {
    
    lazy var conditionTable: UITableView = {
        let conditionTable = UITableView.init(frame: .zero, style: .plain)
        conditionTable.delegate = self
        conditionTable.dataSource = self
        conditionTable.separatorStyle = .none
        conditionTable.register(JWFileConditionTableViewCell.self, forCellReuseIdentifier: "JWFileConditionTableViewCell")
        return conditionTable
    }()
    
    lazy var header: JWFileConditionHeader = {
        let header = JWFileConditionHeader()
        header.didSelectedClosure = { [weak self] (index, item) in
            
            self?.didConditionSelectedIndex = index
        }
        
        return header
    }()
    
    lazy var bottomView: JWFileFilterResetBottomView = {
        
        let bottomView = JWFileFilterResetBottomView()
        bottomView.backgroundColor = UIColor.white
        bottomView.addShadow(shadowColor: UIColor.black.withAlphaComponent(0.06), shadowOffset: CGSize(width: 0, height: -2), shadowRadius: 4)
        
        bottomView.resetClosure = { [weak self] in
            
            self?.didConditionSelectedIndex = 0
            
            let tempFilterPositionOrOwnerItems = self!.filterPositionOrOwnerItems?.map({ (element) -> JWFileFilterPositionOrOwnerItem in
                var newElement = element
                newElement.changeEntries(entries: nil)
                return newElement
            })
            self?.filterPositionOrOwnerItems = tempFilterPositionOrOwnerItems
            
        }
        
        return bottomView
    }()
    
    //MARK: 文件类型element
    var filterConditionItems: Array<JWFileConditionOptionItem>? {
        didSet {
            header.conditionItems = filterConditionItems
        }
    }
    
    var filterOption: JWFileConditionOption = JWFileConditionOption() {
        
        didSet {
            header.filterOption = filterOption
        }
    }
    
    var didConditionSelectedIndex: Int = 0 {
        didSet {
            header.didConditionSelectedIndex = didConditionSelectedIndex
        }
    }
    
    //MARK: 所属人/位置
    var filterPositionOrOwnerItems: Array<JWFileFilterPositionOrOwnerItem>? {
        didSet {
            updateTableViewHeightConstraint()
            UIView.performWithoutAnimation {
                conditionTable.reloadData()
            }
        }
    }
    
    //MARK: 文件类型选中闭包
    //    var headerViewConditionDidSelectedClosure:((Int, JWFileConditionOptionItem)->Void)? {
    //        didSet {
    //            header.didSelectedClosure = headerViewConditionDidSelectedClosure
    //        }
    //    }
    //MARK: 点击清除所属人
    var positionOrOwnerClickClosure:((Int, @escaping ((Any) -> Void)) -> Void)?
    //MARK: 点击确认
    var bottomDetermineClickClosure:(()->Void)? {
        didSet {
            bottomView.determineClosure = bottomDetermineClickClosure
        }
    }
    //    //MARK: 点击重置
    //    var bottomResetClickClosure:(()->Void)? {
    //        didSet {
    //            bottomView.resetClosure = bottomResetClickClosure
    //        }
    //    }
    
    //    var currentFileMetaItem: JWFileConditionOptionItem?
    
    var currentFileOwners: Array<Any>?
    var currentFilePosition: JWFileSearchFolder?
    
    init() {
        super.init(frame: .zero)
        
        header.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 214)
        conditionTable.tableHeaderView = header
        
        addSubview(conditionTable)
        addSubview(bottomView)
        conditionTable.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(214)
            make.bottom.equalTo(bottomView.snp.top).offset(-50)
        }
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(49)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTableViewHeightConstraint()  {
        guard let arr = filterPositionOrOwnerItems else { return }
        conditionTable.snp.updateConstraints { (make) in
            make.height.equalTo(214+70*arr.count)
        }
    }
}

//MARK: JWFileFilterConditionView UITableViewDelegate UITableViewDataSource
extension JWFileFilterConditionView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterPositionOrOwnerItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JWFileConditionTableViewCell", for: indexPath) as! JWFileConditionTableViewCell
        
        cell.clearOwnerEntriesClosure = { [weak self] (ownerCell) in
            
            guard let index = tableView.indexPath(for: ownerCell) else { return }
            guard var element = self?.filterPositionOrOwnerItems?[index.row] else { return }
            element.changeEntries(entries: nil)
            self?.filterPositionOrOwnerItems?[index.row] = element
            UIView.performWithoutAnimation {
                tableView.reloadRows(at: [index], with: .none)
            }
            
        }
        cell.selectionStyle = .none
        guard let element = filterPositionOrOwnerItems else { return cell }
        cell.configure(item: element[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let closure = positionOrOwnerClickClosure else { return }
        
        
        
        closure(indexPath.row) {[weak self] entries in
            
            self?.filterPositionOrOwnerItems?[indexPath.row].changeEntries(entries: entries)
            self?.conditionTable.rectForRow(at: indexPath)
            if let folder = entries as? JWFileSearchFolder {
                self?.currentFilePosition = folder
            }
            JWFileLog(messgae: "filePosition")
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}





class JWFileFilterResetBottomView: UIView {
    
    let reset: UIButton = {
        let reset = UIButton.init(type: .custom)
        reset.setTitle("重置", for: .normal)
        reset.setTitleColor(UIColor(hexString: "777777"), for: .normal)
        reset.titleLabel?.font = UIFont(name: PFSC_R, size: 15)
        reset.backgroundColor = UIColor.white
        reset.addTarget(self, action: #selector(resetOptions), for: .touchUpInside)
        return reset
    }()
    
    let determine: UIButton = {
        let determine = UIButton.init(type: .custom)
        determine.setTitle("确认", for: .normal)
        determine.setTitleColor(UIColor.white, for: .normal)
        determine.titleLabel?.font = UIFont(name: PFSC_R, size: 15)
        determine.backgroundColor = UIColor(hexString: "333333")
        determine.addTarget(self, action: #selector(determineOption), for: .touchUpInside)
        return determine
    }()
    
    var resetClosure:(()->Void)?
    var determineClosure:(()->Void)?
    
    init() {
        super.init(frame: .zero)
        addSubview(reset)
        addSubview(determine)
        
        reset.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        
        determine.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(reset.snp.right)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func resetOptions() {
        guard let closure = resetClosure else { return }
        closure()
    }
    @objc func determineOption() {
        guard let closure = determineClosure else { return }
        closure()
    }
}





//MARK: Option

struct JWFileFilterPositionOrOwnerItem {
    
    enum ConditionType {
        case Position
        case Owner
    }
    
    var title:String
    var placeHolder:String
    var type: ConditionType
    var entries: Any?
    
    
    mutating func changeEntries(entries:Any?) {
        self.entries = entries
    }
    
}

struct JWFileConditionOptionItem {
    
    var title:String
    var fileType:JWFileMetaType
    
}

struct JWFileFilterOptionState {
    var titleFont: UIFont
    var titleTextColor: UIColor
    var backgroudColor: UIColor
    init(titleFont: UIFont = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize), titleTextColor:UIColor = .black, backgroud:UIColor = .gray) {
        
        self.titleFont = titleFont
        self.titleTextColor = titleTextColor
        self.backgroudColor = backgroud
    }
}

typealias JWFileFilterStates = (defaultState:JWFileFilterOptionState, selectedState:JWFileFilterOptionState)
struct JWFileConditionOption {
    
    var state: JWFileFilterStates
    
    init(state:JWFileFilterStates = JWFileFilterStates(defaultState: JWFileFilterOptionState(), selectedState:JWFileFilterOptionState())) {
        self.state = state
    }
    
}
