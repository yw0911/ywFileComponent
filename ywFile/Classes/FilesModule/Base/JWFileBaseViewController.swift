//
//  JWFileBaseViewController.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/3/29.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

public class JWFileBaseViewController: UIViewController {
    
    var currentPage: Int = 0
    var pageSize: Int = 20
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    func configureSubView() {}
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    deinit {
        JWFileLog(messgae: "\(self)==== deinit")
    }
}
