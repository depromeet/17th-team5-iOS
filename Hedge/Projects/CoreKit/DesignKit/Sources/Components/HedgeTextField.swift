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
    public let fieldType: HedgeTextField.FieldType
    
    // MARK: - Convenience Initializers
    public init(
        fieldType: HedgeTextField.FieldType,
        placeHolder: String? = nil,
        label: String? = nil
    ) {
        self.placeHolder = placeHolder ?? fieldType.placeHolder
        self.label = label ?? fieldType.label
        self.fieldType = fieldType
    }
}

public struct HedgeTextField: View {
    
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
    
    @State private var state: TextFieldState = .idle
    @State private var selectedIndex: Int = 0
    
    private let placeHolder: String
    private var id: String
    private var fieldType: FieldType
    
    // MARK: - Builder Pattern
    public struct Builder {
        private var placeHolder: String = ""
        private var label: String = ""
        private var fieldType: FieldType = .buyPrice
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
            builder.fieldType = config.fieldType
            return builder
        }
        
        public func build() -> HedgeTextField {
            HedgeTextField(
                placeHolder: placeHolder,
                label: label,
                id: fieldType.rawValue,
                fieldType: fieldType,
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
        id: String,
        fieldType: FieldType,
        focusedID: Binding<String?>,
        inputText: Binding<String>
    ) {
        self.placeHolder = placeHolder
        self.text = label
        self.id = id
        self.fieldType = fieldType
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
                
                if state != .idle {
                    TextField(placeHolder, text: $inputText) { isEditing in
                        if isEditing { handleTap() }
                    }
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
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if fieldType == .buyPrice || fieldType == .sellPrice {
                HedgeSegmentControl(selectedIndex: $selectedIndex, items: ["원", "$"])
                    .onChange(of: selectedIndex) {
                        handleTap()
                    }
            }
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
        if let focusedID, focusedID == id { return }
        focusedID = id
        
        withAnimation(.easeInOut(duration: 0.3)) {
            state = inputText.isEmpty ? .focusing : .focusingWithInput
        }
    }
    
    private func handleInput(isFocus: Bool, _ input: String) -> String {
        if isFocus {
            return numbersOnly(input)
        } else {
            switch fieldType {
            case .buyPrice, .sellPrice:
                return formatPrice(input)
            case .quantity:
                return formatQuantity(input)
            case .tradeDate:
                return formatTradeDate(input)
            }
        }
    }
    
    private func numbersOnly(_ input: String) -> String {
        return String(input.filter { $0.isNumber })
    }
    
    private func formatPrice(_ input: String) -> String {
        let numbers = numbersOnly(input)
        guard !numbers.isEmpty else { return "" }
        
        // 숫자를 Decimal로 변환
        if let decimal = Decimal(string: numbers) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = ","
            formatter.usesGroupingSeparator = true
            
            let formattedNumber = formatter.string(from: NSDecimalNumber(decimal: decimal)) ?? numbers
            
            // SegmentControl의 선택에 따라 suffix 추가
            let suffix = selectedIndex == 0 ? "원" : "$"
            return "\(formattedNumber)\(suffix)"
        }
        
        return numbers
    }
    
    private func formatQuantity(_ input: String) -> String {
        let numbers = numbersOnly(input)
        guard !numbers.isEmpty else { return "" }
        
        // 숫자를 Decimal로 변환
        if let decimal = Decimal(string: numbers) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = ","
            formatter.usesGroupingSeparator = true
            
            let formattedNumber = formatter.string(from: NSDecimalNumber(decimal: decimal)) ?? numbers
            return "\(formattedNumber)주"
        }
        
        return numbers
    }
    
    private func formatTradeDate(_ input: String) -> String {
        let numbers = numbersOnly(input)
        guard numbers.count >= 8 else { return numbers }
        
        // YYYYMMDD 형식으로 변환
        let year = String(numbers.prefix(4))
        let month = String(numbers.dropFirst(4).prefix(2))
        let day = String(numbers.dropFirst(6).prefix(2))
        
        // 유효한 날짜인지 확인
        if isValidDate(year: year, month: month, day: day) {
            return "\(year)년 \(month)월 \(day)일"
        }
        
        return numbers
    }
    
    private func isValidDate(year: String, month: String, day: String) -> Bool {
        guard let yearInt = Int(year),
              let monthInt = Int(month),
              let dayInt = Int(day) else { return false }
        
        // 기본 유효성 검사
        guard yearInt >= 0000 && yearInt <= 9999,
              monthInt >= 1 && monthInt <= 12,
              dayInt >= 1 && dayInt <= 31 else { return false }
        
        // 실제 날짜 유효성 검사
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = yearInt
        dateComponents.month = monthInt
        dateComponents.day = dayInt
        
        return calendar.date(from: dateComponents) != nil
    }
    
    private func handleFocusChange(_ newValue: String?) {
        DispatchQueue.main.async {
            if id == newValue {
                textFieldFocused = true
            } else {
                state = inputText.isEmpty ? .idle : .idleWithInput
                textFieldFocused = false
            }
            
            inputText = handleInput(isFocus: id == newValue, inputText)
        }
    }
}
 
// #Preview {
//     HedgeTextField.builder()
//         .configuration(.init(fieldType: .buyPrice))
//         .focusedID(.constant(nil))
//         .inputText(.constant(""))
//         .build()
//         .background(Color.red)
// }
