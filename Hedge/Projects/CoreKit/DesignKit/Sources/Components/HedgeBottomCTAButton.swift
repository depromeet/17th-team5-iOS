//
//  HedgeBottomCTAButton.swift
//  DesignKit
//
//  Created by Junyoung on 9/13/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import SwiftUI

/// 하단 고정 CTA 버튼 컴포넌트
/// 
/// 사용 가능한 modifier:
/// - `.bg(_:)` - 배경 스타일 설정 (whiteGradient, transparent)
/// - `.style(_:)` - 버튼 스타일 설정 (oneButton, twoButton)
public struct HedgeBottomCTAButton: View {
    private var background: HedgeBottomCTAButtonBG
    private var style: HedgeBottomCTAButtonStyle
    private var text: String?
    
    public init(
        _ text: String? = nil,
    ) {
        self.background = .whiteGradient
        self.style = .oneButton(
                title: "버튼명",
                onTapped: {}
        )
        self.text = text
    }
    
    public var body: some View {
        VStack(
            spacing: 12
        ) {
            switch style {
            case .oneButton(let title, let onTapped):
                // HedgeActionButton(title) {
                //     onTapped()
                // }
                // .size(.large)
                // .color(.primary)
                
                Button {
                    onTapped()
                } label: {
                    HStack() {
                        Spacer()
                        
                        Text(title)
                            .font(FontModel.body1Semibold)
                            .foregroundStyle(Color.hedgeUI.textWhite)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                }
                .foregroundStyle(Color.hedgeUI.textWhite)
                .background(Color.hedgeUI.brandPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                

                
            case .twoButton(let leftTitle, let rightTitle, let leftOnTapped, let rightOnTapped):
                HStack(spacing: 9) {
                    HedgeActionButton(leftTitle) {
                        leftOnTapped()
                    }
                    .size(.large)
                    .color(.secondary)
                    
                    HedgeActionButton(rightTitle) {
                        rightOnTapped()
                    }
                    .size(.large)
                    .color(.primary)
                }
            }
            
            if let text {
                HedgeTextButton(text) { }
                .size(.large)
                .state(.active)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 10)
        .background(background.view)
    }
    
    /// 버튼의 배경 스타일을 설정합니다.
    /// - Parameter bg: 배경 스타일 (whiteGradient, transparent)
    /// - Returns: 배경이 설정된 HedgeBottomCTAButton
    public func bg(
        _ bg: HedgeBottomCTAButtonBG
    ) -> HedgeBottomCTAButton {
        var button = self
        button.background = bg
        return button
    }
    
    /// 버튼의 스타일을 설정합니다.
    /// - Parameter style: 버튼 스타일 (oneButton, twoButton)
    /// - Returns: 스타일이 설정된 HedgeBottomCTAButton
    public func style(
        _ style: HedgeBottomCTAButtonStyle
    ) -> HedgeBottomCTAButton {
        var button = self
        button.style = style
        return button
    }
}

extension HedgeBottomCTAButton {
    /// 하단 CTA 버튼의 배경 스타일을 정의하는 enum
    /// - `whiteGradient`: 위에서 아래로 흰색 그라디언트 배경
    /// - `transparent`: 투명한 배경
    public enum HedgeBottomCTAButtonBG {
        case whiteGradient
        case transparent
        
        @ViewBuilder
        var view: some View {
            switch self {
            case .whiteGradient:
                LinearGradient(
                    gradient: Gradient(stops: [
                            .init(color: Color.white.opacity(0.0), location: 0.0),
                            .init(color: Color.white.opacity(0.98), location: 0.21),
                            .init(color: Color.white.opacity(1.0), location: 1.0)
                        ]
                    ),
                    startPoint: .top,
                    endPoint: .bottom
                )
            case .transparent:
                Color.clear
            }
        }
    }
    
    /// 하단 CTA 버튼의 스타일을 정의하는 enum
    /// - `oneButton(title:onTapped:)`: 단일 버튼 스타일
    /// - `twoButton(leftTitle:rightTitle:leftOnTapped:rightOnTapped:)`: 두 개의 버튼 스타일
    public enum HedgeBottomCTAButtonStyle {
        case oneButton(
            title: String,
            onTapped: () -> Void
        )
        case twoButton(
            leftTitle: String,
            rightTitle: String,
            leftOnTapped: () -> Void,
            rightOnTapped: () -> Void
        )
    }
}

#Preview {
    ZStack {
        Color.hedgeUI.grey500
        HedgeBottomCTAButton("Text")
        .bg(.whiteGradient)
        .style(.oneButton(title: "123", onTapped: {
            
        }))
    }
}
