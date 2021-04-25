//
//  UIView.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/3/31.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import Foundation

extension UIView {
    
    func setCornerRadius(radius:CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    func addShadow(shadowColor:UIColor, shadowOffset: CGSize = CGSize(width: 0, height: -3), shadowRadius:CGFloat = 0, shadowOpacity: Float = 1) {
        
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        
    }
    
    
    func addCornerLayer(rectCorner:UIRectCorner = .allCorners, radius:CGFloat) {
        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: rectCorner, cornerRadii: CGSize(width: radius, height: radius))
        
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
}
