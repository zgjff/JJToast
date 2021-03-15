//
//  SViewController.swift
//  Demo
//
//  Created by 郑桂杰 on 2020/7/16.
//  Copyright © 2020 Qile. All rights reserved.
//

import UIKit

class SViewController: UIViewController {

    deinit {
        debugPrint("SViewController  deinit")
    }
}

extension SViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(onClickBarItem(_:)))
        
    }
    
    @IBAction private func onClickBarItem(_ sender: UIBarButtonItem) {
        let toast = IndicatorWithTextToastProvider(indicator: ArcrotationToastProvider(), text: TextToastProvider(text: "abcdefasdfksjdafhaksljdhf首发独家反馈哈圣诞节快乐返回萨里的科技护肤撒到了会计法黄金时代克拉合法圣诞节快乐返回撒的快乐返回"))
        view.makeToast(toast).updateToast { opt in
//                opt.imageSize = CGSize(width: 20, height: 20)
            opt.alignment = .bottom
        }
        .duration(.distantFuture)
        .didClick { [unowned self] c in
            self.view.hideToast(c)
        }.didDisappear {
            print("12312321312")
        }.showStart(.inQueue)
        .show()
    }
    
    func aaaa<T: UIViewController>(vc: T) {
        
    }
}
