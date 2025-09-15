//
//  TextFieldView.swift
//  DesignKitDemo
//
//  Created by 이중엽 on 9/14/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import SwiftUI

import DesignKit

struct TextFieldView: View {
    @State private var buyPrice = ""
    @State private var sellPrice = ""
    @State private var quantity = ""
    @State private var tradeDate = ""
    @State var focusedID: String? = nil
    
    // Configuration 모델
    private let buyPriceConfig = HedgeTextFieldConfiguration(fieldType: .buyPrice)
    private let sellPriceConfig = HedgeTextFieldConfiguration(fieldType: .sellPrice)
    private let quantityConfig = HedgeTextFieldConfiguration(fieldType: .quantity)
    private let tradeDateConfig = HedgeTextFieldConfiguration(fieldType: .tradeDate)
    
    var body: some View {
        VStack(spacing: 16) {
            HedgeTextField.builder()
                .configuration(buyPriceConfig)
                .focusedID($focusedID)
                .inputText($buyPrice)
                .build()
            
            HedgeTextField.builder()
                .configuration(sellPriceConfig)
                .focusedID($focusedID)
                .inputText($sellPrice)
                .build()
            
            HedgeTextField.builder()
                .configuration(quantityConfig)
                .focusedID($focusedID)
                .inputText($quantity)
                .build()
            
            HedgeTextField.builder()
                .configuration(tradeDateConfig)
                .focusedID($focusedID)
                .inputText($tradeDate)
                .build()
        }
        .padding()
        .background(Color.hedgeUI.backgroundGrey)
    }
}

#Preview {
    TextFieldView()
}
