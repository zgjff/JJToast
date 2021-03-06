//
//  UIView+Toast.swift
//  JJToast
//
//  Created by 郑桂杰 on 2020/7/7.
//  Copyright © 2020 zgj. All rights reserved.
//

import UIKit

// MARK: - 操作 `Toast`,通用方法
public extension UIView {
    func makeToast<T>(_ toast: T) -> ToastDSL<T> where T: Toastable {
        return ToastDSL(view: self, toast: toast)
    }
    
    func hideToast(_ toast: ToastContainer) {
        toast.startHide { [weak self] container in
            self?.shownContaienrQueue.remove(where: { c -> Bool in
                return container === c
            })
            self?.showNextInQueueToast()
        }
    }
    
    func hideAllToasts() {
        inQueueContaienrQueue.removeAll()
        shownContaienrQueue.forEach { c in
            self.hideToast(c)
        }
    }
}

public extension UIView {
    
}

// MARK: - 非公开调用的方法
extension UIView {
    internal func showToastContainer(_ container: ToastContainer) {
        shownContaienrQueue.append(container)
        container.showToast(inView: self)
        print("showToastContainer0--------->", shownContaienrQueue.arr.count, shownContaienrQueue.arr)
        if case let .duration(t) = container.options.duration {
            hideToast(container, after: t)
        }
    }
    
    internal func hideToast(_ toast: ToastContainer, after time: TimeInterval) {
        print("showToastContainer1--------->", shownContaienrQueue.arr.count, shownContaienrQueue.arr)
        if time <= 0.15 {
            self.hideToast(toast)
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + time) { [weak self] in
            print("DispatchQueue.main.asyncAfter------", self, self?.shownContaienrQueue.arr)
            guard let strongSelf = self else { return }
            if strongSelf.shownContaienrQueue.contains(toast) {
                print("========包含")
                strongSelf.hideToast(toast)
            }
        }
    }
    
    private func showNextInQueueToast() {
        guard let container = inQueueContaienrQueue.remove(at: 0) else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            // 中间间隔一段时间,不要让新出来的toast,像是上一个toast
            self?.showToastContainer(container)
        }
    }
}
