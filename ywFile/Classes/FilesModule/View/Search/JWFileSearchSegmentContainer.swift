//
//  JWFileSearchSegmentContainer.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/4/13.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileSearchSegmentContainer: UIView {
    
    
    let segment: JWFileSegment = {
        let segment = JWFileSegment()
        return segment
    }()
    
    lazy var filter: UIButton = {
        let filter = UIButton.init(type: .custom)
        filter.setImage(UIImage(named: "file_filter"), for: .normal)
        filter.addTarget(self, action: #selector(filter(sender:)), for: UIControl.Event.touchUpInside)
        return filter
    }()
    
    
    var segmentOption: JWFileSegmentOption = JWFileSegmentOption() {
        
        willSet {
            segment.segmentOption = newValue
        }
    }
    
    var items:Array<JWFileSegmentItem>? {
        willSet {
            segment.items = newValue
        }
    }
    
    var didSegmentSelectedIndex: Int = 0 {
        didSet {
            segment.didSegmentSelectedIndex = didSegmentSelectedIndex
        }
    }
    
    var filterClosure: (()->Void)?
    var switchSegmentClosure: ((Int)->Void)? {
        didSet {
            segment.segmentDidSelectedClosure = switchSegmentClosure
        }
    }
    
    
    init() {
        super.init(frame: .zero)
        
        addSubview(segment)
        addSubview(filter)
        
        segment.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(filter.snp.left).offset(-5)
        }
        
        filter.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(15)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func filter(sender:UIButton) {
        
        guard let closure = filterClosure else { return }
        closure()
        
    }
    
}
