//
//  Image.swift
//  DesignKit
//
//  Created by Junyoung on 9/13/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation
import SwiftUI

extension HedgeUI where Base == Image {
    public static var chevronLeftSmall: Image { asset(#function) }
    public static var chevronLeftThickSmall: Image { asset(#function) }
    public static var chevronLeftTightSmall: Image { asset(#function) }
    public static var chevronLeftTightThickSmall: Image { asset(#function) }
    public static var chevronRightSmall: Image { asset(#function) }
    public static var chevronRightThickSmall: Image { asset(#function) }
    public static var chevronRightTightSmall: Image { asset(#function) }
    public static var chevronRightTightThickSmall: Image { asset(#function) }
    public static var close: Image { asset(#function) }
    public static var closeThick: Image { asset(#function) }
    public static var search: Image { asset(#function) }
    public static var closeFill: Image { asset(#function) }
    
    // TODO: 임시 차트 이미지 추후 삭제
    public static var tmpChart: Image { asset(#function) }
}

extension HedgeUI where Base == Image {
    private static func asset(_ name: String) -> Image {
        return Image(uiImage: UIImage.hedgeUI.asset(name))
    }
}

extension HedgeUI where Base == UIImage {
    private static func asset(_ name: String) -> UIImage {
        guard let image = UIImage(named: name, in: .module, with: nil) else {
            assertionFailure("can't find image asset: \(name)")
            return UIImage()
        }
        return image
    }
}
