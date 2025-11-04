//
//  HedgeLinkModal.swift
//  DesignKit
//
//  Created by 이중엽 on 10/20/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

public struct HedgeLinkModal: View {
    
    @State var text: String = ""
    @Binding var shown: Bool
    let onAddLink: (String) -> Void
    
    public init(shown: Binding<Bool>, onAddLink: @escaping (String) -> Void) {
        self._shown = shown
        self.onAddLink = onAddLink
    }
    
    public var body: some View {
        ZStack(alignment: .center) {
            
            Color.black.opacity(0.18)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                Text("기사 링크 추가")
                    .padding(.horizontal, 3)
                    .font(FontModel.body1Semibold)
                    .foregroundStyle(Color.hedgeUI.textTitle)
                
                HedgeSpacer(height: 12)
                
                TextField(text: $text) {
                    Text("링크 입력")
                }
                .padding(12)
                .border(Color.hedgeUI.backgroundSecondary, width: 1.2)
                .cornerRadius(8)
                
                HedgeSpacer(height: 20)
                
                HStack {
                    HedgeActionButton("취소") {
                        shown = false
                    }
                    .color(.secondary)
                    .size(.medium)
                    
                    HedgeActionButton("추가하기") {
                        onAddLink(text)
                    }
                    .size(.medium)
                }
                
            }
            .frame(width: 297)
            .padding(16)
            .background(Color.hedgeUI.backgroundWhite)
            .cornerRadius(24)
        }
    }
}

#Preview {
    HedgeLinkModal(shown: .constant(false)) { text in
        print(text)
    }
}
