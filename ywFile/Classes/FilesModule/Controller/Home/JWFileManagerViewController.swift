//
//  FileListViewController.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/3/26.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit
import SnapKit

class JWFileManagerViewController: UIViewController {
    
    lazy var JW_LROView = JWFileLROView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviBar()
        configureSubView()
    }
    
    func configureNaviBar() {
        
        let searchItem = UIBarButtonItem.init(image: UIImage.image(JWFNamed: "file_search")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(fileSearch))
        
        let switchLayoutItem = UIBarButtonItem.init(image: UIImage.image(JWFNamed: "file_gridLayout")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(fileSearch))
        navigationItem.rightBarButtonItems = [switchLayoutItem, searchItem];
    }
    
    
    func configureSubView()  {
        
        view.backgroundColor = UIColor.white
        let topItemBar = JWFileTopItemBar();
        view.addSubview(topItemBar)
        view.addSubview(JW_LROView)
        topItemBar.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(88)
        }
        JW_LROView.backgroundColor = UIColor(hexString: "F6F6F6")
        JW_LROView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topItemBar.snp.bottom)
            make.height.equalTo(211)
        }
        
    }
    
    
    @objc func fileSearch() {
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
