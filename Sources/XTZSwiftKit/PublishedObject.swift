//
//  PublishedObject.swift
//
//
//  Created by 张雄 on 2023/11/22.
//

import Foundation
import Combine
import SwiftUI

/// 可观察对象发布者
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
@propertyWrapper public struct PublishedObject<Value> where Value: ObservableObject {
    
    /// 包装值
    public var wrappedValue: Value
    
    /// 订阅者
    private var cancellable: AnyCancellable?
    
    /// 官方建议的下标方法
    /// 详情请查看：https://github.com/apple/swift-evolution/blob/main/proposals/0258-property-wrappers.md#referencing-the-enclosing-self-in-a-wrapper-type
    public static subscript<OuterSelf: ObservableObject>(
        _enclosingInstance observed: OuterSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<OuterSelf, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<OuterSelf, Self>
    ) -> Value where OuterSelf.ObjectWillChangePublisher == ObservableObjectPublisher {
        get {
            if observed[keyPath: storageKeyPath].cancellable == nil {
                observed[keyPath: storageKeyPath].subscribe(observed)
            }
            return observed[keyPath: storageKeyPath].wrappedValue
        }
        set {
            observed.objectWillChange.send()
            observed[keyPath: storageKeyPath].wrappedValue = newValue
        }
    }
    
    /// 订阅
    /// - Parameter enclosingInstance: 封闭实例
    private mutating func subscribe<OuterSelf: ObservableObject>(_ enclosingInstance: OuterSelf) where OuterSelf.ObjectWillChangePublisher == ObservableObjectPublisher {
        cancellable = wrappedValue.objectWillChange.sink { _ in
            Task { @MainActor [weak enclosingInstance] in
                (enclosingInstance?.objectWillChange)?.send()
            }
        }
    }
    
    /// 初始化
    /// - Parameter wrappedValue: 包装值
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
    
}
