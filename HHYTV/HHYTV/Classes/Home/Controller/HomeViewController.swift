//
//  HomeViewController.swift
//  HHYTV
//
//  Created by 华惠友 on 2020/3/17.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit
import HandyJSON

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

// MARK: - 设置UI界面
extension HomeViewController {
    fileprivate func setupUI() {
        setupNavigationBar()
        setupContentView()
    }
    
    private func setupNavigationBar() {
        let logoImage = UIImage(named: "home-logo")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .plain, target: nil, action: nil)
        
        let collectImage = UIImage(named: "search_btn_follow")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: collectImage, style: .plain, target: self, action: #selector(collectItemClick))
        
        let searchFrame = CGRect(x: 0, y: 0, width: 200, height: 32)
        let searchBar = UISearchBar(frame: searchFrame)
        searchBar.placeholder = "主播昵称/房间号/链接"
        navigationItem.titleView = searchBar
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = .white
        let searchFiled = searchBar.searchTextField
        searchFiled.attributedPlaceholder = NSAttributedString(string: searchFiled.placeholder!, attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
    }
    
    fileprivate func setupContentView() {
        // 1.获取数据
        let homeTypes = loadTypesData()
        
        // 2.创建主题内容
        let style = HHYTitleStyle()
        let pageFrame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - (kNavigationBarHeight + kStatusBarH + kTabbarHeight))
        
        let titles = homeTypes.map({ $0.title })
        var childVcs = [AnchorController]()
        for type in homeTypes {
            let anchorVc = AnchorController()
            anchorVc.homeType = type
            childVcs.append(anchorVc)
        }
        
        let pageView = HHYPageView(frame: pageFrame, titles: titles, childVcs: childVcs, parentVc: self, style: style)
        view.addSubview(pageView)
    }
    
    private func loadTypesData() -> [HomeType] {
        let path = Bundle.main.path(forResource: "types.plist", ofType: nil)!
        let dataArray = NSArray(contentsOfFile: path) as! [[String : Any]]
        var tempArray = [HomeType]()
        tempArray =  dataArray.map { (dict: [String : Any]) -> HomeType in
            HomeType.deserialize(from: dict)!
        }
        return tempArray
    }
}

// MARK:- 事件监听函数
extension HomeViewController {
    @objc fileprivate func collectItemClick() {
        print("------------")
    }
}
