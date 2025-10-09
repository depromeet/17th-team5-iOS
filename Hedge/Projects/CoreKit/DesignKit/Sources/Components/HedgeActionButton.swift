//
//  HedgeActionButton.swift
//  DesignKit
//
//  Created by 이중엽 on 9/17/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

/// 액션 버튼 컴포넌트
/// 
/// 사용 가능한 modifier:
/// - `.size(_:)` - 버튼 크기 설정 (large, medium, small, tiny)
/// - `.color(_:)` - 버튼 색상 설정 (primary, secondary)
public struct HedgeActionButton: View {
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    private var size: HedgeActionButtonSize
    private var color: HedgeActionButtonColor
    private var image: Image?
    private var imageColor: Color?
    private var title: String
    private var onTapped: () -> Void
    
    public init(
        _ title: String,
        _ image: Image? = nil,
        _ imageColor: Color? = nil,
        _ onTapped: @escaping () -> Void
    ) {
        self.size = .large
        self.color = .primary
        self.title = title
        self.image = image
        self.imageColor = imageColor
        self.onTapped = onTapped
    }
    
    public var body: some View {
        Button {
            onTapped()
        } label: {
            HStack(alignment: .center, spacing: 0) {
                if let image, let imageColor {
                    image
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(imageColor)
                }
                
                Text(title)
                    .font(size.font)
                    .foregroundStyle(isEnabled ? color.textColor : color.disableTextColor)
                    .padding(.horizontal, size.horizontalPadding)
                    .padding(.vertical, size.verticalPadding)
            }
        }
        .background(isEnabled ? color.backgroundColor : color.disableBackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius))
    }
    
    /// 버튼의 크기를 설정합니다.
    /// - Parameter size: 버튼 크기 (large, medium, small, tiny)
    /// - Returns: 설정된 크기의 HedgeActionButton
    public func size(_ size: HedgeActionButtonSize) -> HedgeActionButton {
        var button = self
        button.size = size
        return button
    }
    
    /// 버튼의 색상을 설정합니다.
    /// - Parameter color: 버튼 색상 (primary, secondary)
    /// - Returns: 설정된 색상의 HedgeActionButton
    public func color(_ color: HedgeActionButtonColor) -> HedgeActionButton {
        var button = self
        button.color = color
        return button
    }
}

extension HedgeActionButton {
    /// 액션 버튼의 크기를 정의하는 enum
    /// - `large`: 큰 크기 버튼
    /// - `medium`: 중간 크기 버튼
    /// - `small`: 작은 크기 버튼
    /// - `tiny`: 매우 작은 크기 버튼
    public enum HedgeActionButtonSize {
        case large
        case medium
        case small
        case tiny
        case icon
        
        var font: FontModel {
            switch self {
            case .large:
                return FontModel.body1Semibold
            case .medium:
                return FontModel.body1Medium
            case .small:
                return FontModel.body3Semibold
            case .tiny, .icon:
                return FontModel.label2Semibold
            }
        }
        
        var verticalPadding: CGFloat {
            switch self {
            case .large:
                return 16
            case .medium:
                return 12
            case .small:
                return 10
            case .tiny, .icon:
                return 8
            }
        }
        
        var horizontalPadding: CGFloat {
            switch self {
            case .large:
                return 32
            case .medium:
                return 24
            case .small:
                return 20
            case .tiny:
                return 12
            case .icon:
                return 10
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .large:
                return 18
            case .medium:
                return 14
            case .small:
                return 12
            case .tiny, .icon:
                return 8
            }
        }
    }

    /// 액션 버튼의 색상을 정의하는 enum
    /// - `primary`: 주요 액션 버튼 색상 (브랜드 컬러)
    /// - `secondary`: 보조 액션 버튼 색상 (회색 계열)
    public enum HedgeActionButtonColor {
        case primary
        case secondary
        
        var textColor: Color {
            switch self {
            case .primary:
                return Color.hedgeUI.textWhite
            case .secondary:
                return Color.hedgeUI.textTitle
            }
        }
        
        var disableTextColor: Color {
            switch self {
            case .primary:
                return Color.hedgeUI.textWhite
            case .secondary:
                return Color.hedgeUI.brandDisabled
            }
        }
        
        var backgroundColor: Color {
            switch self {
            case .primary:
                return Color.hedgeUI.brandPrimary
            case .secondary:
                return Color.hedgeUI.neutralBgSecondary
            }
        }
        
        var disableBackgroundColor: Color {
            switch self {
            case .primary:
                return Color.hedgeUI.brandDisabled
            case .secondary:
                return Color.hedgeUI.neutralBgSecondary
            }
        }
    }
}

#Preview {
    HedgeActionButton("버튼") {
        print("클릭")
    }
    .size(.small)
    .color(.primary)
}
