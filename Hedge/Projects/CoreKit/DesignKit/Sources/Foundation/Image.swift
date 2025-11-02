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
    public static var anxiousSimple: Image { asset(#function) }
    public static var confidenceSimple: Image { asset(#function) }
    public static var convictionSimple: Image { asset(#function) }
    public static var impulseSimple: Image { asset(#function) }
    public static var neutralSimple: Image { asset(#function) }
    public static var principleSimple: Image { asset(#function) }
    
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
    public static var aiGenerateBackground: Image { asset(#function) }
    public static var generateIcon: Image { asset(#function) }
    public static var generateCloseIcon: Image { asset(#function) }
    public static var principle: Image { asset(#function) }
    public static var check: Image { asset(#function) }
    public static var uncheck: Image { asset(#function) }
    
    // MARK: Size 28
    public static var closeBottomSheet: Image { asset(#function) }
  
    // MARK: Size 30
    public static var error: Image { asset(#function) }
    
    // MARK: Size 32
    public static var toastWarn: Image { asset(#function) }
    public static var toastCheck: Image { asset(#function) }
    public static var slider: Image { asset(#function) }

    // MARK: Size 35
    public static var anxious: Image { asset(#function) }
    public static var anxiousOff: Image { asset(#function) }
    public static var confidence: Image { asset(#function) }
    public static var confidenceOff: Image { asset(#function) }
    public static var conviction: Image { asset(#function) }
    public static var convictionOff: Image { asset(#function) }
    public static var impulse: Image { asset(#function) }
    public static var impulseOff: Image { asset(#function) }
    public static var neutral: Image { asset(#function) }
    public static var neutralOff: Image { asset(#function) }
    
    // MARK: Size 48
    public static var anxiousOn: Image { asset(#function) }
    public static var confidenceOn: Image { asset(#function) }
    public static var convictionOn: Image { asset(#function) }
    public static var impulseOn: Image { asset(#function) }
    public static var neutralOn: Image { asset(#function) }
    
    public static var logo: Image { asset(#function) }
    
    // TODO: 임시 차트 이미지 추후 삭제
    public static var tmpChart: Image { asset(#function) }
    public static var buyDemo: Image { asset(#function) }
    public static var sellDemo: Image { asset(#function) }
    public static var plusDemo: Image { asset(#function) }
    public static var cancelDemo: Image { asset(#function) }
    public static var stockThumbnailDemo: Image { asset(#function) }
    public static var checkDemo: Image { asset(#function) }
    public static var idleDemo: Image { asset(#function) }
    public static var chartDemoBuy: Image { asset(#function) }
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

