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
    private lazy var label: UILabel = {
       let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16)
        l.textColor = .white
        l.textAlignment = .center
        l.backgroundColor = .clear
        l.numberOfLines = 0
        return l
    }()
    
    weak public var delegate: ToastableDelegate?
    
    public init(text: String) {
        label.text = text
    }

    public init(attributedString: NSAttributedString) {
        label.attributedText = attributedString
    }
    
    private var textPadding = UIEdgeInsets.zero
}

// MARK: - TextToastable
extension TextToastProvider: TextToastable {
    public func layoutToastView(with options: TextToastOptions) {
        textPadding = options.padding
        configLabel(with: options)
        let (lsize, vsize) = calculationSize(with: options.padding, maxSize: options.maxSize)
        label.frame = CGRect(origin: CGPoint(x: options.padding.left, y: options.padding.top), size: lsize)
        delegate?.didCalculationView(label, viewSize: vsize, sender: self)
    }
    
    public func resetContentSizeWithMaxSize(_ size: CGSize) {
        let (lsize, vsize) = calculationSize(with: textPadding, maxSize: size)
        label.frame = CGRect(origin: CGPoint(x: textPadding.left, y: textPadding.top), size: lsize)
        delegate?.didCalculationView(label, viewSize: vsize, sender: self)
    }
}

// MARK: - private
private extension TextToastProvider {
    func configLabel(with options: TextToastOptions) {
        label.lineBreakMode = options.lineBreakMode
        label.numberOfLines = options.numberOfLines
    }
    
    func calculationSize(with padding: UIEdgeInsets, maxSize: CGSize) -> (CGSize, CGSize) {
        let labelMaxSize = CGSize(width: maxSize.width - padding.left - padding.right, height: maxSize.height - padding.top - padding.bottom)
        var labelSize = label.sizeThatFits(labelMaxSize)
        labelSize.width = labelSize.width > labelMaxSize.width ? labelMaxSize.width : labelSize.width
        labelSize.height = labelSize.height > labelMaxSize.height ? labelMaxSize.height : labelSize.height
        let w = labelSize.width + padding.left + padding.right
        let h = labelSize.height + padding.top + padding.bottom
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
