//
//  HedgeButton.swift
//  DesignKit
//
//  Created by 이중엽 on 9/18/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

/// 텍스트와 아이콘을 포함한 버튼 컴포넌트
/// 
/// 사용 가능한 modifier:
/// - `.size(_:)` - 버튼 크기 설정 (large, medium, small)
/// - `.icon(_:)` - 아이콘 설정 (Image 직접 전달 또는 HedgeButtonIcon enum 사용)
/// - `.state(_:)` - 버튼 상태 설정 (active, disabled)
/// - `.style(_:)` - 버튼 스타일 설정 (ghost 등)
public struct HedgeButton: View {
    
    private var size: HedgeButtonSize
    private var icon: HedgeButtonIcon
    private var state: HedgeButtonState
    private var style: HedgeButtonStyle
    private var title: String
    private var onTapped: () -> Void
    
    public init(
        _ title: String,
        _ onTapped: @escaping () -> Void
    ) {
        self.size = .large
        self.icon = .off
        self.state = .active
        self.style = .ghost
        self.title = title
        self.onTapped = onTapped
    }
    
    public var body: some View {
        Button {
            onTapped()
        } label: {
            HStack(spacing: 0) {
                Text(title)
                    .foregroundStyle(state.foregroundColor)
                    .font(size.textFont)
                
                if case .on(let image) = icon {
                    image
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(state.foregroundColor)
                        .frame(width: size.iconSize, height: size.iconSize)
                }
            }
        }
        .disabled(state == .disabled)
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .background(style.backgroundColor)
    }
    
    /// 버튼의 크기를 설정합니다.
    /// - Parameter size: 버튼 크기 (large, medium, small)
    /// - Returns: 설정된 크기의 HedgeTextButton
    public func size(_ size: HedgeButtonSize) -> HedgeButton {
        var hedgeTextButton = self
        hedgeTextButton.size = size
        return hedgeTextButton
    }
    
    /// 버튼의 아이콘을 HedgeButtonIcon enum으로 설정합니다.
    /// - Parameter icon: 아이콘 설정 (.on(image: Image) 또는 .off)
    /// - Returns: 아이콘이 설정된 HedgeButton
    public func icon(_ icon: HedgeButtonIcon) -> HedgeButton {
        var hedgeTextButton = self
        hedgeTextButton.icon = icon
        return hedgeTextButton
    }
    
    /// 버튼에 아이콘을 Image로 직접 설정합니다.
    /// - Parameter image: 표시할 아이콘 이미지
    /// - Returns: 아이콘이 설정된 HedgeButton
    public func icon(_ image: Image) -> HedgeButton {
        var hedgeTextButton = self
        hedgeTextButton.icon = .on(image: image)
        return hedgeTextButton
    }
    
    /// 버튼의 상태를 설정합니다.
    /// - Parameter state: 버튼 상태 (active, disabled)
    /// - Returns: 설정된 상태의 HedgeTextButton
    public func state(_ state: HedgeButtonState) -> HedgeButton {
        var hedgeTextButton = self
        hedgeTextButton.state = state
        return hedgeTextButton
    }
    
    /// 버튼의 스타일을 설정합니다.
    /// - Parameter style: 버튼 스타일 (ghost 등)
    /// - Returns: 스타일이 설정된 HedgeButton
    public func style(_ style: HedgeButtonStyle) -> HedgeButton {
        var hedgeTextButton = self
        hedgeTextButton.style = style
        return hedgeTextButton
    }
}

extension HedgeButton {
    public enum HedgeButtonSize {
        case large
        case medium
        case small
        
        var textFont: FontModel {
            switch self {
            case .large:
                return .body1Semibold
            case .medium:
                return .body3Semibold
            case .small:
                return .label2Semibold
            }
        }
        
        var iconSize: CGFloat {
            switch self {
            case .large:
                return 24
            case .medium:
                return 20
            case .small:
                return 16
            }
        }
    }
    
    /// 버튼 아이콘 설정을 위한 enum
    /// - `on(image: Image)`: 아이콘을 표시하며, 연관값으로 표시할 Image를 받음
    /// - `off`: 아이콘을 표시하지 않음
    public enum HedgeButtonIcon {
        case on(image: Image)
        case off
    }
    
    public enum HedgeButtonState {
        case active
        case disabled
        
        var foregroundColor: Color {
            switch self {
            case .active:
                return Color.hedgeUI.textTitle
            case .disabled:
                return Color.hedgeUI.textDisabled
            }
        }
    }
    
    /// 버튼 스타일을 정의하는 enum
    /// - `ghost`: 투명한 배경의 고스트 버튼 스타일
    public enum HedgeButtonStyle {
        case ghost
        
        var backgroundColor: Color {
            switch self {
            case .ghost:
                return .clear
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        HedgeButton("Text") {
            print("클릭")
        }
        
        HedgeButton("Text with Icon") {
            print("클릭")
        }
        .icon(Image.hedgeUI.arrowRightThin)
        
        HedgeButton("Custom Icon") {
            print("클릭")
        }
        .icon(Image(systemName: "heart.fill"))
    }
}
