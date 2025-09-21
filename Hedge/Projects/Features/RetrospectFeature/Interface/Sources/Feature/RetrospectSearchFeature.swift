//
//  RetrospectFeature.swift
//  RetrospectFeature
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
public struct RetrospectSearchFeature {
    private let coordinator: RetrospectCoordinator
    
    private let fetchStockSearchUseCase = DIContainer.resolve(FetchStockSearchUseCase.self)
    
    public init(coordinator: RetrospectCoordinator) {
        self.coordinator = coordinator
    }
    
    @ObservableState
    public struct State: Equatable {
        public var searchText: String = ""
        public var stocks: [StockSearch] = []
        public init() {}
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
    }
    public enum InnerAction {
        case fetchStockSuccess([StockSearch])
        case failure(Error)
    }
    public enum AsyncAction {
        case fetchStockSearch(String)
    }
    public enum ScopeAction { }
    public enum DelegateAction { }
    
    // MARK: - Debounce ID
    private enum CancelID { case searchDebounce }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce(reducerCore)
    }
}

extension RetrospectSearchFeature {
    // MARK: - Reducer Core
    func reducerCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        switch action {
        case .binding(\.searchText):
            let text = state.searchText
            return .run { send in
                guard !text.isEmpty else { return }
                await send(.async(.fetchStockSearch(text)))
            }
            .debounce(
                id: CancelID.searchDebounce,
                for: 0.5,
                scheduler: RunLoop.main
            )
            
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
        }
    }
    
    // MARK: - Inner Core
    func innerCore(
        _ state: inout State,
        _ action: InnerAction
    ) -> Effect<Action> {
        switch action {
        case .fetchStockSuccess(let response):
            Log.debug("주식 조회 결과: \(response)")
            state.stocks = response
            return .none
            
        case .failure(let error):
            Log.error("error: \(error)")
            return .none
        }
    }
    
    // MARK: - Async Core
    func asyncCore(
        _ state: inout State,
        _ action: AsyncAction
    ) -> Effect<Action> {
        switch action {
        case .fetchStockSearch(let text):
            return .run { send in
                do {
                    let response = try await fetchStockSearchUseCase.execute(text: text)
                    await send(.inner(.fetchStockSuccess(response)))
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
        
    }
}
