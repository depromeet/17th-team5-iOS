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
    @Binding private var selectedIndex: Int
    @State private var state: HedgeTextFieldState = .idle
    
    private var id: String = HedgeTextFieldType.buyPrice.rawValue
    private var type: HedgeTextFieldType = .buyPrice
    
    public init(
        inputText: Binding<String>,
        focusedID: Binding<String?>,
        selectedIndex: Binding<Int> = .constant(0)
    ) {
        self._inputText = inputText
        self._focusedID = focusedID
        self._selectedIndex = selectedIndex
    }
    
    public var body: some View {
        
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                
                Text(displayText)
                    .font(state.textFont)
                    .foregroundStyle(state.textColor)
                    .scaleEffect()
                
                if state != .idle {
                    TextField(type.placeHolder, text: $inputText) { isEditing in
                        if isEditing { handleTap() }
                    }
                    .tint(Color.hedgeUI.brandPrimary)
                    .focused($textFieldFocused)
                    .font(.body1Semibold)
                    .foregroundStyle(Color.hedgeUI.textTitle)
                    .frame(height: 25)
                    .keyboardType(keyboardType)
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
    
    // MARK: - Computed Properties
    
    /// 현재 타입과 선택된 인덱스에 따라 키보드 타입을 반환합니다.
    private var keyboardType: UIKeyboardType {
        if (type == .buyPrice || type == .sellPrice) && selectedIndex == 1 {
            return .decimalPad
        }
        return .numberPad
    }
    
    /// 현재 상태에 따라 표시할 텍스트를 반환합니다.
    private var displayText: String {
        switch state {
        case .idleWithInput(let error), .focusingWithInput(let error):
            if type == .tradeDate && error == .futureDate {
                return "미래 날짜는 입력할 수 없어요"
            }
            return type.text
        default:
            return type.text
        }
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
    public enum HedgeTextFieldState: Equatable {
        case idle
        case focusing
        case idleWithInput(error: HedgeTextFieldError)
        case focusingWithInput(error: HedgeTextFieldError)
        
        var textFont: FontModel { self == .idle ? .body1Medium : .label2Semibold }
        var textColor: Color {
            switch self {
            case .idle:
                return Color.hedgeUI.grey400
            case .focusing:
                return Color.hedgeUI.brandDarken
            case .idleWithInput(let error), .focusingWithInput(let error):
                switch error {
                case .none:
                    return Color.hedgeUI.brandDarken
                case .futureDate:
                    return Color.hedgeUI.feedbackError
                }
            }
        }
        
        var strokeColor: Color {
            switch self {
            case .idle, .idleWithInput:
                return .clear
            case .focusing:
                return Color.hedgeUI.brandDarken
            case .focusingWithInput(let error):
                switch error {
                case .none:
                    return Color.hedgeUI.brandDarken
                case .futureDate:
                    return Color.hedgeUI.feedbackError
                }
            }
        }
    }
    
    /// 거래 날짜 검증 에러를 정의하는 enum
    /// - `none`: 에러 없음
    /// - `futureDate`: 미래 날짜 입력 (오늘보다 미래)
    public enum HedgeTextFieldError {
        case none
        case futureDate
    }
}

private extension HedgeTradeTextField {
    /// 텍스트 필드 탭 이벤트를 처리합니다.
    /// 포커스 상태를 변경하고 타입에 따른 에러 검증을 수행합니다.
    func handleTap() {
        if let focusedID, focusedID == id { return }
        focusedID = id
        
        withAnimation(.easeInOut(duration: 0.3)) {
            switch type {
            case .buyPrice:
                state = inputText.isEmpty ? .focusing : .focusingWithInput(error: .none)
            case .sellPrice:
                state = inputText.isEmpty ? .focusing : .focusingWithInput(error: .none)
            case .quantity:
                state = inputText.isEmpty ? .focusing : .focusingWithInput(error: .none)
            case .tradeDate:
                state = inputText.isEmpty ? .focusing : .focusingWithInput(error: validateTradeDate(inputText))
            case .yield:
                state = inputText.isEmpty ? .focusing : .focusingWithInput(error: .none)
            }
        }
    }
    
    /// 거래 날짜를 검증합니다.
    /// 미래 날짜인지 확인하여 에러 상태를 반환합니다.
    /// - Parameter input: 입력된 날짜 문자열 (YYYYMMDD 형식)
    /// - Returns: 검증 결과에 따른 HedgeTextFieldError
    func validateTradeDate(_ input: String?) -> HedgeTextFieldError {
        guard let input else { return .none }
        let numbers = numbersOnly(input)
        guard numbers.count >= 8 else { return .none }
        
        let year = String(numbers.prefix(4))
        let month = String(numbers.dropFirst(4).prefix(2))
        let day = String(numbers.dropFirst(6).prefix(2))
        
        guard let yearInt = Int(year),
              let monthInt = Int(month),
              let dayInt = Int(day) else { return .none }
        
        // 유효한 날짜인지 확인
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = yearInt
        dateComponents.month = monthInt
        dateComponents.day = dayInt
        
        guard let inputDate = calendar.date(from: dateComponents) else { return .none }
        
        // 오늘 날짜와 비교
        let today = Date()
        if inputDate > today {
            return .futureDate
        }
        
        return .none
    }
    
    /// 입력값을 포커스 상태에 따라 처리합니다.
    /// 포커스 중일 때는 숫자만 추출하고, 포커스 해제 시에는 타입에 맞게 포맷팅합니다.
    /// - Parameters:
    ///   - isFocus: 현재 포커스 상태
    ///   - input: 입력된 문자열
    /// - Returns: 처리된 문자열
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
    
    /// 입력 문자열에서 숫자만 추출합니다.
    /// - Parameter input: 입력된 문자열
    /// - Returns: 숫자만 포함된 문자열
    func numbersOnly(_ input: String) -> String {
        // buyPrice, sellPrice에서 selectedIndex가 1($)일 때는 소수점도 허용
        if (type == .buyPrice || type == .sellPrice) && selectedIndex == 1 {
            return String(input.filter { $0.isNumber || $0 == "." })
        }
        return String(input.filter { $0.isNumber })
    }
    
    /// 가격을 포맷팅합니다.
    /// 천 단위 구분자(,)를 추가하고 선택된 통화 단위(원/$)를 붙입니다.
    /// - Parameter input: 입력된 가격 문자열
    /// - Returns: 포맷팅된 가격 문자열
    func formatPrice(_ input: String) -> String {
        let numbers = numbersOnly(input)
        guard !numbers.isEmpty else { return "" }
        
        // 숫자를 Decimal로 변환
        if let decimal = Decimal(string: numbers) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = ","
            formatter.usesGroupingSeparator = true
            
            // selectedIndex가 1($)일 때는 소수점 자릿수 제한
            if selectedIndex == 1 {
                formatter.minimumFractionDigits = 0
                formatter.maximumFractionDigits = 2
            }
            
            let formattedNumber = formatter.string(from: NSDecimalNumber(decimal: decimal)) ?? numbers
            
            // SegmentControl의 선택에 따라 suffix 추가
            if selectedIndex == 0 {
                return "\(formattedNumber)원"
            } else {
                return "$\(formattedNumber)"
            }
        }
        
        return numbers
    }
    
    /// 거래량을 포맷팅합니다.
    /// 천 단위 구분자(,)를 추가하고 "주" 단위를 붙입니다.
    /// - Parameter input: 입력된 거래량 문자열
    /// - Returns: 포맷팅된 거래량 문자열
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
    
    /// 거래 날짜를 포맷팅합니다.
    /// YYYYMMDD 형식을 "YYYY년 MM월 DD일" 형식으로 변환합니다.
    /// - Parameter input: 입력된 날짜 문자열 (YYYYMMDD)
    /// - Returns: 포맷팅된 날짜 문자열
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
    
    /// 수익률을 포맷팅합니다.
    /// 천 단위 구분자(,)를 추가하고 선택된 부호(+/-)와 "%" 단위를 붙입니다.
    /// - Parameter input: 입력된 수익률 문자열
    /// - Returns: 포맷팅된 수익률 문자열
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
    
    /// 날짜의 유효성을 검증합니다.
    /// 년, 월, 일이 유효한 날짜인지 확인합니다.
    /// - Parameters:
    ///   - year: 년도 문자열
    ///   - month: 월 문자열
    ///   - day: 일 문자열
    /// - Returns: 유효한 날짜인지 여부
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
    
    /// 포커스 상태 변경을 처리합니다.
    /// 포커스가 변경될 때 상태를 업데이트하고 입력값을 포맷팅합니다.
    /// - Parameter newValue: 새로 포커스된 필드의 ID
    func handleFocusChange(_ newValue: String?) {
        DispatchQueue.main.async {
            if id == newValue {
                textFieldFocused = true
            } else {
                state = inputText.isEmpty ? .idle : .idleWithInput(error: validateTradeDate(inputText))
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
