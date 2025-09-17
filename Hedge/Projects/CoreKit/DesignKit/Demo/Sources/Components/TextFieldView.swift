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
            HedgeTextField.builder(.buyPrice)
                .focusedID($focusedID)
                .inputText($buyPrice)
                .build()
            
            HedgeTextField.builder(.sellPrice)
                .focusedID($focusedID)
                .inputText($sellPrice)
                .build()
            
            HedgeTextField.builder(.quantity)
                .focusedID($focusedID)
                .inputText($quantity)
                .build()
            
            HedgeTextField.builder(.tradeDate)
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
