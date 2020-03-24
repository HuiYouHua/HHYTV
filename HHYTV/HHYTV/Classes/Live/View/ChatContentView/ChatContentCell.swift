//
//  ChatContentCell.swift
//  HHYTV
//
//  Created by 华惠友 on 2020/3/24.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit

class ChatContentCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentLabel.font = UIFont.systemFont(ofSize: 17)
        contentLabel.textColor = .white
        selectionStyle = .none
    }


    
}
