//
//  HHYPageCollectionView.swift
//  HHYPageView
//
//  Created by 华惠友 on 2020/3/20.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit

protocol HHYPageCollectionViewDataSource: class {
    func numberOfSections(in pageCollection: HHYPageCollectionView) -> Int
    func pageCollection(_ pageCollection: HHYPageCollectionView, numberOfItemsInSection section: Int) -> Int
    func pageCollection(_ pageCollection: HHYPageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

protocol HHYPageCollectionViewDelegate: class {
    func pageCollectionView(_ pageCollection: HHYPageCollectionView, didSelectItemAt indexPath: IndexPath)
}

class HHYPageCollectionView: UIView {

    weak var dataSource: HHYPageCollectionViewDataSource?
    weak var delegate: HHYPageCollectionViewDelegate?
    
    fileprivate var titles: [String]
    fileprivate var style: HHYTitleStyle
    fileprivate var isTitleTop: Bool
    fileprivate var layout: HHYPageCollectionViewLayout
    fileprivate var collectionView: UICollectionView!
    fileprivate var pageControl: UIPageControl!
    fileprivate var sourceIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    fileprivate var titleView: HHYTitileView!
    
    init(frame: CGRect, titles: [String], style: HHYTitleStyle, isTitleTop: Bool, layout: HHYPageCollectionViewLayout) {
        self.titles = titles
        self.style = style
        self.isTitleTop = isTitleTop
        self.layout = layout
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 设置UI界面
extension HHYPageCollectionView {
    fileprivate func setupUI() {
        // 1.创建titleView
        let titleY = isTitleTop ? 0 : bounds.height - style.titleHeight
        let titleFrame = CGRect(x: 0, y: titleY, width: bounds.width, height: style.titleHeight)
        titleView = HHYTitileView(frame: titleFrame, titles: titles, style: style)
        titleView.delegate = self
        addSubview(titleView)
        
        // 2.创建UIPageControl
        let pageControlHeight: CGFloat = 20
        let pageControlY = isTitleTop ? bounds.height - pageControlHeight : (bounds.height - pageControlHeight - style.titleHeight)
        let pageControlFrame = CGRect(x: 0, y: pageControlY, width: bounds.width, height: pageControlHeight)
        pageControl = UIPageControl(frame: pageControlFrame)
        addSubview(pageControl)
        pageControl.isEnabled = false
        
        // 3.创建UICollectionView
        let collectionViewY = isTitleTop ? style.titleHeight : 0
        let collectionViewFrame = CGRect(x: 0, y: collectionViewY, width: bounds.width, height: bounds.height - style.titleHeight - pageControlHeight)
        collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(collectionView)
        pageControl.backgroundColor = collectionView.backgroundColor
    }
}

// MARK: - 对外暴露的方法
extension HHYPageCollectionView {
    func register(_ cell: AnyClass?, _ identifier: String) {
        collectionView.register(cell, forCellWithReuseIdentifier: identifier)
    }
    
    func register(_ nib: UINib, _ identifier: String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension HHYPageCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSections(in: self) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount = dataSource?.pageCollection(self, numberOfItemsInSection: section) ?? 0
        if section == 0 {
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
        }
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource!.pageCollection(self, collectionView, cellForItemAt: indexPath)
    }
}

// MARK: - UICollectionViewDelegate
extension HHYPageCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pageCollectionView(self, didSelectItemAt: indexPath)
    }
    
    // 手离开屏幕自动减速结束后的回调
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate { // 结束拖拽,无自动减速的情况
            scrollViewEndScroll()
        } else { // 结束拖拽,有自动减速的情况
    
        }
    }
    
    fileprivate func scrollViewEndScroll() {
        // 1.取出在屏幕中显示的cell
        let point = CGPoint(x: layout.sectionInset.left + 1 + collectionView.contentOffset.x, y: layout.sectionInset.top + 1)
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
                
        // 2.判断分组是否有发生改变
        if sourceIndexPath.section != indexPath.section {
            // 2.1.修改pageControl的数量
            let itemCount = dataSource?.pageCollection(self, numberOfItemsInSection: indexPath.section) ?? 0
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
            
            // 2.2.设置titleView的位置
            titleView.setTitleWithProgress(1.0, sourceIndex: sourceIndexPath.section, targetIndex: indexPath.section)
            
            // 2.3记录最新的indexPath
            sourceIndexPath = indexPath
            
            // 2.4.通知titleView进行调整
            titleView.adjustTitlteLabel(targetIndex: indexPath.section)
        }
        
        // 3.根据indexPath设置pageControl
        pageControl.currentPage = indexPath.item / (layout.cols * layout.rows)
    }
}

// MARK: - HHYTitileViewDelegate
extension HHYPageCollectionView: HHYTitileViewDelegate {
    func titleView(_ titleView: HHYTitileView, targetIndex: Int) {
        let indexPath = IndexPath(item: 0, section: targetIndex)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        collectionView.contentOffset.x -= layout.sectionInset.left
        
        scrollViewEndScroll()
    }
    
    
}
