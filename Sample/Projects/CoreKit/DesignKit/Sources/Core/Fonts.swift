//
//  Fonts.swift
//  DesignKit
//
//  Created by Junyoung on 9/13/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation
import SwiftUICore

public struct HedgeFont {
    enum Pretendard: String, CaseIterable {
        case thin = "Pretendard-Thin"
        case extraLight = "Pretendard-ExtraLight"
        case light = "Pretendard-Light"
        case regular = "Pretendard-Regular"
        case medium = "Pretendard-Medium"
        case semiBold = "Pretendard-SemiBold"
        case bold = "Pretendard-Bold"
        case extraBold = "Pretendard-ExtraBold"
        case black = "Pretendard-Black"
    }
    
    public init() {}
}


public struct FontModel {
    let font: HedgeFont.Pretendard
    let size: CGFloat
    let lineHeight: CGFloat
    
    init(
        font: HedgeFont.Pretendard,
        size: CGFloat,
        lineHeight: CGFloat = 1.5
    ) {
        self.font = font
        self.size = size
        self.lineHeight = lineHeight
    }
}

public extension FontModel {
    static var h1Semibold: FontModel { FontModel(font: .semiBold, size: 22) }
    static var h1Medium: FontModel { FontModel(font: .medium, size: 22) }
    static var h1Regular: FontModel { FontModel(font: .regular, size: 22) }
    
    static var h2Semibold: FontModel { FontModel(font: .semiBold, size: 18) }
    static var h2Medium: FontModel { FontModel(font: .medium, size: 18) }
    static var h2Regular: FontModel { FontModel(font: .regular, size: 18) }
    
    static var body1Semibold: FontModel { FontModel(font: .semiBold, size: 17) }
    static var body1Medium: FontModel { FontModel(font: .medium, size: 17) }
    static var body1Regular: FontModel { FontModel(font: .regular, size: 17) }
    
    static var body2Semibold: FontModel { FontModel(font: .semiBold, size: 16) }
    static var body2Medium: FontModel { FontModel(font: .medium, size: 16) }
    static var body2Regular: FontModel { FontModel(font: .regular, size: 16) }
    
    static var body3Semibold: FontModel { FontModel(font: .semiBold, size: 15) }
    static var body3Medium: FontModel { FontModel(font: .medium, size: 15) }
    static var body3Regular: FontModel { FontModel(font: .regular, size: 15) }
    
    static var label1Bold: FontModel { FontModel(font: .bold, size: 14) }
    static var label1Medium: FontModel { FontModel(font: .medium, size: 14) }
    static var label1Regular: FontModel { FontModel(font: .regular, size: 14) }
    
    static var label2Medium: FontModel { FontModel(font: .medium, size: 13) }
    static var label2Regular: FontModel { FontModel(font: .regular, size: 13) }
    
    static var caption1Regular: FontModel { FontModel(font: .regular, size: 12) }
    static var caption1Medium: FontModel { FontModel(font: .medium, size: 12) }
    static var caption1Semibold: FontModel { FontModel(font: .semiBold, size: 12) }
    
    static var caption2Regular: FontModel { FontModel(font: .regular, size: 11) }
    static var caption2Medium: FontModel { FontModel(font: .medium, size: 11) }
    static var caption2Semibold: FontModel { FontModel(font: .semiBold, size: 11) }
}

public struct HedgeFontModifier: ViewModifier {
    private let fontModel: FontModel

    public init(_ fontModel: FontModel) {
        self.fontModel = fontModel
    }

    public func body(content: Content) -> some View {
        let font = fontModel.font.rawValue
        let fontSize = fontModel.size
        let lineHeight = fontModel.size * fontModel.lineHeight
        let lineSpacing = lineHeight - fontSize
        let verticalPadding = (lineHeight - fontSize) / 2
        
        return content
            .font(.custom(font, size: fontSize))
            .lineSpacing(lineSpacing)
            .padding(.vertical, verticalPadding)
    }
}

public extension View {
    func font(_ fontModel: FontModel) -> some View {
        self.modifier(HedgeFontModifier(fontModel))
    }
}
