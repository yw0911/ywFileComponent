//
//  JWFileNaviTextFiled.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/9.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileNaviTextFiled: UITextField {
    
    init(frame:CGRect, placeHolder:String?, image: UIImage?, placeHolderColor:UIColor, background:UIColor?) {
        super.init(frame: frame)
        
        let leftImage = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 14, height: 14))
        
        leftImage.image = image
        
        leftView = leftImage
        leftViewMode = .always
        placeholder = placeHolder
        clearButtonMode = .whileEditing
        let attributeString = NSAttributedString.init(string: placeHolder!, attributes:  [NSAttributedString.Key.foregroundColor : placeHolderColor, NSAttributedString.Key.font : UIFont(name: PFSC_R, size: 17)!])
        
        attributedPlaceholder = attributeString
        backgroundColor = background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 10, y: (bounds.height-14)*0.5, width: 14, height: 14)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets.init(top: 0, left: 30, bottom: 0, right: 0))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets.init(top: 0, left: 30, bottom: 0, right: 22))
    }
    
    //    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
    //        return bounds
    //    }
    
    
}
