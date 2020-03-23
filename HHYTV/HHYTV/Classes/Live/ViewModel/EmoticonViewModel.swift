//
//  EmoticonViewModel.swift
//  HHYTV
//
//  Created by 华惠友 on 2020/3/23.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit

class EmoticonViewModel {
    static let shareInstance: EmoticonViewModel = EmoticonViewModel()
    
    lazy var packages: [EmoticonPackage] = [EmoticonPackage]()
    
    init() {
        packages.append(EmoticonPackage(plistName: "QHNormalEmotionSort.plist"))
        packages.append(EmoticonPackage(plistName: "QHSohuGifSort.plist"))
    }
}
