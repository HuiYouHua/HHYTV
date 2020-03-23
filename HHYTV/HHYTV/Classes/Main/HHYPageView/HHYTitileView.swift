//
//  HHYTitileView.swift
//  HHYPageView
//
//  Created by 华惠友 on 2020/3/18.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit

protocol HHYTitileViewDelegate: class {
    func titleView(_ titleView: HHYTitileView, targetIndex: Int)
}

class HHYTitileView: UIView {
    
    // MARK: 对外属性
    weak var delegate: HHYTitileViewDelegate?
    
    // MARK: 定义属性
    fileprivate var titles: [String]
    fileprivate var style: HHYTitleStyle
    fileprivate lazy var currentIndex: Int = 0
    
    // MARK: 控件属性
    fileprivate lazy var titleLabels: [UILabel] = [UILabel]()
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    fileprivate lazy var splitLineView : UIView = {
        let splitView = UIView()
        splitView.backgroundColor = UIColor.lightGray
        let h : CGFloat = 0.5
        splitView.frame = CGRect(x: 0, y: self.frame.height - h, width: self.frame.width, height: h)
        return splitView
    }()
    fileprivate lazy var botomline: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.scrollLineColor
        bottomLine.frame.size.height = self.style.scrollLineHeight
        bottomLine.frame.origin.y = self.bounds.height - self.style.scrollLineHeight
        return bottomLine
    }()
    fileprivate lazy var coverView : UIView = {
        let coverView = UIView()
        coverView.backgroundColor = self.style.coverBgColor
        coverView.alpha = 0.7
        return coverView
    }()
    
    
    init(frame: CGRect, titles: [String], style: HHYTitleStyle) {
        self.titles = titles
        self.style = style
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//  MARK: - 设置UI
extension HHYTitileView {
    fileprivate func setupUI() {
        // 1.将scrollView添加到view中
        addSubview(scrollView)
        addSubview(splitLineView)
        
        // 2.将titleLabel添加到scrollView中
        setupTitleLabel()
        
        // 3.设置titleLabel的frame
        setupTitleLabelsFrame()
        
        // 4.添加滚动条
        if style.isShowScrollLine {
            scrollView.addSubview(botomline)
        }
        
        // 5.设置遮盖的View
        if style.isShowCover {
            setupCoverView()
        }
    }
    
    fileprivate func setupTitleLabel() {
        for (i, title) in titles.enumerated() {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.systemFont(ofSize: style.fontSize)
            titleLabel.tag = i
            titleLabel.textAlignment = .center
            titleLabel.textColor = i == 0 ? style.selectColor : style.normalColor
            
            scrollView.addSubview(titleLabel)
            
            titleLabels.append(titleLabel)
            
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(titleLabelClick(_:)))
            titleLabel.addGestureRecognizer(tapGesture)
            titleLabel.isUserInteractionEnabled = true
        }
    }
    
    fileprivate func setupTitleLabelsFrame() {
        
        let count = titles.count
        
        var w: CGFloat = 0
        let h: CGFloat = bounds.height
        var x: CGFloat = 0
        let y: CGFloat = 0
        for (i, label) in titleLabels.enumerated() {
            
            if style.isScrollEnable {
                // 可以滚动
                w = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font!], context: nil).width + 8
                if i == 0 {
                    x = style.itemMargin * 0.5
                } else {
                    let preLabel = titleLabels[i-1]
                    x = preLabel.frame.maxX + style.itemMargin
                }
            } else {
                // 不可以滚动
                w = bounds.width / CGFloat(count)
                x = w * CGFloat(i)
            }
            
            // 设置滑动条初始位置
            if (i == 0 && style.isShowScrollLine) {
                botomline.frame.origin.x = x
                botomline.frame.size.width = w
            }
            
            label.frame = CGRect(x: x, y: y, width: w, height: h)
            
            // 先设置frame再设置放大
            if i == 0 && style.isNeedScale {
                label.transform = CGAffineTransform(scaleX: style.scaleRange, y: style.scaleRange)
            }
        }
        
        scrollView.contentSize = style.isScrollEnable ?
            CGSize(width: titleLabels.last!.frame.maxX + style.itemMargin * 0.5, height: 0)
            : CGSize.zero
    }
    
    fileprivate func setupCoverView() {
        scrollView.insertSubview(coverView, at: 0)
        let firstLabel = titleLabels[0]
        var coverW = firstLabel.frame.width
        let coverH = style.coverH
        var coverX = firstLabel.frame.origin.x
        let coverY = (bounds.height - coverH) * 0.5
        
        if style.isScrollEnable {
            coverX -= style.coverMargin
            coverW += style.coverMargin * 2
        }
        coverView.frame = CGRect(x: coverX, y: coverY, width: coverW, height: coverH)
        
        coverView.layer.cornerRadius = style.coverRadius
        coverView.layer.masksToBounds = true
    }
}

// MARK: - 监听事件
extension HHYTitileView {
    @objc fileprivate func titleLabelClick(_ tapGes: UITapGestureRecognizer) {
        // 1.取出用户点击的View
        let targetLabel = tapGes.view as! UILabel
        guard currentIndex != targetLabel.tag else {
            return
        }
        
        // 2.调整titleView
        adjustTitlteLabel(targetIndex: targetLabel.tag)
        
        // 3.调整bottomLine
        if style.isShowScrollLine {
            UIView.animate(withDuration: 0.25) {
                self.botomline.frame.origin.x = targetLabel.frame.origin.x
                self.botomline.frame.size.width = targetLabel.frame.size.width
            }
        }
        
        // 4.通知contentView进行调整
        delegate?.titleView(self, targetIndex: currentIndex)
        
    }
    
}

extension HHYTitileView {
    func setTitleWithProgress(_ progress : CGFloat, sourceIndex : Int, targetIndex : Int) {
        // 1.取出label
        let targetLabel = titleLabels[targetIndex]
        /**
         这种在连续滑动的情况下不适用
         因为连续滑动的时候在HHYContentView中
         scrollView的代理方法只会走scrollViewDidEndDragging:willDecelerate:方法,且decelerate为true,表示手指离开屏幕后,视图还有惯性自动滚动一段距离
         而不会走scrollViewDidEndDragging:willDecelerate:方法,且decelerate为false和scrollViewDidEndDecelerating(滑动视图自动减速结束的回调)
         这样就无法更新最新的currentIndex了,导致视图出现错误
         因此我们需要在外面计算目标序号和原始序号
         */
        //        let sourceLabel = titleLabels[currentIndex]
        let sourceLabel = titleLabels[sourceIndex]
        
        // 2.文字颜色渐变
        let deltaRGB = UIColor.getRGBDelta(style.selectColor, style.normalColor)
        let selectedRGB = style.selectColor.getRGB()
        let normalRGB = style.normalColor.getRGB()
        
        targetLabel.textColor = UIColor(r: normalRGB.0 + deltaRGB.0 * progress, g: normalRGB.1 + deltaRGB.1 * progress, b: normalRGB.2 + deltaRGB.2 * progress)
        sourceLabel.textColor = UIColor(r: selectedRGB.0 - deltaRGB.0 * progress, g: selectedRGB.1 - deltaRGB.1 * progress, b: selectedRGB.2 - deltaRGB.2 * progress)
        
        // 3.下划线渐变
        let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let deltaW = targetLabel.frame.size.width - sourceLabel.frame.size.width
        if style.isShowScrollLine {
            botomline.frame.origin.x = sourceLabel.frame.origin.x + deltaX * progress
            botomline.frame.size.width = sourceLabel.frame.size.width + deltaW * progress
        }
        
        // 4.设置缩放比例
        if style.isNeedScale {
            let scaleDelta = (style.scaleRange - 1.0) * progress
            sourceLabel.transform = CGAffineTransform(scaleX: style.scaleRange - scaleDelta, y: style.scaleRange - scaleDelta)
            targetLabel.transform = CGAffineTransform(scaleX: 1.0 + scaleDelta, y: 1.0 + scaleDelta)
        }
        
        // 5.设置遮罩
        if style.isShowCover {
            coverView.frame.size.width = style.isScrollEnable ? (sourceLabel.frame.width + 2 * style.coverMargin + deltaW * progress) : (sourceLabel.frame.width + deltaW * progress)
            coverView.frame.origin.x = style.isScrollEnable ? (sourceLabel.frame.origin.x - style.coverMargin + deltaX * progress) : (sourceLabel.frame.origin.x + deltaX * progress)
        }
    }
    
    func adjustTitlteLabel(targetIndex: Int) {
        
        if targetIndex == currentIndex { return }
        
        // 1.取出label
        let targetLabel = titleLabels[targetIndex]
        let sourceLabel = titleLabels[currentIndex]
        
        // 2.切换文字的颜色
        targetLabel.textColor = style.selectColor
        sourceLabel.textColor = style.normalColor
        
        // 3.记录下标值
        currentIndex = targetIndex
        
        // 4.调整偏移位置
        if !style.isScrollEnable { return }
        var offsetX = targetLabel.center.x - scrollView.bounds.width * 0.5
        if offsetX < 0 {
            offsetX = 0
        }
        let maxOffset = scrollView.contentSize.width - scrollView.bounds.width
        if maxOffset < 0 {
            offsetX = 0
        } else if offsetX > maxOffset {
            offsetX = maxOffset
        }
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        
        // 5.设置缩放比例
        if style.isNeedScale {
            sourceLabel.transform = CGAffineTransform.identity
            targetLabel.transform = CGAffineTransform(scaleX: style.scaleRange, y: style.scaleRange)
        }
        
        // 6.设置遮罩
        if style.isShowCover {
            let coverX = style.isScrollEnable ? (targetLabel.frame.origin.x - style.coverMargin) : sourceLabel.frame.origin.x
            let coverW = style.isScrollEnable ? (targetLabel.frame.width + style.coverMargin * 2) : sourceLabel.frame.width
            UIView.animate(withDuration: 0.15, animations: {
                self.coverView.frame.origin.x = coverX
                self.coverView.frame.size.width = coverW
            })
        }
    }
}
