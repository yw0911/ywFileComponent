//
//  JWFileBaseTableViewCell.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/20.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileBaseTableViewCell: UITableViewCell {
    
    lazy var bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = lineColor
        return bottomLine
    }()
    
    
    var lineColor:UIColor = UIColor(hexString: "e7e7e7")
    
    var separatorLineInset: UIEdgeInsets = .zero {
        didSet {
            
            bottomLine.snp.updateConstraints { (make) in
                make.left.equalToSuperview().offset(separatorLineInset.left)
                make.right.equalToSuperview().offset(-separatorLineInset.right)
                make.bottom.equalToSuperview().offset(separatorLineInset.bottom)
                make.height.equalTo(1)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
}
