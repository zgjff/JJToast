//
//  SViewController.swift
//  Demo
//
//  Created by 郑桂杰 on 2020/7/16.
//  Copyright © 2020 zgj. All rights reserved.
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
//        let arr: NSMapTable<NSString, AAA> = .weakToStrongObjects()
//        arr.setObject(AAA(index: 0), forKey: "0")
//        arr.setObject(AAA(index: 1), forKey: "1")
//        arr.setObject(AAA(index: 2), forKey: "2")
//        print(arr, arr.count)
//        let keys = arr.keyEnumerator()
//        var key = keys.nextObject()
//        while key != nil {
//            print("----", key.unsafelyUnwrapped)
//            key = keys.nextObject()
//        }
//        arr.removeObject(forKey: "1")
//
//        let keys1 = arr.keyEnumerator()
//        var key1 = keys1.nextObject()
//        while key1 != nil {
//            print("+++++", key1.unsafelyUnwrapped)
//            key1 = keys1.nextObject()
//        }
//        print(arr, arr.count)
    }
    
    @IBAction private func onClickBarItem(_ sender: UIBarButtonItem) {
        let str = "稻盛和夫阿斯顿发生大返回数据卡的繁花似锦的卡号发生的咖喱和方式打开就会撒放到空间里阿水淀粉撒地方撒的"
//        let str = "是"
        let toast = IndicatorWithTextToastProvider(indicator: ArcrotationToastProvider(), text: TextToastProvider(text: str))
        view.makeToast(toast).updateToast { opt in
            opt.alignment = .right
        }
        .duration(.duration(10))
        .didClick { c in
            print("didClick+++++++++++++++")
            self.view.hideToast(c)
        }
//        .showStart(.inQueue)
        .show()
    }
}
