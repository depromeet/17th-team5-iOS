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
    
    // MARK: Size 16
    public static var plus: Image { asset(#function) }
    public static var checkSimple: Image { asset(#function) }
    public static var principleSimple: Image { asset(#function) }
    
    // MARK: Size 18
    public static var feedbackWarn: Image { asset(#function) }

    // MARK: Size 19
    public static var generate: Image { asset(#function) }
    
    // MARK: Size 20
    public static var indicator: Image { asset(#function) }
    
    // MARK: Size 22
    public static var emotion: Image { asset(#function) }
    public static var checklist: Image { asset(#function) }
    
    // MARK: Size 24
    public static var closeThin: Image { asset(#function) }
    public static var closeThick: Image { asset(#function) }
    public static var search: Image { asset(#function) }
    public static var closeFillWhite: Image { asset(#function) }
    public static var trash: Image { asset(#function) }
    public static var edit: Image { asset(#function) }
    public static var arrowDown: Image { asset(#function) }
    public static var pencil: Image { asset(#function) }
    public static var copy: Image { asset(#function) }
    public static var arrowLeftThin: Image { asset(#function) }
    public static var arrowLeftThick: Image { asset(#function) }
    public static var arrowRightThin: Image { asset(#function) }
    public static var arrowRightThick: Image { asset(#function) }
    public static var principle: Image { asset(#function) }
    public static var check: Image { asset(#function) }
    public static var checkFill: Image { asset(#function) }
    public static var uncheckFill: Image { asset(#function) }
    public static var image: Image { asset(#function) }
    public static var link: Image { asset(#function) }
    public static var setting: Image { asset(#function) }
    
    // MARK: Size 28
    public static var closeBottomSheet: Image { asset(#function) }
    public static var circle: Image { asset(#function) }
    public static var cross: Image { asset(#function) }
    public static var triangle: Image { asset(#function) }

    // MARK: Size 30
    public static var error: Image { asset(#function) }
    public static var networkError: Image { asset(#function) }
    
    // MARK: Size 32
    public static var closeFill: Image { asset(#function) }
    public static var toastWarn: Image { asset(#function) }
    public static var toastCheck: Image { asset(#function) }
    public static var slider: Image { asset(#function) }
    public static var thumbnailAdd: Image { asset(#function) }
    
    // MARK: Size 40
    public static var keep: Image { asset(#function) }
    public static var keepDisabled: Image { asset(#function) }
    public static var normal: Image { asset(#function) }
    public static var normalDisabled: Image { asset(#function) }
    public static var notKeep: Image { asset(#function) }
    public static var notKeepDisabled: Image { asset(#function) }
    
    // MARK: Logo
    public static var logo: Image { asset(#function) }
    public static var kakaologo: Image { asset(#function) }
    
    // MARK: Size xlarge
    public static var emerald: Image { asset(#function) }
    public static var gold: Image { asset(#function) }
    public static var silver: Image { asset(#function) }
    public static var bronze: Image { asset(#function) }

    // TODO: 임시 차트 이미지 추후 삭제
    public static var buyDemo: Image { asset(#function) }
    public static var sellDemo: Image { asset(#function) }
    public static var plusDemo: Image { asset(#function) }
    public static var cancelDemo: Image { asset(#function) }
    public static var stockThumbnailDemo: Image { asset(#function) }
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

