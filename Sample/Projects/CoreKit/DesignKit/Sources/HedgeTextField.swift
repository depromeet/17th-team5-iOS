//
//  HedgeTextField.swift
//  DesignKit
//
//  Created by 이중엽 on 9/13/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import SwiftUI

public struct HedgeTextField: View {
    
    @Binding var inputText: String
    private let placeHolder: String
    
    @State private var isFocused: Bool = false
    @FocusState private var textFieldFocused: Bool
    @State private var fontStyle: FontModel = .body1Medium
    @State private var label: String
    @State private var focusingLabel: String
    
    public init(
        placeHolder: String,
        label: String,
        focusingLabel: String,
        inputText: Binding<String>
    ) {
        self.placeHolder = placeHolder
        self.label = label
        self.focusingLabel = focusingLabel
        self._inputText = inputText
    }
    
    public var body: some View {
        
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                
                Text(isFocused ? focusingLabel : label)
                    .font(isFocused ? .label2Semibold : .body1Medium)
                    .foregroundStyle(isFocused ? Color.hedgeUI.grey500 : Color.hedgeUI.grey400)
                    .scaleEffect()
                
                
                if isFocused {
                    TextField(placeHolder, text: $inputText)
                        .tint(Color.hedgeUI.grey900)
                        .focused($textFieldFocused)
                        .font(.body1Semibold)
                        .foregroundStyle(Color.hedgeUI.brand500)
                        .frame(height: 25)
                        .keyboardType(.numberPad)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .offset(y: 5)),
                            removal: .opacity.combined(with: .offset(y: -5))
                        ))
                }
            }
            .padding(.vertical, 14)
            
            Spacer()
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                isFocused.toggle()
                textFieldFocused = true
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 16)
        .frame(width: .infinity, height: 75)
        .background(Color.brown.opacity(0.3))
        .cornerRadius(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isFocused ? Color.hedgeUI.brand500 : .clear, lineWidth: 1.5)
                .animation(.easeInOut(duration: 0.3), value: isFocused)
        )
    }
}

#Preview {
    HedgeTextField(placeHolder: "1주당 가격", label: "매도가", focusingLabel: "매도가 입력", inputText: .constant(""))
    HedgeTextField(placeHolder: "1주당 가격", label: "매도가", focusingLabel: "매도가 입력", inputText: .constant(""))
    HedgeTextField(placeHolder: "1주당 가격", label: "매도가", focusingLabel: "매도가 입력", inputText: .constant(""))
}
