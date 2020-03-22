//
//  HHYNavigationController.swift
//  HHYTV
//
//  Created by 华惠友 on 2020/3/17.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit

class HHYNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.使用运行时,打印手势中的所有属性
        /**
        var count: UInt32 = 0
        let ivars = class_copyIvarList(UIGestureRecognizer.self, &count)!
        for i in 0..<count {
            let nameP = ivar_getName(ivars[Int(i)])!
            let name = String(cString: nameP)
            print(name)
        }
         */
        
        guard let targets = interactivePopGestureRecognizer!.value(forKey: "_targets") as? [NSObject] else { return }
        let targetObject = targets[0]
        let target = targetObject.value(forKey: "target")
        let action = Selector(("handleNavigationTransition:"))
        
        let panGes = UIPanGestureRecognizer(target: target, action: action)
        view.addGestureRecognizer(panGes)
    }
    
    // 修改statusBar颜色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

}
