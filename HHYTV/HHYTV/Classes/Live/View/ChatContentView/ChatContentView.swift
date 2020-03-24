//
//  ChatContentView.swift
//  HHYTV
//
//  Created by 华惠友 on 2020/3/24.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit

private let kChatContentCell = "ChatContentCell"

class ChatContentView: UIView, NibLoadable {

    @IBOutlet weak var tableView: UITableView!
    fileprivate lazy var messages: [NSAttributedString] = [NSAttributedString]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        tableView.register(UINib(nibName: "ChatContentCell", bundle: nil), forCellReuseIdentifier: kChatContentCell)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    // 插入数据
    func inserMsg(_ message: NSAttributedString) {
        messages.append(message)
        tableView.reloadData()
        
        // 滚到最底部
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

extension ChatContentView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kChatContentCell, for: indexPath) as! ChatContentCell
        cell.contentLabel.attributedText = messages[indexPath.row]
        return cell
    }
}
