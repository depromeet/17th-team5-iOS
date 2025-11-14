//
//  RetrospectionFeature.swift
//  RetrospectionFeatureInterface
//
//  Created by 이중엽 on 11/13/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation
import SwiftUI

import ComposableArchitecture

import Core
import Shared

import RetrospectionDomainInterface
import StockDomainInterface
import LinkDomainInterface

@Reducer
public struct RetrospectionFeature {
    private let coordinator: RetrospectionCoordinator
    private let fetchRetrospectionDetailUseCase: FetchRetrospectionDetailUseCase
    private let fetchLinkUseCase: FetchLinkUseCase
    
    public init(
        coordinator: RetrospectionCoordinator,
        fetchRetrospectionDetailUseCase: FetchRetrospectionDetailUseCase,
        fetchLinkUseCase: FetchLinkUseCase
    ) {
        self.coordinator = coordinator
        self.fetchRetrospectionDetailUseCase = fetchRetrospectionDetailUseCase
        self.fetchLinkUseCase = fetchLinkUseCase
    }
    
    @ObservableState
    public struct State: Equatable {
        public var retrospectionId: Int
        public var currentPageIndex: Int = 0
        
        // Stock 정보
        public var stockName: String = ""
        public var stockLogo: String?
        public var returnRate: String = ""
        
        // Trade 정보
        public var tradingPrice: String = ""
        public var tradingQuantity: String = ""
        public var tradeType: TradeType = .buy
        public var tradingDate: String = ""
        
        // Badge 정보
        public var badgeLevel: BadgeLevel = .silver
        
        // 원칙 그룹 정보
        public var principleGroupTitle: String = ""
        
        // 페이지별 원칙 정보
        public var principlePages: [PrinciplePage] = []
        
        public var totalPages: Int {
            principlePages.count
        }
        
        public init(retrospectionId: Int) {
            self.retrospectionId = retrospectionId
        }
    }
    
    public struct PrinciplePage: Equatable {
        public var principle: String
        public var evaluation: PrincipleEvaluation
        public var reason: String
        public var imageURLs: [String]
        public var links: [LinkMetadata]
        
        public init(
            principle: String = "",
            evaluation: PrincipleEvaluation = .keep,
            reason: String = "",
            imageURLs: [String] = [],
            links: [LinkMetadata] = []
        ) {
            self.principle = principle
            self.evaluation = evaluation
            self.reason = reason
            self.imageURLs = imageURLs
            self.links = links
        }
    }
    
    public enum BadgeLevel: String, Equatable {
        case emerald
        case gold
        case silver
        case bronze
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
        case deleteButtonTapped
        case pageChanged(Int)
        case aiFeedbackButtonTapped
    }
    
    public enum InnerAction {
        case fetchRetrospectionSuccess(RetrospectionDetail)
        case fetchRetrospectionFailure(Error)
        case updateLinkMetadata(pageIndex: Int, linkMetadata: LinkMetadata)
    }
    
    public enum AsyncAction {
        case fetchRetrospection(Int)
        case fetchLinkMetadata(pageIndex: Int, urlString: String)
    }
    
    public enum ScopeAction { }
    
    public enum DelegateAction { }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce(reducerCore)
    }
}

extension RetrospectionFeature {
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
            return .send(.async(.fetchRetrospection(state.retrospectionId)))
            
        case .backButtonTapped:
            coordinator.popToPrev()
            return .none
            
        case .deleteButtonTapped:
            // TODO: 삭제 로직 구현
            return .none
            
        case .pageChanged(let newIndex):
            state.currentPageIndex = newIndex
            return .none
            
        case .aiFeedbackButtonTapped:
            // TODO: AI 피드백 화면으로 이동
            return .none
        }
    }
    
    // MARK: - Inner Core
    func innerCore(
        _ state: inout State,
        _ action: InnerAction
    ) -> Effect<Action> {
        switch action {
        case .fetchRetrospectionSuccess(let detail):
            dump(detail)
            // Stock 정보 업데이트
            state.stockName = detail.companyName
            state.stockLogo = detail.companyLogo
            if let returnRate = detail.returnRate {
                let sign = returnRate >= 0 ? "+" : ""
                state.returnRate = "\(sign)\(String(format: "%.1f", returnRate))%"
            }
            
            // Trade 정보 업데이트
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let priceString = formatter.string(from: NSNumber(value: detail.price)) ?? "\(detail.price)"
            state.tradingPrice = "\(priceString)\(detail.currency == "KRW" ? "원" : "")"
            state.tradingQuantity = "\(detail.volume)주"
            state.tradeType = detail.orderType == "BUY" ? .buy : .sell
            state.tradingDate = formatDate(detail.orderDate)
            
            // Badge 정보 업데이트
            state.badgeLevel = parseBadgeLevel(detail.badge)
            
            // 원칙 그룹 정보 업데이트
            state.principleGroupTitle = detail.principleCheckGroup.groupName
            
            // 페이지별 원칙 정보 업데이트
            state.principlePages = detail.principleCheckGroup.principleChecks.enumerated().map { index, check in
                return PrinciplePage(
                    principle: check.principle,
                    evaluation: mapPrincipleStatus(check.status),
                    reason: check.reason,
                    imageURLs: check.imageUrls,
                    links: []
                )
            }
            
            // 각 페이지의 링크들을 비동기로 fetch
            var effects: [Effect<Action>] = []
            for (pageIndex, check) in detail.principleCheckGroup.principleChecks.enumerated() {
                for linkUrl in check.links {
                    effects.append(.send(.async(.fetchLinkMetadata(pageIndex: pageIndex, urlString: linkUrl))))
                }
            }
            
            return .merge(effects)
            
        case .fetchRetrospectionFailure(let error):
            Log.error("Failed to fetch retrospection: \(error)")
            return .none
            
        case .updateLinkMetadata(let pageIndex, let linkMetadata):
            guard pageIndex < state.principlePages.count else {
                return .none
            }
            var updatedPage = state.principlePages[pageIndex]
            updatedPage.links.append(linkMetadata)
            state.principlePages[pageIndex] = updatedPage
            return .none
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "yyyy년 MM월 dd일"
            formatter.locale = Locale(identifier: "ko_KR")
            return formatter.string(from: date)
        }
        
        return dateString
    }
    
    private func parseBadgeLevel(_ badge: String) -> BadgeLevel {
        // Badge 문자열을 분석하여 BadgeLevel 반환
        // 실제 구현은 badge 문자열에 따라 다를 수 있음
        if badge.contains("에메랄드") || badge.contains("emerald") {
            return .emerald
        } else if badge.contains("골드") || badge.contains("gold") {
            return .gold
        } else if badge.contains("실버") || badge.contains("silver") {
            return .silver
        } else {
            return .bronze
        }
    }
    
    private func mapPrincipleStatus(_ status: RetrospectionPrincipleStatus) -> PrincipleEvaluation {
        switch status {
        case .kept:
            return .keep
        case .neutral:
            return .normal
        case .notKept:
            return .notKeep
        }
    }
    
    // MARK: - Async Core
    func asyncCore(
        _ state: inout State,
        _ action: AsyncAction
    ) -> Effect<Action> {
        switch action {
        case .fetchRetrospection(let id):
            return .run { send in
                do {
                    let detail = try await fetchRetrospectionDetailUseCase.execute(retrospectionId: id)
                    await send(.inner(.fetchRetrospectionSuccess(detail)))
                } catch {
                    await send(.inner(.fetchRetrospectionFailure(error)))
                }
            }
            
        case .fetchLinkMetadata(let pageIndex, let urlString):
            return .run { [fetchLinkUseCase] send in
                do {
                    let metadata = try await fetchLinkUseCase.execute(urlString: urlString)
                    await send(.inner(.updateLinkMetadata(pageIndex: pageIndex, linkMetadata: metadata)))
                } catch {
                    Log.error("Failed to fetch link metadata: \(error)")
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
