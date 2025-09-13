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
    
    public static var red500: Color { asset(#function) }
    public static var red700: Color { asset(#function) }
    
    public static var blue500: Color { asset(#function) }
    
    public static var backgroundGrey: Color { asset(#function) }
    public static var backgroundWhite: Color { asset(#function) }
    
    public static var brand500: Color { asset(#function) }
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
