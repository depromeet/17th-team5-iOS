//
//  HedgeSearchTextField.swift
//  DesignKit
//
//  Created by Junyoung on 9/14/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import SwiftUI

public struct HedgeSearchTextField: View {
    @FocusState private var isFocused
    @Binding private var text: String
    private let placeholder: String
    
    public init(
        placeholder: String,
        text: Binding<String>
    ) {
        self.placeholder = placeholder
        self._text = text
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            // 검색 아이콘
            Image.hedgeUI.search
                .foregroundColor(Color.hedgeUI.grey500)
                .frame(width: 24, height: 24)
            
            // 텍스트 필드
            TextField(placeholder, text: $text)
                .font(.body1Medium)
                .foregroundColor(Color.hedgeUI.grey900)
                .focused($isFocused)
                .submitLabel(.search)
            
            Spacer()
            
            // X 버튼 (텍스트가 있을 때만 표시)
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image.hedgeUI.closeFill
                        .foregroundColor(Color.hedgeUI.grey500)
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 8)
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.hedgeUI.backgroundWhite)
        )
    }
}

#Preview {
    HedgeSearchTextField(placeholder: "종목 검색", text: .constant("안녕하세요"))
}
