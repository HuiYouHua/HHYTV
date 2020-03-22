//
//  HHYPageView.swift
//  HHYPageView
//
//  Created by 华惠友 on 2020/3/18.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit

class HHYPageView: UIView {
    
    fileprivate var titles: [String]
    fileprivate var childVcs: [UIViewController]
    fileprivate var parentVc: UIViewController
    fileprivate var style: HHYTitleStyle
    
    fileprivate var titleView: HHYTitileView!
    
    init(frame: CGRect, titles: [String], childVcs: [UIViewController], parentVc: UIViewController, style: HHYTitleStyle) {
        // 两段式初始化
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        self.style = style
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 设置UI界面
extension HHYPageView {
    fileprivate func setupUI() {
        setupTitleView()
        setupContentView()
        
    }
    
    fileprivate func setupTitleView() {
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleHeight)
        titleView = HHYTitileView(frame: titleFrame, titles: titles, style: style)
        addSubview(titleView)
    }
    
    fileprivate func setupContentView() {
        let contentFrame = CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight)
        let contentView = HHYContentView(frame: contentFrame, childVcs: childVcs, parentVc: parentVc)
        addSubview(contentView)
        
        // 让contentView和titleView相互成为代理
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
}

















