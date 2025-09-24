//
//  PressButtonStyle.swift
//  DesignKit
//
//  Created by Junyoung on 9/23/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

struct PressButtonStyle: ButtonStyle {
    var cornerRadius: CGFloat = 9
    var normalColor: Color = .clear
    var pressedColor: Color = Color.hedgeUI.greyOpacity200
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        configuration.isPressed
                        ? pressedColor
                        : normalColor
                    )
            )
            .animation(
                .easeInOut(duration: 0.2),
                value: configuration.isPressed
            )
    }
}
