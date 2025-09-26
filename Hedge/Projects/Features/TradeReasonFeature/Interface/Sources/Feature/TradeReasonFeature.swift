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

@Reducer
public struct TradeReasonFeature {
    private let coordinator: TradeReasonCoordinator
    
    public init(coordinator: TradeReasonCoordinator) {
        self.coordinator = coordinator
    }
    
    @ObservableState
    public struct State: Equatable {
        public var tradeType: TradeType
        public var stock: StockSearch
        public var tradingPrice: String
        public var tradingQuantity: String
        public var tradingDate: String
        public var yield: String
        public var reasonText: String = ""
        
        public init(tradeType: TradeType, stock: StockSearch, tradingPrice: String, tradingQuantity: String, tradingDate: String, yield: String) {
            self.tradeType = tradeType
            self.stock = stock
            self.tradingPrice = tradingPrice
            self.tradingQuantity = tradingQuantity
            self.tradingDate = tradingDate
            self.yield = yield
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
    
    public enum InnerAction { }
    public enum AsyncAction { }
    public enum ScopeAction { }
    public enum DelegateAction {
        case pushToPrinciples(tradeType: TradeType, stock: StockSearch, tradingPrice: String, tradingQuantity: String, tradingDate: String, yield: String, reasonText: String)
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
            // Go back to PrinciplesView
            return .send(.delegate(.pushToPrinciples(
                tradeType: state.tradeType,
                stock: state.stock,
                tradingPrice: state.tradingPrice,
                tradingQuantity: state.tradingQuantity,
                tradingDate: state.tradingDate,
                yield: state.yield,
                reasonText: state.reasonText
            )))
            
        case .nextTapped:
            // This should go to a final screen (summary/completion), not back to principles
            // For now, just pop back to home or show completion
            coordinator.popToPrev()
            return .none
        }
    }
    
    // MARK: - Inner Core
    func innerCore(
        _ state: inout State,
        _ action: InnerAction
    ) -> Effect<Action> {
        switch action {
            
        }
    }
    
    // MARK: - Async Core
    func asyncCore(
        _ state: inout State,
        _ action: AsyncAction
    ) -> Effect<Action> {
        switch action {
            
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
        case .pushToPrinciples(let tradeType, let stock, let tradingPrice, let tradingQuantity, let tradingDate, let yield, let reasonText):
            coordinator.pushToPrinciples(
                tradeType: tradeType,
                stock: stock,
                tradingPrice: tradingPrice,
                tradingQuantity: tradingQuantity,
                tradingDate: tradingDate,
                yield: yield,
                reasonText: reasonText
            )
            return .none
        }
    }
}
