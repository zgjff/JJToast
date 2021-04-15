//
//  ToastPosition.swift
//  JJToast
//
//  Created by 郑桂杰 on 2020/7/8.
//  Copyright © 2020 zgj. All rights reserved.
//

import UIKit

/// Toast的显示位置
public struct ToastPosition {
    private let centerYRatio: CGFloat
    private let offset: CGFloat
    
    /// 初始化ToastPosition
    /// - Parameters:
    ///   - centerYRatio: taost container的中心点占superView的比例,具体算法为
    ///
    ///         containerView.centerY/(superView.height - containerView.height - superView.safeAreaInsets.top - superView.safeAreaInsets.bottom)
    ///
    ///   - offset: centerY的偏移量
    public init(centerYRatio: CGFloat, offset: CGFloat) {
        self.centerYRatio = centerYRatio
        self.offset = offset
    }
}

extension ToastPosition {
    /// 顶部
    public static let top = ToastPosition(centerYRatio: 0, offset: 0)
    /// 四分之一处
    public static let quarter = ToastPosition(centerYRatio: 0.25, offset: 0)
    /// 中心处
    public static let center = ToastPosition(centerYRatio: 0.5, offset: 0)
    /// 四分之三处
    public static let threeQuarter = ToastPosition(centerYRatio: 0.75, offset: 0)
    /// 底部
    public static let bottom = ToastPosition(centerYRatio: 1, offset: 0)
}

extension ToastPosition {
    internal func centerForContainer(_ container: ToastContainer, inView superView: UIView) -> CGPoint {
        let cx = superView.bounds.width * 0.5
        let containerSize = container.toastContainerSize()
        let safeAreaHeight = superView.bounds.height - containerSize.height - superView.safeInserts.top - superView.safeInserts.bottom
        let cy = safeAreaHeight * centerYRatio + offset + containerSize.height * 0.5 + superView.safeInserts.top
        return CGPoint(x: cx, y: cy)
    }
}

extension ToastPosition: Equatable {
    public static func == (lhs: ToastPosition, rhs: ToastPosition) -> Bool {
        return (lhs.centerYRatio == rhs.centerYRatio) && (lhs.offset == rhs.offset)
    }
}
