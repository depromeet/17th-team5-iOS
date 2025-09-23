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
    private let onTapped: (FloatingButtonSelectType) -> Void
    
    public init(
        _ onTapped: @escaping (FloatingButtonSelectType) -> Void
    ) {
        self.onTapped = onTapped
    }
    public var body: some View {
        HStack(spacing: 4) {
            Button {
                onTapped(.generate)
            } label: {
                Image.hedgeUI.generate
                    .resizable()
                    .frame(width: 22, height: 22)
                    .padding(8)
            }
            .buttonStyle(PressButtonStyle())
            
            Button {
                onTapped(.emotion)
            } label: {
                Image.hedgeUI.emotion
                    .resizable()
                    .frame(width: 22, height: 22)
                    .padding(8)
            }
            .buttonStyle(PressButtonStyle())
            
            Button {
                onTapped(.checklist)
            } label: {
                Image.hedgeUI.checklist
                    .resizable()
                    .frame(width: 22, height: 22)
                    .padding(8)
            }
            .buttonStyle(PressButtonStyle())
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 5)
        .background(Color.hedgeUI.textWhite.opacity(0.7))
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color.hedgeUI.textWhite, lineWidth: 1.2)
        )
        .shadow(
            color: Color(red: 13/255, green: 15/255, blue: 38/255).opacity(0.14),
            radius: 60,
            x: 0,
            y: 12
        )
    }
}

#Preview {
    ZStack {
        FloatingToolbar { selecte in
            
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.hedgeUI.feedbackAI)
}
