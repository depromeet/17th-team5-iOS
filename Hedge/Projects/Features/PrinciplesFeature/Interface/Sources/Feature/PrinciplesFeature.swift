//
//  PrinciplesFeature.swift
//  PrinciplesFeature
//
//  Created by 이중엽 on 11/1/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation
import ComposableArchitecture

import Core

import PrinciplesDomainInterface

@Reducer
public struct PrinciplesFeature {
    private let coordinator: PrinciplesCoordinator
    private let fetchPrinciplesUseCase: FetchPrinciplesUseCase
    
    let tradeType: TradeType
    let stock: StockSearch
    let tradeHistory: TradeHistory
    
    let principleGroups: [PrincipleGroup] = []
    
    public init(
        coordinator: PrinciplesCoordinator,
        fetchPrinciplesUseCase: FetchPrinciplesUseCase,
        tradeType: TradeType,
        stock: StockSearch,
        tradeHistory: TradeHistory
    ) {
        self.coordinator = coordinator
        self.fetchPrinciplesUseCase = fetchPrinciplesUseCase
        self.tradeType = tradeType
        self.stock = stock
        self.tradeHistory = tradeHistory
    }
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
    }
    
    public enum Action: FeatureAction, ViewAction {
        case view(View)
        case inner(InnerAction)
        case async(AsyncAction)
        case scope(ScopeAction)
        case delegate(DelegateAction)
    }
    
    public enum View {
        case onAppear
        case closeButtonTapped
    }
    
    public enum InnerAction {
        case fetchPrincipleGroupsSuccess([PrincipleGroup])
        case failure(Error)
    }
    
    public enum AsyncAction {
        case fetchPrincipleGroups
    }
    
    public enum ScopeAction { }
    
    public enum DelegateAction {
        
    }
    
    public var body: some Reducer<State, Action> {
        Reduce(reducerCore)
    }
}

extension PrinciplesFeature {
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
        case .onAppear:
            return .none
        case .closeButtonTapped:
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
        case .fetchPrincipleGroupsSuccess(let principleGroups):
            self.principleGroups = principleGroups
        case .failure(let error):
            print("error")
        }
    }
    
    // MARK: - Async Core
    func asyncCore(
        _ state: inout State,
        _ action: AsyncAction
    ) -> Effect<Action> {
        switch action {
        case .fetchPrincipleGroups:
            return .run { send in
                do {
                    let response = try await fetchPrinciplesUseCase.execute(tradeType)
                    await send(.inner(.fetchPrincipleGroupsSuccess(response)))
                } catch {
                    await send(.inner(.failure(error)))
                }
            }
        }
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
            
        }
    }
}

