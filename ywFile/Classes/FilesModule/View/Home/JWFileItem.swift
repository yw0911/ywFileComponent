//
//  JWFileItem.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/3/26.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileItem: UIView {
    
    lazy var innerButton: UIButton = {
        let innerButton = UIButton.init(type: .custom)
        innerButton.addTarget(self, action: #selector(choose(sender:)), for: .touchUpInside)
        return innerButton
    }()
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    lazy var title: UILabel = {
        let title = UILabel()
        title.jw_File_configureLabel(fontName: PFSC_R, fontSize: 12, textColor: UIColor(hexString: "333333"))
        return title
    }()
    
    var isSelected = false {
        willSet {
            image.image = newValue ? selectedImage : normalImage
            title.textColor = newValue ? selectedColor : normalColor
        }
    }
    
    private var normalColor:UIColor? {
        willSet {
            guard isSelected else {
                title.textColor = newValue
                return
            }
        }
    }
    private var selectedColor:UIColor? {
        willSet {
            guard !isSelected else {
                title.textColor = newValue
                return
            }
        }
    }
    private var normalImage:UIImage? {
        willSet {
            guard isSelected else {
                image.image = newValue
                return
            }
        }
    }
    private var selectedImage:UIImage? {
        willSet {
            guard !isSelected else {
                image.image = newValue
                return
            }
        }
    }
    
    private var normalTitle:String? {
        willSet {
            guard isSelected else {
                title.text = newValue
                return
            }
        }
    }
    
    private var selectedTitle:String? {
        willSet {
            guard !isSelected else {
                title.text = newValue
                return
            }
        }
    }
    
    var clickClosure: ((JWFileItem)->Void)?
    
    
    func setImage(normalImage image:UIImage?)  {
        
        normalImage = image
        guard selectedImage != nil else {
            selectedImage = normalImage
            return
        }
    }
    
    func setSelectedImage(selectedImage image:UIImage?)  {
        selectedImage = image
    }
    
    func setTitleTextColor(normalColor color:UIColor?)  {
        normalColor = color
        guard selectedColor != nil else {
            selectedColor = normalColor
            return
        }
    }
    
    func setSelectedTitleTextColor(selectedColor color:UIColor?)  {
        selectedColor = color
    }
    
    func setTitle(normalTitle title:String?) {
        normalTitle = title
        guard selectedTitle != nil else {
            selectedTitle = normalTitle
            return
        }
    }
    
    func setSelectedTitle(selectedTitle title:String?) {
        selectedTitle = title
    }
    
    init() {
        super.init(frame: .zero)
        
        addSubview(innerButton)
        addSubview(image)
        addSubview(title)
        innerButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        image.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(30)
        }
        
        title.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview().offset(0)
            make.top.equalTo(image.snp.bottom).offset(6)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func choose(sender:UIButton) {
        if isSelected {
            return
        }
        //        self.isSelected = true
        guard let closure = clickClosure else { return }
        closure(self)
    }
    
}
