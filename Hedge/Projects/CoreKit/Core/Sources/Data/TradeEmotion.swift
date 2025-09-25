//
//  TradeEmotion.swift
//  Core
//
//  Created by 이중엽 on 9/25/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

import DesignKit

// MARK: - Emotion
public enum TradeEmotion: String, CaseIterable, Equatable {
    case confidence = "자신감"
    case conviction = "확신"
    case neutral = "무념무상"
    case impulse = "충동"
    case anxious = "불안"
    
    var onImage: Image {
        switch self {
        case .confidence:
            return .hedgeUI.confidenceOn
        case .conviction:
            return .hedgeUI.convictionOn
        case .neutral:
            return .hedgeUI.neutralOn
        case .impulse:
            return .hedgeUI.impulseOn
        case .anxious:
            return .hedgeUI.anxiousOn
        }
    }
    
    var offImage: Image {
        switch self {
        case .confidence:
            return .hedgeUI.anxiousOff
        case .conviction:
            return .hedgeUI.anxiousOff
        case .neutral:
            return .hedgeUI.anxiousOff
        case .impulse:
            return .hedgeUI.anxiousOff
        case .anxious:
            return .hedgeUI.anxiousOff
        }
    }
    
    var normalImage: Image {
        switch self {
        case .confidence:
            return .hedgeUI.confidence
        case .conviction:
            return .hedgeUI.conviction
        case .neutral:
            return .hedgeUI.neutral
        case .impulse:
            return .hedgeUI.impulse
        case .anxious:
            return .hedgeUI.anxious
        }
    }
}
