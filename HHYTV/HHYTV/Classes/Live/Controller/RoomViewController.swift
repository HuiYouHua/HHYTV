//
//  RoomViewController.swift
//  HHYTV
//
//  Created by 华惠友 on 2020/3/20.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit
import Kingfisher

private let kChatToosViewHeight: CGFloat = 44
private let kGiftlistViewHeight : CGFloat = 370
private let kChatContentViewHeight: CGFloat = 200

class RoomViewController: UIViewController {

    // MARK: 控件属性
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var bottomView: UIStackView!
    
    fileprivate lazy var chatToolsView: ChatToolsView = ChatToolsView.loadFromNib()
    fileprivate lazy var giftListView: GiftListView = GiftListView.loadFromNib()
    fileprivate lazy var chatContentView: ChatContentView = ChatContentView.loadFromNib()
    fileprivate lazy var socket: HHYSocket = HHYSocket(addr: "192.168.1.101", port: 8080)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.设置UI界面
        setupUI()
        
        // 2.监听键盘通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // 3.连接聊天服务器
        if socket.connectServer() {
            print("连接成功")
            socket.delegate = self
            socket.startReadMsg()
            socket.sendJoinRoom()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        socket.sendLeaveRoom()
    }
}

extension RoomViewController {
    fileprivate func setupUI() {
        view.backgroundColor = .white
        setupBlurView()
        setupBottomView()
    }
    
    fileprivate func setupBlurView() {
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        blurView.frame = bgImageView.bounds
        bgImageView.addSubview(blurView)
    }
    
    fileprivate func setupBottomView() {
        // 1.设置chatToolsView
        chatToolsView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kChatToosViewHeight)
        chatToolsView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        chatToolsView.delegate = self
        view.addSubview(chatToolsView)
        
        // 2.设置GiftListView
        giftListView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kGiftlistViewHeight)
        giftListView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        giftListView.delegate = self
        view.addSubview(giftListView)
        
        // 3.设置chatContentView
        chatContentView.frame = CGRect(x: 0, y: view.bounds.height - kSafeAreaHeight - 44 - kChatContentViewHeight, width: view.bounds.width, height: kChatContentViewHeight)
        chatContentView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        view.insertSubview(chatContentView, belowSubview: chatToolsView)
    }
}

// MARK:- 事件监听
extension RoomViewController: Emitter {
    @IBAction func exitBtnClick() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        chatToolsView.inputTextField.resignFirstResponder()
        UIView.animate(withDuration: 0.25) {
            self.giftListView.frame.origin.y = self.view.bounds.height
        }
    }
    
    @IBAction func bottomMenuClick(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            chatToolsView.inputTextField.becomeFirstResponder()
        case 1:
            print("点击了分享")
        case 2:
            UIView.animate(withDuration: 0.25, animations: {
                self.giftListView.frame.origin.y = kScreenH - kGiftlistViewHeight
            })
        case 3:
            print("点击了更多")
        case 4:
            let point = bottomView.convert(sender.center, to: view)
            sender.isSelected = !sender.isSelected
            sender.isSelected ? startEmitter(point) : stopEmitter()
        default:
            fatalError("未处理按钮")
        }
    }
}


// MARK: - 监听键盘弹出
extension RoomViewController {
    @objc fileprivate func keyboardWillChangeFrame(_ note: Notification) {
        let duration = note.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let endFrame = (note.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let inputViewY = endFrame.origin.y - kChatToosViewHeight


//            UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationCurve(rawValue: 7), animations: {
                
//            }, completion: nil)
//
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveLinear, animations: {
            let endY = inputViewY == (kScreenH - kChatToosViewHeight) ? kScreenH : inputViewY
            self.chatToolsView.frame.origin.y = endY
            
            let contentEndY = (inputViewY == (kScreenH - kChatToosViewHeight) ? (kScreenH - kChatContentViewHeight - 44) : (endY - kChatContentViewHeight)) - kSafeAreaHeight
            self.chatContentView.frame.origin.y = contentEndY
        }, completion: nil)
    }
}

// MARK: - 监听用户输入的内容
extension RoomViewController: ChatToolsViewDelegate, GiftListViewDelegate {
    func chatToolsView(toolView: ChatToolsView, message: String) {
        socket.sendTextMsg(message: message)
    }
    
    func giftListView(giftView: GiftListView, giftModel: GiftModel) {
        print(giftModel.subject)
        socket.sendGiftMsg(giftName: giftModel.subject, giftURL: giftModel.img2, giftCount: 1)
    }
}


extension RoomViewController: HHYSocketDelegate {
    func socket(_ socket: HHYSocket, joinRoom user: UserInfo) {
        let attr = AttrStringGenerator.generateJoinLeaveRoom(user.name!, true)
        chatContentView.inserMsg(attr)
    }
    
    func socket(_ socket: HHYSocket, leaveRoom user: UserInfo) {
        let attr = AttrStringGenerator.generateJoinLeaveRoom(user.name!, false)
        chatContentView.inserMsg(attr)
    }
    
    func socket(_ socket: HHYSocket, chatMessage: ChatMessage) {
        let attr = AttrStringGenerator.generatorTextMessage(chatMessage.user.name!, chatMessage.text!)
        chatContentView.inserMsg(attr)
    }
    
    func socket(_ socket: HHYSocket, giftMessage: GiftMessage) {
        let attr = AttrStringGenerator.generatorGiftMessage(giftMessage.user.name!, giftMessage.giftname!, giftMessage.giftUrl!)
        chatContentView.inserMsg(attr)
    }
}
