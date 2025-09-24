//
//  TradeEmotion.swift
//  Core
//
//  Created by 이중엽 on 9/25/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

// MARK: - Emotion
public enum Emotion: String, CaseIterable, Equatable {
    case confident = "자신감"
    case conviction = "확신"
    case mindfulness = "무념무상"
    case impulse = "충동"
    case anxious = "불안"
}
