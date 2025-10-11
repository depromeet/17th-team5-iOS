//
//  TradeReasonViewBuilder.swift
//  TradeReasonFeatureInterface
//
//  Created by Junyoung on 10/11/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

import Core
import TradeReasonFeatureInterface
import StockDomainInterface
import PrinciplesDomainInterface
import AnalysisDomainInterface
import RetrospectDomainInterface
import PrinciplesFeatureInterface

public struct TradeReasonViewBuilder: TradeReasonViewBuilderProtocol {
    public init() {}
    
    public func build(
        coordinator: TradeReasonCoordinator?,
        tradeType: TradeType,
        stock: StockSearch,
        tradeHistory: TradeHistory,
        principles: [Principle],
        selectedPrinciples: Set<Int>,
        principleBuilder: PrinciplesViewBuilderProtocol,
        analysisUseCase: AnalysisUseCase,
        generateRetrospectUseCase: GenerateRetrospectUseCase
    ) -> any View {
        let model = TradeReasonModel(
            tradeType: tradeType,
            stock: stock,
            tradeHistory: tradeHistory,
            principles: principles,
            selectedPrinciples: selectedPrinciples,
            principleBuilder: principleBuilder,
            analysisUseCase: analysisUseCase,
            generateRetrospectUseCase: generateRetrospectUseCase
        )
        model.coordinator = coordinator
        
        let intent = TradeReasonIntent(modelAction: model)
        
        let container = MVIContainer(
            intent: intent as TradeReasonIntentProtocol,
            model: model as TradeReasonModelProtocol,
            modelChangePublisher: model.objectWillChange
        )
        
        return TradeReasonInputView(container: container)
    }
}
