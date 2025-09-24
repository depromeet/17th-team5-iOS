//
//  StockSearchCoordinator.swift
//  StockSearchFeature
//
//  Created by Junyoung on 9/14/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation

import Core
import StockDomainInterface

public protocol StockSearchCoordinator: Coordinator {
    func popToPrev()
    func pushToTradeHistory(tradeType: TradeType, stock: StockSearch)
}
