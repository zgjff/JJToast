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
        let str = "稻盛和夫阿斯顿发生大返回数据卡的繁花似锦的卡号发生的咖喱和方式打开就会撒放到空间里阿水淀粉撒地方撒的"
//        let str = "是"
        let toast = IndicatorWithTextToastProvider(indicator: ArcrotationToastProvider(), text: TextToastProvider(text: str))
        view.makeToast(toast).updateToast { opt in
            opt.alignment = .right
        }
        .duration(.distantFuture)
        .didClick { [unowned self] c in
            self.view.hideToast(c)
        }.showStart(.inQueue)
        .show()
    }
}
