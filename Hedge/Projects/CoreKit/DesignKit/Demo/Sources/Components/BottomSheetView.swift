//
//  BottomSheetView.swift
//  DesignKit
//
//  Created by Junyoung on 10/11/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

struct BottomSheetView: View {
    @State private var isPresented: Bool = false
    var body: some View {
        ZStack(alignment: .center) {
            Button("show!") {
                isPresented = true
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .hedgeBottomSheet(isPresented: $isPresented, title: "타이틀", maxHeight: 0.8) {
            VStack {
                Text("hi my name is junyoung")
                    .frame(height: 50)
            }
        }
    }
}

#Preview {
    BottomSheetView()
}


