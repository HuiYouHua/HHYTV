//
//  HHYTitleStyle.swift
//  HHYPageView
//
//  Created by 华惠友 on 2020/3/18.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit

class HHYTitleStyle {
    /// Title高度
    var titleHeight: CGFloat = 44
    /// 普通Title颜色
    var normalColor: UIColor = UIColor(r: 0, g: 0, b: 0)
    /// 选中Title颜色
    var selectColor: UIColor = UIColor(r: 255, g: 0, b: 0)
    /// Title字体大小
    var fontSize: CGFloat = 15.0
    /// 是否是滚动的Title
    var isScrollEnable: Bool = true
    /// 滚动Title的字体间距
    var itemMargin: CGFloat = 30
    
    /// 是否显示底部滚动条
    var isShowScrollLine: Bool = true
    /// 底部滚动条的颜色
    var scrollLineHeight: CGFloat = 2
    /// 底部滚动条的高度
    var scrollLineColor: UIColor = .orange
    
    /// 是否进行缩放
    var isNeedScale : Bool = true
    var scaleRange : CGFloat = 1.3
    
    /// 是否显示遮盖
    var isShowCover : Bool = false
    /// 遮盖背景颜色
    var coverBgColor : UIColor = UIColor.lightGray
    /// 文字&遮盖间隙
    var coverMargin : CGFloat = 5
    /// 遮盖的高度
    var coverH : CGFloat = 25
    /// 设置圆角大小
    var coverRadius : CGFloat = 12
}
