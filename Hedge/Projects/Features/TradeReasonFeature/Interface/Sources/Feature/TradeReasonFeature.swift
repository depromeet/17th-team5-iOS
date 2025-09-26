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
import RetrospectDomainInterface
import DesignKit
import Shared

@Reducer
public struct TradeReasonFeature {
    private let coordinator: TradeReasonCoordinator
    private let generateRetrospectUseCase: GenerateRetrospectUseCase
    
    public init(
        coordinator: TradeReasonCoordinator,
        generateRetrospectUseCase: GenerateRetrospectUseCase
    ) {
        self.coordinator = coordinator
        self.generateRetrospectUseCase = generateRetrospectUseCase
    }
    
    @ObservableState
    public struct State: Equatable {
        public var tradeType: TradeType
        public var stock: StockSearch
        public var tradingPrice: String
        public var tradingQuantity: String
        public var tradingDate: String
        public var yield: String?
        public var reasonText: String = ""
        public var selectedButton: FloatingButtonSelectType? = .generate
        public var emotionSelection: Int = 0
        public var isEmotionShow: Bool = false
        public var isChecklistShow: Bool = false
        public var checkedItems: Set<Int> = []
        
        public init(tradeType: TradeType, stock: StockSearch, tradingPrice: String, tradingQuantity: String, tradingDate: String, yield: String?) {
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
    
    public enum InnerAction {
        case aiGenerateCloseTapped
        case emotionSelected(Int)
        case emotionShowTapped
        case emotionCloseTapped
        case checklistShowTapped
        case checklistCloseTapped
        case checklistSelected(Set<Int>)
        case generateSuccess(Int)
        case generateFailure(Error)
    }
    public enum AsyncAction {
        case generateRetrospection
    }
    public enum ScopeAction { }
    public enum DelegateAction {
        case pushToPrinciples(tradeType: TradeType, stock: StockSearch, tradingPrice: String, tradingQuantity: String, tradingDate: String, yield: String?, reasonText: String)
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
            return .send(.async(.generateRetrospection))
        }
    }
    
    // MARK: - Inner Core
    func innerCore(
        _ state: inout State,
        _ action: InnerAction
    ) -> Effect<Action> {
        switch action {
        case .aiGenerateCloseTapped:
            state.selectedButton = nil
            return .none
            
        case .emotionSelected(let emotionIndex):
            // 감정 선택 완료 처리
            print("Selected emotion index: \(emotionIndex)")
            state.isEmotionShow = false
            state.selectedButton = nil
            return .none
            
        case .emotionShowTapped:
            state.isEmotionShow = true
            return .none
            
        case .emotionCloseTapped:
            state.isEmotionShow = false
            state.selectedButton = nil
            return .none
            
        case .checklistShowTapped:
            state.isChecklistShow = true
            return .none
            
        case .checklistCloseTapped:
            state.isChecklistShow = false
            state.selectedButton = nil
            return .none
            
        case .checklistSelected(let selectedItems):
            let items = [
                "주가가 오르는 흐름이면 매수, 하락 흐름이면 매도하기",
                "기업의 본질 가치보다 낮게 거래되는 주식을 찾아 장기 보유하기",
                "단기 등락에 흔들리지 말고 기업의 장기 성장성에 집중하기",
                "분산 투자 원칙을 지키고 감정적 결정을 피하기",
                "리스크를 관리하며 손절 기준을 미리 정해두기"
            ]
            let picked = selectedItems.sorted().map { items[$0] }
            state.isChecklistShow = false
            state.selectedButton = nil
            return .none
            
        case .generateSuccess(let id):
            Log.debug("\(id)")
            let tradeData = TradeData(
                id: id,
                tradeType: .sell,
                stockSymbol: "",
                stockTitle: "",
                stockMarket: "",
                tradingPrice: "",
                tradingQuantity: "",
                tradingDate: "",
                tradePrinciple: [],
                retrospection: ""
            )
            coordinator.pushToFeedback(tradeData: tradeData)
            return .none
            
        case .generateFailure(let error):
            Log.error(error.localizedDescription)
            return .none
        }
    }
    
    // MARK: - Async Core
    func asyncCore(
        _ state: inout State,
        _ action: AsyncAction
    ) -> Effect<Action> {
        switch action {
        case .generateRetrospection:
            return .run { [state] send in
                let request = GenerateRetrospectRequest(
                    symbol: state.stock.symbol,
                    market: state.stock.market,
                    orderType: OrderType(rawValue: state.tradeType.toRequest) ?? .buy,
                    price: 10000,
                    currency: "KRW",
                    volume: 10,
                    orderDate: "2025-09-13",
                    returnRate: -15.67,
                    content: state.reasonText,
                    principleChecks: [],
                    emotion: .confidence
                )
                
                do {
                    let response = try await generateRetrospectUseCase.execute(request)
                    await send(.inner(.generateSuccess(response)))
                } catch {
                    await send(.inner(.generateFailure(error)))
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
