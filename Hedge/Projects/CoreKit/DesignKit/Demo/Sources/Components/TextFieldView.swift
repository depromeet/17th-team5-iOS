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
    
    var body: some View {
        VStack(spacing: 16) {
            HedgeTextField(
                inputText: $buyPrice,
                focusedID: $focusedID
            )
            .type(.buyPrice)
            
            HedgeTextField(
                inputText: $sellPrice,
                focusedID: $focusedID
            )
            .type(.sellPrice)
            
            HedgeTextField(
                inputText: $quantity,
                focusedID: $focusedID
            )
            .type(.quantity)
            
            HedgeTextField(
                inputText: $tradeDate,
                focusedID: $focusedID
            )
            .type(.tradeDate)
        }
        .padding()
        .background(Color.hedgeUI.backgroundGrey)
    }
}

#Preview {
    TextFieldView()
}
