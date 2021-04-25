//
//  JWFileSearchBar.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/9.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileSearchBar: UIView {
    
    let icon: UIImageView = {
        let icon =  UIImageView(image: UIImage.image(JWFNamed: "file_search_s"))
        return icon
    }()
    let title: UILabel = {
        let title = UILabel()
        title.jw_File_configureLabel(fontName: PFSC_L, fontSize: 14, textColor: UIColor(hexString: "b0b0b0"))
        return title
    }()
    
    lazy var tapButton: UIButton = {
        
        let tapButton = UIButton.init(type: .custom)
        tapButton.addTarget(self, action: #selector(tap), for: .touchUpInside)
        return tapButton
    }()
    
    var tapClosure:(()->Void)?
    
    init(searchTip:String) {
        self.title.text = searchTip
        super.init(frame: .zero)
        
        layer.masksToBounds = false
        addSubview(icon)
        addSubview(title)
        addSubview(tapButton)
        
        icon.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        
        title.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(7)
            make.centerY.equalTo(icon)
        }
        
        tapButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //        addShadow(shadowColor: UIColor.black, shadowOffset: CGSize(width: 0, height: 10), shadowRadius: 7)
    }
    
    @objc func tap() {
        
        guard let closure = tapClosure else { return }
        closure()
        
    }
    

}
