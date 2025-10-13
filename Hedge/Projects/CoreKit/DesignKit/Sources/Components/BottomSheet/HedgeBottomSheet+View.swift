//
//  HedgeBottomSheet+View.swift
//  DesignKit
//
//  Created by Junyoung on 10/11/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

public extension View {
    /// 컨텐츠 높이에 맞춰 유연하게 늘어나되 최대 높이 제한 바텀시트
    /// - 컨텐츠가 작으면: 컨텐츠 크기에 맞춤
    /// - 컨텐츠가 크면: 최대 높이로 제한하고 스크롤 가능
    ///
    /// - Parameters:
    ///   - isPresented: 바텀시트 표시 상태를 바인딩
    ///   - maxHeight: 최대 높이 비율 (0.0 ~ 1.0)
    ///   - content: 바텀시트에 표시할 컨텐츠
    func hedgeBottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        title: String,
        maxHeight: CGFloat,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(
            HedgeBottomSheetModifier(
                isPresented: isPresented,
                title: title,
                maxHeight: maxHeight,
                sheetContent: content
            )
        )
    }
}
