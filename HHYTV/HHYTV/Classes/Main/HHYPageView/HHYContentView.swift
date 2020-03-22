//
//  HHYContentView.swift
//  HHYPageView
//
//  Created by 华惠友 on 2020/3/18.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit

private let kContentCellId = "kContentCellId"

protocol HHYContentViewDelegate: class {
    func contentView(_ contentView: HHYContentView, targetIndex: Int)
    func contentView(_ contentView: HHYContentView, targetIndex: Int, sourceIndex: Int, progress: CGFloat)

}

class HHYContentView: UIView {

    weak var delegate: HHYContentViewDelegate?
    
    fileprivate var childVcs: [UIViewController]
    fileprivate var parentVc: UIViewController
    
    fileprivate var startOffsetX: CGFloat = 0
    fileprivate var isForbidScroll: Bool = false
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellId)
        return collectionView
    }()
    
    init(frame: CGRect, childVcs: [UIViewController], parentVc: UIViewController) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)

        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HHYContentView {
    fileprivate func setupUI() {
        // 1.将所有子控制器添加到父控制器中
        for childVc in childVcs {
            parentVc.addChild(childVc)
        }
        
        // 2.添加UICollectionView用于展示内容
        addSubview(collectionView)
    }
}

extension HHYContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellId, for: indexPath)
        
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}

extension HHYContentView: UICollectionViewDelegate {
    // 视图滚动减速结束后的回调,有减速过程的处理
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentEndScroll()
    }
    
    // 结束拖拽的回调,手指离开屏幕
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate { // 没有减速过程的处理
            // 表示手指离开屏幕了,滑动就停止了
            contentEndScroll()
        } else {
            // 表示手指离开屏幕后,视图还有惯性自动滚动一段距离
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScroll = false
        // FIXME: - 当连续滚动时,这里起始点并不是边界
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 0.判断和开始时的偏移量是否一致
        guard startOffsetX != scrollView.contentOffset.x ||  !isForbidScroll else {
            return
        }
        
        // 这样有问题
//        var targetIndex = 0
//        var progress: CGFloat = 0.0
//
//        // 2.赋值
//        let currentIndex = Int(startOffsetX / scrollView.bounds.width)
//        if startOffsetX < scrollView.contentOffset.x {
//            // 左滑
//            targetIndex = currentIndex + 1
//            if targetIndex > childVcs.count - 1 {
//                targetIndex = childVcs.count - 1
//            }
//            progress = (scrollView.contentOffset.x - startOffsetX) / scrollView.bounds.width
//        } else {
//            // 右滑
//            targetIndex = currentIndex - 1
//            if targetIndex < 0 {
//                targetIndex = 0
//            }
////            progress = (startOffsetX - scrollView.contentOffset.x) / scrollView.bounds.width
//            progress = (scrollView.contentOffset.x.truncatingRemainder(dividingBy: scrollView.bounds.width)) / scrollView.bounds.width
//        }
//
//        // 3.通知代理
//        delegate?.contentView(self, targetIndex: targetIndex, progress: progress)
        
        var progress = (scrollView.contentOffset.x.truncatingRemainder(dividingBy: scrollView.bounds.width)) / scrollView.bounds.width
        if progress == 0 {
            return
        }
        
        var sourceIndex = 0 // 初始点
        var targetIndex = 0 // 目标点
        
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        if startOffsetX < scrollView.contentOffset.x {
            // 左滑
            sourceIndex = index + 1
            targetIndex = index
            progress = 1 - progress
            if targetIndex < 0 {
                return
            }
        } else {
            // 右滑
            sourceIndex = index
            targetIndex = index + 1
            if targetIndex > childVcs.count - 1 { // 防止只有一个
                return
            }
        }
        if progress > 0.998 {
            progress = 1
        }
        delegate?.contentView(self, targetIndex: targetIndex, sourceIndex: sourceIndex, progress: progress)
    }
    
    fileprivate func contentEndScroll() {
        // 0.判断是否是禁止状态
        guard !isForbidScroll else { return }
        
        // 1.获取滚动到的位置
        let curretentIndex = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        
        // 2.通知titleView进行调整
        delegate?.contentView(self, targetIndex: curretentIndex)
    }
}

// MARK: - HHYTitileViewDelegate
extension HHYContentView: HHYTitileViewDelegate {
    func titleView(_ titleView: HHYTitileView, targetIndex: Int) {
        isForbidScroll = true
        
        let indexPath = IndexPath(item: targetIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}








