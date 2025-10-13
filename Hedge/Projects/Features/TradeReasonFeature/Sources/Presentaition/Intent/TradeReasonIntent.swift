//
//  TradeReasonIntent.swift
//  TradeReasonFeatureInterface
//
//  Created by Junyoung on 10/11/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Core
import DesignKit
import PrinciplesFeatureInterface
import StockDomainInterface
import PrinciplesDomainInterface
import TradeReasonFeatureInterface
import AnalysisDomainInterface
import RetrospectDomainInterface
import Shared

public struct TradeReasonIntent: TradeReasonIntentProtocol {
    private weak var modelAction: TradeReasonModelActionProtocol?
    private var state: TradeReasonModelProtocol
    weak var coordinator: TradeReasonCoordinator?
    
    private let analysisUseCase: AnalysisUseCase
    private let generateRetrospectUseCase: GenerateRetrospectUseCase
    
    init(
        state: TradeReasonModelProtocol,
        modelAction: TradeReasonModelActionProtocol,
        analysisUseCase: AnalysisUseCase,
        generateRetrospectUseCase: GenerateRetrospectUseCase
    ) {
        self.state = state
        self.modelAction = modelAction
        self.analysisUseCase = analysisUseCase
        self.generateRetrospectUseCase = generateRetrospectUseCase
    }
    
    public func onAppear() {
        Task {
            try await fetchAnalysis()
        }
    }
    
    public func backButtonTapped() {
        coordinator?.popToPrev()
    }
    
    public func nextTapped() {
        Task {
            try await generateRetrospection()
        }
    }
    
    public func aiGenerateCloseTapped() {
        modelAction?.dismissAIGenerate()
    }
    
    public func emotionShowTapped() {
        modelAction?.presentEmotion()
    }
    
    public func emotionSelected(for index: Int) {
        modelAction?.selectEmotion(for: index)
    }
    
    public func emotionCloseTapped() {
        modelAction?.dismissEmotion()
    }
    
    public func checklistShowTapped() {
        modelAction?.presentChecklist()
    }
    
    public func checkListApproveTapped() {
        modelAction?.confirmCheckList()
    }
    
    public func checklistCloseTapped() {
        modelAction?.dismissChecklist()
    }
    
    public func checklistTapped(for id: Int) {
        modelAction?.selectChecklist(for: id)
    }
}

extension TradeReasonIntent {
    private func fetchAnalysis() async throws {
        do {
            let response = try await analysisUseCase.execute(
                market: state.stock.market,
                symbol: state.stock.symbol,
                time: state.tradeHistory.tradingDate.toDateTimeString()
            )
            analysisSuccess(with: response)
        } catch {
            handleError(with: error)
        }
    }
    
    private func generateRetrospection() async throws {
        let checks = state.principles.map { PrincipleCheck(principleId: $0.id, isFollowed: true) }
        let principleChecks = checks.filter { state.checkedItems.contains($0.principleId) }
        
        let request = GenerateRetrospectRequest(
            symbol: state.stock.symbol,
            market: state.stock.market,
            orderType: OrderType(rawValue: state.tradeType.toRequest) ?? .buy,
            price: state.tradeHistory.tradingPrice.extractNumbers(),
            currency: state.tradeHistory.concurrency,
            volume: state.tradeHistory.tradingQuantity.extractNumbers(),
            orderDate: state.tradeHistory.tradingDate.toDateString(),
            returnRate: state.tradeHistory.yield?.extractDecimalNumber() ?? 0,
            content: state.text,
            principleChecks: principleChecks,
            emotion: Emotion(rawValue: (state.emotion?.engValue) ?? Emotion.neutral.rawValue) ?? .neutral
        )
        
        do {
            let response = try await generateRetrospectUseCase.execute(request)
            generateSuccess(with: response)
        } catch {
            handleError(with: error)
        }
    }
    
    private func analysisSuccess(with response: String) {
        modelAction?.fetchAnalysisContent(with: response)
    }
    
    private func generateSuccess(with id: Int) {
        Log.debug("\(id)")
        let checks = state.principles
        let principleChecks = checks.filter { state.checkedItems.contains($0.id) }
        
        let tradeData = TradeData(
            id: id,
            tradeType: state.tradeType,
            stockSymbol: state.stock.symbol,
            stockTitle: state.stock.title,
            stockMarket: state.stock.market,
            tradingPrice: state.tradeHistory.tradingPrice,
            tradingQuantity: state.tradeHistory.tradingQuantity,
            tradingDate: state.tradeHistory.tradingDate,
            emotion: state.emotion,
            tradePrinciple: principleChecks,
            retrospection: state.text
        )
        coordinator?.pushToFeedback(tradeData: tradeData)
    }
    
    private func handleError(with error: Error) {
        Log.error(error.localizedDescription)
    }
}
