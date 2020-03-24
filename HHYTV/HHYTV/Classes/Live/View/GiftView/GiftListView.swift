//
//  GiftListView.swift
//  HHYTV
//
//  Created by 华惠友 on 2020/3/23.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit

private let kGiftCellID = "kGiftCellID"

protocol GiftListViewDelegate : class {
    func giftListView(giftView : GiftListView, giftModel : GiftModel)
}

class GiftListView: UIView, NibLoadable {
    // MARK: 控件属性
    @IBOutlet weak var giftView: UIView!
    @IBOutlet weak var sendGiftBtn: UIButton!
    
    fileprivate var pageCollectionView : HHYPageCollectionView!
    fileprivate var currentIndexPath : IndexPath?
    fileprivate var giftVM: GiftViewModel = GiftViewModel()
    
    weak var delegate : GiftListViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 1.初始化礼物的View
        setupGiftView()
        
        // 2.加载礼物的数据
        loadGiftData()
    }
}

extension GiftListView {
    fileprivate func setupUI() {
        setupGiftView()
    }
    
    fileprivate func setupGiftView() {
        let style = HHYTitleStyle()
        style.isScrollEnable = false
        style.normalColor = UIColor(r: 255, g: 255, b: 255)
        
        let layout = HHYPageCollectionViewLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.cols = 4
        layout.rows = 2
        
        var pageViewFrame = giftView.bounds
        pageViewFrame.size.width = kScreenW
        pageCollectionView = HHYPageCollectionView(frame: pageViewFrame, titles: ["热门", "高级", "豪华"], style: style, isTitleTop: true, layout : layout)
        giftView.addSubview(pageCollectionView)
        
        pageCollectionView.dataSource = self
        pageCollectionView.delegate = self
        
        pageCollectionView.register(UINib(nibName: "GiftViewCell", bundle: nil), kGiftCellID)
    }
}

// MARK:- 加载数据
extension GiftListView {
    fileprivate func loadGiftData() {
        giftVM.loadGiftData {
            self.pageCollectionView.reloadData()
        }
    }
}



// MARK:- 数据设置
extension GiftListView : HHYPageCollectionViewDataSource, HHYPageCollectionViewDelegate {
    func numberOfSections(in pageCollection: HHYPageCollectionView) -> Int {
        return giftVM.giftlistData.count
    }
    
    func pageCollection(_ pageCollection: HHYPageCollectionView, numberOfItemsInSection section: Int) -> Int {
        return giftVM.giftlistData[section].list.count
    }
    
    func pageCollection(_ pageCollection: HHYPageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGiftCellID, for: indexPath) as! GiftViewCell
        let giftModel = giftVM.giftlistData[indexPath.section].list[indexPath.item]
        cell.giftModel = giftModel
        return cell
    }
    
    func pageCollectionView(_ pageCollection: HHYPageCollectionView, didSelectItemAt indexPath: IndexPath) {
        sendGiftBtn.isEnabled = true
        currentIndexPath = indexPath
    }
    

}


// MARK:- 送礼物
extension GiftListView {
    @IBAction func sendGiftBtnClick() {
        let package = giftVM.giftlistData[currentIndexPath!.section]
        let giftModel = package.list[currentIndexPath!.item]
        delegate?.giftListView(giftView: self, giftModel: giftModel)
    }
}
