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
public enum TradeEmotion: Int, CaseIterable, Equatable {
    case confidence
    case conviction
    case neutral
    case impulse
    case anxious
    
    public var value: String {
        switch self {
        case .confidence:
            return "자신감"
        case .conviction:
            return "확신"
        case .neutral:
            return "무념무상"
        case .impulse:
            return "충동"
        case .anxious:
            return "불안"
        }
    }
    
    public var onImage: Image {
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
    
    public var offImage: Image {
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
    
    public var normalImage: Image {
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
    
    public var simpleImage: Image {
        switch self {
        case .confidence:
            return .hedgeUI.confidenceSimple
        case .conviction:
            return .hedgeUI.convictionSimple
        case .neutral:
            return .hedgeUI.neutralSimple
        case .impulse:
            return .hedgeUI.impulseSimple
        case .anxious:
            return .hedgeUI.anxiousSimple
        }
    }
}
