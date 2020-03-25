//
//  AttrStringGenerator.swift
//  HHYTV
//
//  Created by 华惠友 on 2020/3/25.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit
import Kingfisher

class AttrStringGenerator {

}

extension AttrStringGenerator {
    class func generateJoinLeaveRoom(_ username: String, _ isJoin: Bool) -> NSAttributedString {
        let message = "\(username) " + (isJoin ? "进入房间" : "离开房间")

        let attr = NSMutableAttributedString(string: message)
        attr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.orange], range: NSRange(location: 0, length: username.count))
        return attr
    }
    
    class func generatorTextMessage(_ username: String, _ message: String) -> NSAttributedString {
        // 1.获取整个字符串
         let message = "\(username): \(message)"
         
         // 2.创建属性字符串
         let attr = NSMutableAttributedString(string: message)
        
         // 3.将名称加色
         attr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.orange], range: NSRange(location: 0, length: username.count))
         
         // 4.将所有表情匹配出来,并换乘对应的图片进行展示
         // 4.1.创建正则表达式匹配规则
         let pattern = "\\[.*?\\]"
         guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return attr }
         let results = regex.matches(in: message, options: [], range: NSRange(location: 0, length: message.count))
         
         // 4.2.获取表情的结果(从后往前遍历)
         for i in (0..<results.count).reversed() {
             // 4.3.获取结果
             let result = results[i]
             let emoticonName = (message as NSString).substring(with: result.range)
             
             // 4.4.根据结果创建对应的图片
             guard let image = UIImage(named: emoticonName) else { continue }
             
             // 4.5.根据图片创建NSTextAttachment
             let attachment = NSTextAttachment()
             attachment.image = image
             let fontSize = UIFont.systemFont(ofSize: 17)
             attachment.bounds = CGRect(x: 0, y: -3, width: fontSize.lineHeight, height: fontSize.lineHeight)
             let imageAttStr = NSAttributedString(attachment: attachment)
             
             // 4.6.将imageAttStr替换之前的文本位置
             attr.replaceCharacters(in: result.range, with: imageAttStr)
         }
        return attr
    }
    
    class func generatorGiftMessage(_ username: String, _ giftname: String, _ giftURL: String) -> NSAttributedString {
        let message = "\(username) 赠送 \(giftname)"

        let attr = NSMutableAttributedString(string: message)
        attr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.orange], range: NSRange(location: 0, length: username.count))
        let range = (message as NSString).range(of: giftname)
        attr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], range: range)

        // 拼接图片
        guard let image = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: giftURL) else {
            return attr
        }
        let attachment = NSTextAttachment()
        attachment.image = image
        let font = UIFont.systemFont(ofSize: 17)
        attachment.bounds = CGRect(x: 0, y: -3, width: font.lineHeight, height: font.lineHeight)
        let imageAttrStr = NSAttributedString(attachment: attachment)
        attr.append(imageAttrStr)
        
        return attr
    }
}
