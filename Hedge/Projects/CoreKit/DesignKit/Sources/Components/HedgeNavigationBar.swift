//
//  HedgeNavigationBar.swift
//  DesignKit
//
//  Created by 이중엽 on 9/13/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import SwiftUI

/// 네비게이션 바 컴포넌트
/// 
/// 좌측 뒤로가기 버튼과 우측 액션 버튼을 포함한 네비게이션 바입니다.
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
                Image.hedgeUI.arrowLeftThick
            }
            .frame(width: 40, height: 40)
            
            Spacer()
            
            Button {
                onRightButtonTap?()
            } label: {
                Text(buttonText)
                    .foregroundStyle(HedgeUI.brandDarken)
                    .font(FontModel.body1Semibold)
            }
            .padding(.trailing, 12)
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
