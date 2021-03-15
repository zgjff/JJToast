//
//  BlurEffectContainer.swift
//  JJToast
//
//  Created by 郑桂杰 on 2020/7/8.
//  Copyright © 2020 Qile. All rights reserved.
//

import UIKit

/// `BlurEffect`的容器默认实现
public final class BlurEffectContainer: NSObject {
    public var options = ToastContainerOptions()
    private let effectView = UIVisualEffectView()
    private var hiddenCompletion: (() -> ())?
    public init(effect: UIBlurEffect = UIBlurEffect(style: .dark)) {
        effectView.effect = effect
        effectView.isExclusiveTouch = true
        super.init()
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        effectView.addGestureRecognizer(tap)
    }
    
    deinit {
        debugPrint("BlurEffectContainer deinit")
    }
}

// MARK: - ToastContainer
extension BlurEffectContainer: ToastContainer {
    public func didCalculationView<T>(_ view: UIView, viewSize size: CGSize, sender: T) where T : Toastable {
        effectView.bounds.size = size
        effectView.contentView.addSubview(view)
    }
    
    public func toastContainerSize() -> CGSize {
        return effectView.bounds.size
    }
    
    public func showToast(inView view: UIView) {
        let center = options.postition.centerForContainer(self, inView: view)
        effectView.center = center
        effectView.layer.setCornerRadius(options.cornerRadius, corner: options.corners)
        effectView.clipsToBounds = true
        view.addSubview(effectView)
        options.onAppear?()
        if let ani = options.startAppearAnimations(for: effectView) {
            let key = options.layerAnimationKey(forShow: true)
            effectView.layer.add(ani, forKey: key)
        }
    }
    
    public func startHide(completion: (() -> ())?) {
        // 如果显示时间太短,还处在显示动画中,直接干掉显示动画
        effectView.layer.removeAllAnimations()
        if let ani = options.startHiddenAnimations(for: effectView) {
            hiddenCompletion = completion
            ani.delegate = self
            let key = options.layerAnimationKey(forShow: false)
            effectView.layer.add(ani, forKey: key)
        } else {
            effectView.removeFromSuperview()
            options.onDisappear?()
            completion?()
        }
    }
}

// MARK: - CAAnimationDelegate
extension BlurEffectContainer: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        effectView.layer.removeAllAnimations()
        effectView.removeFromSuperview()
        options.onDisappear?()
        hiddenCompletion?()
        hiddenCompletion = nil
    }
}

// MARK: - private
private extension BlurEffectContainer {
    @IBAction func onTap() {
        options.onClick?(self)
    }
}
