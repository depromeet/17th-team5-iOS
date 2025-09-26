//
//  FloattingToolbar.swift
//  DesignKit
//
//  Created by Junyoung on 9/22/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

public enum FloatingButtonSelectType {
    case generate
    case emotion
    case checklist
}

public struct FloatingToolbar: View {
    @Binding private var selectedButton: FloatingButtonSelectType?
    private let onTapped: (FloatingButtonSelectType) -> Void
    
    public init(
        selectedButton: Binding<FloatingButtonSelectType?>,
        _ onTapped: @escaping (FloatingButtonSelectType) -> Void
    ) {
        self._selectedButton = selectedButton
        self.onTapped = onTapped
    }
    public var body: some View {
        HStack(spacing: 4) {
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    selectedButton = .generate
                    onTapped(.generate)
                }
            } label: {
                Image.hedgeUI.generate
                    .resizable()
                    .frame(width: 22, height: 22)
                    .padding(8)
            }
            .buttonStyle(PressButtonStyle())
            .background(
                selectedButton == .generate ? 
                Color.hedgeUI.greyOpacity200 : Color.clear
            )
            .clipShape(RoundedRectangle(cornerRadius: 9))
            
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    selectedButton = .emotion
                    onTapped(.emotion)
                }
            } label: {
                Image.hedgeUI.emotion
                    .resizable()
                    .frame(width: 22, height: 22)
                    .padding(8)
            }
            .buttonStyle(PressButtonStyle())
            .background(
                selectedButton == .emotion ? 
                Color.hedgeUI.greyOpacity200 : Color.clear
            )
            .clipShape(RoundedRectangle(cornerRadius: 9))
            
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    selectedButton = .checklist
                    onTapped(.checklist)
                }
            } label: {
                Image.hedgeUI.checklist
                    .resizable()
                    .frame(width: 22, height: 22)
                    .padding(8)
            }
            .buttonStyle(PressButtonStyle())
            .background(
                selectedButton == .checklist ? 
                Color.hedgeUI.greyOpacity200 : Color.clear
            )
            .clipShape(RoundedRectangle(cornerRadius: 9))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 5)
        .background(
            Color.hedgeUI.textWhite.opacity(0.7)
                .blur(radius: 13)
        )
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color.hedgeUI.textWhite, lineWidth: 1.2)
        )
        .shadow(
            color: Color(red: 13/255, green: 15/255, blue: 38/255),
            radius: 60,
            x: 0,
            y: 12
        )
    }
}

#Preview {
    @Previewable @State var selectedButton: FloatingButtonSelectType? = .generate
    
    ZStack {
        FloatingToolbar(selectedButton: $selectedButton) { selected in
            print("Selected: \(selected)")
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.hedgeUI.feedbackAI)
}
