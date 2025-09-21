//
//  Color.swift
//  DesignKit
//
//  Created by Junyoung on 9/13/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation
import SwiftUI

extension HedgeUI where Base == Color {
    // MARK: - Base Color
    public static var grey100: Color { asset(#function) }
    public static var grey200: Color { asset(#function) }
    public static var grey300: Color { asset(#function) }
    public static var grey400: Color { asset(#function) }
    public static var grey500: Color { asset(#function) }
    public static var grey600: Color { asset(#function) }
    public static var grey700: Color { asset(#function) }
    public static var grey800: Color { asset(#function) }
    public static var grey900: Color { asset(#function) }
    
    public static var greyOpacity200: Color { asset(#function) }
    public static var greyOpacity300: Color { asset(#function) }
    public static var greyOpacity600: Color { asset(#function) }
    
    public static var backgroundGrey: Color { asset(#function) }
    public static var backgroundWhite: Color { asset(#function) }
    public static var backgroundSecondary: Color { asset(#function) }
    
    // MARK: - Semantic
    
    // MARK: Text
    public static var textTitle: Color { grey900 }
    public static var textPrimary: Color { grey800 }
    public static var textSecondary: Color { grey600 }
    public static var textAlternative: Color { grey500 }
    public static var textAssistive: Color { grey400 }
    public static var textDisabled: Color { grey300 }
    public static var textWhite: Color { backgroundWhite }
    
    // MARK: Trade
    public static var tradeBuy: Color { asset(#function) }
    public static var tradeSell: Color { asset(#function) }
    
    // MARK: Feedback
    public static var feedbackError: Color { asset(#function) }
    public static var feedbackAI: Color { asset(#function) }
    
    // MARK: Brand
    public static var brandPrimary: Color { asset(#function) }
    public static var brandDarken: Color { asset(#function) }
    public static var brandSecondary: Color { asset(#function) }
    public static var brandDisabled: Color { grey300 }
    
    // MARK: Neutral
    public static var neutralBgDefault: Color { backgroundWhite }
    public static var neutralBgSecondary: Color { backgroundSecondary }
}

extension HedgeUI where Base == Color {
    private static func asset(_ name: String) -> Color {
        return Color(uiColor: UIColor.hedgeUI.asset(name) )
    }
}

extension HedgeUI where Base == UIColor {
    private static func asset(_ name: String) -> UIColor {
        guard let color = UIColor(named: name, in: .module, compatibleWith: nil) else {
            assertionFailure("can't find color asset: \(name)")
            return UIColor.clear
        }
        return color
    }
}
