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
        public var tradingPrice: String = ""
        public var tradingQuantity: String = ""
        public var tradingDate: String = ""
        public var yield: String = ""
        public var stock: StockSearch
        
        public init(stock: StockSearch) {
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
    public enum DelegateAction { }
    
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
            print(state.tradingPrice)
            print(state.tradingQuantity)
            print(state.tradingDate)
            print(state.yield)
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
        
    }
}
