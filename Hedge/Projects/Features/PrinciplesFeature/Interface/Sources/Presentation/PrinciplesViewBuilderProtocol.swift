//
//  PrinciplesViewBuilderProtocol.swift
//  PrinciplesFeature
//
//  Created by Junyoung on 10/9/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

import Core
import StockDomainInterface
import PrinciplesDomainInterface

public protocol PrinciplesViewBuilderProtocol {
    func build(
        coordinator: PrinciplesCoordinator?,
        tradeType: TradeType,
        stock: StockSearch,
        tradeHistory: TradeHistory,
        fetchPrinciplesUseCase: FetchPrinciplesUseCase
    ) -> any View
}
