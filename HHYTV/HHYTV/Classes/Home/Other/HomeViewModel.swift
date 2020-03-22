//
//  HomeViewModel.swift
//  HHYTV
//
//  Created by 华惠友 on 2020/3/19.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit
import HandyJSON

class HomeViewModel {
    lazy var anchorModels = [AnchorModel]()
}

extension HomeViewModel {
    func loadHomeData(type: HomeType, index: Int, finsherCallback: @escaping () -> ()) {
        NetworkTools.requestData(.post, URLString: "http://onapp.yahibo.top/public/?s=api/test/list", parameters: ["type" : type.type, "index" : index, "size" : 48], finishedCallback: { (result) -> Void in
            
            guard let resultDict = result as? [String : Any] else { return }
            guard let messageDict = resultDict["data"] as? [String : Any] else { return }
            guard let dataArray = messageDict["list"] as? [[String : Any]] else { return }
            
            for (index, dict) in dataArray.enumerated() {
                var anchor = AnchorModel.deserialize(from: dict)!
//                anchor.isEvenIndex = index % 2 == 0
                self.anchorModels.append(anchor)
            }
            
            finsherCallback()
        })
    }
}
