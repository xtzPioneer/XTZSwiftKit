//
//  ScrollViewOffset.swift
//
//
//  Created by 张雄 on 2023/11/23.
//

import SwiftUI

/// 滚动视图偏移Key
struct ScrollViewOffsetKey: PreferenceKey {
    
    typealias Value = CGPoint
    
    static var defaultValue: CGPoint {
        .zero
    }
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
    }
    
}

/// 滚动视图
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct ScrollViewOffset<Content>: View where Content: View {
    
    /// 滚动视图的内容。
    public var content: Content
    
    /// 滚动视图的可滚动轴。
    public var axes: Axis.Set
    
    /// 该值指示滚动视图是否显示可滚动对象。
    public var showsIndicators: Bool
    
    /// 滚动视图的偏移更改回调
    public let onOffsetChange: ((CGPoint) -> Void)?
    
    /// 坐标空间名称
    private var coordinateSpaceName: String
    
    /// 滚动视图的内容和行为。
    public var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            content
                .overlay {
                    offsetReader
                }
        }
        .coordinateSpace(name: coordinateSpaceName)
        .onPreferenceChange(ScrollViewOffsetKey.self) { offset in
            if let onOffsetChange {
                onOffsetChange(offset)
            }
        }
    }
    
    /// 获取偏移
    /// - Parameter geometryProxy: 几何代理
    /// - Returns: 坐标信息
    private func offset(_ geometryProxy: GeometryProxy) -> CGPoint {
        geometryProxy.frame(in: .named(coordinateSpaceName)).origin
    }
    
    /// 偏移读取器
    private var offsetReader: some View {
        GeometryReader {
            Color
                .clear
                .preference(
                    key: ScrollViewOffsetKey.self,
                    value: offset($0)
                )
        }
    }
    
    /// 初始化
    /// - Parameters:
    ///   - axes: 滚动视图的可滚动轴。
    ///   - showsIndicators: 该值指示滚动视图是否显示可滚动对象。
    ///   - onOffsetChange: 滚动视图的偏移更改回调
    ///   - content: 滚动视图的内容。
    public init(_ axes: Axis.Set = .vertical,
                showsIndicators: Bool = true,
                onOffsetChange: ((_ offset: CGPoint) -> Void)? = nil,
                @ViewBuilder content: () -> Content) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.onOffsetChange = onOffsetChange
        self.content = content()
        self.coordinateSpaceName = "\(Self.self)"
    }
    
}
