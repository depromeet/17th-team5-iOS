//
//  HedgeBottomSheetModifier.swift
//  DesignKit
//
//  Created by Junyoung on 10/11/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

public struct HedgeBottomSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let maxHeight: CGFloat
    let sheetContent: () -> SheetContent
    
    @State private var lastOffset: CGFloat = 0
    
    private let minDismissOffset: CGFloat = 100
    private let cornerRadius: CGFloat = 24
    private var screenHeight: CGFloat {
        UIScreen.main.bounds.height * maxHeight
    }
    
    public init(
        isPresented: Binding<Bool>,
        title: String,
        maxHeight: CGFloat,
        @ViewBuilder sheetContent: @escaping () -> SheetContent
    ) {
        self._isPresented = isPresented
        self.maxHeight = maxHeight
        self.sheetContent = sheetContent
        self.title = title
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            
            ZStack(alignment: .bottom) {
                if isPresented {
                    BottomSheetDimBackground(
                        onTap: dismiss
                    )
                    
                    BottomSheetContainer(
                        title: title,
                        maxHeight: screenHeight,
                        cornerRadius: cornerRadius,
                        onDragEnded: handleDragEnded,
                        minDismissOffset: minDismissOffset,
                        content: sheetContent()
                    )
                }
            }
            .ignoresSafeArea()
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPresented)
    }
    
    // MARK: - Gesture Handlers
    
    private func handleDragEnded(_ value: DragGesture.Value) {
        let dragDistance = value.translation.height
        
        if dragDistance > minDismissOffset {
            dismiss()
        }
    }

    private func dismiss() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            isPresented = false
        }
    }
}
