//
//  PrinciplesCoordinator.swift
//  PrinciplesFeatureInterface
//
//  Created by Dongjoo Lee on 9/23/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation
import Core
import StockDomainInterface
import PrinciplesDomainInterface

public protocol PrinciplesCoordinator: Coordinator {
    func popToPrev()
    func pushToTradeReason(tradeType: TradeType, stock: StockSearch, tradingPrice: String, tradingQuantity: String, tradingDate: String, yield: String?, tradePrinciple: [Principle])
}
