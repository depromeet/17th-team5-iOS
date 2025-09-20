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
    // MARK: Size 24
    public static var closeThin: Image { asset(#function) }
    public static var closeThick: Image { asset(#function) }
    public static var search: Image { asset(#function) }
    public static var closeFill: Image { asset(#function) }
    public static var trash: Image { asset(#function) }
    public static var edit: Image { asset(#function) }
    public static var arrowDown: Image { asset(#function) }
    public static var pencil: Image { asset(#function) }
    public static var copy: Image { asset(#function) }
    public static var arrowLeftThin: Image { asset(#function) }
    public static var arrowLeftThick: Image { asset(#function) }
    public static var arrowRightThin: Image { asset(#function) }
    public static var arrowRightThick: Image { asset(#function) }
    
    public static var toastWarn: Image { asset(#function) }
    public static var toastCheck: Image { asset(#function) }

    // MARK: Size 30
    public static var error: Image { asset(#function) }
    
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
        let img = UIImage(named: name, in: .module, with: nil) ?? UIImage(named: name)
        return img ?? UIImage(systemName: "questionmark.circle")! // fallback
    }
}

