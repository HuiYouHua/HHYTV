//
//  GiftPackage.swift
//  XMGTV
//
//  Created by apple on 16/11/13.
//  Copyright © 2016年 coderwhy. All rights reserved.
//

import UIKit
import HandyJSON

struct GiftPackage: HandyJSON {
    var t : Int = 0
    var title : String = ""
    var list : [GiftModel] = [GiftModel]()
    
//    func setValue(_ value: Any?, forKey key: String) {
//        if key == "list" {
//            if let listArray = value as? [[String : Any]] {
//                for listDict in listArray {
//                    list.append(GiftModel(dict: listDict))
//                }
//            }
//        }
//    }
}
