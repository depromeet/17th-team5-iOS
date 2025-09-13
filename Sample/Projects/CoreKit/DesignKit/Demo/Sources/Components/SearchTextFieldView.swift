//
//  SearchTextFieldView.swift
//  DesignKit
//
//  Created by Junyoung on 9/14/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import SwiftUI

import DesignKit

struct SearchTextFieldView: View {
    @State var text: String = ""
    
    var body: some View {
        HedgeSearchTextField(placeholder: "종목 검색", text: $text)
    }
}
