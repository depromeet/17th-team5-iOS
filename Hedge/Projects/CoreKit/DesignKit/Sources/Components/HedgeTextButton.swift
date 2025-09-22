//
//  HedgeTextButton.swift
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
public struct HedgeTextButton: View {
    
    private var size: HedgeTextButtonSize
    private var icon: HedgeTextButtonIcon
    private var state: HedgeTextButtonState
    private var color: HedgeTextButtonColor
    private var title: String
    private var onTapped: () -> Void
    
    public init(
        _ title: String,
        _ onTapped: @escaping () -> Void
    ) {
        self.size = .large
        self.icon = .off
        self.state = .active
        self.color = .primary
        self.title = title
        self.onTapped = onTapped
    }
    
    public var body: some View {
        Button {
            onTapped()
        } label: {
            HStack(spacing: 0) {
                Text(title)
                    .foregroundStyle(foregroundColor)
                    .font(size.textFont)
                
                if case .on(let image) = icon {
                    image
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(foregroundColor)
                        .frame(width: size.iconSize, height: size.iconSize)
                }
            }
        }
        .disabled(state == .disabled)
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
    }
    
    /// 버튼의 크기를 설정합니다.
    /// - Parameter size: 버튼 크기 (large, medium, small)
    /// - Returns: 설정된 크기의 HedgeTextButton
    public func size(_ size: HedgeTextButtonSize) -> HedgeTextButton {
        var hedgeTextButton = self
        hedgeTextButton.size = size
        return hedgeTextButton
    }
    
    /// 버튼의 아이콘을 HedgeTextButtonIcon enum으로 설정합니다.
    /// - Parameter icon: 아이콘 설정 (.on(image: Image) 또는 .off)
    /// - Returns: 아이콘이 설정된 HedgeTextButton
    public func icon(_ icon: HedgeTextButtonIcon) -> HedgeTextButton {
        var hedgeTextButton = self
        hedgeTextButton.icon = icon
        return hedgeTextButton
    }
    
    /// 버튼에 아이콘을 Image로 직접 설정합니다.
    /// - Parameter image: 표시할 아이콘 이미지
    /// - Returns: 아이콘이 설정된 HedgeTextButton
    public func icon(_ image: Image) -> HedgeTextButton {
        var hedgeTextButton = self
        hedgeTextButton.icon = .on(image: image)
        return hedgeTextButton
    }
    
    /// 버튼의 상태를 설정합니다.
    /// - Parameter state: 버튼 상태 (active, disabled)
    /// - Returns: 설정된 상태의 HedgeTextButton
    public func state(_ state: HedgeTextButtonState) -> HedgeTextButton {
        var hedgeTextButton = self
        hedgeTextButton.state = state
        return hedgeTextButton
    }
    
    /// 버튼의 스타일을 설정합니다.
    /// - Parameter color: 버튼 스타일 (primary, secondary)
    /// - Returns: 색상이 설정된 HedgeTextButton
    public func color(_ color: HedgeTextButtonColor) -> HedgeTextButton {
        var hedgeTextButton = self
        hedgeTextButton.color = color
        return hedgeTextButton
    }
    
    private var foregroundColor: Color {
        switch state {
        case .active:
            return color.foregroundColor
        case .disabled:
            return Color.hedgeUI.textDisabled
        }
    }
}

extension HedgeTextButton {
    public enum HedgeTextButtonSize {
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
    public enum HedgeTextButtonIcon {
        case on(image: Image)
        case off
    }
    
    public enum HedgeTextButtonState {
        case active
        case disabled
    }
    
    public enum HedgeTextButtonColor {
        case primary
        case secondary
        
        var foregroundColor: Color {
            switch self {
            case .primary:
                return Color.hedgeUI.brandDarken
            case .secondary:
                return Color.hedgeUI.textAlternative
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        HedgeTextButton("Text") {
            print("클릭")
        }
        
        HedgeTextButton("Text with Icon") {
            print("클릭")
        }
        .icon(Image.hedgeUI.arrowRightThin)
        
        HedgeTextButton("Custom Icon") {
            print("클릭")
        }
        .icon(Image(systemName: "heart.fill"))
    }
}
