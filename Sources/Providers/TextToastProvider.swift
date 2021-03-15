//
//  TextToastProvider.swift
//  Demo
//
//  Created by 郑桂杰 on 2021/3/8.
//  Copyright © 2021 Qile. All rights reserved.
//

import UIKit

/// 显示文字的`toast`的默认实现
public final class TextToastProvider {
    public typealias Options = TextToastOptions
    private lazy var label = UILabel()
    weak public var delegate: ToastableDelegate?
    
    public init(text: String) {
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.text = text
    }

    public init(attributedString: NSAttributedString) {
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.attributedText = attributedString
    }
}

// MARK: - TextToastable
extension TextToastProvider: TextToastable {
    public func layoutToastView(with options: TextToastOptions) {
        configLabel(with: options)
        let (lsize, vsize) = calculationSize(with: options)
        label.frame = CGRect(origin: CGPoint(x: options.padding.left, y: options.padding.top), size: lsize)
        delegate?.didCalculationView(label, viewSize: vsize, sender: self)
    }
}

// MARK: - private
private extension TextToastProvider {
    func configLabel(with options: TextToastOptions) {
        label.lineBreakMode = options.lineBreakMode
        label.numberOfLines = options.numberOfLines
    }
    
    func calculationSize(with options: TextToastOptions) -> (CGSize, CGSize) {
        let labelMaxSize = CGSize(width: options.maxSize.width - options.padding.left - options.padding.right, height: options.maxSize.height - options.padding.top - options.padding.bottom)
        var labelSize = label.sizeThatFits(labelMaxSize)
        labelSize.width = labelSize.width > labelMaxSize.width ? labelMaxSize.width : labelSize.width
        labelSize.height = labelSize.height > labelMaxSize.height ? labelMaxSize.height : labelSize.height
        let w = labelSize.width + options.padding.left + options.padding.right
        let h = labelSize.height + options.padding.top + options.padding.bottom
        let viewSize = CGSize(width: w, height: h)
        return (labelSize, viewSize)
    }
}

// MARK: - 文字配置

/// 文字`taost`配置项
public struct TextToastOptions: ToastOptions {
    public init() {}
    /// 设置文字自动换行方式
    public var lineBreakMode = NSLineBreakMode.byTruncatingTail
    
    /// 设置文字最大行数
    public var numberOfLines = 0
    
    /// 设置文字内边距
    public var padding = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    
    /// 设置文字最大size
    public var maxSize = CGSize(width: UIScreen.main.bounds.width - 100, height: 300)
}
