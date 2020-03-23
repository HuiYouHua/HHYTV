//
//  EmoticonView.swift
//  HHYTV
//
//  Created by 华惠友 on 2020/3/23.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit

private let kEmoticonViewCellId = "EmoticonViewCell"

class EmoticonView: UIView {
    
    var emoticonClickCallback: ((Emoticon) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmoticonView {
    fileprivate func setupUI() {
        // 1.创建HHYPageCollectionView
        let style = HHYTitleStyle()
        let layout = HHYPageCollectionViewLayout()
        layout.cols = 7
        layout.rows = 3
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let pageCollectionView = HHYPageCollectionView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - kSafeAreaHeight), titles: ["普通", "粉丝专属"], style: style, isTitleTop: false, layout: layout)
        
        // 2.添加pageCollectionView视图
        addSubview(pageCollectionView)

        // 3.设置pageCollectionView的属性
        pageCollectionView.dataSource = self
        pageCollectionView.delegate = self
        pageCollectionView.register(UINib(nibName: "EmoticonViewCell", bundle: nil), kEmoticonViewCellId)
    }
}

// MARK: - HHYPageCollectionViewDataSource
extension EmoticonView: HHYPageCollectionViewDataSource {
    func numberOfSections(in pageCollection: HHYPageCollectionView) -> Int {
        return EmoticonViewModel.shareInstance.packages.count
    }
    
    func pageCollection(_ pageCollection: HHYPageCollectionView, numberOfItemsInSection section: Int) -> Int {
        return EmoticonViewModel.shareInstance.packages[section].emoticons.count
    }
    
    func pageCollection(_ pageCollection: HHYPageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kEmoticonViewCellId, for: indexPath) as! EmoticonViewCell
        let emoticon =  EmoticonViewModel.shareInstance.packages[indexPath.section].emoticons[indexPath.item]
        cell.emoticon = emoticon
        return cell
    }
}

extension EmoticonView: HHYPageCollectionViewDelegate {
    func pageCollectionView(_ pageCollection: HHYPageCollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoticon =  EmoticonViewModel.shareInstance.packages[indexPath.section].emoticons[indexPath.item]
        if let emoticonClickCallback = emoticonClickCallback {
            emoticonClickCallback(emoticon)
        }
    }
}
