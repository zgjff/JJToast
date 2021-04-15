//
//  ActivityToastProvider.swift
//  JJToast
//
//  Created by 郑桂杰 on 2020/7/16.
//  Copyright © 2020 zgj. All rights reserved.
//

import UIKit

/// 显示菊花转动指示器的`toast`
public final class ActivityToastProvider {
    public typealias Options = ActivityToastOptions
    private lazy var activity = UIActivityIndicatorView(style: .white)
    weak public var delegate: ToastableDelegate?
}

// MARK: - ActivityIndicatorable
extension ActivityToastProvider: ActivityIndicatorToastable {
    public func layoutToastView(with options: ActivityToastOptions) {
        config(with: options)
        activity.sizeToFit()
        let size = calculationSize(with: options)
        activity.center = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        delegate?.didCalculationView(activity, viewSize: size, sender: self)
        startAnimating()
    }
    
    public func startAnimating() {
        activity.startAnimating()
    }
}

// MARK: - private
private extension ActivityToastProvider {
    func config(with options: ActivityToastOptions) {
        activity.style = options.style
        activity.color = options.color
    }
    
    func calculationSize(with options: ActivityToastOptions) -> CGSize {
        return CGSize(width: activity.bounds.width + options.padding.left + options.padding.right, height: activity.bounds.height + options.padding.top + options.padding.bottom)
    }
}

// MARK: - Activity配置

/// Activity转动`taost`配置项
public struct ActivityToastOptions: ToastOptions {
    public init() {}
    
    private static func defaultStyle() -> UIActivityIndicatorView.Style {
        if #available(iOS 13.0, *) {
            return UIActivityIndicatorView.Style.large
        } else {
            return .white
        }
    }
    
    /// 设置Activity颜色
    public var color = UIColor.white
    
    /// 设置`UIActivityIndicatorView.Style`
    public var style: UIActivityIndicatorView.Style = defaultStyle()
    
    /// 设置Activity内边距
    public var padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
}
