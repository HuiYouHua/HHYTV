//
//  MainViewController.swift
//  HHYTV
//
//  Created by 华惠友 on 2020/3/17.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let vcDic = [
            ["vcName": "HomeViewController", "title": "直播", "imageName": "live"],
            ["vcName": "RankViewController", "title": "排行", "imageName": "ranking"],
            ["vcName": "DiscoverViewController", "title": "发现", "imageName": "found"],
            ["vcName": "ProfileViewController", "title": "我的", "imageName": "mine"],
        ]
        for item in vcDic {
            guard let vcName = item["vcName"],
                   let title = item["title"],
               let imageName = item["imageName"] else {
                break
            }
            guard let nav = buildNav(vcName: vcName, title: title, imageName: imageName) else {
                break
            }
            self.addChild(nav)
        }
        self.tabBar.tintColor = UIColor.orange
    }
    
    func buildNav(vcName: String, title: String, imageName: String) -> HHYNavigationController? {
        
        guard let nameSpage = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            print("没有命名空间")
            return nil
        }
        
        guard let cls = NSClassFromString(nameSpage + "." + vcName) else {
            print("没有获取到对应的class")
            return nil
        }
        guard let vcType = cls as? UIViewController.Type else {
            print("没有得到的类型")
            return nil
        }
        let nav: HHYNavigationController = HHYNavigationController.init(rootViewController: vcType.init())
        
//        let normalImage = UIImage(named: imageName + "-p")
//        normalImage?.renderingMode = UIImageRenderingModeAlwaysOriginal
        nav.tabBarItem = UITabBarItem.init(title: title, image: UIImage(named: imageName + "-n"), selectedImage: UIImage(named: imageName + "-p"))
        nav.navigationBar.isTranslucent = false
        return nav
    }

}
