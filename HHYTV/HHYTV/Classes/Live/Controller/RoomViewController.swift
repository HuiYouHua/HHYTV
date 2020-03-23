//
//  RoomViewController.swift
//  HHYTV
//
//  Created by 华惠友 on 2020/3/20.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit

private let kChatToosViewHeight: CGFloat = 44

class RoomViewController: UIViewController {

    // MARK: 控件属性
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var bottomView: UIStackView!
    
    fileprivate lazy var chatToolsView: ChatToolsView = ChatToolsView.loadFromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
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
        chatToolsView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kChatToosViewHeight)
        chatToolsView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        view.addSubview(chatToolsView)
    }
}

// MARK:- 事件监听
extension RoomViewController: Emitter {
    @IBAction func exitBtnClick() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        chatToolsView.inputTextField.resignFirstResponder()
    }
    
    @IBAction func bottomMenuClick(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            chatToolsView.inputTextField.becomeFirstResponder()
        case 1:
            print("点击了分享")
        case 2:
            print("点击了礼物")
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

        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveLinear, animations: {
            let endY = inputViewY == (kScreenH - kChatToosViewHeight) ? kScreenH : inputViewY
            self.chatToolsView.frame.origin.y = endY
        }, completion: nil)
    }
}
