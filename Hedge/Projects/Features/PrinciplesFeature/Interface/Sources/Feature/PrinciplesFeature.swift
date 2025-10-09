//
//  PrinciplesFeature.swift
//  PrinciplesFeatureInterface
//
//  Created by Dongjoo Lee on 9/23/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import ComposableArchitecture
import Core
import StockDomainInterface
import PrinciplesDomainInterface
import Shared

@Reducer
public struct PrinciplesFeature {
    private let coordinator: PrinciplesCoordinator
    
    private let fetchPrinciplesUseCase = DIContainer.resolve(FetchPrinciplesUseCase.self)
    
    public init(coordinator: PrinciplesCoordinator) {
        self.coordinator = coordinator
    }
    
    @ObservableState
    public struct State: Equatable {
        public var selectedPrinciples: Set<Int> = []
        public var tradeType: TradeType
        public var stock: StockSearch
        public var tradingPrice: String
        public var tradingQuantity: String
        public var tradingDate: String
        public var yield: String
        public var reasonText: String
        public var principles: [Principle] = []
        
        public init(tradeType: TradeType, stock: StockSearch, tradingPrice: String, tradingQuantity: String, tradingDate: String, yield: String, reasonText: String) {
            self.tradeType = tradeType
            self.stock = stock
            self.tradingPrice = tradingPrice
            self.tradingQuantity = tradingQuantity
            self.tradingDate = tradingDate
            self.yield = yield
            self.reasonText = reasonText
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
        case principleToggled(Int)
        case completeTapped
        case skipTapped
    }
    
    public enum InnerAction {
        case fetchPrinciplesSuccess([Principle])
        case failure(Error)
    }
    
    public enum AsyncAction {
        case fetchPrinciples
    }
    public enum ScopeAction { }
    public enum DelegateAction {
        case pushToTradeReason(tradeType: TradeType, stock: StockSearch, tradingPrice: String, tradingQuantity: String, tradingDate: String, yield: String, emotion: TradeEmotion, tradePrinciple: [String])
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
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
            return .run { send in
                await send(.async(.fetchPrinciples))
            }
            
        case .backButtonTapped:
            coordinator.popToPrev()
            return .none
            
        case .principleToggled(let index):
            if state.selectedPrinciples.contains(index) {
                state.selectedPrinciples.remove(index)
            } else {
                state.selectedPrinciples.insert(index)
            }
            return .none
            
        case .completeTapped:
            // Convert selected principles to strings
            let principles = [
                "주가가 오르는 흐름이면 매수, 하락 흐름이면 매도하기",
                "기업의 본질 가치보다 낮게 거래되는 주식을 찾아 장기 보유하기",
                "단기 등락에 흔들리지 말고 기업의 장기 성장성에 집중하기",
                "분산 투자 원칙을 지키고 감정적 결정을 피하기",
                "리스크를 관리하며 손절 기준을 미리 정해두기"
            ]
            let selectedPrinciples = state.selectedPrinciples.map { principles[$0] }
            
            return .send(.delegate(.pushToTradeReason(
                tradeType: state.tradeType,
                stock: state.stock,
                tradingPrice: state.tradingPrice,
                tradingQuantity: state.tradingQuantity,
                tradingDate: state.tradingDate,
                yield: state.yield,
                emotion: .neutral, // Default emotion since we're not handling emotions here
                tradePrinciple: selectedPrinciples
            )))
            
        case .skipTapped:
            return .send(.delegate(.pushToTradeReason(
                tradeType: state.tradeType,
                stock: state.stock,
                tradingPrice: state.tradingPrice,
                tradingQuantity: state.tradingQuantity,
                tradingDate: state.tradingDate,
                yield: state.yield,
                emotion: .neutral, // Default emotion
                tradePrinciple: [] // Empty array for skip
            )))
        }
    }
    
    
    // MARK: - Async Core
    func asyncCore(
        _ state: inout State,
        _ action: AsyncAction
    ) -> Effect<Action> {
        switch action {
        case .fetchPrinciples:
            return .run { send in
                do {
                    let response = try await fetchPrinciplesUseCase.execute()
                    await send(.inner(.fetchPrinciplesSuccess(response)))
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
        switch action {
            
        }
    }
    
    // MARK: - Inner Core
    func innerCore(
        _ state: inout State,
        _ action: InnerAction
    ) -> Effect<Action> {
        switch action {
        case .fetchPrinciplesSuccess(let response):
            dump(response)
            state.principles = response
            return .none
            
        case .failure(let error):
            Log.error("error: \(error)")
            return .none
        }
    }
    
    // MARK: - Delegate Core
    func delegateCore(
        _ state: inout State,
        _ action: DelegateAction
    ) -> Effect<Action> {
        switch action {
        case .pushToTradeReason(let tradeType, let stock, let tradingPrice, let tradingQuantity, let tradingDate, let yield, let emotion, let tradePrinciple):
            coordinator.pushToTradeReason(
                tradeType: tradeType,
                stock: stock,
                tradingPrice: tradingPrice,
                tradingQuantity: tradingQuantity,
                tradingDate: tradingDate,
                yield: yield,
                emotion: emotion,
                tradePrinciple: tradePrinciple
            )
            return .none
        }
    }
}
