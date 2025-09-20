//
//  TradeHistoryInputView.swift
//  TradeHistoryFeature
//
//  Created by 이중엽 on 9/20/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI
import DesignKit

struct TradeHistoryInputView: View {
    
    let image: Image
    let StockTitle: String
    let description: String
    
    @State var tradingPrice: String = ""
    @State var tradingQuantity: String = ""
    @State var tradingDate: String = ""
    @State var focuedID: String? = nil
    @State var isYieldInputVisible: Bool = false
    
    // 첫 번째 구분선 색상 (buy/SellPrice와 quantity 사이)
    private var firstDividerColor: Color {
        guard let focuedID = focuedID else { return Color.hedgeUI.grey200 }
        
        if focuedID == HedgeTradeTextField.HedgeTextFieldType.buyPrice.rawValue ||
            focuedID == HedgeTradeTextField.HedgeTextFieldType.sellPrice.rawValue ||
            focuedID == HedgeTradeTextField.HedgeTextFieldType.quantity.rawValue {
            return .clear
        }
        return Color.hedgeUI.grey200
    }
    
    // 두 번째 구분선 색상 (quantity와 tradeDate 사이)
    private var secondDividerColor: Color {
        guard let focuedID = focuedID else { return Color.hedgeUI.grey200 }
        
        if focuedID == HedgeTradeTextField.HedgeTextFieldType.quantity.rawValue ||
           focuedID == HedgeTradeTextField.HedgeTextFieldType.tradeDate.rawValue {
            return .clear
        }
        return Color.hedgeUI.grey200
    }
    
    var body: some View {
        
        ZStack {
            Color.hedgeUI.neutralBgSecondary.ignoresSafeArea()
            
            VStack(spacing: 0) {
                HedgeNavigationBar(buttonText: "", onLeftButtonTap: nil)
                
                VStack(spacing: 16) {
                    topView
                    
                    textFieldGroup
                    
                    Spacer()
                    
                    YieldInputToggleRow
                }
            }
        }
    }
    
    @ViewBuilder
    private var topView: some View {
        VStack(spacing: 8) {
            HStack(spacing: 7) {
                image
                    .resizable()
                    .frame(width: 22, height: 22)
                
                Text(StockTitle)
                    .font(FontModel.body3Medium)
                    .foregroundStyle(Color.hedgeUI.grey900)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Text(description)
                .font(FontModel.h1Semibold)
                .foregroundStyle(Color.hedgeUI.grey900)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    @ViewBuilder
    private var textFieldGroup: some View {
        VStack(spacing: 0) {
            HedgeTradeTextField(inputText: $tradingPrice, focusedID: $focuedID)
                .type(.buyPrice)
            
            RoundedRectangle(cornerSize: .zero)
                .fill(firstDividerColor)
                .frame(height: 1)
                .frame(maxWidth: .infinity)
            
            HedgeTradeTextField(inputText: $tradingQuantity, focusedID: $focuedID)
                .type(.quantity)
            
            RoundedRectangle(cornerSize: .zero)
                .fill(secondDividerColor)
                .frame(height: 1)
                .frame(maxWidth: .infinity)
            
            HedgeTradeTextField(inputText: $tradingDate, focusedID: $focuedID)
                .type(.tradeDate)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.hedgeUI.neutralBgDefault)
        )
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private var YieldInputToggleRow: some View {
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
        .padding(.vertical, 16)
    }
    
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

#Preview {
    TradeHistoryInputView(image: HedgeUI.search, StockTitle: "종목명", description: "얼마에 매도하셨나요?")
}
