//
//  UIKit.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/2.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import Foundation

extension UICollectionViewCell {
    
    @objc func configureSubView() {}
    @objc func configureModel(model:Any) {}
}


extension UICollectionView {
    
    func registerCellClassFromStrings(strings:Array<String>) {
        strings.forEach { (className) in
            register(className.classFormName(type: UICollectionViewCell.self), forCellWithReuseIdentifier: className)
        }
    }
}

var UIViewListDidSelectedClosureKey = "UICollectionViewDidSelectedClosureKey"
extension UIViewController {
    
    private var _didSelectedClosure: ((_ listView:UIView, _ indexPath:IndexPath, _ data:Any?)->Void)? {
        get {
            (objc_getAssociatedObject(self, &UIViewListDidSelectedClosureKey) as! (UIView, IndexPath, Any?) -> Void)
        }
        set {
            
            objc_setAssociatedObject(self, &UIViewListDidSelectedClosureKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    var didSelectedClosure:((_ listView:UIView, _ indexPath:IndexPath, _ data:Any?)->Void)? {
        get {
            return _didSelectedClosure
        }
        set {
            _didSelectedClosure = newValue
        }
    }
}


extension UITableViewCell {
    
    @objc func configureSubView() {}
    @objc func configureModel(model:Any) {}
}



extension UIImage {
    static func imageWithColor(_ color:UIColor, rect:CGRect = CGRect.init(x: 0, y: 0, width: 1, height: 1)) -> UIImage {
        UIGraphicsBeginImageContext(rect.size)
        color.set()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
        
    static func image(JWFNamed:String) -> UIImage? {

        return UIImage(named: JWFNamed, in: Bundle.currentBundle(), compatibleWith: nil)
    }
}


