//
//  TradeReasonFeature.swift
//  TradeReasonFeatureInterface
//
//  Created by Dongjoo Lee on 9/23/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Core
import StockDomainInterface
import RetrospectDomainInterface
import PrinciplesDomainInterface
import DesignKit
import Shared
import AnalysisDomainInterface

@Reducer
public struct TradeReasonFeature {
    private let coordinator: TradeReasonCoordinator
    private let generateRetrospectUseCase: GenerateRetrospectUseCase = DIContainer.resolve(GenerateRetrospectUseCase.self)
    private let analysisUseCase: AnalysisUseCase = DIContainer.resolve(AnalysisUseCase.self)
    
    public init(
        coordinator: TradeReasonCoordinator
    ) {
        self.coordinator = coordinator
    }
    
    @ObservableState
    public struct State: Equatable {
        public var tradeType: TradeType
        public var stock: StockSearch
        public var tradeHistory: TradeHistory
        public var principles: [Principle]
        public var selectedButton: FloatingButtonSelectType? = .generate
        public var emotionSelection: Int = 0
        public var isEmotionShow: Bool = false
        public var isChecklistShow: Bool = false
        public var checkedItems: Set<Int> = []
        public var text: String = ""
        public var contents: String? = nil
        public var emotion: TradeEmotion? = nil
        internal var checkedItemsTmp: Set<Int> = []
        
        public init(tradeType: TradeType, stock: StockSearch, tradeHistory: TradeHistory, principles: [Principle], selectedPrinciples: Set<Int>) {
            self.tradeType = tradeType
            self.stock = stock
            self.tradeHistory = tradeHistory
            self.principles = principles
            self.checkedItems = selectedPrinciples
            self.checkedItemsTmp = selectedPrinciples
        }
    }
    
    public enum Action: FeatureAction, ViewAction, BindableAction {
        case binding(BindingAction<State>)
        case view(View)
        case inner(InnerAction)
        case async(AsyncAction)
        case scope(ScopeAction)
        case delegate(DelegateAction)
    }
    
    public enum View {
        case onAppear
        case backButtonTapped
        case nextTapped
    }
    
    public enum InnerAction {
        case aiGenerateCloseTapped
        case emotionSelected(Int)
        case emotionShowTapped
        case emotionCloseTapped
        case checklistShowTapped
        case checklistCloseTapped
        case checklistTapped(id: Int)
        case checkListApproveTapped
        case generateSuccess(Int)
        case generateFailure(Error)
        case analysisSuccess(String)
        case analysisFailure(Error)
    }
    public enum AsyncAction {
        case generateRetrospection
        case fetchAnalysis
    }
    public enum ScopeAction { }
    public enum DelegateAction {
        case pushToPrinciples(tradeType: TradeType, stock: StockSearch, tradeHistory: TradeHistory)
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce(reducerCore)
    }
}

extension TradeReasonFeature {
    // MARK: - Reducer Core
    func reducerCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        switch action {
        case .binding:
            return .none
            
        case .view(let action):
            return viewCore(&state, action)
            
        case .inner(let action):
            return innerCore(&state, action)
            
        case .async(let action):
            return asyncCore(&state, action)
            
        case .scope(let action):
            return scopeCore(&state, action)
            
        case .delegate(let action):
            return delegateCore(&state, action)
        }
    }
    
    // MARK: - View Core
    func viewCore(
        _ state: inout State,
        _ action: View
    ) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .send(.async(.fetchAnalysis))
            
        case .backButtonTapped:
            coordinator.popToPrev()
            return .none
            
        case .nextTapped:
            return .send(.async(.generateRetrospection))
        }
    }
    
    // MARK: - Inner Core
    func innerCore(
        _ state: inout State,
        _ action: InnerAction
    ) -> Effect<Action> {
        switch action {
        case .aiGenerateCloseTapped:
            state.selectedButton = nil
            return .none
            
        case .emotionSelected(let emotionIndex):
            state.emotion = TradeEmotion(rawValue: emotionIndex)
            state.isEmotionShow = false
            state.selectedButton = nil
            return .none
            
        case .emotionShowTapped:
            state.isEmotionShow = true
            return .none
            
        case .emotionCloseTapped:
            state.isEmotionShow = false
            state.selectedButton = nil
            return .none
            
        case .checklistShowTapped:
            state.isChecklistShow = true
            return .none
            
        case .checklistCloseTapped:
            state.checkedItems = state.checkedItemsTmp
            state.isChecklistShow = false
            state.selectedButton = nil
            return .none
            
        case .checklistTapped(let id):
            if state.checkedItems.contains(id) {
                state.checkedItems.remove(id)
            } else {
                state.checkedItems.insert(id)
            }
            return .none
            
        case .checkListApproveTapped:
            state.checkedItemsTmp = state.checkedItems
            state.isChecklistShow = false
            state.selectedButton = nil
            
            return .none
            
        case .generateSuccess(let id):
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
            coordinator.pushToFeedback(tradeData: tradeData)
            return .none
            
        case .generateFailure(let error):
            Log.error(error.localizedDescription)
            return .none
            
        case .analysisSuccess(let text):
            Log.debug("\(text)")
            state.contents = text
            return .none
            
        case .analysisFailure(let error):
            Log.error(error.localizedDescription)
            return .none
        }
    }
    
    // MARK: - Async Core
    func asyncCore(
        _ state: inout State,
        _ action: AsyncAction
    ) -> Effect<Action> {
        switch action {
        case .fetchAnalysis:
            return .run { [state] send in
                
                do {
                    let response = try await analysisUseCase.execute(
                        market: state.stock.market,
                        symbol: state.stock.symbol,
                        time: state.tradeHistory.tradingDate.toDateTimeString()
                    )
                    await send(.inner(.analysisSuccess(response)))
                } catch {
                    await send(.inner(.analysisFailure(error)))
                }
            }
            
        case .generateRetrospection:
            return .run { [state] send in
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
                    await send(.inner(.generateSuccess(response)))
                } catch {
                    await send(.inner(.generateFailure(error)))
                }
            }
        }
    }
    
    // MARK: - Scope Core
    func scopeCore(
        _ state: inout State,
        _ action: ScopeAction
    ) -> Effect<Action> {
        switch action {
            
        }
    }
    
    // MARK: - Delegate Core
    func delegateCore(
        _ state: inout State,
        _ action: DelegateAction
    ) -> Effect<Action> {
        switch action {
        case .pushToPrinciples(let tradeType, let stock, let tradeHistory):
            coordinator.pushToPrinciples(
                tradeType: tradeType,
                stock: stock,
                tradeHistory: tradeHistory
            )
            return .none
        }
    }
}
