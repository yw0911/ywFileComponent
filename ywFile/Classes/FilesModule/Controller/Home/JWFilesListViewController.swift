//
//  JWFilesListViewController.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/3/26.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit
import MJRefresh

public class JWFilesListViewController: JWFileBaseViewController {
    
    var offset: CGPoint = .zero
    
    lazy var topItemBar: JWFileTopItemBar = {
        let itemBar = JWFileTopItemBar(inset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
        itemBar.didSeletedWithType(type: .File)
        itemBar.backgroundColor = UIColor.white
        itemBar.itemClickClosure = {[weak self](type) in
            print("item type is \(type.rawValue)")
            self?.currentItemType = type
            self?.switchItemVc(type: type)
        }
        return itemBar
    }()
    
    lazy var myFileVC: JWFileOfMineViewController = {
        let vc = JWFileOfMineViewController()
        vc.scrollViewDidScrollClosure = { [weak self] (scrollView) in
            
            self?.headerHiddenAnimation(scrollView: scrollView)
            
        }
        
        vc.segmentItemSwitchClosure = { [weak self] (type) in
            
            self?.switchItemVc(type: type)
        }
        
        return vc
    }()
    
    
    lazy var shareMeVC: JWFileShareMeListViewController = {
        let vc = JWFileShareMeListViewController()
        vc.scrollViewDidScrollClosure = { [weak self] (scrollView) in
            
            self?.headerHiddenAnimation(scrollView: scrollView)
        }
        
        vc.segmentItemSwitchClosure = { [weak self] (type) in
            
            self?.switchItemVc(type: type)
        }
        return vc
    }()
    
    
    lazy var favouriteVC: JWFileFavouriteViewController = {
        let vc = JWFileFavouriteViewController()
        vc.scrollViewDidScrollClosure = { [weak self] (scrollView) in
            
            self?.headerHiddenAnimation(scrollView: scrollView)
        }
        
        vc.segmentItemSwitchClosure = { [weak self] (type) in
            
            self?.switchItemVc(type: type)
        }
        return vc
    }()
    
    lazy var trashVC: JWFileTrashViewController = {
        let vc = JWFileTrashViewController()
        vc.scrollViewDidScrollClosure = { [weak self] (scrollView) in
            
            self?.headerHiddenAnimation(scrollView: scrollView)
        }
        
        vc.segmentItemSwitchClosure = { [weak self] (type) in
            
            self?.switchItemVc(type: type)
        }
        return vc
    }()
    
    var isGridLayout = true {
        willSet{
            print(newValue)
            myFileVC.isGridLayout = newValue
            shareMeVC.isGridLayout = newValue
            favouriteVC.isGridLayout = newValue
            trashVC.isGridLayout = newValue
        }
        didSet{
            print(oldValue)
        }
    }
    
    private var _currentItemType:JWFileTopItemBar.ItemType = .File
    var currentItemType:JWFileTopItemBar.ItemType = .File {
        willSet{
            _currentItemType = newValue
        }
        
        didSet {
            
        }
        
    }
    
    var accessToken: String? {
        willSet {
            myFileVC.accessToken = newValue
            shareMeVC.accessToken = newValue
            favouriteVC.accessToken = newValue
            trashVC.accessToken = newValue
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        configureNaviBar()
        configureSubView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JWFileLog(messgae: "viewWillAppear")
    }
    
    override func configureSubView() {
        
        addChild(trashVC)
        addChild(favouriteVC)
        addChild(shareMeVC)
        addChild(myFileVC)
        
        view.addSubview(trashVC.view)
        view.addSubview(favouriteVC.view)
        view.addSubview(shareMeVC.view)
        view.addSubview(myFileVC.view)
        
        trashVC.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        favouriteVC.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        myFileVC.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        shareMeVC.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        view.addSubview(topItemBar)
        topItemBar.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(-88)
            make.height.equalTo(88)
        }
        
        
        
    }
    
    func configureNaviBar() {
        
        let searchItem = UIBarButtonItem.init(image: UIImage.image(JWFNamed: "file_search")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(fileSearch))
        
        let switchLayoutItem = UIBarButtonItem.init(image: UIImage.image(JWFNamed: "file_gridLayout")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(switchLayout))
        navigationItem.rightBarButtonItems = [switchLayoutItem, searchItem];
    }
    
    @objc func fileSearch() {
        
        
        let searchVC = JWFileSearchHistoryViewController()
        searchVC.accessToken = accessToken
        searchVC.searchFilterConfigure = JWFileSearchFilterConfigure.init(route: .Home, dimension: .FD_All, fileSpace: .FileSpace_All)
        let searchNaviVC = UINavigationController(rootViewController: searchVC)
        searchNaviVC.modalPresentationStyle = .fullScreen
        present(searchNaviVC, animated: true, completion: nil)
    }
    
    @objc func switchLayout() {
        isGridLayout = !isGridLayout
    }
    
    func headerHiddenAnimation(scrollView:UIScrollView) {
        
        if scrollView.contentOffset.y <= 0 {
            topItemBar.isHidden = true
            //            return
        }else {
            topItemBar.isHidden = false
        }
        
        if scrollView.contentOffset.y >= offset.y {
            // up
            
            topItemBar.frame = CGRect(x: 0, y: -88, width: topItemBar.bounds.width, height: topItemBar.bounds.height)
            
            //            self.topItemBar.snp.updateConstraints { (make) in
            //                make.top.equalToSuperview().offset(-88)
            //            }
            //
            
        } else {
            // down
            if scrollView.contentOffset.y >= 88 {
                
                //                self.topItemBar.snp.updateConstraints { (make) in
                //                    make.top.equalToSuperview().offset(0)
                //                }
                //                UIView.animate(withDuration: 0.5) {
                topItemBar.frame = CGRect(x: 0, y: 0, width: topItemBar.bounds.width, height: topItemBar.bounds.height)
                //                }
            }
            
        }
        offset =  scrollView.contentOffset
        JWFileLog(messgae: "=========offset \(offset)")
        
    }
    
    
    func switchItemVc (type:JWFileTopItemBar.ItemType) {
        
        for index in 0..<4 {
            [myFileVC, shareMeVC, favouriteVC, trashVC][index].view.isHidden = !(type.rawValue == index)
        }
        topItemBar.didSeletedWithType(type: type)
        switch type {
        case .File:
            myFileVC.filesCollection.setContentOffset(.zero, animated: false)
            myFileVC.resetSortOption()
            myFileVC.refresh()
        case .Share:
            shareMeVC.filesCollection.setContentOffset(.zero, animated: false)
            shareMeVC.resetSortOption()
            shareMeVC.refresh()
        case .Collection:
            favouriteVC.filesCollection.setContentOffset(.zero, animated: false)
            favouriteVC.resetSortOption()
            favouriteVC.refresh()
        case .Trash:
            trashVC.filesCollection.setContentOffset(.zero, animated: false)
            trashVC.resetSortOption()
            trashVC.refresh()
        case .Unknow:
            break
        }
        
    }
    
}


