//
//  HomeFeature.swift
//  HomeFeature
//
//  Created by Dongjoo on 11/1/25.
//  Copyright © 2025 depromeet. All rights reserved.
//

import Foundation
import ComposableArchitecture

import Core
import Shared
import TradeDomainInterface

// Cancellation ID for badge dot persistence debouncing
private struct BadgeDotPersistenceID: Hashable {}

// MARK: - HomePersistenceService Protocol
/// Protocol for persisting HomeFeature data
/// Allows easy swapping of persistence implementations
public protocol HomePersistenceServiceProtocol {
    func loadTradeRecords() -> [TradeData]?
    func saveTradeRecords(_ records: [TradeData])
    func loadBadgeDots() -> Set<Int>
    func saveBadgeDots(_ dots: Set<Int>)
    func loadShowHelpBubble() -> Bool?
    func saveShowHelpBubble(_ show: Bool)
    func clearAll()
}

// MARK: - No-Op Persistence Service
/// Default no-op implementation for when persistence is not provided
/// Real implementation should be injected from Sources module
public struct NoOpPersistenceService: HomePersistenceServiceProtocol {
    public init() {}
    
    public func loadTradeRecords() -> [TradeData]? { nil }
    public func saveTradeRecords(_ records: [TradeData]) {}
    public func loadBadgeDots() -> Set<Int> { [] }
    public func saveBadgeDots(_ dots: Set<Int>) {}
    public func loadShowHelpBubble() -> Bool? { nil }
    public func saveShowHelpBubble(_ show: Bool) {}
    public func clearAll() {}
}

@Reducer
public struct HomeFeature {
    private let fetchTradeRecordsUseCase: FetchTradeRecordsUseCase
    private let persistenceService: HomePersistenceServiceProtocol
    
    /// Default initializer - uses DIContainer.resolve for UseCases (production)
    public init(persistenceService: HomePersistenceServiceProtocol = NoOpPersistenceService()) {
        // Use DIContainer.resolve for UseCases (matches StockSearchFeature pattern)
        self.fetchTradeRecordsUseCase = DIContainer.resolve(FetchTradeRecordsUseCase.self)
        self.persistenceService = persistenceService
    }
    
    /// Preview/testing initializer - allows injecting UseCases directly
    /// Use this in previews where DI container may not be initialized
    public init(
        fetchTradeRecordsUseCase: FetchTradeRecordsUseCase,
        persistenceService: HomePersistenceServiceProtocol = NoOpPersistenceService()
    ) {
        self.fetchTradeRecordsUseCase = fetchTradeRecordsUseCase
        self.persistenceService = persistenceService
    }
    
    @ObservableState
    public struct State: Equatable {
        public var isFABOpen: Bool = false
        public var showHelpBubble: Bool = true
        public var selectedTab: HomeTab = .home
        public var tradeRecords: [TradeData] = []
        public var selectedStockSymbol: String? = nil
        public var showBadgeModal: Bool = false
        // Track which record IDs have shown their badge dots (persisted across sessions)
        // Badge dot is shown only once per record, when feedback is completed
        // Loaded from persistence on app launch
        public var recordsWithBadgeDots: Set<Int> = []
        
        // Records with completed feedback (have badges)
        // Records with yield != nil are considered to have completed feedback
        public var recordsWithCompletedFeedback: Set<Int> {
            Set(tradeRecords.filter { $0.yield != nil }.map { $0.id })
        }
        
        public init() {
            // Initial data will be loaded via async action
            // Persistence will be loaded in onAppear
        }
        
        // Helper: Sort records by date (newest first), then by ID (higher = newer)
        private func sortRecordsByDateAndID(_ records: [TradeData], ascending: Bool = false) -> [TradeData] {
            return records.sorted { record1, record2 in
                let date1 = DateKit.parse(record1.tradingDate) ?? Date.distantPast
                let date2 = DateKit.parse(record2.tradingDate) ?? Date.distantPast
                if date1 != date2 {
                    return ascending ? date1 < date2 : date1 > date2
                }
                // Same date: sort by ID (higher ID = newer)
                return ascending ? record1.id < record2.id : record1.id > record2.id
            }
        }
        
        // Get unique stocks from records, sorted by latest retrospective creation time (newest first)
        public var availableStocks: [StockInfo] {
            let uniqueStocks = Dictionary(grouping: tradeRecords, by: { $0.stockSymbol })
            let stockInfos = uniqueStocks.map { symbol, records in
                // Use the record with the latest date (or max ID) for title/market
                let sortedRecords = sortRecordsByDateAndID(records, ascending: false)
                let latestRecord = sortedRecords.first ?? records.first!
                
                // Get the latest date for sorting (not ID-based)
                let latestDate = DateKit.parse(latestRecord.tradingDate) ?? Date.distantPast
                
                return StockInfo(
                    symbol: symbol,
                    title: latestRecord.stockTitle,
                    market: latestRecord.stockMarket,
                    latestRecordId: records.map { $0.id }.max() ?? 0, // Keep for backwards compat if needed
                    latestDate: latestDate // For stable date-based sorting
                )
            }
            
            // Sort by actual date (newest first), then by ID as tiebreaker
            return stockInfos.sorted { stock1, stock2 in
                if stock1.latestDate != stock2.latestDate {
                    return stock1.latestDate > stock2.latestDate
                }
                return stock1.latestRecordId > stock2.latestRecordId
            }
        }
        
        // Get filtered records by selected stock, sorted by creation time (newest first)
        // Within same date, sort by creation time (using ID as proxy)
        public var filteredRecords: [TradeData] {
            let records = selectedStockSymbol.map { symbol in
                tradeRecords.filter { $0.stockSymbol == symbol }
            } ?? tradeRecords
            
            return sortRecordsByDateAndID(records, ascending: false)
        }
        
        // Badge counts tuple for badge section
        // Calculated from tradeRecords that have completed feedback (yield != nil)
        // Returns zeros if no records have yield data (fallback)
        public var badgeCountsTuple: (emerald: Int, gold: Int, silver: Int, bronze: Int) {
            var emerald = 0, gold = 0, silver = 0, bronze = 0
            
            // Only calculate badges for records with completed feedback (yield != nil)
            // Records from list API don't have yield, so badges will be zero until detail data is available
            for record in tradeRecords where recordsWithCompletedFeedback.contains(record.id) {
                let badge = calculateBadgeForRecord(record)
                switch badge {
                case .emerald: emerald += 1
                case .gold: gold += 1
                case .silver: silver += 1
                case .bronze: bronze += 1
                }
            }
            
            return (emerald, gold, silver, bronze)
        }
        
        // Helper: Calculate badge type for a single record based on yield and principle compliance
        // Badge calculation logic (based on returnRate and principle compliance status):
        // - Emerald: High return (>20%) AND all principles kept
        // - Gold: Good return (10-20%) AND all principles kept, OR high return (>20%)
        // - Silver: Positive return (>0%) OR all principles kept
        // - Bronze: Negative return with some principles not kept
        private func calculateBadgeForRecord(_ record: TradeData) -> BadgeType {
            guard let yieldString = record.yield else {
                // No yield data - return zero (fallback)
                return .bronze
            }
            
            // Parse yield from string like "10.5%" or "-5.2%"
            let yieldValue = parseYield(yieldString)
            
            // Check principle compliance
            // Note: tradePrinciple array doesn't include status information
            // Status (KEPT/NOT_KEPT) is only in detail response's principleChecks
            // For now, assume principles exist = they're relevant (not necessarily all kept)
            // This is a simplified calculation - can be improved when we have status data
            let hasPrinciples = !record.tradePrinciple.isEmpty
            
            // Badge calculation based on yield
            // Since we don't have principle status in TradeData, we'll base it mainly on yield
            // TODO: Enhance when principle status is available in TradeData
            if yieldValue > 20.0 {
                return hasPrinciples ? .emerald : .gold
            } else if yieldValue >= 10.0 {
                return hasPrinciples ? .gold : .silver
            } else if yieldValue > 0.0 {
                return .silver
            } else {
                return .bronze
            }
        }
        
        // Helper: Parse yield string to Double (e.g., "10.5%" -> 10.5)
        private func parseYield(_ yieldString: String) -> Double {
            let cleaned = yieldString.replacingOccurrences(of: "%", with: "").trimmingCharacters(in: .whitespaces)
            return Double(cleaned) ?? 0.0
        }
        
        // Helper enum for badge types
        private enum BadgeType {
            case emerald, gold, silver, bronze
        }
        
        // Badge section message based on ratio
        public var badgeSectionMessage: String {
            let counts = badgeCountsTuple
            let total = counts.emerald + counts.gold + counts.silver + counts.bronze
            
            // Edge cases
            if total == 0 {
                return "아직 모은 뱃지가 없어요"
            }
            
            if total <= 2 {
                return "아직은 내 투자 기준을 다듬어가는 중이에요"
            }
            
            // Calculate higher-tier ratio (Hedge + Gold) / Total
            let higherTier = counts.emerald + counts.gold
            let ratio = Double(higherTier) / Double(total) * 100
            
            if ratio.isNaN || ratio.isInfinite {
                return "투자 회고를 통해 나만의 감각을 쌓아가보세요"
            }
            
            // Message based on ratio
            if ratio >= 60 {
                return "좋은 투자 흐름을 이어가고 있어요"
            } else if ratio >= 40 {
                return "판단이 안정적으로 이어지고 있어요"
            } else if ratio >= 20 {
                return "판단이 다소 흔들렸어요"
            } else {
                return "최근 투자에서 일관성이 낮았어요"
            }
        }
    }
    
    // Helper struct for stock info
    public struct StockInfo: Equatable, Identifiable {
        public let id: String
        public let symbol: String
        public let title: String
        public let market: String
        public let latestRecordId: Int // Used for sorting tiebreaker
        public let latestDate: Date // Used for stable date-based sorting
        
        public init(
            symbol: String,
            title: String,
            market: String,
            latestRecordId: Int = 0,
            latestDate: Date = Date.distantPast
        ) {
            self.id = symbol
            self.symbol = symbol
            self.title = title
            self.market = market
            self.latestRecordId = latestRecordId
            self.latestDate = latestDate
        }
    }
    
    public enum HomeTab: String, Equatable {
        case home = "홈"
        case principles = "원칙"
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
        case fabTapped
        case retrospectTapped(TradeType)
        case helpBubbleDismissed
        case tabSelected(HomeTab)
        case settingsTapped
        case stockSelected(String)
        case tradeRecordTapped(TradeData)
        case badgeDotShown(Int) // Mark badge dot as shown for a record ID
        case badgeContainerTapped
        case badgeModalDismissed
    }
    public enum InnerAction {
        case fetchTradeRecordsSuccess([TradeData])
        case fetchTradeRecordsFailure(Error)
        case loadBadgeDotsFromPersistence(Set<Int>)
        case loadShowHelpBubbleFromPersistence(Bool?)
    }
    public enum AsyncAction {
        case fetchTradeRecords
        case loadFromPersistence
        case persistTradeRecords
        case persistBadgeDots
        case persistShowHelpBubble
    }
    public enum ScopeAction { }
    public enum DelegateAction {
        case pushToStockSearch(TradeType)
        case pushToTradeFeedback(TradeData)
    }
    
    public var body: some Reducer<State, Action> {
        Reduce(reducerCore)
    }
}

extension HomeFeature {
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
            // Always load from persistence first (fast, offline support)
            // Then refresh from API in background
            // Badge counts are calculated from tradeRecords, no separate API call needed
            return .merge(
                .send(.async(.loadFromPersistence)),
                .send(.async(.fetchTradeRecords)) // Always refresh on appear
            )
            
        case .fabTapped:
            state.isFABOpen.toggle()
            return .none
            
        case .retrospectTapped(let type):
            state.isFABOpen = false
            return .send(.delegate(.pushToStockSearch(type)))
            
        case .helpBubbleDismissed:
            state.showHelpBubble = false
            return .send(.async(.persistShowHelpBubble))
            
        case .tabSelected(let tab):
            state.selectedTab = tab
            return .none
            
        case .settingsTapped:
            // Settings navigation not yet implemented
            return .none
            
        case .stockSelected(let symbol):
            state.selectedStockSymbol = symbol
            return .none
            
        case .tradeRecordTapped(let tradeData):
            // Debug: Log that trade record was tapped
            #if DEBUG
            print("📱 HomeFeature: Trade record tapped - ID: \(tradeData.id), Symbol: \(tradeData.stockSymbol)")
            #endif
            return .send(.delegate(.pushToTradeFeedback(tradeData)))
            
        case .badgeDotShown(let recordId):
            state.recordsWithBadgeDots.insert(recordId)
            // Debounce persistence to avoid flooding UserDefaults when scrolling
            // Persist after 0.5 seconds of no new badge dots appearing
            return .run { [persistenceService = persistenceService, dots = state.recordsWithBadgeDots] send in
                try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
                persistenceService.saveBadgeDots(dots)
            }
            .cancellable(id: BadgeDotPersistenceID(), cancelInFlight: true)
            
        case .badgeContainerTapped:
            state.showBadgeModal = true
            return .none
            
        case .badgeModalDismissed:
            state.showBadgeModal = false
            return .none
        }
    }
    
    // MARK: - Inner Core
    func innerCore(
        _ state: inout State,
        _ action: InnerAction
    ) -> Effect<Action> {
        switch action {
        case .fetchTradeRecordsSuccess(let records):
            state.tradeRecords = records
            // Auto-select first stock if none selected
            // Use availableStocks.first to ensure deterministic selection after computing sorted stocks
            if state.selectedStockSymbol == nil {
                state.selectedStockSymbol = state.availableStocks.first?.symbol
            }
            // Persist the fresh data to ensure offline support
            return .send(.async(.persistTradeRecords))
            
        case .fetchTradeRecordsFailure(let error):
            // Keep using cached data if available
            // Error state handling can be added in future iterations
            #if DEBUG
            print("⚠️ HomeFeature: Failed to fetch trade records: \(error)")
            #endif
            return .none
            
        case .loadBadgeDotsFromPersistence(let dots):
            state.recordsWithBadgeDots = dots
            return .none
            
        case .loadShowHelpBubbleFromPersistence(let show):
            // If nil, it's first install - keep default true
            // If false, user has dismissed it
            if let show = show {
                state.showHelpBubble = show
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
        case .fetchTradeRecords:
            return .run { [fetchTradeRecordsUseCase = fetchTradeRecordsUseCase] send in
                do {
                    let records = try await fetchTradeRecordsUseCase.execute()
                    await send(.inner(.fetchTradeRecordsSuccess(records)))
                } catch {
                    await send(.inner(.fetchTradeRecordsFailure(error)))
                }
            }
            
        case .loadFromPersistence:
            return .run { [persistenceService = persistenceService] send in
                // Load trade records from cache
                if let cachedRecords = persistenceService.loadTradeRecords() {
                    await send(.inner(.fetchTradeRecordsSuccess(cachedRecords)))
                }
                
                // Load badge dots
                let badgeDots = persistenceService.loadBadgeDots()
                await send(.inner(.loadBadgeDotsFromPersistence(badgeDots)))
                
                // Load showHelpBubble (nil means first install - should show)
                let showHelpBubble = persistenceService.loadShowHelpBubble()
                await send(.inner(.loadShowHelpBubbleFromPersistence(showHelpBubble)))
            }
            
        case .persistTradeRecords:
            return .run { [persistenceService = persistenceService, records = state.tradeRecords] send in
                persistenceService.saveTradeRecords(records)
            }
            
        case .persistBadgeDots:
            return .run { [persistenceService = persistenceService, dots = state.recordsWithBadgeDots] send in
                persistenceService.saveBadgeDots(dots)
            }
            
        case .persistShowHelpBubble:
            return .run { [persistenceService = persistenceService, show = state.showHelpBubble] send in
                persistenceService.saveShowHelpBubble(show)
            }
        }
    }
    
    // MARK: - Scope Core
    func scopeCore(
        _ state: inout State,
        _ action: ScopeAction
    ) -> Effect<Action> {
        // Scope actions are empty - no child reducers
        // This switch is exhaustive by design (ScopeAction is currently empty)
        return .none
    }
    
    // MARK: - Delegate Core
    func delegateCore(
        _ state: inout State,
        _ action: DelegateAction
    ) -> Effect<Action> {
        switch action {
        case .pushToStockSearch:
            // 여기서는 단순히 .none을 반환
            // 실제 처리는 TabBarFeature에서 담당
            return .none
            
        case .pushToTradeFeedback:
            // 여기서는 단순히 .none을 반환
            // 실제 처리는 TabBarFeature에서 담당
            return .none
        }
    }
}
