//
//  ToastTime.swift
//  JJToast
//
//  Created by 郑桂杰 on 2020/7/7.
//  Copyright © 2020 Qile. All rights reserved.
//

import Foundation

/// toast的显示时机
///
///     now: 立即显示
///     inQueue: 在队列中按加入顺序显示
public enum ToastStartStyle {
    case now, inQueue
}

/// toast的显示时长
///
///     duration: 显示设置的时长
///     distantFuture: 只要不主动隐藏就会永久显示
public enum ToastDuration {
    case duration(TimeInterval)
    case distantFuture
}
