//
//  ToastContainer.swift
//  JJToast
//
//  Created by 郑桂杰 on 2020/7/7.
//  Copyright © 2020 Qile. All rights reserved.
//

import UIKit

/// `toast`容器协议
public protocol ToastContainer: ToastableDelegate {
    var options: ToastContainerOptions { get set }
    func toastContainerSize() -> CGSize
    func showToast(inView view: UIView)
    func startHide(completion: (() -> ())?)
}
