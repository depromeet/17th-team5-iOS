//
//  PrinciplesViewBuilder.swift
//  PrinciplesFeature
//
//  Created by Junyoung on 10/9/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

import Core
import PrinciplesFeatureInterface
import StockDomainInterface
import PrinciplesDomainInterface

public struct PrinciplesViewBuilder: PrinciplesViewBuilderProtocol {
    public init() {}
    
    public func buildContainer(
        coordinator: PrinciplesCoordinator?,
        tradeType: TradeType,
        stock: StockSearch,
        tradeHistory: TradeHistory,
        fetchPrinciplesUseCase: FetchPrinciplesUseCase
    ) -> any View {
        let model = PrinciplesModel(
            tradeType: tradeType,
            stock: stock,
            tradeHistory: tradeHistory,
            fetchPrinciplesUseCase: fetchPrinciplesUseCase
        )
        model.coordinator = coordinator
        
        let intent = PrinciplesIntent(modelAction: model)
        
        let container = MVIContainer(
            intent: intent as PrinciplesIntentProtocol,
            model: model as PrinciplesModelProtocol,
            modelChangePublisher: model.objectWillChange
        )
        
        return PrinciplesContainerView(container: container)
    }
    
    public func buildView(
        principles: Binding<[Principle]>,
        selectedPrinciples: Binding<Set<Int>>
    ) -> any View {
        PrinciplesView(
            selectedPrinciples: selectedPrinciples,
            principles: principles
        )
    }
}
