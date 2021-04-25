//
//  JWFileSortTableViewCell.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/21.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileSortTableViewCell: JWFileBaseTableViewCell {
    
    let title: UILabel = {
        let title = UILabel()
        title.jw_File_configureLabel(fontName: PFSC_R, fontSize: 16, textColor: UIColor(hexString: "999999"))
        return title
    }()
    
    let icon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "file_arrowhead")
        return icon
    }()
    
    let selectedIcon: UIImageView = {
        let selectedIcon = UIImageView()
        selectedIcon.image = UIImage(named: "file_selected")
        return selectedIcon
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        configureSubView()
        
    }
    
    override func configureSubView() {
        contentView.addSubview(title)
        contentView.addSubview(icon)
        contentView.addSubview(selectedIcon)
        
        title.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(15)
        }
        
        icon.snp.makeConstraints { (make) in
            make.left.equalTo(title.snp.right).offset(10)
            make.centerY.equalTo(title)
        }
        
        selectedIcon.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(sortModel:JWFileTimeSortItem, selected:Bool) {
        
        title.text = sortModel.title
        icon.isHidden = !selected
        selectedIcon.isHidden = !selected
        
    }
    
    
}
