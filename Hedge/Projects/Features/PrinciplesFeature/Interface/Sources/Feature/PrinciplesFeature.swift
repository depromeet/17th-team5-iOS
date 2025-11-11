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

import StockDomainInterface
import PrinciplesDomainInterface

@Reducer
public struct PrinciplesFeature {
    private let coordinator: PrinciplesCoordinator
    private let fetchPrinciplesUseCase: FetchPrinciplesUseCase
    private let tradeType: TradeType
    private let stock: StockSearch
    private let tradeHistory: TradeHistory
    
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
    
    public enum PrincipleViewType {
        case select
        case management
    }
    
    @ObservableState
    public struct State: Equatable {
        public var principleGroups: [PrincipleGroup] = []
        public var systemPrincipleGroups: [PrincipleGroup] = []
        public var customPrincipleGroups: [PrincipleGroup] = []
        public var selectedGroupId: Int?
        public var viewType: PrincipleViewType
        public var warningText: String? = nil
        public var buttonTitle: String = ""
        
        public func isSelected(_ groupId: Int) -> Bool {
            selectedGroupId == groupId
        }
        
        public init(viewType: PrincipleViewType) {
            self.viewType = viewType
            
            switch viewType {
            case .select:
                warningText = nil
                buttonTitle = "이 원칙으로 회고하기"
            case .management:
                warningText = "한 템플릿당 최대 5개를 추가할 수 있어요"
                buttonTitle = "선택"
            }
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
        case onAppear
        case closeButtonTapped
        case groupTapped(Int)
        case confirmButtonTapped
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
        // case pushToTradeReason(PrincipleGroup)
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
            return .send(.async(.fetchPrincipleGroups))
            
        case .closeButtonTapped:
            coordinator.dismiss(animated: true)
            return .none
            
        case .groupTapped(let groupId):
            if state.isSelected(groupId) {
                state.selectedGroupId = nil
            } else {
                state.selectedGroupId = groupId
            }
            return .none
            
        case .confirmButtonTapped:
            
            coordinator.dismiss(animated: false)
            if let principleGroup = state.principleGroups.first(where: { principleGroup in
                principleGroup.id == state.selectedGroupId
            }) {
                coordinator.principleDelegate?.choosePrincipleGroup(tradeType: tradeType, stock: stock, tradeHistory: tradeHistory, group: principleGroup)
            }
            
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
            let principleGroups = principleGroups.filter { !$0.principles.isEmpty }
            
            state.principleGroups = principleGroups
            state.systemPrincipleGroups = principleGroups.filter { $0.groupType == .system }
            state.customPrincipleGroups = principleGroups.filter { $0.groupType == .custom }
            return .none
            
        case .failure(let error):
            print("Failed to fetch principle groups: \(error)")
            return .none
        }
    }
    
    // MARK: - Async Core
    func asyncCore(
        _ state: inout State,
        _ action: AsyncAction
    ) -> Effect<Action> {
        switch action {
        case .fetchPrincipleGroups:
            return .run { [tradeType] send in
                do {
                    let response = try await fetchPrinciplesUseCase.execute(tradeType.toRequest)
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
        return .none
    }
    
    // MARK: - Delegate Core
    func delegateCore(
        _ state: inout State,
        _ action: DelegateAction
    ) -> Effect<Action> {
        return .none
    }
}

