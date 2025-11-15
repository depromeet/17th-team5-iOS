import Foundation
import ComposableArchitecture

import Core
import RetrospectionDomainInterface
import UserDefaultsDomainInterface
import PrinciplesDomainInterface

@Reducer
public struct HomeFeature {
    private let fetchRetrospectionUseCase: RetrospectionUseCase
    private let fetchBadgeReportUseCase: FetchBadgeReportUseCase
    private let getUserDefaultsUseCase: GetUserDefaultsUseCase
    private let deleteUserDefaultsUseCase: DeleteUserDefaultsUseCase
    private let fetchRecommendedPrinciplesUseCase: FetchRecommendedPrinciplesUseCase
    private let fetchDefaultPrinciplesUseCase: FetchDefaultPrinciplesUseCase
    private let fetchPrinciplesUseCase: FetchPrinciplesUseCase
    
    public init(
        fetchRetrospectionUseCase: RetrospectionUseCase,
        fetchBadgeReportUseCase: FetchBadgeReportUseCase,
        getUserDefaultsUseCase: GetUserDefaultsUseCase,
        deleteUserDefaultsUseCase: DeleteUserDefaultsUseCase,
        fetchRecommendedPrinciplesUseCase: FetchRecommendedPrinciplesUseCase,
        fetchDefaultPrinciplesUseCase: FetchDefaultPrinciplesUseCase,
        fetchPrinciplesUseCase: FetchPrinciplesUseCase
    ) {
        self.fetchRetrospectionUseCase = fetchRetrospectionUseCase
        self.fetchBadgeReportUseCase = fetchBadgeReportUseCase
        self.getUserDefaultsUseCase = getUserDefaultsUseCase
        self.deleteUserDefaultsUseCase = deleteUserDefaultsUseCase
        self.fetchRecommendedPrinciplesUseCase = fetchRecommendedPrinciplesUseCase
        self.fetchDefaultPrinciplesUseCase = fetchDefaultPrinciplesUseCase
        self.fetchPrinciplesUseCase = fetchPrinciplesUseCase
    }
    
    @ObservableState
    public struct State: Equatable {
        public var retrospectionButtonActive: Bool = false
        public var selectedType: TabType = .home
        public var retrospectionCompanies: [RetrospectionCompany] = []
        public var lastRetrospectionComapnyName: String?
        public var lastRetrospectionID: Int?
        public var selectedCompanyName: String?
        public var isBadgePopupPresented: Bool = false
        public var isLoadingRetrospections: Bool = false
        public var badgeReport: RetrospectionBadgeReport?
        public var badgeTitle: String = "아직 모은 뱃지가 없어요"
        
        // 원칙 관련
        public var recommendedPrincipleGroups: [PrincipleGroup] = []
        public var systemPrincipleGroups: [PrincipleGroup] = []
        public var customPrincipleGroups: [PrincipleGroup] = []
        public var isLoadingPrinciples: Bool = false
        public var selectedTradeType: TradeType = .buy
        public var loadedPrincipleCount: Int = 0
        
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
        case retrospectStartButtonTapped(TradeType)
        case homeTabTapped
        case principleTabTapped
        case restrospectionSelectButtonTapped
        case pushToSetting
        case retrospectionButtonTapped(Int)
        
        case badgePopupTapped(Bool)
        case buyTabTapped
        case sellTabTapped
    }
    public enum InnerAction {
        case fetchRetrospectionsSuccess([RetrospectionCompany])
        case fetchRetrospectionsFailure(Error)
        case fetchBadgeReportSuccess(RetrospectionBadgeReport)
        case fetchBadgeReportFailure(Error)
        case deleteLastRetrospectionID
        case fetchRecommendedPrincipleGroupsSuccess([PrincipleGroup])
        case fetchDefaultPrincipleGroupsSuccess([PrincipleGroup])
        case fetchCustomPrincipleGroupsSuccess([PrincipleGroup])
        case fetchPrincipleGroupsFailure(Error)
    }
    public enum AsyncAction {
        case fetchRetrospections
        case fetchBadgeReport
        case fetchRecommendedPrincipleGroups
        case fetchDefaultPrincipleGroups
        case fetchCustomPrincipleGroups
    }
    public enum ScopeAction { }
    public enum DelegateAction {
        case pushToStockSearch(TradeType)
        case pushToSetting
        case pushToRetrospection(Int)
        case finish
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
            // TODO: 나중에 UseCase로 뺴기
            state.lastRetrospectionComapnyName = UserDefaults.standard.string(forKey: "companyName")
            UserDefaults.standard.removeObject(forKey: "companyName")
            state.isLoadingRetrospections = true
            state.isLoadingPrinciples = true
            state.loadedPrincipleCount = 0
            return .merge(
                .send(.async(.fetchRetrospections)),
                .send(.async(.fetchBadgeReport)),
                .send(.async(.fetchRecommendedPrincipleGroups)),
                .send(.async(.fetchDefaultPrincipleGroups)),
                .send(.async(.fetchCustomPrincipleGroups))
            )
        case .restrospectionSelectButtonTapped:
            state.retrospectionButtonActive.toggle()
            return .send(.inner(.deleteLastRetrospectionID))
        case .companyTapped(let selectedSymbol):
            state.selectedCompanyName = selectedSymbol
            updateGroupedRetrospections(for: selectedSymbol, state: &state)
            return .send(.inner(.deleteLastRetrospectionID))
        case .retrospectStartButtonTapped(let type):
            state.retrospectionButtonActive = false
            return .send(.delegate(.pushToStockSearch(type)))
        case .homeTabTapped:
            state.selectedType = .home
            return .none
        case .principleTabTapped:
            state.selectedType = .principle
            return .none
        case .buyTabTapped:
            state.selectedTradeType = .buy
            return .none
        case .sellTabTapped:
            state.selectedTradeType = .sell
            return .none
        case .badgePopupTapped(let isPresented):
            state.isBadgePopupPresented = isPresented
            return .none
        case .pushToSetting:
            return .run { send in
                await send(.delegate(.pushToSetting))
            }
        case .retrospectionButtonTapped(let id):
            return .send(.delegate(.pushToRetrospection(id)))
        }
    }
    
    // MARK: - Inner Core
    func innerCore(
        _ state: inout State,
        _ action: InnerAction
    ) -> Effect<Action> {
        switch action {
        case .deleteLastRetrospectionID:
            state.lastRetrospectionID = nil
            return .none
        case .fetchRetrospectionsSuccess(let companies):
            state.retrospectionCompanies = companies
            
            if let lastRetrospectionComapnyName = state.lastRetrospectionComapnyName {
                state.selectedCompanyName = lastRetrospectionComapnyName
            } else {
                state.selectedCompanyName = companies.first?.companyName
            }
            
            if let lastRetrospectionID: Int? = getUserDefaultsUseCase.execute(.retrospectionID) {
                state.lastRetrospectionID = lastRetrospectionID
                deleteUserDefaultsUseCase.execute(.retrospectionID)
            }
            
            if let selectedSymbol = state.selectedCompanyName {
                updateGroupedRetrospections(for: selectedSymbol, state: &state)
            }
            
            state.isLoadingRetrospections = false
            return .none
            
        case .fetchRetrospectionsFailure(let error):
            state.isLoadingRetrospections = false
            // TODO:
            UserDefaults.standard.removeObject(forKey: "accessToken")
            UserDefaults.standard.removeObject(forKey: "refreshToken")
            print("Failed to fetch retrospections: \(error)")
            return .send(.delegate(.finish))
            
        case .fetchBadgeReportSuccess(let report):
            state.badgeReport = report
            
            if report.percentage >= 60 {
                state.badgeTitle = "좋은 투자 흐름을 이어가고 있어요"
            } else if report.percentage >= 40 {
                state.badgeTitle = "판단이 안정적으로 이어지고 있어요"
            } else if report.percentage >= 20 {
                state.badgeTitle = "판단이 다소 흔들렸어요"
            } else {
                state.badgeTitle = "최근 투자에서 일관성이 낮았어요"
            }
            
            return .none
            
        case .fetchBadgeReportFailure(let error):
            // TODO:
            UserDefaults.standard.removeObject(forKey: "accessToken")
            UserDefaults.standard.removeObject(forKey: "refreshToken")
            print("Failed to fetch badge report: \(error)")
            return .none
            
        case .fetchRecommendedPrincipleGroupsSuccess(let groups):
            state.recommendedPrincipleGroups = groups
            state.loadedPrincipleCount += 1
            // 3개 모두 로드되었는지 확인 (recommended, defaults, custom)
            if state.loadedPrincipleCount >= 3 {
                state.isLoadingPrinciples = false
            }
            return .none
            
        case .fetchDefaultPrincipleGroupsSuccess(let groups):
            state.systemPrincipleGroups = groups
            state.loadedPrincipleCount += 1
            // 3개 모두 로드되었는지 확인
            if state.loadedPrincipleCount >= 3 {
                state.isLoadingPrinciples = false
            }
            return .none
            
        case .fetchCustomPrincipleGroupsSuccess(let groups):
            state.customPrincipleGroups = groups
            state.loadedPrincipleCount += 1
            // 3개 모두 로드되었는지 확인
            if state.loadedPrincipleCount >= 3 {
                state.isLoadingPrinciples = false
            }
            return .none
            
        case .fetchPrincipleGroupsFailure(let error):
            state.isLoadingPrinciples = false
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
        case .fetchRetrospections:
            return .run { send in
                do {
                    let companies = try await fetchRetrospectionUseCase.execute()
                    await send(.inner(.fetchRetrospectionsSuccess(companies)))
                } catch {
                    await send(.inner(.fetchRetrospectionsFailure(error)))
                }
            }
        case .fetchBadgeReport:
            return .run { send in
                do {
                    let report = try await fetchBadgeReportUseCase.execute()
                    await send(.inner(.fetchBadgeReportSuccess(report)))
                } catch {
                    await send(.inner(.fetchBadgeReportFailure(error)))
                }
            }
        case .fetchRecommendedPrincipleGroups:
            return .run { send in
                do {
                    let groups = try await fetchRecommendedPrinciplesUseCase.execute(nil)
                    await send(.inner(.fetchRecommendedPrincipleGroupsSuccess(groups)))
                } catch {
                    await send(.inner(.fetchPrincipleGroupsFailure(error)))
                }
            }
        case .fetchDefaultPrincipleGroups:
            return .run { send in
                do {
                    let groups = try await fetchDefaultPrinciplesUseCase.execute(nil)
                    await send(.inner(.fetchDefaultPrincipleGroupsSuccess(groups)))
                } catch {
                    await send(.inner(.fetchPrincipleGroupsFailure(error)))
                }
            }
        case .fetchCustomPrincipleGroups:
            return .run { send in
                do {
                    let groups = try await fetchPrinciplesUseCase.execute(nil)
                    await send(.inner(.fetchCustomPrincipleGroupsSuccess(groups)))
                } catch {
                    await send(.inner(.fetchPrincipleGroupsFailure(error)))
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
        case .pushToSetting:
            return .none
        case .pushToRetrospection:
            return .none
        case .finish:
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
