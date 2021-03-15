//
//  ContaienrQueue.swift
//  JJToast
//
//  Created by 郑桂杰 on 2020/7/16.
//  Copyright © 2020 Qile. All rights reserved.
//

import UIKit

extension UIView {
    private static var shownToastContainerQueueKey = "shownToastContainerQueueKey_JJToast"
    internal var shownContaienrQueue: ContaienrQueue {
        get {
            return containerQueue(for: &UIView.shownToastContainerQueueKey)
        }
    }
    
    private static var inQueueContainerQueueKey = "inQueueToastContainerQueueKey_JJToast"
    internal var inQueueContaienrQueue: ContaienrQueue {
        get {
            return containerQueue(for: &UIView.inQueueContainerQueueKey)
        }
    }
    
    private func containerQueue(for key: UnsafeRawPointer) -> ContaienrQueue {
        if let queue = objc_getAssociatedObject(self, key) as? ContaienrQueue {
            return queue
        }
        let queue = ContaienrQueue()
        objc_setAssociatedObject(self, key, queue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return queue
    }
}

internal final class ContaienrQueue {
    //    private var weakDelegates: NSPointerArray<AnyObject> = NSPointerArray<AnyObject>(options: NSPointerFunctions.Options.weakMemory)
    private var arr: [ToastContainer] = []

    var isEmpty: Bool {
        return arr.isEmpty
    }
    
    func append(_ container: ToastContainer) {
        arr.append(container)
    }
    
    func remove(where shouldBeRemoved: (ToastContainer) -> Bool) {
        arr.removeAll(where: shouldBeRemoved)
    }
    
    func contains(_ container: ToastContainer) -> Bool {
        return arr.contains { c -> Bool in
            return c === container
        }
    }
    
    func forEach(body: (ToastContainer) -> Void) {
        arr.forEach(body)
    }
    
    func remove(at index: Int) -> ToastContainer? {
        if index >= arr.count {
            return nil
        }
        return arr.remove(at: index)
    }
    
    func removeAll() {
        arr.removeAll()
    }
}
