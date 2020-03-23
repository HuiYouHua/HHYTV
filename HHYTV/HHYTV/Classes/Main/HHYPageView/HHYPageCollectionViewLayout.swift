//
//  HHYPageCollectionViewLayout.swift
//  HHYPageView
//
//  Created by 华惠友 on 2020/3/20.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit

class HHYPageCollectionViewLayout: UICollectionViewFlowLayout {

    var cols: Int = 4   // 列数
    var rows: Int = 2   // 行数
    
    fileprivate lazy var cellAttrs: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    fileprivate lazy var maxWidth: CGFloat = 0
}

extension HHYPageCollectionViewLayout {
    override func prepare() {
        super.prepare()
        // 0.计算item宽度和高度
        let itemW: CGFloat = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat(cols - 1)) / CGFloat(cols)
        let itemH: CGFloat = (collectionView!.bounds.height - sectionInset.top - sectionInset.bottom - minimumLineSpacing * CGFloat(rows - 1)) / CGFloat(rows)
        
        // 1.获取一共多少组
        let sectionCount = collectionView!.numberOfSections
        
        // 2.获取每组中有多少个item
        var prePageCount: Int = 0
        for i in 0..<sectionCount {
            let itemCount = collectionView!.numberOfItems(inSection: i)
            
            for j in 0..<itemCount {
                // 2.1.获取cell对应的indexPath
                let indexPath = IndexPath(item: j, section: i)
                
                // 2.2.根据indexPath创建UICollectionViewLayoutAttributes
                let att = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                // 2.3.计算j在该组中的第几页,第几页的第几个
                let page = j / (rows * cols)
                let index = j % (rows * cols)
                
                // 2.3.设置attr的frame
                let itemX = CGFloat(prePageCount + page) * collectionView!.bounds.width + sectionInset.left + (itemW + minimumInteritemSpacing) * CGFloat(index % cols)
                let itemY = sectionInset.top + (itemH + minimumLineSpacing) * CGFloat(index / cols)
                att.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
                // 2.4.保存att到数组中
                cellAttrs.append(att)
            }
            prePageCount += (itemCount - 1) / (cols * rows) + 1
        }
        
        // 3.计算最大宽度
        maxWidth = CGFloat(prePageCount) * collectionView!.bounds.width
    }
}

extension HHYPageCollectionViewLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttrs
    }
}

extension HHYPageCollectionViewLayout {
    override var collectionViewContentSize: CGSize {
        return CGSize(width: maxWidth, height: 0)
    }
}
