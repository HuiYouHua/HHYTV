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

    weak var delegate: HHYTitileViewDelegate?

    fileprivate var titles: [String]
    fileprivate var style: HHYTitleStyle
    
    fileprivate lazy var currentIndex: Int = 0
    
    fileprivate lazy var titleLabels: [UILabel] = [UILabel]()
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        
        return scrollView
    }()
    fileprivate lazy var botomline: UIView = {
       let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.scrollLineColor
        bottomLine.frame.size.height = self.style.scrollLineHeight
        bottomLine.frame.origin.y = self.bounds.height - self.style.scrollLineHeight
        return bottomLine
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
        
        // 2.将titleLabel添加到scrollView中
        setupTitleLabel()
        
        // 3.设置titleLabel的frame
        setupTitleLabelsFrame()
        
        // 4.添加滚动条
        if style.isShowScrollLine {
            scrollView.addSubview(botomline)
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
        
        for (i, label) in titleLabels.enumerated() {
            var w: CGFloat = 0
            let h: CGFloat = bounds.height
            var x: CGFloat = 0
            let y: CGFloat = 0
            
            if style.isScrollEnable {
                // 可以滚动
                w = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font!], context: nil).width
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
        }
        
        scrollView.contentSize = style.isScrollEnable ?
            CGSize(width: titleLabels.last!.frame.maxX + style.itemMargin * 0.5, height: 0)
            : CGSize.zero
    }
}

// MARK: - 监听事件
extension HHYTitileView {
    @objc fileprivate func titleLabelClick(_ tapGes: UITapGestureRecognizer) {
        // 1.取出用户点击的View
        let targetLabel = tapGes.view as! UILabel
        
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
    
    fileprivate func adjustTitlteLabel(targetIndex: Int) {
        
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
        if offsetX > (scrollView.contentSize.width - scrollView.bounds.width) {
            offsetX = scrollView.contentSize.width - scrollView.bounds.width
        }
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}

// MARK: - HHYContentViewDelegate
extension HHYTitileView: HHYContentViewDelegate {
    func contentView(_ contentView: HHYContentView, targetIndex: Int) {
        adjustTitlteLabel(targetIndex: targetIndex)
    }
    
    func contentView(_ contentView: HHYContentView, targetIndex: Int, sourceIndex: Int, progress: CGFloat) {
        
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
        if style.isShowScrollLine {
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            let deltaW = targetLabel.frame.size.width - sourceLabel.frame.size.width
            botomline.frame.origin.x = sourceLabel.frame.origin.x + deltaX * progress
            botomline.frame.size.width = sourceLabel.frame.size.width + deltaW * progress
        }
    }
}
