//
//  BadgeGrade.swift
//  TradeFeedbackFeature
//
//  Created by 이중엽 on 11/10/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation
import SwiftUI
import DesignKit

// MARK: Badge Enum:
public enum BadgeGrade: String {
    case emerald, gold, silver, bronze
}

public extension BadgeGrade {
    var image: Image {
        switch self {
        case .emerald: return Image.hedgeUI.emerald
        case .gold:    return Image.hedgeUI.gold
        case .silver:  return Image.hedgeUI.silver
        case .bronze:  return Image.hedgeUI.bronze
        }
    }
    
    var title: String {
        switch self {
        case .emerald: return "감각의 전성기"
        case .gold:    return "안정의 흐름"
        case .silver:  return "유연의 구간"
        case .bronze:  return "성찰의 시간기"
        }
    }
    
    var content: String {
        switch self {
        case .emerald: return "시장의 흐름을 넓고 깊게 이해하며, 스스로의 기준으로 움직였어"
        case .gold:    return "근거 있는 판단으로 흔들림 없이 결정했어요"
        case .silver:  return "계획과는 조금 달랐지만 상황에 맞게 판단을 잘 조정했어요"
        case .bronze:  return "기대와 다른 결과였지만, 이번 회고로 배움을 쌓고 있어요"
        }
    }
}
