//
//  TradeHistoryFeature.swift
//  TradeHistoryFeature
//
//  Created by Junyoung on 9/14/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation

import ComposableArchitecture

import Core
import Shared

import StockDomainInterface

@Reducer
public struct TradeHistoryFeature {
    private let coordinator: TradeHistoryCoordinator
    
    public init(coordinator: TradeHistoryCoordinator) {
        self.coordinator = coordinator
    }
    
    @ObservableState
    public struct State: Equatable {
        public var tradingPrice: String
        public var tradingQuantity: String
        public var tradingDate: String
        public var yield: String
        public var selectedConcurrency: Int
        public var selectedYield: Int
        public var stock: StockSearch
        public var tradeType: TradeType
        public var isButtonActive: Bool = false
        
        public init(tradeType: TradeType, stock: StockSearch) {
            self.tradingPrice = ""
            self.tradingQuantity = ""
            self.tradingDate = ""
            self.yield = ""
            self.selectedConcurrency = 0
            self.selectedYield = 0
            self.tradeType = tradeType
            self.stock = stock
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
    }
    public enum AsyncAction {
        
    }
    public enum ScopeAction { }
    public enum DelegateAction {
        case pushToPrinciples(tradeType: TradeType, stock: StockSearch, tradingPrice: String, tradingQuantity: String, tradingDate: String, yield: String?)
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce(reducerCore)
    }
}

extension TradeHistoryFeature {
    // MARK: - Reducer Core
    func reducerCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        switch action {
        case .binding:
            updateButtonState(&state)
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
            return .send(.delegate(.pushToPrinciples(
                tradeType: state.tradeType,
                stock: state.stock,
                tradingPrice: state.tradingPrice,
                tradingQuantity: state.tradingQuantity,
                tradingDate: state.tradingDate,
                yield: state.yield
            )))
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
        return .none
    }
    
    // MARK: - Scope Core
    func scopeCore(
        _ state: inout State,
        _ action: ScopeAction
    ) -> Effect<Action> {
        
    }
    
    // MARK: - Delegate Core
    func delegateCore(
        _ state: inout State,
        _ action: DelegateAction
    ) -> Effect<Action> {
        switch action {
        case .pushToPrinciples(let tradeType, let stock, let tradingPrice, let tradingQuantity, let tradingDate, let yield):
            let concurrency = state.selectedConcurrency == 0 ? "KRW" : "USD"
            let tradeHistory = TradeHistory(tradingPrice: tradingPrice, tradingQuantity: tradingQuantity, tradingDate: tradingDate, yield: yield, concurrency: concurrency)
            
            coordinator.pushToPrinciples(
                tradeType: tradeType,
                stock: stock,
                tradeHistory: tradeHistory
            )
            return .none
        }
    }
}

private extension TradeHistoryFeature {
    func updateButtonState(_ state: inout State) {
        let priceFilled = !state.tradingPrice.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let quantityFilled = !state.tradingQuantity.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let dateFilled = isValidTradingDateFormat(state.tradingDate)
        
        state.isButtonActive = priceFilled && quantityFilled && dateFilled
    }
    
    func isValidTradingDateFormat(_ dateString: String) -> Bool {
        let trimmed = dateString.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy년 MM월 dd일"
        formatter.isLenient = false
        
        return formatter.date(from: trimmed) != nil
    }
}
