//
//  JWFileConditionEntriesView.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/14.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileConditionEntriesView: UIView {
    
    
    let title: UILabel = {
        let title = UILabel()
        title.jw_File_configureLabel(fontName: PFSC_R, fontSize: 14, textColor: UIColor.white)
        
        return title
    }()
    
    let entriesButton: UIButton = {
        let entriesButton = UIButton.init(type: .custom)
        //        entriesButton.setTitle("高国盛等2人", for: .normal)
        //        entriesButton.setImage(UIImage(named: "file_filter_close"), for: .normal)
        entriesButton.addTarget(self, action: #selector(clearEntries), for: .touchUpInside)
        return entriesButton
    }()
    
    let close: UIImageView = {
        let close = UIImageView()
        close.image = UIImage(named: "file_filter_close")
        return close
    }()
    
    var clearOwnerEntriesClosure:(()->Void)?
    
    init() {
        super.init(frame: .zero)
        
        addSubview(entriesButton)
        entriesButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 7, left: 12, bottom: 7, right: 12))
        }
        addSubview(title)
        addSubview(close)
        title.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        
        close.snp.makeConstraints { (make) in
            make.left.equalTo(title.snp.right).offset(6)
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func clearEntries() {
        
        guard let closure = clearOwnerEntriesClosure else { return }
        closure()
        
        
    }
    
    
}
