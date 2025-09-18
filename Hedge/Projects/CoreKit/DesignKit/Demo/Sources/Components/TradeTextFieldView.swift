//
//  TradeTextFieldView.swift
//  DesignKitDemo
//
//  Created by 이중엽 on 9/14/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import SwiftUI

import DesignKit

struct TradeTextFieldView: View {
    @State private var buyPrice = ""
    @State private var sellPrice = ""
    @State private var quantity = ""
    @State private var tradeDate = ""
    @State private var yield = ""
    @State var focusedID: String? = nil
    
    var body: some View {
        VStack(spacing: 16) {
            HedgeTradeTextField(
                inputText: $buyPrice,
                focusedID: $focusedID
            )
            .type(.buyPrice)
            
            HedgeTradeTextField(
                inputText: $sellPrice,
                focusedID: $focusedID
            )
            .type(.sellPrice)
            
            HedgeTradeTextField(
                inputText: $quantity,
                focusedID: $focusedID
            )
            .type(.quantity)
            
            HedgeTradeTextField(
                inputText: $tradeDate,
                focusedID: $focusedID
            )
            .type(.tradeDate)
            
            HedgeTradeTextField(
                inputText: $yield,
                focusedID: $focusedID
            )
            .type(.yield)
        }
        .padding()
        .background(Color.hedgeUI.backgroundGrey)
    }
}

#Preview {
    TradeTextFieldView()
}
