//
//  HomeViewCell.swift
//  HHYTV
//
//  Created by 华惠友 on 2020/3/19.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit
import Kingfisher

class HomeViewCell: UICollectionViewCell {

    // MARK: 控件属性
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var liveImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var onlinePeopleLabel: UIButton!
    
    var anchorModel: AnchorModel? {
        didSet {
//            albumImageView.kf.setImage(with: URL(string: anchorModel!.isEvenIndex ? anchorModel!.pic74 : anchorModel!.pic51), placeholder: UIImage(named: "home_pic_default"))
//            liveImageView.isHidden = anchorModel?.live == 0
//            nickNameLabel.text = anchorModel?.name
//            onlinePeopleLabel.setTitle("\(anchorModel?.focus ?? 0)", for: .normal)
            
            albumImageView.kf.setImage(with: URL(string: ""), placeholder: UIImage(named: "home_pic_default"))
//            liveImageView.isHidden = anchorModel?.live == 0
            nickNameLabel.text = anchorModel?.name
//            onlinePeopleLabel.setTitle("\(anchorModel?.focus ?? 0)", for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
