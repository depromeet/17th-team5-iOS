//
//  HedgeTradeTextField.swift
//  DesignKit
//
//  Created by 이중엽 on 9/13/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import SwiftUI

/// 거래 관련 텍스트 필드 컴포넌트
/// 
/// 사용 가능한 modifier:
/// - `.type(_:)` - 텍스트 필드 타입 설정 (buyPrice, sellPrice, quantity, tradeDate, yield)
/// 
/// 매수가, 매도가, 거래량, 거래날짜, 수익률 등의 거래 관련 데이터를 입력받는 텍스트 필드입니다.
public struct HedgeTradeTextField: View {
    
    @FocusState private var textFieldFocused: Bool
    @Binding private var inputText: String
    @Binding private var focusedID: String?
    @State private var state: HedgeTextFieldState = .idle
    @State private var selectedIndex: Int = 0
    
    private var id: String = HedgeTextFieldType.buyPrice.rawValue
    private var type: HedgeTextFieldType = .buyPrice
    
    public init(
        inputText: Binding<String>,
        focusedID: Binding<String?>
    ) {
        self._inputText = inputText
        self._focusedID = focusedID
    }
    
    public var body: some View {
        
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                
                Text(type.text)
                    .font(state.textFont)
                    .foregroundStyle(state.textColor)
                    .scaleEffect()
                
                if state != .idle {
                    TextField(type.placeHolder, text: $inputText) { isEditing in
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
            
            if let segmentItems = type.segmentItems {
                HedgeSegmentControl(selectedIndex: $selectedIndex, items: segmentItems)
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
                .stroke(state.strokeColor, lineWidth: 1.5)
                .animation(.easeInOut(duration: 0.3), value: state)
        )
        .onTapGesture {
            handleTap()
        }
        .onChange(of: focusedID) { _, newValue in
            handleFocusChange(newValue)
        }
    }
    
    /// 텍스트 필드의 타입을 설정합니다.
    /// - Parameter type: 텍스트 필드 타입 (buyPrice, sellPrice, quantity, tradeDate, yield)
    /// - Returns: 설정된 타입의 HedgeTradeTextField
    public func type(_ type: HedgeTextFieldType) -> HedgeTradeTextField {
        var hedgeTextField = self
        hedgeTextField.type = type
        hedgeTextField.id = type.rawValue
        return hedgeTextField
    }
}

extension HedgeTradeTextField {
    /// 거래 텍스트 필드의 타입을 정의하는 enum
    /// - `buyPrice`: 매수가 입력 필드
    /// - `sellPrice`: 매도가 입력 필드
    /// - `quantity`: 거래량 입력 필드
    /// - `tradeDate`: 거래날짜 입력 필드
    /// - `yield`: 수익률 입력 필드
    public enum HedgeTextFieldType: String {
        case buyPrice = "buyPrice"
        case sellPrice = "sellPrice"
        case quantity = "quantity"
        case tradeDate = "tradeDate"
        case yield = "yield"
        
        var text: String {
            switch self {
            case .buyPrice: return "매수가"
            case .sellPrice: return "매도가"
            case .quantity: return "거래량"
            case .tradeDate: return "거래날짜"
            case .yield: return "수익률"
            }
        }
        
        var placeHolder: String {
            switch self {
            case .buyPrice, .sellPrice: return "1주당 가격"
            case .quantity: return "주"
            case .tradeDate: return "YYYYMMDD"
            case .yield: return "수익률"
            }
        }
        
        var segmentItems: [String]? {
            switch self {
            case .buyPrice, .sellPrice: return ["원", "$"]
            case .yield: return ["+", "-"]
            default: return nil
            }
        }
    }
    
    /// 거래 텍스트 필드의 상태를 정의하는 enum
    /// - `idle`: 기본 상태 (포커스되지 않음, 입력 없음)
    /// - `focusing`: 포커스된 상태 (입력 없음)
    /// - `idleWithInput`: 기본 상태 (포커스되지 않음, 입력 있음)
    /// - `focusingWithInput`: 포커스된 상태 (입력 있음)
    public enum HedgeTextFieldState {
        case idle
        case focusing
        case idleWithInput
        case focusingWithInput
        
        var isFocused: Bool {
            switch self {
            case .focusing, .focusingWithInput: return true
            case .idle, .idleWithInput: return false
            }
        }
        
        var textFont: FontModel { self == .idle ? .body1Medium : .label2Semibold }
        var textColor: Color { self == .idle ? Color.hedgeUI.grey400 : Color.hedgeUI.grey500 }
        var strokeColor: Color { self.isFocused ? Color.hedgeUI.brand500 : .clear }
    }
}

private extension HedgeTradeTextField {
    func handleTap() {
        if let focusedID, focusedID == id { return }
        focusedID = id
        
        withAnimation(.easeInOut(duration: 0.3)) {
            state = inputText.isEmpty ? .focusing : .focusingWithInput
        }
    }
    
    func handleInput(isFocus: Bool, _ input: String) -> String {
        if isFocus {
            return numbersOnly(input)
        } else {
            switch type {
            case .buyPrice, .sellPrice:
                return formatPrice(input)
            case .quantity:
                return formatQuantity(input)
            case .tradeDate:
                return formatTradeDate(input)
            case .yield:
                return formatYield(input)
            }
        }
    }
    
    func numbersOnly(_ input: String) -> String {
        return String(input.filter { $0.isNumber })
    }
    
    func formatPrice(_ input: String) -> String {
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
    
    func formatQuantity(_ input: String) -> String {
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
    
    func formatTradeDate(_ input: String) -> String {
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
    
    func formatYield(_ input: String) -> String {
        let numbers = numbersOnly(input)
        guard !numbers.isEmpty else { return "" }
        
        // 숫자를 Decimal로 변환
        if let decimal = Decimal(string: numbers) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = ","
            formatter.usesGroupingSeparator = true
            
            let formattedNumber = formatter.string(from: NSDecimalNumber(decimal: decimal)) ?? numbers
            let sign = type.segmentItems?[selectedIndex] ?? "+"
            return "\(sign)\(formattedNumber)%"
        }
        
        return numbers
    }
    
    func isValidDate(year: String, month: String, day: String) -> Bool {
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
    
    func handleFocusChange(_ newValue: String?) {
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

#Preview {
    HedgeTradeTextField(inputText: .constant(""), focusedID: .constant(nil))
        .type(.yield)
}
