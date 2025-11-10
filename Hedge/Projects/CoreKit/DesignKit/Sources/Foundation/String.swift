//
//  Text.swift
//  DesignKit
//
//  Created by 이중엽 on 11/8/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

extension String {
    public func colorText(target: String, color: Color, defaultColor: Color = .primary) -> AttributedString {
        var attributed = AttributedString(self)
        attributed.foregroundColor = defaultColor

        if let range = attributed.range(of: target) {
            attributed[range].foregroundColor = color
        }

        return attributed
    }
}
