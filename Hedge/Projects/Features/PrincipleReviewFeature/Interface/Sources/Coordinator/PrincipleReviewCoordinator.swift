//
//  PrincipleReviewCoordinator.swift
//  PrincipleReviewFeatureInterface
//
//  Created by Dongjoo Lee on 9/23/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation
import Core
import StockDomainInterface
import PrinciplesDomainInterface
import FeedbackDomainInterface

public protocol PrincipleReviewCoordinator: Coordinator {
    
    func pushToTradeFeedback(tradeType: TradeType, stock: StockSearch, tradeHistory: TradeHistory, feedback: FeedbackData)
    func popToProv()
}
