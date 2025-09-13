//
//  HedgeButton.swift
//  DesignKit
//
//  Created by Junyoung on 9/13/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import SwiftUI

public struct HedgeCTAButton: View {
    private var configuration: HedgeButtonConfiguration
    @Environment(\.isEnabled) private var isEnabled: Bool
    private var onTapped: () -> Void
    
    public init(
        _ title: String,
        _ onTapped: @escaping () -> Void
    ) {
        self.configuration = HedgeButtonConfiguration(
            style: .fill,
            text: title
        )
        self.onTapped = onTapped
    }
    
    fileprivate init(
        _ configuration: HedgeButtonConfiguration,
        onTapped: @escaping () -> Void
    ) {
        self.configuration = configuration
        self.onTapped = onTapped
    }
    
    public var body: some View {
        Button {
            onTapped()
        } label: {
            ZStack(alignment: .center) {
                Text(configuration.text)
                    .font(configuration.style.font)
            }
            .frame(height: 56)
            .frame(maxWidth: .infinity)
            .foregroundStyle(
                isEnabled ?
                configuration.style.textColor :
                configuration.style.disableTextColor
            )
            .background(
                isEnabled ?
                configuration.style.backgroundColor :
                configuration.style.disableBackgroundColor
            )
            .cornerRadius(18)
        }

    }
    
    public func style(_ style: HedgeButtonConfiguration.HedgeButtonStyle) -> HedgeCTAButton {
        var newConfig = self.configuration
        newConfig.style = style
        return HedgeCTAButton(newConfig, onTapped: self.onTapped)
    }
}

public struct HedgeButtonConfiguration {
    var style: HedgeButtonStyle
    var image: Image?
    var text: String
    
    public enum HedgeButtonStyle {
        case fill
        case ghost
        
        var textColor: Color {
            switch self {
            case .fill:
                return .hedgeUI.backgroundWhite
            case .ghost:
                return .hedgeUI.brand500
            }
        }
        
        var disableTextColor: Color {
            switch self {
            case .fill:
                return .hedgeUI.backgroundWhite
            case .ghost:
                return .hedgeUI.brand500
            }
        }
        
        var backgroundColor: Color {
            switch self {
            case .fill:
                return .hedgeUI.brand500
            case .ghost:
                return .clear
            }
        }
        
        var disableBackgroundColor: Color {
            switch self {
            case .fill:
                return .hedgeUI.grey300
            case .ghost:
                return .clear
            }
        }
        
        var font: FontModel {
            switch self {
            case .fill:
                return .body2Semibold
            case .ghost:
                return .body1Medium
            }
        }
    }
}

#Preview {
    HedgeCTAButton("") {}
}
