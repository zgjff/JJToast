//
//  ToastContainerOptions.swift
//  JJToast
//
//  Created by 郑桂杰 on 2020/7/9.
//  Copyright © 2020 Qile. All rights reserved.
//

import UIKit

public struct ToastContainerOptions {
    internal var cornerRadius: CGFloat = 6
    internal var corners = UIRectCorner.allCorners
    internal var startStyle = ToastStartStyle.now
    internal var duration = ToastDuration.duration(2)
    internal var postition = ToastPosition.center
    internal var appearAnimations: Set<ContainerAnimator> = [ContainerAnimator.scale(0.3)]
    internal var disappearAnimations: Set<ContainerAnimator>!
    internal var onAppear: (() -> ())?
    internal var onDisappear: (() -> ())?
    internal var onClick: ((ToastContainer) -> ())?
    
    init() {
        disappearAnimations = oppositeOfAppearAnimations()
    }
}

extension ToastContainerOptions {
    internal func oppositeOfAppearAnimations() -> Set<ContainerAnimator> {
        var animations: Set<ContainerAnimator> = []
        for ani in appearAnimations {
            animations.insert(ani.opposite)
        }
        return animations
    }
    
    @discardableResult
    internal func startAppearAnimations(for view: UIView) -> CAAnimation? {
        return handleAnimations(appearAnimations, forView: view)
    }
       
    @discardableResult
    internal func startHiddenAnimations(for view: UIView) -> CAAnimation? {
        return handleAnimations(disappearAnimations, forView: view)
    }
       
    @discardableResult
    private func handleAnimations(_ animations: Set<ContainerAnimator>, forView view: UIView) -> CAAnimation? {
        if animations.isEmpty {
            return nil
        }
        var anis: [CAAnimation] = []
        for ani in animations {
            view.layer.setValue(ani.toValue, forKey: ani.keyPath)
            anis.append(ani.animation)
        }
        let group = CAAnimationGroup()
        group.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        group.duration = 0.2
        group.animations = anis
        return group
    }
       
    internal func layerAnimationKey(forShow isShow: Bool) -> String {
        return isShow ? "showGroupAnimations" : "hideGroupAnimations"
    }
}

extension ToastContainerOptions {
    public enum CornerRadius {
        case none
        case value(CGFloat)
        // TODO: 再加一个跟高一样的
    }
}
