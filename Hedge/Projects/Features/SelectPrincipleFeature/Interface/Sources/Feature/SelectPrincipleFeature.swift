import Foundation
import ComposableArchitecture

import Core

@Reducer
public struct SelectPrincipleFeature {
    private let coordinator: SelectPrincipleCoordinator
    
    public init(coordinator: SelectPrincipleCoordinator) {
        self.coordinator = coordinator
    }
    
    @ObservableState
    public struct State: Equatable {
        public var groupId: Int
        public var groupTitle: String
        public var principles: [PrincipleItem]
        public var selectedPrincipleIds: Set<Int>
        
        public var helperText: String {
            "최대 \(principles.count)개의 원칙을 선택해 추가할 수 있어요"
        }
        
        public var isPrimaryEnabled: Bool {
            !selectedPrincipleIds.isEmpty
        }
        
        public init(
            groupId: Int = 0,
            groupTitle: String = "",
            principles: [PrincipleItem] = [],
            selectedPrincipleIds: Set<Int> = [],
        ) {
            self.groupId = groupId
            self.groupTitle = groupTitle
            self.principles = principles
            self.selectedPrincipleIds = selectedPrincipleIds
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
        case principleTapped(Int)
        case primaryButtonTapped
        case closeTapped
    }
    
    public enum InnerAction { }
    public enum AsyncAction { }
    public enum ScopeAction { }
    
    public enum DelegateAction {
        case didClose
        case didFinishSelection(Int, [String])
    }
    
    public var body: some Reducer<State, Action> {
        Reduce(reducerCore)
    }
}

extension SelectPrincipleFeature {
    // MARK: - Reducer Core
    func reducerCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        switch action {
        case .view(let viewAction):
            return viewCore(&state, viewAction)
            
        case .inner(let innerAction):
            return innerCore(&state, innerAction)
            
        case .async(let asyncAction):
            return asyncCore(&state, asyncAction)
            
        case .scope(let scopeAction):
            return scopeCore(&state, scopeAction)
            
        case .delegate(let delegateAction):
            return delegateCore(&state, delegateAction)
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
            
        case .principleTapped(let principleId):
            if state.selectedPrincipleIds.contains(principleId) {
                state.selectedPrincipleIds.remove(principleId)
            } else {
                state.selectedPrincipleIds.insert(principleId)
            }
            return .none
            
        case .primaryButtonTapped:
            guard state.isPrimaryEnabled else { return .none }
            let selectedPrinciples = state.principles
                .filter { state.selectedPrincipleIds.contains($0.id) }
                .map(\.detail)
            coordinator.finishSelectPrinciple(
                groupId: state.groupId,
                selectedPrinciples: selectedPrinciples
            )
            return .send(.delegate(.didFinishSelection(state.groupId, selectedPrinciples)))
            
        case .closeTapped:
            coordinator.dismiss()
            return .send(.delegate(.didClose))
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
        .none
    }
    
    // MARK: - Scope Core
    func scopeCore(
        _ state: inout State,
        _ action: ScopeAction
    ) -> Effect<Action> {
        .none
    }
    
    // MARK: - Delegate Core
    func delegateCore(
        _ state: inout State,
        _ action: DelegateAction
    ) -> Effect<Action> {
        .none
    }
}

// MARK: - Models
public extension SelectPrincipleFeature {
    struct PrincipleItem: Equatable, Identifiable {
        public let id: Int
        public let title: String
        public let detail: String
        
        public init(
            id: Int,
            title: String,
            detail: String
        ) {
            self.id = id
            self.title = title
            self.detail = detail
        }
    }
}
