//
//  TradeReasonViewBuilderProtocol.swift
//  TradeReasonFeatureInterface
//
//  Created by Junyoung on 10/11/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

import Core
import StockDomainInterface
import PrinciplesDomainInterface
import AnalysisDomainInterface
import RetrospectDomainInterface
import PrinciplesFeatureInterface

public protocol TradeReasonViewBuilderProtocol {
    func build(
        coordinator: TradeReasonCoordinator?,
        tradeType: TradeType,
        stock: StockSearch,
        tradeHistory: TradeHistory,
        principles: [Principle],
        selectedPrinciples: Set<Int>,
        principleBuilder: PrinciplesViewBuilderProtocol,
        analysisUseCase: AnalysisUseCase,
        generateRetrospectUseCase: GenerateRetrospectUseCase,
    ) -> any View
}
