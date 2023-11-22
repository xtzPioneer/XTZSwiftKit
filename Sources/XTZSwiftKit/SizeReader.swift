//
//  SizeReader.swift
//
//
//  Created by 张雄 on 2023/11/22.
//

import SwiftUI

/// Size动态读取器
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct SizeDynamicReader: ViewModifier {
    @Binding var size: CGSize
    @Binding var safeArea: EdgeInsets
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color
                        .clear
                        .task(id: geometry.size) {
                            size = geometry.size
                        }
                        .task(id: geometry.safeAreaInsets) {
                            safeArea = geometry.safeAreaInsets
                        }
                }
            )
    }
}

/// Size静态读取器
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct SizeStaticReader: ViewModifier {
    @Binding var size: CGSize
    @Binding var safeArea: EdgeInsets
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color
                        .clear
                        .task(id: size) {
                            size = geometry.size
                        }
                        .task(id: safeArea) {
                            safeArea = geometry.safeAreaInsets
                        }
                }
            )
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {
    
    /// Size动态读取器
    /// - Parameters:
    ///   - size: 大小
    ///   - safeArea: 安全区域
    /// - Returns: 视图
    public func sizeDynamicReader(size: Binding<CGSize>, safeArea: Binding<EdgeInsets> = .constant(.init())) -> some View {
        modifier(SizeDynamicReader(size: size, safeArea: safeArea))
    }
    
    /// Size静态读取器
    /// - Parameters:
    ///   - size: 大小
    ///   - safeArea: 安全区域
    /// - Returns: 视图
    public func sizeStaticReader(size: Binding<CGSize>, safeArea: Binding<EdgeInsets> = .constant(.init())) -> some View {
        modifier(SizeStaticReader(size: size, safeArea: safeArea))
    }
    
}
