//
//  RoomViewController.swift
//  HHYTV
//
//  Created by 华惠友 on 2020/3/20.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController {

    // MARK: 控件属性
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var bottomView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
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
    }
    
    fileprivate func setupBlurView() {
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        blurView.frame = bgImageView.bounds
        bgImageView.addSubview(blurView)
    }
}

// MARK:- 事件监听
extension RoomViewController: Emitter {
    @IBAction func exitBtnClick() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func bottomMenuClick(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("点击了聊天")
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
