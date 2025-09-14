//
//  FontAssembly.swift
//  Umbrella
//
//  Created by 이중엽 on 9/14/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import Swinject
import DesignKit
import SwiftUICore

extension HedgeFont: @retroactive Assembly {
    
    public func assemble(container: Container) {
        Pretendard.allCases.forEach { font in
            guard let fontURL = fontURL(for: font) else {
                fatalError("❌ 폰트 파일을 찾을 수 없음: \(font.rawValue)")
            }
            CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
        }
    }
}
