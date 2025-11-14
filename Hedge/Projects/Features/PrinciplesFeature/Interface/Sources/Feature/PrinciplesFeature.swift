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
    private let fetchSystemPrinciplesUseCase: FetchSystemPrinciplesUseCase
    private let recommendedPrinciples: [String]
    private let tradeType: TradeType?
    private let stock: StockSearch?
    private let tradeHistory: TradeHistory?
    
    public init(
        coordinator: PrinciplesCoordinator,
        fetchPrinciplesUseCase: FetchPrinciplesUseCase,
        fetchSystemPrinciplesUseCase: FetchSystemPrinciplesUseCase,
        recommendedPrinciples: [String],
        tradeType: TradeType?,
        stock: StockSearch?,
        tradeHistory: TradeHistory?
    ) {
        self.coordinator = coordinator
        self.fetchPrinciplesUseCase = fetchPrinciplesUseCase
        self.fetchSystemPrinciplesUseCase = fetchSystemPrinciplesUseCase
        self.recommendedPrinciples = recommendedPrinciples
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
        case fetchCustomPrincipleGroupsSuccess([PrincipleGroup])
        case fetchSystemPrincipleGroupsSuccess([PrincipleGroup])
        case failure(Error)
    }
    
    public enum AsyncAction {
        case fetchCustomPrincipleGroups
        case fetchSystemPrincipleGroups
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
            return .merge(
                .send(.async(.fetchCustomPrincipleGroups)),
                .send(.async(.fetchSystemPrincipleGroups))
            )
            
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
            guard let tradeType, let stock, let tradeHistory else {
                return .none
            }
            
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
        case .fetchCustomPrincipleGroupsSuccess(let principleGroups):
            let filtered = principleGroups.filter { !$0.principles.isEmpty }
            state.customPrincipleGroups = filtered
            updateCombinedPrincipleGroups(&state)
            return .none
        case .fetchSystemPrincipleGroupsSuccess(let principleGroups):
            let filtered = principleGroups.filter { !$0.principles.isEmpty }
            state.systemPrincipleGroups = filtered
            updateCombinedPrincipleGroups(&state)
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
        case .fetchCustomPrincipleGroups:
            return .run { [tradeType] send in
                do {
                    let response = try await fetchPrinciplesUseCase.execute(tradeType?.toRequest)
                    await send(.inner(.fetchCustomPrincipleGroupsSuccess(response)))
                } catch {
                    await send(.inner(.failure(error)))
                }
            }
        case .fetchSystemPrincipleGroups:
            return .run { [tradeType] send in
                do {
                    let response = try await fetchSystemPrinciplesUseCase.execute(tradeType?.toRequest)
                    await send(.inner(.fetchSystemPrincipleGroupsSuccess(response)))
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

private extension PrinciplesFeature {
    func updateCombinedPrincipleGroups(_ state: inout State) {
        let combined = state.systemPrincipleGroups + state.customPrincipleGroups
        state.principleGroups = combined
        
        if let selectedId = state.selectedGroupId,
           combined.contains(where: { $0.id == selectedId }) == false {
            state.selectedGroupId = nil
        }
    }
}

