//
//  Extensions.swift
//  JJToast
//
//  Created by 郑桂杰 on 2020/7/8.
//  Copyright © 2020 Qile. All rights reserved.
//

import UIKit

internal extension CALayer {
    func setCornerRadius(_ radius: CGFloat, corner: UIRectCorner) {
        if #available(iOS 11.0, *) {
            cornerRadius = radius
            var maskedCorners: CACornerMask = []
            if corner.contains(.topLeft) {
                maskedCorners.insert(.layerMinXMinYCorner)
            }
            if corner.contains(.topRight) {
                maskedCorners.insert(.layerMaxXMinYCorner)
            }
            if corner.contains(.bottomLeft) {
                maskedCorners.insert(.layerMinXMaxYCorner)
            }
            if corner.contains(.bottomRight) {
                maskedCorners.insert(.layerMaxXMaxYCorner)
            }
            self.maskedCorners = maskedCorners
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = bounds
            maskLayer.path = path.cgPath
            mask = maskLayer
        }
    }
}

internal extension UIView {
    var safeInserts: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return safeAreaInsets
        } else {
            return .zero
        }
    }
}
