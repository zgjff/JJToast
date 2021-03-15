//
//  IndicatorWithTextToastProvider.swift
//  Demo
//
//  Created by 郑桂杰 on 2021/3/8.
//  Copyright © 2021 Qile. All rights reserved.
//

import UIKit

/// 显示指示器+文字的`toast`
public final class IndicatorWithTextToastProvider<Indicator: ActivityIndicatorToastable, Text: TextToastable>: NSObject, IndicatorWithTextToastable, ToastableDelegate {
    public typealias Options = IndicatorWithTextToastProviderOptions<Indicator, Text>
    weak public var delegate: ToastableDelegate?
    private let indicatorView: Indicator
    private let textView: Text
    private var options: Options = Options.init()
    
    public init(indicator: Indicator, text: Text) {
        indicatorView = indicator
        textView = text
        super.init()
        indicator.delegate = self
        textView.delegate = self
    }
    
    private var indicatorToastProvider: SubToastProvider? {
        didSet {
            calculationSize()
        }
    }
    
    private var textToastProvider: SubToastProvider? {
        didSet {
            calculationSize()
        }
    }
}

// MARK: - ToastableDelegate
extension IndicatorWithTextToastProvider {
    public func didCalculationView<T>(_ view: UIView, viewSize size: CGSize, sender: T) where T : Toastable {
        if sender === indicatorView {
            indicatorToastProvider = SubToastProvider(view: view, size: view.bounds.size)
        }
        if sender === textView {
            textToastProvider = SubToastProvider(view: view, size: view.bounds.size)
        }
    }
    
    private func calculationSize() {
        guard let indicatorProvider = indicatorToastProvider,
              let textProvider = textToastProvider else {
            return
        }
        // 指示器
        let indicatorProviderSize = indicatorProvider.size
        // 文字
        let textProviderSize = textProvider.size
        
        let indicatorMargin = options.indicatorMargin
        let textMargin = options.textMargin
        
        let width: CGFloat
        let height: CGFloat
        
        switch options.alignment {
        case .top:
            width = max(indicatorProviderSize.width + indicatorMargin.left + indicatorMargin.right, textProviderSize.width + textMargin.left + textMargin.right)
            height = indicatorProviderSize.height + indicatorMargin.top + textProviderSize.height + textMargin.bottom + options.indicatorAndTextSpace
            indicatorProvider.view.frame = CGRect(x: width * 0.5 - indicatorProviderSize.width * 0.5, y: indicatorMargin.top, width: indicatorProviderSize.width, height: indicatorProviderSize.height)
            textProvider.view.frame = CGRect(x: width * 0.5 - textProviderSize.width * 0.5, y: height - textMargin.bottom - textProviderSize.height, width: textProviderSize.width, height: textProviderSize.height)
        case .bottom:
            width = max(indicatorProviderSize.width + indicatorMargin.left + indicatorMargin.right, textProviderSize.width + textMargin.left + textMargin.right)
            height = indicatorProviderSize.height + indicatorMargin.top + textProviderSize.height + textMargin.bottom + options.indicatorAndTextSpace
            textProvider.view.frame = CGRect(x: width * 0.5 - textProviderSize.width * 0.5, y: textMargin.top, width: textProviderSize.width, height: textProviderSize.height)
            indicatorProvider.view.frame = CGRect(x: width * 0.5 - indicatorProviderSize.width * 0.5, y: height - indicatorMargin.bottom - indicatorProviderSize.height, width: indicatorProviderSize.width, height: indicatorProviderSize.height)
        case .left:
            // TODO
            width = 0
            height = 0
        case .right:
            // TODO
            width = 0
            height = 0
        }
        let view = UIView()
        view.addSubview(indicatorProvider.view)
        view.addSubview(textProvider.view)
        delegate?.didCalculationView(view, viewSize: CGSize(width: width, height: height), sender: self)
    }
}

// MARK: - IndicatorWithTextToastable
extension IndicatorWithTextToastProvider {
    public func layoutToastView(with options: IndicatorWithTextToastProviderOptions<Indicator, Text>) {
        self.options = options
        indicatorView.layoutToastView(with: options.indicatorOptions)
        textView.layoutToastView(with: options.textOptions)
    }
    
    public func startAnimating() {
        indicatorView.startAnimating()
    }
}

public struct IndicatorWithTextToastProviderOptions<Indicator: ActivityIndicatorToastable, Text: TextToastable>: ToastOptions {
    public init() {}
    /// 指示器设置选项
    public var indicatorOptions = Indicator.Options.init()
    
    /// 文字设置选项
    public var textOptions = Text.Options.init()
    
    /// 指示器对齐方式
    public var alignment = IndicatorWithTextToastProvider<Indicator, Text>.IndicatorAlignment.top
    
    /// 文字外边距
    public var textMargin = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    
    /// 指示器外边距
    public var indicatorMargin = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    
    /// 文字与指示器的间距
    public var indicatorAndTextSpace: CGFloat = 15
    
    /// 设置最大size
    public var maxSize = CGSize(width: UIScreen.main.bounds.width - 100, height: 500)
}

extension IndicatorWithTextToastProvider {
    /// 指示器于文字之间的对齐方式
    public enum IndicatorAlignment {
        case top, left, bottom, right
    }
    
    private struct SubToastProvider {
        let view: UIView
        let size: CGSize
    }
}
