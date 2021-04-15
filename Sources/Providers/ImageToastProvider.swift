//
//  ImageToastProvider.swift
//  Demo
//
//  Created by 郑桂杰 on 2021/3/8.
//  Copyright © 2021 zgj. All rights reserved.
//

import UIKit

/// 显示自定义图像的`toast`,可提供动画
public final class ImageToastProvider {
    public typealias Options = ImageToastOptions
    private lazy var imageView = UIImageView()
    private let animationImagesCount: Int
    weak public var delegate: ToastableDelegate?
    
    init(image: UIImage?, animationImages: [UIImage] = []) {
        animationImagesCount = animationImages.count
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.animationImages = animationImages
    }
}

// MARK: - ActivityIndicatorable
extension ImageToastProvider: ActivityIndicatorToastable {
    public func layoutToastView(with options: ImageToastOptions) {
        config(with: options)
        let (imageSize, toastSize) = calculationSize(with: options)
        imageView.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        imageView.center = CGPoint(x: toastSize.width * 0.5, y: toastSize.height * 0.5)
        delegate?.didCalculationView(imageView, viewSize: toastSize, sender: self)
        startAnimating()
    }
    
    public func startAnimating() {
        if animationImagesCount > 0 {
            imageView.startAnimating()
        }
    }
}

// MARK: - private
private extension ImageToastProvider {
    func config(with options: ImageToastOptions) {
        imageView.contentMode = options.contentMode
        if options.hasChangeAnimationDuration {
            imageView.animationDuration = options.animationDuration
        }
        imageView.animationRepeatCount = options.animationRepeatCount
    }
    
    func calculationSize(with options: ImageToastOptions) -> (image: CGSize, toast: CGSize) {
        let imageSize: CGSize
        switch options.imageSize {
        case .auto:
            imageView.sizeToFit()
            imageSize = imageView.bounds.size
        case .size(let s):
            imageSize = s
        }
        let width = imageSize.width + options.padding.left + options.padding.right
        let height = imageSize.height + options.padding.top + options.padding.bottom
        return (imageSize, CGSize(width: width, height: height))
    }
}

// MARK: - ImageToastOptions配置

/// 自定义图像`taost`配置项
public struct ImageToastOptions: ToastOptions {
    public init() {}
    /// 设置图像显示`mode`
    public var contentMode = UIImageView.ContentMode.scaleAspectFit
    
    /// 设置图像内边距
    public var padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    /// 设置图像大小---默认自适应图片大小
    public var imageSize = ImageSize.auto
    
    fileprivate var hasChangeAnimationDuration = false
    
    /// 设置动画持续时间
    public var animationDuration: TimeInterval = 0.25 {
        didSet {
            hasChangeAnimationDuration = true
        }
    }
    
    /// 设置动画重复次数
    public var animationRepeatCount = 0
}

extension ImageToastOptions {
    /// 图片大小
    public enum ImageSize {
        /// 自适应
        case auto
        /// 规定确定的size
        case size(CGSize)
    }
}
