//
//  TradeFeedbackFeature.swift
//  TradeFeedbackFeatureInterface
//
//  Created by 이중엽 on 9/24/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import ComposableArchitecture

import Core
import Shared

import StockDomainInterface

@Reducer
public struct TradeFeedbackFeature {
    private let coordinator: TradeFeedbackCoordinator
    
    public init(coordinator: TradeFeedbackCoordinator) {
        self.coordinator = coordinator
    }
    
    @ObservableState
    public struct State: Equatable {
        public var tradeData: TradeData
        public var feedback: Feedback? = nil
        
        public init(tradeData: TradeData) {
            self.tradeData = tradeData
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

extension TradeFeedbackFeature {
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
        return .none
    }
    
    // MARK: - Inner Core
    func innerCore(
        _ state: inout State,
        _ action: InnerAction
    ) -> Effect<Action> {
        
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
