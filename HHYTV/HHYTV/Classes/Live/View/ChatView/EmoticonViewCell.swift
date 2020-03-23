//
//  EmoticonViewCell.swift
//  HHYTV
//
//  Created by 华惠友 on 2020/3/23.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit

class EmoticonViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    
    var emoticon : Emoticon? {
        didSet {
            iconImageView.image = UIImage(named: emoticon!.emoticonName)
        }
    }
}
