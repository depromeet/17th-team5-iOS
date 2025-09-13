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
    @State private var sellPrice = ""
    @State private var quantity = ""
    @State private var totalAmount = ""
    @State var id: String = ""
    @State var focusedID: String? = nil
    
    var body: some View {
        VStack(spacing: 16) {
            HedgeTextField(
                placeHolder: "1주당 가격",
                label: "매도가",
                focusingLabel: "매도가 입력",
                id: .constant("1"),
                focusedID: $focusedID,
                inputText: $sellPrice
            )
            
            HedgeTextField(
                placeHolder: "수량",
                label: "수량",
                focusingLabel: "수량 입력",
                id: .constant("2"),
                focusedID: $focusedID,
                inputText: $quantity
            )
            
            HedgeTextField(
                placeHolder: "총 금액",
                label: "총 금액",
                focusingLabel: "총 금액 입력",
                id: .constant("3"),
                focusedID: $focusedID,
                inputText: $totalAmount
            )
        }
        .padding()
    }
}

#Preview {
    TextFieldView()
}
