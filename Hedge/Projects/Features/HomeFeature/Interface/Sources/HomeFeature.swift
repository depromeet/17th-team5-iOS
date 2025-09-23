//
//  HomeFeature.swift
//  HomeFeature
//
//  Created by Junyoung on 9/14/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation
import ComposableArchitecture

import Core

@Reducer
public struct HomeFeature {
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public var tradeDataBuilder: TradeDataBuilder
        
        public init(tradeDataBuilder: TradeDataBuilder = TradeDataBuilder()) {
            self.tradeDataBuilder = tradeDataBuilder
        }
    }
    
    public enum Action: FeatureAction, ViewAction {
        case view(View)
        case inner(InnerAction)
        case async(AsyncAction)
        case scope(ScopeAction)
        case delegate(DelegateAction)
    }
    
    public enum View {
        case retrospectTapped(TradeType)
        case setTradeType(TradeType)
    }
    public enum InnerAction { }
    public enum AsyncAction { }
    public enum ScopeAction { }
    public enum DelegateAction {
        case pushToRetrospect(TradeDataBuilder)
    }
    
    public var body: some Reducer<State, Action> {
        Reduce(reducerCore)
    }
}

extension HomeFeature {
    // MARK: - Reducer Core
    func reducerCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        switch action {
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
        case .retrospectTapped(let type):
            return .send(.view(.setTradeType(type)))
        case .setTradeType(let type):
            do {
                state.tradeDataBuilder = state.tradeDataBuilder.setType(type)
                return .send(.delegate(.pushToRetrospect(state.tradeDataBuilder)))
            } catch {
                // 에러 처리 - 사용자에게 알림 표시 등
                return .none
            }
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
        case .pushToRetrospect(let tradeDataBuilder):
            // 여기서는 단순히 .none을 반환
            // 실제 처리는 TabBarFeature에서 담당
            return .none
        }
    }
}
