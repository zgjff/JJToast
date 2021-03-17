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
            indicatorToastProvider = SubToastProvider(view: view, contentSize: view.bounds.size, toastSize: size)
        }
        if sender === textView {
            textToastProvider = SubToastProvider(view: view, contentSize: view.bounds.size, toastSize: size)
        }
    }
    
    private func calculationSize() {
        guard let indicatorProvider = indicatorToastProvider,
              let textProvider = textToastProvider else {
            return
        }
        // 指示器
        let indicatorSize = indicatorProvider.contentSize
        let indicatorFrame = indicatorProvider.view.frame
        let indicatorViewSize = indicatorProvider.toastSize
        
        let indicatorMargin = UIEdgeInsets(top: indicatorFrame.minY, left: indicatorFrame.minX, bottom: indicatorViewSize.height - indicatorFrame.maxY, right: indicatorViewSize.width - indicatorFrame.maxX)
        // 文字
        let textSize = textProvider.contentSize
        let textFrame = textProvider.view.frame
        let textViewSize = textProvider.toastSize
        let textMargin = UIEdgeInsets(top: textFrame.minY, left: textFrame.minX, bottom: textViewSize.height - textFrame.maxY, right: textViewSize.width - textFrame.maxX)
        let width: CGFloat
        let height: CGFloat
        
        switch options.alignment {
        case .top:
            let w = max(indicatorViewSize.width, textViewSize.width)
            let h = indicatorSize.height + textSize.height + options.indicatorAndTextSpace + indicatorMargin.top + textMargin.bottom
            
            width = max(w, options.minSize.width)
            height = max(h, options.minSize.height)
            
            if (width > options.maxSize.width) || (height > options.maxSize.height) {
                textView.resetContentSizeWithMaxSize(CGSize(width: options.maxSize.width, height: options.maxSize.height - options.indicatorAndTextSpace - indicatorSize.height - textMargin.bottom - indicatorMargin.top))
                return
            }
            
            let heightIsShortThanMinHeight = h < options.minSize.height
            
            if heightIsShortThanMinHeight {
                textProvider.view.frame = CGRect(x: width * 0.5 - textSize.width * 0.5, y: height - textMargin.bottom - textSize.height, width: textSize.width, height: textSize.height)
                indicatorProvider.view.frame = CGRect(x: width * 0.5 - indicatorSize.width * 0.5, y: textProvider.view.frame.minY - options.indicatorAndTextSpace - indicatorSize.height, width: indicatorSize.width, height: indicatorSize.height)
            } else {
                textProvider.view.frame = CGRect(x: width * 0.5 - textSize.width * 0.5, y: height - textMargin.bottom - textSize.height, width: textSize.width, height: textSize.height)
                indicatorProvider.view.frame = CGRect(x: width * 0.5 - indicatorSize.width * 0.5, y: textProvider.view.frame.minY - options.indicatorAndTextSpace - indicatorSize.height, width: indicatorSize.width, height: indicatorSize.height)
            }
        case .bottom:
            let w = max(indicatorViewSize.width, textViewSize.width)
            let h = indicatorSize.height + textSize.height + options.indicatorAndTextSpace + indicatorMargin.top + textMargin.bottom
            
            width = max(w, options.minSize.width)
            height = max(h, options.minSize.height)
            
            if (width > options.maxSize.width) || (height > options.maxSize.height) {
                textView.resetContentSizeWithMaxSize(CGSize(width: options.maxSize.width, height: options.maxSize.height - options.indicatorAndTextSpace - indicatorSize.height - textMargin.top - indicatorMargin.bottom))
                return
            }
            
            let heightIsShortThanMinHeight = h < options.minSize.height
            
            if heightIsShortThanMinHeight {
                textProvider.view.frame = CGRect(x: width * 0.5 - textSize.width * 0.5, y: textMargin.top, width: textSize.width, height: textSize.height)
                indicatorProvider.view.frame = CGRect(x: width * 0.5 - indicatorSize.width * 0.5, y: textProvider.view.frame.maxY + options.indicatorAndTextSpace, width: indicatorSize.width, height: indicatorSize.height)
            } else {
                textProvider.view.frame = CGRect(x: width * 0.5 - textSize.width * 0.5, y: textMargin.top, width: textSize.width, height: textSize.height)
                
                indicatorProvider.view.frame = CGRect(x: width * 0.5 - indicatorSize.width * 0.5, y: textProvider.view.frame.maxY + options.indicatorAndTextSpace, width: indicatorSize.width, height: indicatorSize.height)
            }
        case .left:
            let w = indicatorSize.width + textSize.width + options.indicatorAndTextSpace + indicatorMargin.left + textMargin.right
            let h = max(indicatorViewSize.height, textViewSize.height)
            
            width = max(w, options.minSize.width)
            height = max(h, options.minSize.height)
            if (width > options.maxSize.width) || (height > options.maxSize.height) {
                textView.resetContentSizeWithMaxSize(CGSize(width: options.maxSize.width - options.indicatorAndTextSpace - indicatorMargin.left - indicatorSize.width - textMargin.right, height: options.maxSize.height))
                return
            }
            
            let widthIsShortThanMinWidth = w < options.minSize.width
            
            if widthIsShortThanMinWidth {
                indicatorProvider.view.frame = CGRect(x: width * 0.5 - indicatorSize.width, y: height * 0.5 - indicatorSize.height * 0.5, width: indicatorSize.width, height: indicatorSize.height)
                textProvider.view.frame = CGRect(x: indicatorProvider.view.frame.maxX + options.indicatorAndTextSpace, y: height * 0.5 - textSize.height * 0.5, width: textSize.width, height: textSize.height)
            } else {
                indicatorProvider.view.frame = CGRect(x: indicatorMargin.left, y: height * 0.5 - indicatorSize.height * 0.5, width: indicatorSize.width, height: indicatorSize.height)
                textProvider.view.frame = CGRect(x: indicatorProvider.view.frame.maxX + options.indicatorAndTextSpace, y: height * 0.5 - textSize.height * 0.5, width: textSize.width, height: textSize.height)
            }
        case .right:
            let w = indicatorSize.width + textSize.width + options.indicatorAndTextSpace + indicatorMargin.left + textMargin.right
            let h = max(indicatorViewSize.height, textViewSize.height)
            
            width = max(w, options.minSize.width)
            height = max(h, options.minSize.height)
            
            if (width > options.maxSize.width) || (height > options.maxSize.height) {
                textView.resetContentSizeWithMaxSize(CGSize(width: options.maxSize.width - options.indicatorAndTextSpace - indicatorMargin.right - indicatorSize.width - textMargin.left, height: options.maxSize.height))
                return
            }
            
            let widthIsShortThanMinWidth = w < options.minSize.width
            
            if widthIsShortThanMinWidth {
                indicatorProvider.view.frame = CGRect(x: width * 0.5, y: height * 0.5 - indicatorSize.height * 0.5, width: indicatorSize.width, height: indicatorSize.height)
                textProvider.view.frame = CGRect(x: indicatorProvider.view.frame.minX - options.indicatorAndTextSpace - textSize.width, y: height * 0.5 - textSize.height * 0.5, width: textSize.width, height: textSize.height)
            } else {
                indicatorProvider.view.frame = CGRect(x: width - indicatorMargin.right - indicatorSize.width, y: height * 0.5 - indicatorSize.height * 0.5, width: indicatorSize.width, height: indicatorSize.height)
                textProvider.view.frame = CGRect(x: indicatorProvider.view.frame.minX - options.indicatorAndTextSpace - textSize.width, y: height * 0.5 - textSize.height * 0.5, width: textSize.width, height: textSize.height)
            }
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
    
    /// 文字与指示器的间距
    public var indicatorAndTextSpace: CGFloat = 15
    
    /// 设置最大size
    public var maxSize = CGSize(width: UIScreen.main.bounds.width - 100, height: 500)
    
    /// 设置最小size
    public var minSize = CGSize(width: 125, height: 125)
}

extension IndicatorWithTextToastProvider {
    /// 指示器于文字之间的对齐方式
    public enum IndicatorAlignment {
        case top, left, bottom, right
    }
    
    private struct SubToastProvider {
        let view: UIView
        let contentSize: CGSize
        let toastSize: CGSize
    }
}
