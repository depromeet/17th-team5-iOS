//
//  TradeHistoryInputView.swift
//  TradeHistoryFeature
//
//  Created by 이중엽 on 9/20/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI
import Combine

import ComposableArchitecture

import TradeHistoryFeatureInterface
import DesignKit
import Shared

@ViewAction(for: TradeHistoryFeature.self)
public struct TradeHistoryInputView: View {
    @Bindable public var store: StoreOf<TradeHistoryFeature>
    @State var focusedID: String? = nil
    @State var isYieldInputVisible: Bool = false
    @State var selectedDate: Date = Date()
    @State var showDatePicker: Bool = false
    
    @State private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Computed Properties
    
    /// 첫 번째 구분선 색상 (매수가/매도가와 거래량 사이)
    private var firstDividerColor: Color {
        guard let focusedID = focusedID else { return Color.hedgeUI.grey200 }
        
        if focusedID == HedgeTradeTextField.HedgeTextFieldType.buyPrice.rawValue ||
            focusedID == HedgeTradeTextField.HedgeTextFieldType.sellPrice.rawValue ||
            focusedID == HedgeTradeTextField.HedgeTextFieldType.quantity.rawValue {
            return .clear
        }
        return Color.hedgeUI.grey200
    }
    
    /// 두 번째 구분선 색상 (거래량과 거래날짜 사이)
    private var secondDividerColor: Color {
        guard let focusedID = focusedID else { return Color.hedgeUI.grey200 }
        
        if focusedID == HedgeTradeTextField.HedgeTextFieldType.quantity.rawValue ||
           focusedID == HedgeTradeTextField.HedgeTextFieldType.tradeDate.rawValue {
            return .clear
        }
        return Color.hedgeUI.grey200
    }
    
    private var description: String {
        if let focusedID, let type = HedgeTradeTextField.HedgeTextFieldType(rawValue: focusedID) {
            switch type {
            case .buyPrice:
                return "얼마에 매수하셨나요?"
            case .sellPrice:
                return "얼마에 매도하셨나요?"
            case .quantity:
                return "몇 주 \(store.tradeType.rawValue)하셨나요?"
            case .tradeDate:
                return "언제 \(store.tradeType.rawValue)하셨나요?"
            case .yield:
                let price = store.tradingPrice.extractDecimalNumber()
                let quantity = Double(store.tradingQuantity.extractNumbers())
                let total = String(price * quantity).toDecimalStringWithDecimal()
                let prefix = store.state.selectedConcurrency == 0 ? "" : "$"
                let suffix = store.state.selectedConcurrency == 0 ? "원" : ""
                return "총 \(prefix)\(total)\(suffix) \(store.tradeType == .buy ? "매수" : "매도")"
            }
        } else {
            let price = store.tradingPrice.extractDecimalNumber()
            let quantity = Double(store.tradingQuantity.extractNumbers())
            let total = String(price * quantity).toDecimalStringWithDecimal()
            let prefix = store.state.selectedConcurrency == 0 ? "" : "$"
            let suffix = store.state.selectedConcurrency == 0 ? "원" : ""
            return "총 \(prefix)\(total)\(suffix) \(store.tradeType == .buy ? "매수" : "매도")"
        }
    }
    
    // MARK: - Initializer
    
    public init(
        store: StoreOf<TradeHistoryFeature>
    ) {
        self.store = store
    }
    
    // MARK: - Body
    
    public var body: some View {
        
        ZStack {
            Color.hedgeUI.neutralBgSecondary.ignoresSafeArea()
                .onTapGesture {
                    focusedID = nil
                }
            
            VStack(spacing: 0) {
                HedgeNavigationBar(buttonText: "", onLeftButtonTap:  {
                    send(.backButtonTapped)
                })
                
                VStack(spacing: 16) {
                    HedgeTopView(
                        symbolImage: Image.hedgeUI.stockThumbnailDemo,
                        title: store.stock.title,
                        description: description
                    )
                    
                    textFieldGroup
                }
                
                HedgeTradeTextField(inputText: $store.yield, focusedID: $focusedID)
                    .type(.yield)
                    .padding(.top, 12)
                    .padding(.horizontal, 20)
                    .opacity(isYieldInputVisible ? 1 : 0)
                    .offset(y: isYieldInputVisible ? 0 : -12)
                    .animation(.easeInOut(duration: 0.3), value: isYieldInputVisible)
                
                Spacer()
                
                if store.state.tradeType == .sell {
                    yieldInputToggleRow
                }
                
                HedgeBottomCTAButton()
                    .style(
                        .oneButton(
                            title: "다음",
                            onTapped: {
                                send(.nextTapped)
                            }
                        )
                    )
                    .bg(.transparent)
            }
        }
        .onAppear {
            registerKeyboardDismissal()
            registerDatePickerDisplay()
        }
    }
}

// MARK: - SubViews
extension TradeHistoryInputView {
    
    @ViewBuilder
    private var textFieldGroup: some View {
        VStack(spacing: 0) {
            HedgeTradeTextField(inputText: $store.tradingPrice, focusedID: $focusedID, selectedIndex: $store.state.selectedConcurrency)
                .type(store.state.tradeType == .buy ? .buyPrice : .sellPrice)
            
            RoundedRectangle(cornerSize: .zero)
                .fill(firstDividerColor)
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .animation(.easeInOut(duration: 0.3), value: firstDividerColor)
            
            HedgeTradeTextField(inputText: $store.tradingQuantity, focusedID: $focusedID)
                .type(.quantity)
            
            RoundedRectangle(cornerSize: .zero)
                .fill(secondDividerColor)
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .animation(.easeInOut(duration: 0.3), value: secondDividerColor)
            
            HedgeTradeTextField(inputText: $store.tradingDate, focusedID: $focusedID)
                .type(.tradeDate)
                .sheet(isPresented: $showDatePicker) {
                    VStack {
                        DatePicker("날짜 선택", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            .tint(Color.hedgeUI.brandPrimary)
                        
                        HedgeBottomCTAButton()
                            .style(.oneButton(title: "완료", onTapped: {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd"
                                store.tradingDate = formatter.string(from: selectedDate)
                                focusedID = nil
                                showDatePicker = false
                            }))
                    }
                    .onDisappear(perform: {
                        focusedID = nil
                        showDatePicker = false
                    })
                    .presentationDetents([.medium])
                    .presentationBackground(.white)
                    .presentationCornerRadius(20)
                }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.hedgeUI.neutralBgDefault)
        )
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private var yieldInputToggleRow: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("수익률도 입력하기")
                    .font(FontModel.body3Semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("더 자세한 AI 분석이 가능해요")
                    .font(FontModel.label2Semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Toggle("", isOn: $isYieldInputVisible)
                .toggleStyle(CustomToggleStyle())
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Custom Styles
extension TradeHistoryInputView {
    struct CustomToggleStyle: ToggleStyle {
        func makeBody(configuration: Configuration) -> some View {
            HStack {
                configuration.label
                Spacer()
                
                RoundedRectangle(cornerRadius: 14)
                    .fill(configuration.isOn ? Color.hedgeUI.brandPrimary : Color.hedgeUI.greyOpacity300)
                    .frame(width: 45, height: 28)
                    .overlay(
                        Circle()
                            .fill(Color.white)
                            .offset(x: configuration.isOn ? 10 : -10)
                            .frame(width: 22, height: 22)
                    )
                    .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
                    .onTapGesture {
                        configuration.isOn.toggle()
                    }
            }
        }
    }
}

// MARK: - Keyboard Management
extension TradeHistoryInputView {
    /// 키보드가 표시될 때 자동으로 숨기는 기능을 등록합니다.
    private func registerKeyboardDismissal() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { _ in focusedID }
            .filter { $0 == HedgeTradeTextField.HedgeTextFieldType.tradeDate.rawValue }
            .sink { _ in
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .store(in: &cancellables)
    }
    
    /// 키보드가 표시될 때 DatePicker를 표시하는 기능을 등록합니다.
    private func registerDatePickerDisplay() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { _ in focusedID }
            .filter { $0 == HedgeTradeTextField.HedgeTextFieldType.tradeDate.rawValue }
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .sink { _ in
                showDatePicker = true
            }
            .store(in: &cancellables)
    }
}
