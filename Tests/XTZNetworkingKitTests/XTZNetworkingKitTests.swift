//
//  XTZNetworkingKitTests.swift
//
//
//  Created by 张雄 on 2023/11/22.
//

import XCTest
import Combine
@testable import XTZNetworkingKit

final class XTZNetworkingKitTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable> = .init()
    
    func testExample() throws {
        let timeoutInterval: TimeInterval = 60.0
        let networkingExpectation = expectation(description: #function)
        NetworkReachabilityPublisher.shared.publisher.sink { status in
            switch status {
            case .unknown:
                print("未知网络")
            case .notReachable:
                print("无法连接网络")
            case .reachable(.cellular):
                print("蜂窝网络")
            case .reachable(.ethernetOrWiFi):
                print("WIFI网络")
            }
            networkingExpectation.fulfill()
        }
        .store(in: &cancellables)
        XCTWaiter(delegate: self).wait(for: [networkingExpectation], timeout: timeoutInterval)
    }
    
}
