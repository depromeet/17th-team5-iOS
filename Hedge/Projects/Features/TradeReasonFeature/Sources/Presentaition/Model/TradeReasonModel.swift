//
//  TradeReasonModel.swift
//  TradeReasonFeatureInterface
//
//  Created by Junyoung on 10/11/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

import Core
import DesignKit
import PrinciplesFeatureInterface
import StockDomainInterface
import PrinciplesDomainInterface
import TradeReasonFeatureInterface
import AnalysisDomainInterface
import RetrospectDomainInterface
import Shared

public final class TradeReasonModel: ObservableObject, TradeReasonModelProtocol {
    @Published public var tradeType: TradeType
    @Published public var stock: StockSearch
    @Published public var tradeHistory: Core.TradeHistory
    @Published public var principles: [Principle]
    @Published public var selectedButton: FloatingButtonSelectType? = .generate
    @Published public var emotionSelection: Int = 0
    @Published public var isEmotionShow: Bool = false
    @Published public var isChecklistShow: Bool = false
    @Published public var checkedItems: Set<Int> = []
    @Published public var text: String = ""
    @Published public var contents: String? = nil
    @Published public var emotion: TradeEmotion? = nil
    @Published public var principlesView: any View = AnyView(EmptyView())
    
    weak var coordinator: TradeReasonCoordinator?
    private let principleBuilder: PrinciplesViewBuilderProtocol
    private let analysisUseCase: AnalysisUseCase
    private let generateRetrospectUseCase: GenerateRetrospectUseCase
    private var checkedItemsTmp: Set<Int> = []
    
    public init(
        tradeType: TradeType,
        stock: StockSearch,
        tradeHistory: TradeHistory,
        principles: [Principle],
        selectedPrinciples: Set<Int>,
        principleBuilder: PrinciplesViewBuilderProtocol,
        analysisUseCase: AnalysisUseCase,
        generateRetrospectUseCase: GenerateRetrospectUseCase
    ) {
        self.tradeType = tradeType
        self.stock = stock
        self.tradeHistory = tradeHistory
        self.principles = principles
        self.checkedItems = selectedPrinciples
        self.checkedItemsTmp = selectedPrinciples
        self.principleBuilder = principleBuilder
        self.analysisUseCase = analysisUseCase
        self.generateRetrospectUseCase = generateRetrospectUseCase
    }
}

extension TradeReasonModel: TradeReasonModelActionProtocol {
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
        selectedButton = nil
    }
    
    public func emotionShowTapped() {
        isEmotionShow = true
    }
    
    public func emotionSelected(for index: Int) {
        emotion = TradeEmotion(rawValue: index)
        isEmotionShow = false
        selectedButton = nil
    }
    
    public func emotionCloseTapped() {
        isEmotionShow = false
        selectedButton = nil
    }
    
    public func checklistShowTapped() {
        isChecklistShow = true
    }
    
    public func checkListApproveTapped() {
        checkedItemsTmp = checkedItems
        isChecklistShow = false
        selectedButton = nil
    }
    
    public func checklistCloseTapped() {
        checkedItems = checkedItemsTmp
        isChecklistShow = false
        selectedButton = nil
    }
    
    public func checklistTapped(for id: Int) {
        if checkedItems.contains(id) {
            checkedItems.remove(id)
        } else {
            checkedItems.insert(id)
        }
    }
}

extension TradeReasonModel {
    private func makePrincipleView() {
        principlesView = principleBuilder.buildView(
            principles: .init(
                get: {
                    self.principles
                },
                set: { principles in
                    self.principles = principles
                }
            ),
            selectedPrinciples: .init(
                get: {
                    self.checkedItems
                },
                set: { selected in
                    self.checkedItems = selected
                }
            )
        )
    }
    
    private func fetchAnalysis() async throws {
        do {
            let response = try await analysisUseCase.execute(
                market: stock.market,
                symbol: stock.symbol,
                time: tradeHistory.tradingDate.toDateTimeString()
            )
            analysisSuccess(with: response)
        } catch {
            handleError(with: error)
        }
    }
    
    private func generateRetrospection() async throws {
        let checks = principles.map { PrincipleCheck(principleId: $0.id, isFollowed: true) }
        let principleChecks = checks.filter { checkedItems.contains($0.principleId) }
        
        let request = GenerateRetrospectRequest(
            symbol: stock.symbol,
            market: stock.market,
            orderType: OrderType(rawValue: tradeType.toRequest) ?? .buy,
            price: tradeHistory.tradingPrice.extractNumbers(),
            currency: tradeHistory.concurrency,
            volume: tradeHistory.tradingQuantity.extractNumbers(),
            orderDate: tradeHistory.tradingDate.toDateString(),
            returnRate: tradeHistory.yield?.extractDecimalNumber() ?? 0,
            content: text,
            principleChecks: principleChecks,
            emotion: Emotion(rawValue: (emotion?.engValue) ?? Emotion.neutral.rawValue) ?? .neutral
        )
        
        do {
            let response = try await generateRetrospectUseCase.execute(request)
            generateSuccess(with: response)
        } catch {
            handleError(with: error)
        }
    }
    
    private func analysisSuccess(with response: String) {
        contents = text
    }
    
    private func generateSuccess(with id: Int) {
        Log.debug("\(id)")
        let checks = principles
        let principleChecks = checks.filter { checkedItems.contains($0.id) }
        
        let tradeData = TradeData(
            id: id,
            tradeType: tradeType,
            stockSymbol: stock.symbol,
            stockTitle: stock.title,
            stockMarket: stock.market,
            tradingPrice: tradeHistory.tradingPrice,
            tradingQuantity: tradeHistory.tradingQuantity,
            tradingDate: tradeHistory.tradingDate,
            emotion: emotion,
            tradePrinciple: principleChecks,
            retrospection: text
        )
        coordinator?.pushToFeedback(tradeData: tradeData)
    }
    
    private func handleError(with error: Error) {
        Log.error(error.localizedDescription)
    }
}
