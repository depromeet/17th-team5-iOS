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
import FeedbackDomainInterface

@Reducer
public struct TradeFeedbackFeature {
    private let coordinator: TradeFeedbackCoordinator
    private let fetchFeedbackUseCase: FetchFeedbackUseCase
    
    public init(
        coordinator: TradeFeedbackCoordinator,
        fetchFeedbackUseCase: FetchFeedbackUseCase
    ) {
        self.coordinator = coordinator
        self.fetchFeedbackUseCase = fetchFeedbackUseCase
    }
    
    @ObservableState
    public struct State: Equatable {
        public var tradeData: TradeData
        public var feedback: Feedback? = .mock()
        
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
        case fetchFeedbackSuccess(FeedbackData)
        case fetchFeedbackFailure(Error)
    }
    public enum AsyncAction {
        case fetchFeedback(Int)
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
        switch action {
        case .onAppear:
            Log.debug("\(state.tradeData)")
            return .send(.async(.fetchFeedback(state.tradeData.id)))
            
        case .backButtonTapped:
            coordinator.popToPrev()
            return .none
            
        case .nextTapped:
            return .none
        }
    }
    
    // MARK: - Inner Core
    func innerCore(
        _ state: inout State,
        _ action: InnerAction
    ) -> Effect<Action> {
        switch action {
        case .fetchFeedbackSuccess(let response):
            Log.debug("\(response)")
            return .none
            
        case .fetchFeedbackFailure(let error):
            Log.error("FetchFeedback failed: \(error)")
            if let hedgeError = error as? HedgeError {
                switch hedgeError {
                case .client(let clientError):
                    Log.error("Client error: \(clientError)")
                case .server(let serverError):
                    Log.error("Server error: \(serverError.code) - \(serverError.message)")
                case .unknown:
                    Log.error("Unknown error occurred")
                }
            }
            return .none
        }
    }
    
    // MARK: - Async Core
    func asyncCore(
        _ state: inout State,
        _ action: AsyncAction
    ) -> Effect<Action> {
        switch action {
        case .fetchFeedback(let id):
            return .run { send in
                do {
                    let response = try await fetchFeedbackUseCase.execute(id: id)
                    await send(.inner(.fetchFeedbackSuccess(response)))
                } catch {
                    await send(.inner(.fetchFeedbackFailure(error)))
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
