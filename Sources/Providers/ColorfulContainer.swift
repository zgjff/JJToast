//
//  ColorfulContainer.swift
//  Demo
//
//  Created by 郑桂杰 on 2020/7/31.
//  Copyright © 2020 zgj. All rights reserved.
//

import UIKit

/// 带背景色的容器默认实现
public final class ColorfulContainer: NSObject {
    public var options = ToastContainerOptions()
    private let backgroundView = UIView()
    private var hiddenCompletion: ((ColorfulContainer) -> ())?
    
    init(color: UIColor) {
        super.init()
        backgroundView.backgroundColor = color
        backgroundView.isExclusiveTouch = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        backgroundView.addGestureRecognizer(tap)
    }
    
    deinit {
        debugPrint("ColorfulContainer deinit")
    }
}

// MARK: - ToastContainer
extension ColorfulContainer: ToastContainer {
    public func didCalculationView<T>(_ view: UIView, viewSize size: CGSize, sender: T) where T : Toastable {
        backgroundView.bounds.size = size
        backgroundView.addSubview(view)
    }
    
    public func toastContainerSize() -> CGSize {
        return backgroundView.bounds.size
    }
    
    public func showToast(inView view: UIView) {
        let center = options.postition.centerForContainer(self, inView: view)
        backgroundView.center = center
        backgroundView.layer.setCornerRadius(options.cornerRadius, corner: options.corners)
        backgroundView.clipsToBounds = true
        view.addSubview(backgroundView)
        options.onAppear?()
        if let ani = options.startAppearAnimations(for: backgroundView) {
            let key = options.layerAnimationKey(forShow: true)
            backgroundView.layer.add(ani, forKey: key)
        }
    }
    public func startHide(completion: ((ColorfulContainer) -> ())?) {
        // 如果显示时间太短,还处在显示动画中,直接干掉显示动画
        backgroundView.layer.removeAllAnimations()
        if let ani = options.startHiddenAnimations(for: backgroundView) {
            hiddenCompletion = completion
            ani.delegate = WeakProxy(target: self).target
            let key = options.layerAnimationKey(forShow: false)
            backgroundView.layer.add(ani, forKey: key)
        } else {
            backgroundView.removeFromSuperview()
            options.onDisappear?()
            completion?(self)
        }
    }
}

// MARK: - CAAnimationDelegate
extension ColorfulContainer: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        backgroundView.layer.removeAllAnimations()
        backgroundView.removeFromSuperview()
        options.onDisappear?()
        hiddenCompletion?(self)
        hiddenCompletion = nil
    }
}

// MARK: - private
private extension ColorfulContainer {
    @IBAction func onTap() {
        options.onClick?(self)
    }
}
