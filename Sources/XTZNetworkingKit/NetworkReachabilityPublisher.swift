//
//  NetworkReachabilityPublisher.swift
//
//
//  Created by 张雄 on 2023/11/22.
//

import Foundation
import Combine
import Alamofire

/// 网络可访问性发布者
public final class NetworkReachabilityPublisher {
    
    /// 共享
    public static let shared: NetworkReachabilityPublisher = .init()
    
    /// 网络可访问性管理器
    private var networkReachabilityManager: NetworkReachabilityManager?
    
    /// 网络可访问性状态主题
    private var networkReachabilityStatusSubject: PassthroughSubject<NetworkReachabilityManager.NetworkReachabilityStatus, Never>
    
    /// 网络可访问性状态发布者
    var publisher: AnyPublisher<NetworkReachabilityManager.NetworkReachabilityStatus, Never> {
        networkReachabilityStatusSubject.eraseToAnyPublisher()
    }
    
    /// 网络当前是否可访问。
    public var isReachable: Bool { networkReachabilityManager?.isReachable ?? false }
    
    /// 网络当前是否可通过蜂窝网络接口访问。
    public var isReachableOnCellular: Bool { networkReachabilityManager?.isReachableOnCellular ?? false }
    
    /// 网络当前是否可通过以太网或WiFi接口访问。
    public var isReachableOnEthernetOrWiFi: Bool { networkReachabilityManager?.isReachableOnEthernetOrWiFi ?? false }
    
    /// 初始化
    private init() {
        self.networkReachabilityManager = .init()
        self.networkReachabilityStatusSubject = .init()
        self.networkReachabilityManager?
            .startListening(onUpdatePerforming: { [weak self] in
                guard let `self` else { return }
                networkReachabilityStatusSubject.send($0)
            })
    }
    
}
