//
//  UILabel.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/3/26.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import Foundation

extension UILabel {
    
    func jw_File_configureLabel(fontName:String? , fontSize:CGFloat ,textColor color:UIColor , alignment:NSTextAlignment = NSTextAlignment.left)  {
        if let name = fontName {
            self.font = UIFont.init(name: name, size: fontSize)
        }else {
            self.font = UIFont.systemFont(ofSize: fontSize)
        }
        textColor = color
        textAlignment = alignment
    }
    
    func jw_File_configureLabel(text:String? , fontName:String? , fontSize:CGFloat ,textColor color:UIColor , alignment:NSTextAlignment = NSTextAlignment.left) {
        jw_File_configureLabel(fontName: fontName, fontSize: fontSize, textColor: color, alignment: alignment)
        self.text = text
    }
    
    convenience init(text:String? = nil , fontName:String? , fontSize:CGFloat ,textColor color:UIColor , alignment:NSTextAlignment = NSTextAlignment.left) {
        self.init()
        jw_File_configureLabel(text:text, fontName: fontName, fontSize: fontSize, textColor: color, alignment:alignment)
    }
    
    func jw_File_caculatorWidth() -> CGFloat {
        
        sizeToFit()
        return frame.width
    }
    
    
}
