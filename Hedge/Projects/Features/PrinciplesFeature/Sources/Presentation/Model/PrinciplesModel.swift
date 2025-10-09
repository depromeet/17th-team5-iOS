//
//  PrinciplesModel.swift
//  PrinciplesFeature
//
//  Created by Junyoung on 10/9/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Combine

import Core
import StockDomainInterface
import PrinciplesDomainInterface
import PrinciplesFeatureInterface
import Shared

public final class PrinciplesModel: ObservableObject, PrinciplesModelProtocol {
    weak var coordinator: PrinciplesCoordinator?
    private let fetchPrinciplesUseCase: FetchPrinciplesUseCase
    
    @Published public var selectedPrinciples: Set<Int> = []
    @Published public var tradeType: TradeType
    @Published public var stock: StockSearch
    @Published public var tradeHistory: TradeHistory
    @Published public var principles: [Principle] = []
    
    public init(
        tradeType: TradeType,
        stock: StockSearch,
        tradeHistory: TradeHistory,
        fetchPrinciplesUseCase: FetchPrinciplesUseCase
    ) {
        self.tradeType = tradeType
        self.stock = stock
        self.tradeHistory = tradeHistory
        self.fetchPrinciplesUseCase = fetchPrinciplesUseCase
    }
}

extension PrinciplesModel: PrinciplesModelActionProtocol {
    public func onAppear() async throws {
        try await fetchPrinciples()
    }
    
    public func backButtonTapped() {
        coordinator?.popToPrev()
    }
    
    public func principleToggled(index: Int) {
        if selectedPrinciples.contains(index) {
            selectedPrinciples.remove(index)
        } else {
            selectedPrinciples.insert(index)
        }
    }
    
    public func completeTapped() {
        moveToReason()
    }
    
    public func skipTapped() {
        moveToReason()
    }
}

extension PrinciplesModel {
    private func fetchPrinciples() async throws {
        do {
            let response = try await fetchPrinciplesUseCase.execute()
            fetchPrinciplesSuccess(to: response)
        } catch {
            fetchPrinciplesFailure(to: error)
        }
    }
    
    private func fetchPrinciplesSuccess(to response: [Principle]) {
        principles = response
    }
    
    private func fetchPrinciplesFailure(to error: Error) {
        Log.error("error: \(error)")
    }
    
    private func moveToReason() {
        coordinator?.pushToTradeReason(
            tradeType: tradeType,
            stock: stock,
            tradeHistory: tradeHistory,
            tradePrinciple: principles,
            selectedPrinciples: selectedPrinciples
        )
    }
}
