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
/// - `.icon(_:)` - 아이콘 표시 여부 설정 (on, off)
/// - `.state(_:)` - 버튼 상태 설정 (active, disabled)
public struct HedgeTextButton: View {
    
    private var size: HedgeTextButtonSize
    private var icon: HedgeTextButtonIcon
    private var state: HedgeTextButtonState
    private var title: String
    private var onTapped: () -> Void
    
    public init(
        _ title: String,
        _ onTapped: @escaping () -> Void
    ) {
        self.size = .large
        self.icon = .on
        self.state = .active
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
                
                if icon == .on {
                    Image(.chevronRightSmall)
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
    }
    
    /// 버튼의 크기를 설정합니다.
    /// - Parameter size: 버튼 크기 (large, medium, small)
    /// - Returns: 설정된 크기의 HedgeTextButton
    public func size(_ size: HedgeTextButtonSize) -> HedgeTextButton {
        var hedgeTextButton = self
        hedgeTextButton.size = size
        return hedgeTextButton
    }
    
    /// 버튼의 아이콘 표시 여부를 설정합니다.
    /// - Parameter icon: 아이콘 표시 여부 (on, off)
    /// - Returns: 설정된 아이콘의 HedgeTextButton
    public func icon(_ icon: HedgeTextButtonIcon) -> HedgeTextButton {
        var hedgeTextButton = self
        hedgeTextButton.icon = icon
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
    
    public enum HedgeTextButtonIcon {
        case on
        case off
    }
    
    public enum HedgeTextButtonState {
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
}

#Preview {
    HedgeTextButton("Text") {
        print("클릭")
    }
}
