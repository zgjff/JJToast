//
//  ToastBuilder.swift
//  Demo
//
//  Created by 郑桂杰 on 2021/4/4.
//  Copyright © 2021 zgj. All rights reserved.
//

import Foundation

//public protocol TextRequestParam: RequestParam {
//    func buildTextToast(_ textToastable: TextToastable)
//}
//
//extension TextRequestParam {
//    public func buildParam(_ request: inout URLRequest) {
//        fatalError("TextRequestParam shouldn't build URLRequest")
//    }
//}

public protocol RequestParam {
    func buildParam(_ request: inout ToastContainerOptions)
}

public struct EmptyParam: RequestParam {
    public func buildParam(_ request: inout ToastContainerOptions) {}
}

@_functionBuilder
public struct ToastBuilder {
    public static func buildBlock(_ params: RequestParam...) -> RequestParam {
        CombinedParams(children: params)
    }

    public static func buildBlock(_ param: RequestParam) -> RequestParam {
        param
    }

    public static func buildBlock() -> EmptyParam {
        EmptyParam()
    }

    public static func buildIf(_ param: RequestParam?) -> RequestParam {
        param ?? EmptyParam()
    }

    public static func buildEither(first: RequestParam) -> RequestParam {
        first
    }

    public static func buildEither(second: RequestParam) -> RequestParam {
        second
    }
}

internal struct CombinedParams: RequestParam {
    fileprivate let children: [RequestParam]

    init(children: [RequestParam]) {
        self.children = children
    }

    func buildParam(_ request: inout ToastContainerOptions) {
//        children
//            .sorted { a, _ in (a is Url) }
//            .filter { !($0 is SessionParam) || $0 is CombinedParams }
//            .forEach {
//                $0.buildParam(&request)
//            }
    }
//
//    func buildConfiguration(_ configuration: URLSessionConfiguration) {
//        children
//            .compactMap { $0 as? SessionParam }
//            .forEach {
//                $0.buildConfiguration(configuration)
//            }
//    }
}

public typealias TextToast = AnyToast<TextToastProvider>

public struct AnyToast<Toast> where Toast: Toastable {
    public init(@ToastBuilder builder: () -> RequestParam) {
//        rootParam = builder()
    }
}


extension ToastStartStyle: RequestParam {
    public func buildParam(_ request: inout ToastContainerOptions) {
        
    }
}

extension ToastDuration: RequestParam {
    public func buildParam(_ request: inout ToastContainerOptions) {
        
    }
}

public enum Actions: RequestParam {
    case didAppear(() -> ())
    case didTap(() -> ())
    case didDisAppear(() -> ())
    public func buildParam(_ request: inout ToastContainerOptions) {
        
    }
}

extension ToastPosition: RequestParam {
    public func buildParam(_ request: inout ToastContainerOptions) {
        
    }
}
