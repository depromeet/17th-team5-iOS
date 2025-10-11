//
//  HedgeBottomSheet+View.swift
//  DesignKit
//
//  Created by Junyoung on 10/11/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

public extension View {
    /// 화면 비율 기반 바텀시트
    ///
    /// - Parameters:
    ///   - isPresented: 바텀시트 표시 상태를 바인딩
    ///   - ratio: 화면 높이 비율 (0.0 ~ 1.0)
    ///   - content: 바텀시트에 표시할 컨텐츠
    func hedgeBottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        ratio: CGFloat,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        hedgeBottomSheet(
            isPresented: isPresented,
            height: .ratio(ratio),
            content: content
        )
    }
    
    /// 고정 높이 바텀시트
    ///
    /// - Parameters:
    ///   - isPresented: 바텀시트 표시 상태를 바인딩
    ///   - fixedHeight: 고정 높이 (pt)
    ///   - content: 바텀시트에 표시할 컨텐츠
    func hedgeBottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        fixedHeight: CGFloat,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        hedgeBottomSheet(
            isPresented: isPresented,
            height: .fixed(fixedHeight),
            content: content
        )
    }
    
    /// 컨텐츠 크기에 맞춰 자동 조절되는 바텀시트
    /// - 컨텐츠 크기에 정확히 맞춰서 표시
    /// - 스크롤 없음 (컨텐츠가 길면 잘림)
    ///
    /// - Parameters:
    ///   - isPresented: 바텀시트 표시 상태를 바인딩
    ///   - content: 바텀시트에 표시할 컨텐츠
    func hedgeBottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        hedgeBottomSheet(
            isPresented: isPresented,
            height: .contentSize,
            content: content
        )
    }
    
    private func hedgeBottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        height: BottomSheetHeight,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(
            HedgeBottomSheetModifier(
                isPresented: isPresented,
                height: height,
                sheetContent: content
            )
        )
    }
}
