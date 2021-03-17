//
//  TextToastable.swift
//  JJToast
//
//  Created by 郑桂杰 on 2020/7/7.
//  Copyright © 2020 Qile. All rights reserved.
//

import UIKit

public protocol ToastOptions {
    init()
}

public protocol Toastable: class {
    associatedtype Options: ToastOptions
    var delegate: ToastableDelegate? { get set }
    func layoutToastView(with options: Options)
}

public protocol ToastableDelegate: NSObjectProtocol {
    func didCalculationView<T>(_ view: UIView, viewSize size: CGSize, sender: T) where T: Toastable
}

/// 显示文字的 `toast`协议
public protocol TextToastable: Toastable {
    init(text: String)
    init(attributedString: NSAttributedString)
    func resetContentSizeWithMaxSize(_ size: CGSize)
}

/// 显示活动指示器的 `toast`协议
public protocol ActivityIndicatorToastable: Toastable {
    func startAnimating()
}

/// 显示指示器+富文本的 `toast`协议
public protocol IndicatorWithTextToastable: Toastable {
    func startAnimating()
}

// TODO: 进度条
public protocol ProgressToastable: Toastable {
    func setProgress(_ progress: Float, animated: Bool)
}
