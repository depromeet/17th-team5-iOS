//
//  Fonts.swift
//  DesignKit
//
//  Created by Junyoung on 9/13/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation
import SwiftUI
import CoreText

public struct HedgeFont {
    public enum Pretendard: String, CaseIterable {
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
    public let font: HedgeFont.Pretendard
    public let size: CGFloat
    public let lineHeight: CGFloat
    
    public init(
        font: HedgeFont.Pretendard,
        size: CGFloat,
        lineHeight: CGFloat = 1
    ) {
        self.font = font
        self.size = size
        self.lineHeight = lineHeight
    }
}

public extension FontModel {
    static var h1Semibold: FontModel { FontModel(font: .semiBold, size: 22, lineHeight: 1.36) }
    static var h1Medium: FontModel { FontModel(font: .medium, size: 22, lineHeight: 1.36) }
    static var h1Regular: FontModel { FontModel(font: .regular, size: 22, lineHeight: 1.36) }
    
    static var h2Semibold: FontModel { FontModel(font: .semiBold, size: 18, lineHeight: 1.44) }
    static var h2Medium: FontModel { FontModel(font: .medium, size: 18, lineHeight: 1.44) }
    static var h2Regular: FontModel { FontModel(font: .regular, size: 18, lineHeight: 1.44) }
    
    static var body1Semibold: FontModel { FontModel(font: .semiBold, size: 17, lineHeight: 1.47) }
    static var body1Medium: FontModel { FontModel(font: .medium, size: 17, lineHeight: 1.47) }
    static var body1Regular: FontModel { FontModel(font: .regular, size: 17, lineHeight: 1.47) }
    
    static var body2Semibold: FontModel { FontModel(font: .semiBold, size: 16, lineHeight: 1.48) }
    static var body2Medium: FontModel { FontModel(font: .medium, size: 16, lineHeight: 1.48) }
    static var body2Regular: FontModel { FontModel(font: .regular, size: 16, lineHeight: 1.48) }
    
    static var body3Semibold: FontModel { FontModel(font: .semiBold, size: 15, lineHeight: 1.46) }
    static var body3Medium: FontModel { FontModel(font: .medium, size: 15, lineHeight: 1.46) }
    static var body3Regular: FontModel { FontModel(font: .regular, size: 15, lineHeight: 1.46) }
    
    static var label1Semibold: FontModel { FontModel(font: .semiBold, size: 14, lineHeight: 1.42) }
    static var label1Medium: FontModel { FontModel(font: .medium, size: 14, lineHeight: 1.42) }
    static var label1Regular: FontModel { FontModel(font: .regular, size: 14, lineHeight: 1.42) }
    
    static var label2Medium: FontModel { FontModel(font: .medium, size: 13, lineHeight: 1.39) }
    static var label2Regular: FontModel { FontModel(font: .regular, size: 13, lineHeight: 1.39) }
    static var label2Semibold: FontModel { FontModel(font: .semiBold, size: 13, lineHeight: 1.39) }
    
    static var caption1Regular: FontModel { FontModel(font: .regular, size: 12, lineHeight: 1.33) }
    static var caption1Medium: FontModel { FontModel(font: .medium, size: 12, lineHeight: 1.33) }
    static var caption1Semibold: FontModel { FontModel(font: .semiBold, size: 12, lineHeight: 1.33) }
    
    static var caption2Regular: FontModel { FontModel(font: .regular, size: 11, lineHeight: 1.27) }
    static var caption2Medium: FontModel { FontModel(font: .medium, size: 11, lineHeight: 1.27) }
    static var caption2Semibold: FontModel { FontModel(font: .semiBold, size: 11, lineHeight: 1.27) }
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

extension HedgeFont {
    
    public static func registerFonts() {
        Pretendard.allCases.forEach { font in
            guard let fontURL = Bundle.module.url(forResource: font.rawValue, withExtension: "otf") else {
                fatalError("❌ 폰트 파일을 찾을 수 없음: \(font.rawValue)")
            }
            CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
        }
    }
    
    public func fontURL(for font: Pretendard) -> URL? {
        return Bundle.module.url(forResource: font.rawValue, withExtension: "otf")
    }
}
