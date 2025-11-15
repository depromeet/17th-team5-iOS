//
//  PrincipleDetailFeature.swift
//  PrincipleDetailFeature
//
//  Created by Auto on 1/15/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation
import SwiftUI

import ComposableArchitecture

import Core
import Shared

import PrinciplesDomainInterface

@Reducer
public struct PrincipleDetailFeature {
    private let coordinator: PrincipleDetailCoordinator
    private let createPrincipleGroupUseCase: CreatePrincipleGroupUseCase
    
    public init(
        coordinator: PrincipleDetailCoordinator,
        createPrincipleGroupUseCase: CreatePrincipleGroupUseCase
    ) {
        self.coordinator = coordinator
        self.createPrincipleGroupUseCase = createPrincipleGroupUseCase
    }
    
    @ObservableState
    public struct State: Equatable {
        public var principleGroup: PrincipleGroup
        public var isRecommended: Bool
        public var isBottomModdalShown: Bool = false
        public var selectedTradeType: TradeType? = nil
        
        public init(principleGroup: PrincipleGroup, isRecommended: Bool) {
            self.principleGroup = principleGroup
            self.isRecommended = isRecommended
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
        case addButtonTapped
        case buyButtonTapped
        case sellButtonTapped
        case selectButtonTapped
    }
    
    public enum InnerAction {
        case createPrincipleGroupSuccess
        case createPrincipleGroupFailure(Error)
    }
    
    public enum AsyncAction {
        case createPrincipleGroup(
            groupName: String,
            displayOrder: Int,
            principleType: String,
            thumbnail: String,
            principles: [(principle: String, description: String)]
        )
    }
    
    public enum ScopeAction { }
    
    public enum DelegateAction { }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce(reducerCore)
    }
}

extension PrincipleDetailFeature {
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
            
        case .addButtonTapped:
            state.isBottomModdalShown = true
            return .none
            
        case .buyButtonTapped:
            state.selectedTradeType = .buy
            return .none
            
        case .sellButtonTapped:
            state.selectedTradeType = .sell
            return .none
            
        case .selectButtonTapped:
            guard let tradeType = state.selectedTradeType else {
                return .none
            }
            
            // principleGroup의 정보와 principles를 변환
            let principles = state.principleGroup.principles.map { principle in
                (principle: principle.principle, description: principle.description)
            }
            
            let principleType = tradeType == .buy ? "BUY" : "SELL"
            
            state.isBottomModdalShown = false
            return .send(.async(.createPrincipleGroup(
                groupName: state.principleGroup.groupName,
                displayOrder: state.principleGroup.displayOrder ?? 1,
                principleType: principleType,
                thumbnail: "\(state.principleGroup.imageId ?? 0)",
                principles: principles
            )))
        }
    }
    
    // MARK: - Inner Core
    func innerCore(
        _ state: inout State,
        _ action: InnerAction
    ) -> Effect<Action> {
        switch action {
        case .createPrincipleGroupSuccess:
            coordinator.popToPrev()
            return .none
            
        case .createPrincipleGroupFailure(let error):
            // HedgeError의 상세 정보 로깅
            if let hedgeError = error as? HedgeError {
                switch hedgeError {
                case .client(let clientError):
                    Log.error("Failed to create principle group - Client Error: \(clientError)")
                case .server(let serverError):
                    Log.error("Failed to create principle group - Server Error: code=\(serverError.code), message=\(serverError.message)")
                case .unknown:
                    Log.error("Failed to create principle group - Unknown Error")
                }
            } else {
                Log.error("Failed to create principle group: \(error)")
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
        case .createPrincipleGroup(let groupName, let displayOrder, let principleType, let thumbnail, let principles):
            return .run { [createPrincipleGroupUseCase] send in
                do {
                    _ = try await createPrincipleGroupUseCase.execute(
                        groupName: groupName,
                        displayOrder: displayOrder,
                        principleType: principleType,
                        thumbnail: thumbnail,
                        principles: principles
                    )
                    await send(.inner(.createPrincipleGroupSuccess))
                } catch {
                    await send(.inner(.createPrincipleGroupFailure(error)))
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

