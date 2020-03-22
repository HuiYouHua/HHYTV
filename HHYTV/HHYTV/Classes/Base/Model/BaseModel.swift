//
//  BaseModel.swift
//  HHYTV
//
//  Created by 华惠友 on 2020/3/19.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit

class BaseModel: NSObject {

    override init() {
        
    }
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}
