//
//  TabBarFeature.swift
//  RootFeature
//
//  Created by Junyoung on 9/14/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import ComposableArchitecture

import Core
import HomeFeatureInterface

@Reducer
public struct TabBarFeature {
    private let coordinator: RootCoordinator
    
    public init(coordinator: RootCoordinator) {
        self.coordinator = coordinator
    }
    
    @ObservableState
    public struct State: Equatable {
        var homeState: HomeFeature.State?
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
    }
    public enum InnerAction { }
    public enum AsyncAction { }
    public enum ScopeAction { }
    @CasePathable
    public enum DelegateAction {
        case homeAction(HomeFeature.Action)
    }
    
    public var body: some Reducer<State, Action> {
        Reduce(reducerCore)
            .ifLet(\.homeState, action: \.delegate.homeAction) {
                HomeFeature()
            }
    }
}

extension TabBarFeature {
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
            state.homeState = HomeFeature.State()
            return .none
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
        case .homeAction(.delegate(.pushToRetrospect)):
            coordinator.pushToRetrospect()
            return .none
        default:
            return .none
        }
    }
}
