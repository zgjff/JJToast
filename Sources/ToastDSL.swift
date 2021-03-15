//
//  ToastDSL.swift
//  JJToast
//
//  Created by 郑桂杰 on 2020/7/17.
//  Copyright © 2020 Qile. All rights reserved.
//

import UIKit

public class ToastDSL<T> where T: Toastable {
    private var toast: T
    private var toastOptions = T.Options.init()
    private var containerOptions = ToastContainerOptions()
    private var container: ToastContainer!
    private unowned let view: UIView
    internal init(view: UIView, toast: T) {
        self.view = view
        self.toast = toast
    }
    
    deinit {
        debugPrint("ToastDSL  deinit")
    }
}

// MARK: - Config
public extension ToastDSL {
    func updateToast(options block: (inout T.Options) -> ()) -> Self {
        block(&toastOptions)
        return self
    }
    
    func useContainer(_ container: ToastContainer) -> Self {
        self.container = container
        return self
    }
    
    func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        containerOptions.cornerRadius = cornerRadius
        return self
    }
    
    func corners(_ corners: UIRectCorner) -> Self {
        containerOptions.corners = corners
        return self
    }
    
    func showStart(_ style: ToastStartStyle) -> Self {
        containerOptions.startStyle = style
        return self
    }
    
    func duration(_ duration: ToastDuration) -> Self {
        containerOptions.duration = duration
        return self
    }
    
    func position(_ position: ToastPosition) -> Self {
        containerOptions.postition = position
        return self
    }
    
    func appearAnimations(_ appearAnimations: Set<ContainerAnimator>) -> Self {
        containerOptions.appearAnimations = appearAnimations
        return self
    }
    
    func disappearAnimations(_ disappearAnimations: Set<ContainerAnimator>) -> Self {
        containerOptions.disappearAnimations = disappearAnimations
        return self
    }
    
    func useOppositeAppearAnimationsForDisappear() -> Self {
        containerOptions.disappearAnimations = containerOptions.oppositeOfAppearAnimations()
        return self
    }
    
    func didAppear(block: @escaping () -> ()) -> Self {
        containerOptions.onAppear = block
        return self
    }
    
    func didDisappear(block: @escaping () -> ()) -> Self {
        containerOptions.onDisappear = block
        return self
    }
    
    func didClick(block: @escaping (ToastContainer) -> ()) -> Self {
        containerOptions.onClick = block
        return self
    }
}

public extension ToastDSL {
    func show() {
        if container == nil {
            container = BlurEffectContainer()
        }
        toast.delegate = container
        container.options = containerOptions
        toast.layoutToastView(with: toastOptions)
        
        if case .inQueue = containerOptions.startStyle, !view.shownContaienrQueue.isEmpty {
            view.inQueueContaienrQueue.append(container)
            return
        }
        
        view.showToastContainer(container)
    }
}
