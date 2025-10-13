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
    let height: BottomSheetHeight
    let sheetContent: () -> SheetContent
    
    @State private var lastOffset: CGFloat = 0
    
    private let minDismissOffset: CGFloat = 150
    private let topPadding: CGFloat = 22
    private let cornerRadius: CGFloat = 24
    private let screenHeight = UIScreen.main.bounds.height
    private let sheetHeight: CGFloat?
    
    public init(
        isPresented: Binding<Bool>,
        height: BottomSheetHeight,
        @ViewBuilder sheetContent: @escaping () -> SheetContent
    ) {
        self._isPresented = isPresented
        self.height = height
        self.sheetContent = sheetContent
        sheetHeight = height.calculate(screenHeight: screenHeight)
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
                        height: sheetHeight,
                        cornerRadius: cornerRadius,
                        topPadding: topPadding,
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
