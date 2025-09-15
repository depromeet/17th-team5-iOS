//
//  HedgeTextField.swift
//  DesignKit
//
//  Created by 이중엽 on 9/13/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import SwiftUI

// MARK: - Configuration Model
public struct HedgeTextFieldConfiguration {
    public let placeHolder: String
    public let label: String
    public let identifier: String
    
    // MARK: - Convenience Initializers
    public init(
        fieldType: FieldType,
        placeHolder: String? = nil,
        label: String? = nil
    ) {
        self.placeHolder = placeHolder ?? fieldType.placeHolder
        self.label = label ?? fieldType.label
        self.identifier = fieldType.rawValue
    }
    
    public enum FieldType: String {
        case buyPrice = "buyPrice"      // 매수가
        case sellPrice = "sellPrice"    // 매도가
        case quantity = "quantity"      // 거래량
        case tradeDate = "tradeDate"    // 거래날짜
        
        public var label: String {
            switch self {
            case .buyPrice:
                return "매수가"
            case .sellPrice:
                return "매도가"
            case .quantity:
                return "거래량"
            case .tradeDate:
                return "거래날짜"
            }
        }
        
        public var placeHolder: String {
            switch self {
            case .buyPrice, .sellPrice:
                return "1주당 가격"
            case .quantity:
                return "주"
            case .tradeDate:
                return "YYYYMMDD"
            }
        }
    }
}

public struct HedgeTextField: View {
    
    enum TextFieldState {
        case idle   // 입력 X, 포커싱 X
        case focusing   // 입력 X, 포커싱 O
        case idleWithInput  // 입력 O, 포커싱 X
        case focusingWithInput // 입력 O, 포커싱 O
        
        var isFocused: Bool {
            switch self {
            case .focusing, .focusingWithInput: return true
            case .idle, .idleWithInput: return false
            }
        }
    }
    
    @FocusState private var textFieldFocused: Bool
    
    @Binding private var inputText: String
    @Binding private var focusedID: String?
    @Binding private var id: String
    
    @State private var state: TextFieldState = .idle
    
    private let placeHolder: String
    
    // MARK: - Builder Pattern
    public struct Builder {
        private var placeHolder: String = ""
        private var label: String = ""
        private var id: Binding<String> = .constant("")
        private var focusedID: Binding<String?> = .constant(nil)
        private var inputText: Binding<String> = .constant("")
        
        public init() {}
        
        public func focusedID(_ binding: Binding<String?>) -> Builder {
            var builder = self
            builder.focusedID = binding
            return builder
        }
        
        public func inputText(_ binding: Binding<String>) -> Builder {
            var builder = self
            builder.inputText = binding
            return builder
        }
        
        public func configuration(_ config: HedgeTextFieldConfiguration) -> Builder {
            var builder = self
            builder.placeHolder = config.placeHolder
            builder.label = config.label
            builder.id = .constant(config.identifier)
            return builder
        }

        public func build() -> HedgeTextField {
            HedgeTextField(
                placeHolder: placeHolder,
                label: label,
                id: id,
                focusedID: focusedID,
                inputText: inputText
            )
        }
    }
    
    // MARK: - Computed Properties
    private var text: String
    private var textFont: FontModel { state == .idle ? .body1Medium : .label2Semibold }
    private var textColor: Color { state == .idle ? Color.hedgeUI.grey400 : Color.hedgeUI.grey500 }
    private var strokeColor: Color { state.isFocused ? Color.hedgeUI.brand500 : .clear }
    
    private init(
        placeHolder: String,
        label: String,
        id: Binding<String>,
        focusedID: Binding<String?>,
        inputText: Binding<String>
    ) {
        self.placeHolder = placeHolder
        self.text = label
        self._id = id
        self._focusedID = focusedID
        self._inputText = inputText
    }
    
    // MARK: - Static Factory Method
    public static func builder() -> Builder {
        Builder()
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
        .background(Color.hedgeUI.neutralBgDefault)
        .cornerRadius(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(strokeColor, lineWidth: 1.5)
                .animation(.easeInOut(duration: 0.3), value: state)
        )
        .onTapGesture {
            handleTap()
        }
        .onChange(of: focusedID) { _, newValue in
            handleFocusChange(newValue)
        }
    }
    
    private func handleTap() {
        focusedID = id
        
        withAnimation(.easeInOut(duration: 0.3)) {
            state = inputText.isEmpty ? .focusing : .focusingWithInput
        }
    }
    
    private func handleFocusChange(_ newValue: String?) {
        DispatchQueue.main.async {
            if id == newValue {
                textFieldFocused = true
            } else {
                state = inputText.isEmpty ? .idle : .idleWithInput
                textFieldFocused = false
            }
        }
    }
}
