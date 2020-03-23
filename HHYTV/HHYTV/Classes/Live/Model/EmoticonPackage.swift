//
//  EmoticonPackage.swift
//  HHYTV
//
//  Created by 华惠友 on 2020/3/23.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit

class EmoticonPackage {
    lazy var emoticons: [Emoticon] = [Emoticon]()
    
    init(plistName: String) {
        guard let path = Bundle.main.path(forResource: plistName, ofType: nil) else { return }
        guard let emotionArray = NSArray(contentsOfFile: path) as? [String] else { return }
        
        for str in emotionArray {
            emoticons.append(Emoticon(emoticonName: str))
        }
    }
}
