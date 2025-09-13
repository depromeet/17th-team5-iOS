//
//  HedgeTextField.swift
//  DesignKit
//
//  Created by 이중엽 on 9/13/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import SwiftUI

public struct HedgeTextField: View {
    
    enum TextFieldState {
        case idle
        case focused
        case unfocusedWithText
    }
    
    @Binding var inputText: String
    @Binding var focusedID: String?
    @Binding var id: String
    private let placeHolder: String
    
    @FocusState private var textFieldFocused: Bool
    @State private var state: TextFieldState = .idle
    @State private var fontStyle: FontModel = .body1Medium
    @State private var label: String
    @State private var focusingLabel: String
    
    private var text: String {
        switch state {
        case .idle:
            return label
        case .focused:
            return focusingLabel
        case .unfocusedWithText:
            return label
        }
    }
    
    private var textFont: FontModel {
        switch state {
        case .idle:
            return .body1Medium
        case .focused:
            return .label2Semibold
        case .unfocusedWithText:
            return .body1Medium
        }
    }
    
    private var textColor: Color {
        switch state {
        case .idle:
            return Color.hedgeUI.grey400
        case .focused:
            return Color.hedgeUI.grey500
        case .unfocusedWithText:
            return Color.hedgeUI.grey400
        }
    }
    
    private var strokeColor: Color {
        switch state {
        case .idle:
            return .clear
        case .focused:
            return Color.hedgeUI.brand500
        case .unfocusedWithText:
            return .clear
        }
    }
    
    private var shouldShowTextField: Bool {
        return state == .focused || state == .unfocusedWithText
    }
    
    public init(
        placeHolder: String,
        label: String,
        focusingLabel: String,
        id: Binding<String>,
        focusedID: Binding<String?>,
        inputText: Binding<String>
    ) {
        self.placeHolder = placeHolder
        self.label = label
        self.focusingLabel = focusingLabel
        self._id = id
        self._focusedID = focusedID
        self._inputText = inputText
    }
    
    public var body: some View {
        
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                
                Text(text)
                    .font(textFont)
                    .foregroundStyle(textColor)
                    .scaleEffect()
                
                if state == .focused || state == .unfocusedWithText {
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
        .padding(.leading, 20)
        .padding(.trailing, 16)
        .frame(height: 75)
        .background(Color.brown.opacity(0.3))
        .cornerRadius(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(strokeColor, lineWidth: 1.5)
                .animation(.easeInOut(duration: 0.3), value: state)
        )
        .onTapGesture {
            focusedID = id
            
            withAnimation(.easeInOut(duration: 0.3)) {
                state = .focused
            }
        }
        .onChange(of: focusedID) { newValue in
            DispatchQueue.main.async {
                if id == newValue {
                    // 이 필드가 선택되었을 때만 포커스
                    textFieldFocused = true
                } else {
                    // 다른 필드가 선택되었을 때 포커스 해제
                    if inputText.isEmpty {
                        state = .idle
                    } else {
                        state = .unfocusedWithText
                    }
                    textFieldFocused = false
                }
            }
        }
        .onChange(of: inputText) { newValue in
            // inputText가 변경될 때 상태 업데이트
            if !newValue.isEmpty && state == .idle {
                state = .unfocusedWithText
            } else if newValue.isEmpty && state == .unfocusedWithText {
                state = .idle
            }
        }
    }
}
