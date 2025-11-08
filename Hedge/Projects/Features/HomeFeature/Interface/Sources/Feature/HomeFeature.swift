import Foundation
import ComposableArchitecture

import Core
import RetrospectionDomainInterface

@Reducer
public struct HomeFeature {
    private let fetchRetrospectionUseCase: RetrospectionUseCase
    
    public init(fetchRetrospectionUseCase: RetrospectionUseCase) {
        self.fetchRetrospectionUseCase = fetchRetrospectionUseCase
    }
    
    @ObservableState
    public struct State: Equatable {
        public var selectedType: TabType = .home
        public var retrospectionCompanies: [RetrospectionCompany] = []
        public var selectedCompanyName: String?
        public var isBadgePopupPresented: Bool = false
        
        // Company symbols만 따로 모은 프로퍼티
        public var companyNames: [String] {
            retrospectionCompanies.map { $0.companyName }
        }
        
        // 그룹화된 데이터 (Company -> Month -> Day)
        public var groupedRetrospections: [GroupedRetrospectionByCompany] = []
        
        public init() { }
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
        case companyTapped(String)
        case retrospectTapped(TradeType)
        case homeTabTapped
        case principleTabTapped
        
        case badgePopupTapped(Bool)
    }
    public enum InnerAction {
        case fetchRetrospectionsSuccess([RetrospectionCompany])
        case failure(Error)
    }
    public enum AsyncAction {
        case fetchRetrospections
    }
    public enum ScopeAction { }
    public enum DelegateAction {
        case pushToStockSearch(TradeType)
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
    
    private func updateGroupedRetrospections(for companyName: String, state: inout State) {
        let selectedCompanies = state.retrospectionCompanies.filter { $0.companyName == companyName }
        state.groupedRetrospections = state.groupRetrospections(companies: selectedCompanies)
    }
    
    // MARK: - View Core
    func viewCore(
        _ state: inout State,
        _ action: View
    ) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .send(.async(.fetchRetrospections))
        case .companyTapped(let selectedSymbol):
            state.selectedCompanyName = selectedSymbol
            updateGroupedRetrospections(for: selectedSymbol, state: &state)
            return .none
        case .retrospectTapped(let type):
            return .send(.delegate(.pushToStockSearch(type)))
        case .homeTabTapped:
            state.selectedType = .home
            return .none
        case .principleTabTapped:
            state.selectedType = .principle
            return .none
            
        case .badgePopupTapped(let isPresented):
            state.isBadgePopupPresented = isPresented
            return .none
        }
    }
    
    // MARK: - Inner Core
    func innerCore(
        _ state: inout State,
        _ action: InnerAction
    ) -> Effect<Action> {
        switch action {
        case .fetchRetrospectionsSuccess(let companies):
            state.retrospectionCompanies = companies
            state.selectedCompanyName = companies.first?.companyName
            
            if let selectedSymbol = state.selectedCompanyName {
                updateGroupedRetrospections(for: selectedSymbol, state: &state)
            }
            
            return .none
            
        case .failure(let error):
            print("Failed to fetch retrospections: \(error)")
            return .none
        }
    }
    
    // MARK: - Async Core
    func asyncCore(
        _ state: inout State,
        _ action: AsyncAction
    ) -> Effect<Action> {
        switch action {
        case .fetchRetrospections:
            return .run { send in
                do {
                    let companies = try await fetchRetrospectionUseCase.execute()
                    await send(.inner(.fetchRetrospectionsSuccess(companies)))
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
    
    // MARK: - Delegate Core
    func delegateCore(
        _ state: inout State,
        _ action: DelegateAction
    ) -> Effect<Action> {
        switch action {
        case .pushToStockSearch(let tradeType):
            // 여기서는 단순히 .none을 반환
            // 실제 처리는 TabBarFeature에서 담당
            return .none
        }
    }
}

// MARK: - State Extension for Grouping
extension HomeFeature.State {
    /// RetrospectionCompany 배열을 Company -> Month -> Day로 그룹화
    public func groupRetrospections(companies: [RetrospectionCompany]) -> [GroupedRetrospectionByCompany] {
        guard !companies.isEmpty else {
            return []
        }
        
        let calendar = Calendar.current
        let now = Date()
        let currentMonth = calendar.component(.month, from: now)
        let currentYear = calendar.component(.year, from: now)
        
        // 날짜 파싱 함수: 2025-09-26T21:19:23.353459 형식
        func parseDate(_ dateString: String) -> Date? {
            // ISO8601DateFormatter 시도 (timezone 포함된 경우)
            let iso8601Formatter = ISO8601DateFormatter()
            iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = iso8601Formatter.date(from: dateString) {
                return date
            }
            
            // 커스텀 DateFormatter: 2025-09-26T21:19:23.353459 형식 (timezone 없음)
            let customFormatter = DateFormatter()
            customFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
            customFormatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC
            customFormatter.locale = Locale(identifier: "en_US_POSIX")
            if let date = customFormatter.date(from: dateString) {
                return date
            }
            
            // 소수점 초가 없는 경우: 2025-09-26T21:19:23
            let noFractionalFormatter = DateFormatter()
            noFractionalFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            noFractionalFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            noFractionalFormatter.locale = Locale(identifier: "en_US_POSIX")
            if let date = noFractionalFormatter.date(from: dateString) {
                return date
            }
            
            return nil
        }
        
        return companies.compactMap { company in
            // retrospections가 비어있으면 건너뛰기
            guard !company.retrospections.isEmpty else {
                return nil
            }
            
            // retrospectionCreatedAt 기준으로 월별 그룹화
            let monthlyDict = Dictionary(grouping: company.retrospections) { retrospection -> String in
                guard let date = parseDate(retrospection.retrospectionCreatedAt) else {
                    print("⚠️ 날짜 파싱 실패: \(retrospection.retrospectionCreatedAt)")
                    return "unknown"
                }
                let components = calendar.dateComponents([.year, .month], from: date)
                return "\(components.year ?? 0)-\(String(format: "%02d", components.month ?? 0))"
            }
            
            // "unknown" 그룹은 제외
            let validMonthlyDict = monthlyDict.filter { $0.key != "unknown" }
            
            guard !validMonthlyDict.isEmpty else {
                return nil
            }
            
            let monthlyGroups = validMonthlyDict.compactMap { monthKey, retrospections -> MonthlyRetrospectionGroup? in
                let components = monthKey.split(separator: "-")
                guard components.count == 2,
                      let year = Int(components[0]),
                      let month = Int(components[1]) else {
                    print("⚠️ 월별 키 파싱 실패: \(monthKey)")
                    return nil
                }
                
                // 일별로 그룹화
                let dailyDict = Dictionary(grouping: retrospections) { retrospection -> String in
                    guard let date = parseDate(retrospection.retrospectionCreatedAt) else {
                        return "unknown"
                    }
                    let dayComponents = calendar.dateComponents([.year, .month, .day], from: date)
                    return "\(dayComponents.year ?? 0)-\(String(format: "%02d", dayComponents.month ?? 0))-\(String(format: "%02d", dayComponents.day ?? 0))"
                }
                
                // "unknown" 그룹은 제외
                let validDailyDict = dailyDict.filter { $0.key != "unknown" }
                
                let dailyGroups = validDailyDict.compactMap { dayKey, items -> DailyRetrospectionGroup? in
                    let dayComponents = dayKey.split(separator: "-")
                    guard dayComponents.count == 3,
                          let dayYear = Int(dayComponents[0]),
                          let dayMonth = Int(dayComponents[1]),
                          let day = Int(dayComponents[2]) else {
                        print("⚠️ 일별 키 파싱 실패: \(dayKey)")
                        return nil
                    }
                    
                    // 날짜 문자열 생성 ("9월 15일")
                    let dateString = "\(dayMonth)월 \(day)일"
                    
                    // 시간순 정렬 (최신순)
                    let sortedItems = items.sorted { r1, r2 in
                        guard let d1 = parseDate(r1.retrospectionCreatedAt),
                              let d2 = parseDate(r2.retrospectionCreatedAt) else {
                            return false
                        }
                        return d1 > d2
                    }
                    
                    return DailyRetrospectionGroup(
                        day: day,
                        month: dayMonth,
                        year: dayYear,
                        retrospections: sortedItems,
                        dateString: dateString
                    )
                }
                .sorted { d1, d2 in
                    if d1.year != d2.year { return d1.year > d2.year }
                    if d1.month != d2.month { return d1.month > d2.month }
                    return d1.day > d2.day
                }
                
                guard !dailyGroups.isEmpty else {
                    return nil
                }
                
                // 월별 타이틀 결정
                let monthTitle: String
                if year == currentYear && month == currentMonth {
                    monthTitle = "이번달 회고"
                } else if (year == currentYear && month == currentMonth - 1) || 
                          (year == currentYear - 1 && month == 12 && currentMonth == 1) {
                    monthTitle = "지난달 회고"
                } else {
                    monthTitle = "\(year)년 \(month)월"
                }
                
                return MonthlyRetrospectionGroup(
                    month: month,
                    year: year,
                    dailyGroups: dailyGroups,
                    monthTitle: monthTitle
                )
            }
            .sorted { m1, m2 in
                if m1.year != m2.year { return m1.year > m2.year }
                return m1.month > m2.month
            }
            
            guard !monthlyGroups.isEmpty else {
                return nil
            }
            
            return GroupedRetrospectionByCompany(
                symbol: company.companyName,
                monthlyGroups: monthlyGroups
            )
        }
    }
}
