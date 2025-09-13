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
        case idle   // 입력 X, 포커싱 X
        case focusing   // 입력 X, 포커싱 O
        case idleWithInput  // 입력 O, 포커싱 X
        case focusingWithInput // 입력 O, 포커싱 O
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
        case .focusing:
            return focusingLabel
        case .idleWithInput:
            return focusingLabel
        case .focusingWithInput:
            return focusingLabel
        }
    }
    
    private var textFont: FontModel {
        switch state {
        case .idle:
            return .body1Medium
        case .focusing:
            return .label2Semibold
        case .idleWithInput:
            return .label2Semibold
        case .focusingWithInput:
            return .label2Semibold
        }
    }
    
    private var textColor: Color {
        switch state {
        case .idle:
            return Color.hedgeUI.grey400
        case .focusing:
            return Color.hedgeUI.grey500
        case .idleWithInput:
            return Color.hedgeUI.grey500
        case .focusingWithInput:
            return Color.hedgeUI.grey500
        }
    }
    
    private var strokeColor: Color {
        switch state {
        case .idle:
            return .clear
        case .focusing:
            return Color.hedgeUI.brand500
        case .idleWithInput:
            return .clear
        case .focusingWithInput:
            return Color.hedgeUI.brand500
        }
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
                
                if state == .focusing || state == .idleWithInput || state == .focusingWithInput {
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
                        .allowsHitTesting(false)
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
                if inputText.isEmpty {
                    state = .focusing
                } else {
                    state = .focusingWithInput
                }
            }
        }
        .onChange(of: focusedID) { newValue in
            DispatchQueue.main.async {
                if id == newValue {
                    if inputText.isEmpty {
                        state = .focusing
                    } else {
                        state = .focusingWithInput
                    }
                    
                    textFieldFocused = true
                } else {
                    if inputText.isEmpty {
                        state = .idle
                    } else {
                        state = .idleWithInput
                    }
                    textFieldFocused = false
                }
                
                print("\(id) = \(state)")
            }
        }
    }
}
