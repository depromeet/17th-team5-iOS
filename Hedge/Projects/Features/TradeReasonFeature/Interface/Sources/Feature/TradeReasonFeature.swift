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

@Reducer
public struct TradeReasonFeature {
    private let coordinator: TradeReasonCoordinator
    private let generateRetrospectUseCase: GenerateRetrospectUseCase
    
    public init(
        coordinator: TradeReasonCoordinator,
        generateRetrospectUseCase: GenerateRetrospectUseCase
    ) {
        self.coordinator = coordinator
        self.generateRetrospectUseCase = generateRetrospectUseCase
    }
    
    @ObservableState
    public struct State: Equatable {
        public var tradeType: TradeType
        public var stock: StockSearch
        public var tradeHistory: TradeHistory
        public var selectedPrinciples: [Principle]
        public var selectedButton: FloatingButtonSelectType? = .generate
        public var emotionSelection: Int = 0
        public var isEmotionShow: Bool = false
        public var isChecklistShow: Bool = false
        public var checkedItems: Set<Int> = []
        public var text: String = ""
        
        public init(tradeType: TradeType, stock: StockSearch, tradeHistory: TradeHistory, selectedPrinciples: [Principle]) {
            self.tradeType = tradeType
            self.stock = stock
            self.tradeHistory = tradeHistory
            self.selectedPrinciples = selectedPrinciples
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
        case checklistSelected(Set<Int>)
        case generateSuccess(Int)
        case generateFailure(Error)
    }
    public enum AsyncAction {
        case generateRetrospection
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
            return .none
            
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
            // 감정 선택 완료 처리
            print("Selected emotion index: \(emotionIndex)")
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
            state.isChecklistShow = false
            state.selectedButton = nil
            return .none
            
        case .checklistSelected(let selectedItems):
            state.isChecklistShow = false
            state.selectedButton = nil
            return .none
            
        case .generateSuccess(let id):
            Log.debug("\(id)")
            let tradeData = TradeData(
                id: id,
                tradeType: state.tradeType,
                stockSymbol: state.stock.symbol,
                stockTitle: state.stock.title,
                stockMarket: state.stock.market,
                tradingPrice: state.tradeHistory.tradingPrice,
                tradingQuantity: state.tradeHistory.tradingQuantity,
                tradingDate: state.tradeHistory.tradingDate,
                tradePrinciple: state.selectedPrinciples,
                retrospection: state.text
            )
            coordinator.pushToFeedback(tradeData: tradeData)
            return .none
            
        case .generateFailure(let error):
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
        case .generateRetrospection:
            return .run { [state] send in
                print(state.text)
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
                    principleChecks: state.selectedPrinciples.map { PrincipleCheck(principleId: $0.id, isFollowed: true) },
                    emotion: .confidence
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
