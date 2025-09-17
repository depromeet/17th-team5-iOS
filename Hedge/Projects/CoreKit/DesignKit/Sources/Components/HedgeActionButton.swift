//
//  HedgeActionButton.swift
//  DesignKit
//
//  Created by 이중엽 on 9/17/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

public struct HedgeActionButton: View {
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    private var size: HedgeActionButtonSize
    private var color: HedgeActionButtonColor
    private var title: String
    private var onTapped: () -> Void
    
    public init(
        _ title: String,
        _ onTapped: @escaping () -> Void
    ) {
        self.size = .large
        self.color = .primary
        self.title = title
        self.onTapped = onTapped
    }
    
    public var body: some View {
        Button {
            onTapped()
        } label: {
            Text(title)
                .font(size.font)
                .foregroundStyle(isEnabled ? color.textColor : color.disableTextColor)
                .frame(maxWidth: .infinity)
        }
        .padding(.vertical, size.verticalPadding)
        .padding(.horizontal, size.horizontalPadding)
        .background(isEnabled ? color.backgroundColor : color.disableBackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius))
    }
    
    public func size(_ size: HedgeActionButtonSize) -> HedgeActionButton {
        var button = self
        button.size = size
        return button
    }
    
    public func color(_ color: HedgeActionButtonColor) -> HedgeActionButton {
        var button = self
        button.color = color
        return button
    }
}

extension HedgeActionButton {
    public enum HedgeActionButtonSize {
        case large
        case medium
        case small
        case tiny
        
        var font: FontModel {
            switch self {
            case .large:
                return FontModel.body1Semibold
            case .medium:
                return FontModel.body1Medium
            case .small:
                return FontModel.body3Semibold
            case .tiny:
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
            case .tiny:
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
            case .tiny:
                return 8
            }
        }
    }

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
                return Color.hedgeUI.brandSecondary
            }
        }
        
        var disableBackgroundColor: Color {
            switch self {
            case .primary:
                return Color.hedgeUI.brandDisabled
            case .secondary:
                return Color.hedgeUI.brandSecondary
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
