//
//  HedgeNavigationBar.swift
//  DesignKit
//
//  Created by 이중엽 on 9/13/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import SwiftUI

public struct HedgeNavigationBar: View {
    
    let buttonText: String
    let onLeftButtonTap: (() -> Void)?
    let onRightButtonTap: (() -> Void)?
    
    public init(
        buttonText: String,
        onLeftButtonTap: (() -> Void)? = nil,
        onRightButtonTap: (() -> Void)? = nil
    ) {
        self.buttonText = buttonText
        self.onLeftButtonTap = onLeftButtonTap
        self.onRightButtonTap = onRightButtonTap
    }
    
    public var body: some View {
        HStack {
            Button {
                onLeftButtonTap?()
            } label: {
                Image(.chevronLeftThickSmall)
            }
            .frame(width: 40, height: 40)
            
            Spacer()
            
            Button {
                onRightButtonTap?()
            } label: {
                Text(buttonText)
                    .foregroundStyle(.black)
                    .font(.body3Semibold)
            }
            .padding(.horizontal, 14)
        }
        .padding(.horizontal, 4)
        .frame(height: 44)
    }
}

#Preview {
    HedgeNavigationBar(
        buttonText: "다음",
        onLeftButtonTap: {
            print("왼쪽 버튼 클릭")
        },
        onRightButtonTap: {
            print("오른쪽 버튼 클릭")
        }
    )
}
