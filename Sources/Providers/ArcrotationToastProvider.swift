//
//  ArcrotationToastProvider.swift
//  JJToast
//
//  Created by 郑桂杰 on 2020/7/24.
//  Copyright © 2020 zgj. All rights reserved.
//

import UIKit

/// 显示三色旋转的转动指示器的`toast`
public final class ArcrotationToastProvider {
    public typealias Options = ArcrotationToastOptions
    weak public var delegate: ToastableDelegate?
    private var view: View!
}

// MARK: - ActivityIndicatorable
extension ArcrotationToastProvider: ActivityIndicatorToastable {
    public func layoutToastView(with options: ArcrotationToastOptions) {
        let viewFrame = CGRect(x: 0, y: 0, width: options.radius * 2, height: options.radius * 2)
        view = View(frame: viewFrame, options: options)
        let viewSize = CGSize(width: options.radius * 2 + options.margin * 2, height: options.radius * 2 + options.margin * 2)
        view.center = CGPoint(x: viewSize.width * 0.5, y: viewSize.height * 0.5)
        delegate?.didCalculationView(view, viewSize: viewSize, sender: self)
    }
    
    public func startAnimating() {
        if view != nil {
            view.startAnimating()
        }
    }
}

// MARK: - Arcrotation配置

/// 三色旋转器配置项
public struct ArcrotationToastOptions: ToastOptions {
    public init() {}
    /// 三个圆弧的颜色
    public var colors = (UIColor.white, UIColor.systemGreen, UIColor.systemRed)
    
    /// 圆的半径
    public var radius: CGFloat = 20
    
    /// 圆弧角度--必须小于120度
    public var angle = CGFloat.pi / 3.0
    
    /// 圆弧距离containerView边缘的距离
    public var margin: CGFloat = 20
    
    /// 圆弧线条宽度
    public var layerLineWidth: CGFloat = 3
    
    /// 动画节奏
    public var timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    
    /// 动画周期时间
    public var animationDuration: CFTimeInterval = 1.5
}

// MARK: - 动画view
extension ArcrotationToastProvider {
    fileprivate class View: UIView {
        init(frame: CGRect, options: ArcrotationToastOptions) {
            self.options = options
            super.init(frame: frame)
            setup()
            NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        }
        
        fileprivate let options: ArcrotationToastOptions
        fileprivate lazy var layer1 = CAShapeLayer()
        fileprivate lazy var layer2 = CAShapeLayer()
        fileprivate lazy var layer3 = CAShapeLayer()
        private var rotaAnim: CAKeyframeAnimation?
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    }
}

extension ArcrotationToastProvider.View {
    private func setup() {
        let arcAngle = (options.angle < CGFloat.pi / 1.5) ? options.angle : CGFloat.pi / 1.5
        let spaceAngle = (CGFloat.pi * 2 - arcAngle * 3) / 3.0
        let firstStartAngle: CGFloat = 0
        addShaperLayer(layer1, strokeColor: options.colors.0, startAngle: firstStartAngle, arcAngle: arcAngle)
        let secondStartAngle = firstStartAngle + arcAngle + spaceAngle
        addShaperLayer(layer2, strokeColor: options.colors.1, startAngle: secondStartAngle, arcAngle: arcAngle)
        let thirdStartAngle = secondStartAngle + arcAngle + spaceAngle
        addShaperLayer(layer3, strokeColor: options.colors.2, startAngle: thirdStartAngle, arcAngle: arcAngle)
    }
    
    private func addShaperLayer(_ shapeLayer: CAShapeLayer, strokeColor: UIColor, startAngle: CGFloat, arcAngle: CGFloat) {
        shapeLayer.lineWidth = options.layerLineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineCap = .round
        let r = options.radius
        let arcCenter = CGPoint(x: r, y: r)
        let path = UIBezierPath(arcCenter: arcCenter, radius: r, startAngle: startAngle, endAngle: startAngle + arcAngle, clockwise: true)
        shapeLayer.path = path.cgPath
        layer.addSublayer(shapeLayer)
    }
    
    @IBAction private func willEnterForeground() {
        self.startAnimating()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window != nil {
            startAnimating()
        }
    }
    
    func startAnimating() {
        rotaAnim = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotaAnim?.timingFunction = options.timingFunction
        rotaAnim?.values = [0, CGFloat.pi, CGFloat.pi * 2]
        rotaAnim?.duration = options.animationDuration
        rotaAnim?.repeatCount = HUGE
        layer.add(rotaAnim!, forKey: "transformAni")
    }
}
