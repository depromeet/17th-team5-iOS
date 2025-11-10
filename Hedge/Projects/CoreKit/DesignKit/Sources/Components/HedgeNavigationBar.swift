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
    
    let title: String?
    let buttonText: String
    let color: HedgeTextButton.HedgeTextButtonColor
    let state: HedgeTextButton.HedgeTextButtonState
    let onLeftButtonTap: (() -> Void)?
    let onRightButtonTap: (() -> Void)?
    
    public init(
        title: String? = nil,
        buttonText: String,
        color: HedgeTextButton.HedgeTextButtonColor = .primary,
        state: HedgeTextButton.HedgeTextButtonState = .active,
        onLeftButtonTap: (() -> Void)? = nil,
        onRightButtonTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.buttonText = buttonText
        self.color = color
        self.state = state
        self.onLeftButtonTap = onLeftButtonTap
        self.onRightButtonTap = onRightButtonTap
    }
    
    // public init(
    //     title: String? = nil,
    //     buttonText: String,
    //     color: HedgeTextButton.HedgeTextButtonColor = .primary,
    //     state: HedgeTextButton.HedgeTextButtonState = .active,
    //     onLeftButtonTap: (() -> Void)? = nil,
    //     onRightButtonTap: (() -> Void)? = nil
    // ) {
    //     self.init(
    //         title: nil,
    //         buttonText: buttonText,
    //         color: color,
    //         state: state,
    //         onLeftButtonTap: onLeftButtonTap,
    //         onRightButtonTap: onRightButtonTap
    //     )
    // }
    
    public var body: some View {
        HStack {
            Button {
                onLeftButtonTap?()
            } label: {
                Image.hedgeUI.arrowLeftThick
            }
            .frame(width: 40, height: 40)
            
            Spacer()
            
            if let title = self.title {
                Text(title)
                    .font(FontModel.body3Semibold)
                    .foregroundStyle(Color.hedgeUI.textPrimary)
            }
            
            Spacer()
            
            HedgeTextButton(buttonText) {
                onRightButtonTap?()
            }
            .color(color)
            .state(state)
            .padding(.trailing, 6)
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
