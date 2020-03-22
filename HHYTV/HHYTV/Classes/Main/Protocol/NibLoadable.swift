//
//  NibLoadable.swift
//  HHYTV
//
//  Created by 华惠友 on 2020/3/20.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit

protocol NibLoadable {
    
}

extension NibLoadable where Self: UIView {
    // Xib加载
    static func loadFromNib(_ nibName: String? = nil) -> Self {
        let loadName = nibName == nil ? "\(self)" : nibName!
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
}
