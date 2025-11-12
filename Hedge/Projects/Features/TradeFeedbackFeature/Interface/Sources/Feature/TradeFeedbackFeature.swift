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
    
    public init(
        coordinator: TradeFeedbackCoordinator
    ) {
        self.coordinator = coordinator
    }
    
    @ObservableState
    public struct State: Equatable {
        public var tradeType: TradeType
        public var stock: StockSearch
        public var tradeHistory: TradeHistory
        public var feedback: FeedbackData
        public var badgeGrade: BadgeGrade
        
        public init(tradeType: TradeType, stock: StockSearch, tradeHistory: TradeHistory, feedback: FeedbackData) {
            self.tradeType = tradeType
            self.stock = stock
            self.tradeHistory = tradeHistory
            self.feedback = feedback
            self.badgeGrade = BadgeGrade(rawValue: feedback.badge) ?? .bronze
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
        case completeButtonTapped
    }
    public enum InnerAction {
        case fetchFeedbackSuccess(FeedbackData)
        case fetchFeedbackFailure(Error)
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
        switch action {
        case .onAppear:
            return .none
        case .backButtonTapped:
            coordinator.popToPrev()
            return .none
        case .nextTapped:
            return .none
        case .completeButtonTapped:
            //companyName: state.stock.companyName
            UserDefaults.standard.set(state.stock.companyName, forKey: "companyName")
            coordinator.popToHome()
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
            state.feedback = FeedbackData(
                symbol: response.symbol,
                price: response.price,
                volume: response.volume,
                orderType: response.orderType,
                keptCount: response.keptCount,
                neutralCount: response.neutralCount,
                notKeptCount: response.notKeptCount,
                badge: response.badge,
                keep: response.keep,
                fix: response.fix,
                next: response.next
            )
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
