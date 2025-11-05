//
//  TradeType.swift
//  Core
//
//  Created by 이중엽 on 9/25/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

// MARK: - TradeType
public enum TradeType: String, CaseIterable, Equatable, Codable {
    case buy = "매수"
    case sell = "매도"
    
    public var toRequest: String {
        switch self {
        case .buy:
            "BUY"
        case .sell:
            "SELL"
        }
    }
}
