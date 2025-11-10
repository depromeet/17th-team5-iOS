import SwiftUI

import DesignKit
import HomeFeatureInterface
import RetrospectionDomainInterface

import ComposableArchitecture

@ViewAction(for: HomeFeature.self)
public struct HomeView: View {
    
    @State var isActive: Bool = false
    @State private var rotationAngle: Double = 0
    @State private var showCompanyTopGradient: Bool = false
    
    public var store: StoreOf<HomeFeature>
    
    public init(store: StoreOf<HomeFeature>) {
        self.store = store
    }
    
    public var body: some View {
        
        ZStack {
            Color.hedgeUI.backgroundWhite
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                topNavigationBar
                tabArea
                badgeArea
                retrospectArea
                
                Spacer()
            }
            
            startArea
            
            if store.state.isBadgePopupPresented {
                Color.init(hex: "#242424")
                    .opacity(0.5)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            _ = send(.badgePopupTapped(false))
                        }
                    }
                
                badgePopup
                    .padding(.horizontal, 20)
                    .transition(.scale(scale: 0.95).combined(with: .opacity))
            }
        }
        .onAppear {
            send(.onAppear)
        }
        .animation(.easeInOut(duration: 0.2), value: store.state.isBadgePopupPresented)
    }
}

extension HomeView {
    private var topNavigationBar: some View {
        HStack(spacing: 0) {
            Spacer()
            
            Image.hedgeUI.setting
                .renderingMode(.template)
                .foregroundStyle(Color.hedgeUI.textAssistive)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 11)
        .onTapGesture {
            send(.pushToSetting)
        }
    }
    
    private var tabArea: some View {
        HStack(spacing: 16) {
            Button {
                send(.homeTabTapped)
            } label: {
                Text("홈")
                    .font(FontModel.h1Semibold)
                    .foregroundStyle(store.state.selectedType == .home ? Color.hedgeUI.textTitle : Color.hedgeUI.textAssistive)
            }
            
            Button {
                send(.principleTabTapped)
            } label: {
                Text("원칙")
                    .font(FontModel.h1Semibold)
                    .foregroundStyle(store.state.selectedType == .principle ? Color.hedgeUI.textTitle : Color.hedgeUI.textAssistive)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    private var badgeArea: some View {
        let report = store.state.badgeReport
        let hasBadges = (report?.hedge ?? 0) > 0 ||
        (report?.gold ?? 0) > 0 ||
        (report?.silver ?? 0) > 0 ||
        (report?.bronze ?? 0) > 0
        
        return RoundedRectangle(cornerRadius: 22)
            .fill(Color.hedgeUI.backgroundWhite)
            .overlay {
                ZStack {
                    Capsule()
                        .fill(
                            RadialGradient(
                                colors: [Color.hedgeUI.shadowGreen.opacity(0.16 / 0.7),
                                         Color.clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: 137.5
                            )
                        )
                        .frame(width: 355, height: 274)
                        .opacity(0.7)
                        .blur(radius: 84.6)
                        .offset(x: -124, y: -117)
                        .allowsHitTesting(false)
                    
                    Capsule()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.hedgeUI.shadowBlue.opacity(0.24 / 0.7), Color.clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: 137.5
                            )
                        )
                        .frame(width: 355, height: 274)
                        .opacity(0.7)
                        .blur(radius: 84.6)
                        .offset(x: 90, y: -117)
                        .allowsHitTesting(false)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 22))
            .overlay(content: {
                VStack(spacing: 0) {
                    HStack {
                        
                        Text("아직 모은 뱃지가 없어요")
                            .font(.body2Semibold)
                            .foregroundStyle(Color.hedgeUI.textPrimary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    HStack(alignment: .center) {
                        badge(image: HedgeUI.emerald, count: report?.hedge ?? 0)
                        
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 2)
                            .frame(width: 1)
                            .foregroundStyle(Color.hedgeUI.neutralBgSecondary)
                            .padding(.vertical, 6)
                        
                        Spacer()
                        
                        badge(image: HedgeUI.gold, count: report?.gold ?? 0)
                        
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 2)
                            .frame(width: 1)
                            .foregroundStyle(Color.hedgeUI.neutralBgSecondary)
                            .padding(.vertical, 6)
                        
                        Spacer()
                        
                        badge(image: HedgeUI.silver, count: report?.silver ?? 0)
                        
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 2)
                            .frame(width: 1)
                            .foregroundStyle(Color.hedgeUI.neutralBgSecondary)
                            .padding(.vertical, 6)
                        
                        Spacer()
                        
                        badge(image: HedgeUI.bronze, count: report?.bronze ?? 0)
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 32)
                    
                    Spacer()
                }
            })
            .shadow(
                color: Color.black.opacity(0.08),
                radius: 20,
                x: 0,
                y: 6
            )
            .frame(height: 148)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    _ = send(.badgePopupTapped(true))
                }
            }
    }
    
    private var retrospectArea: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("회고기록")
                .font(FontModel.h2Semibold)
                .foregroundStyle(Color.hedgeUI.textTitle)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            
            if store.state.groupedRetrospections.isEmpty {
                Text("회고 기록이 없습니다")
                    .font(FontModel.body3Regular)
                    .foregroundStyle(Color.hedgeUI.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
            } else {
                HStack(spacing: 2) {
                    // 주식 종목 리스트 (왼쪽)
                    ScrollView {
                        GeometryReader { proxy in
                            Color.clear
                                .preference(
                                    key: ScrollOffsetPreferenceKey.self,
                                    value: proxy.frame(in: .named("CompanyScroll")).minY
                                )
                        }
                        .frame(height: 0)
                        
                        VStack(alignment: .center, spacing: 12) {
                            ForEach(store.state.companyNames, id: \.self) { symbol in
                                let isSelected = store.state.selectedCompanyName == symbol
                                
                                HStack(spacing: 8) {
                                    Image.hedgeUI.stockThumbnailDemo
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                    
                                    Text(symbol)
                                        .font(FontModel.body3Medium)
                                        .foregroundStyle(
                                            isSelected ? Color.hedgeUI.brandPrimary : Color.hedgeUI.textSecondary
                                        )
                                        .lineLimit(2)
                                        .truncationMode(.tail)
                                }
                                .frame(width: 98, alignment: .leading)
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(isSelected ? Color.hedgeUI.neutralBgSecondary : .clear)
                                )
                                .onTapGesture {
                                    send(.companyTapped(symbol))
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                    }
                    .scrollIndicators(.hidden)
                    .coordinateSpace(name: "CompanyScroll")
                    .overlay(alignment: .top) {
                        if showCompanyTopGradient {
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: Color.white.opacity(1.0), location: 0.0),
                                    .init(color: Color.white.opacity(0.0), location: 0.85),
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(width: 134, height: 70)
                            .allowsHitTesting(false)
                        }
                    }
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        showCompanyTopGradient = value < -1
                    }
                    .frame(width: 134, alignment: .leading)
                    
                    // 회고 리스트 (오른쪽) - 월별 -> 일별 -> 개별 항목
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 0) {
                                // 최상단 앵커 뷰
                                Color.clear
                                    .frame(height: 0)
                                    .id("scrollTop")
                                
                                ForEach(store.state.groupedRetrospections) { companyGroup in
                                    ForEach(Array(companyGroup.monthlyGroups.enumerated()), id: \.element.id) { monthIndex, monthlyGroup in
                                        
                                        // 월별 헤더 ("이번달 회고", "지난달 회고" 등)
                                        Text(monthlyGroup.monthTitle)
                                            .font(FontModel.body1Semibold)
                                            .foregroundStyle(Color.hedgeUI.textTitle)
                                            .padding(.trailing, 15)
                                            .padding(.bottom, 12)
                                        
                                        // 월별 섹션 구분선
                                        Rectangle()
                                            .fill(Color.hedgeUI.neutralBgSecondary)
                                            .frame(height: 1)
                                            .padding(.bottom, 16)
                                        
                                        // 일별 그룹
                                        ForEach(monthlyGroup.dailyGroups) { dailyGroup in
                                            Text(dailyGroup.dateString)
                                                .font(FontModel.label1Regular)
                                                .foregroundStyle(Color.hedgeUI.textPrimary)
                                                .padding(.bottom, 8)
                                            
                                            // 개별 회고 항목
                                            LazyVStack(alignment: .leading, spacing: 20) {
                                                ForEach(dailyGroup.retrospections, id: \.id) { retrospection in
                                                    retrospectItemView(retrospection: retrospection)
                                                }
                                            }
                                            HedgeSpacer(height: 28)
                                        }
                                        HedgeSpacer(height: 16)
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .scrollIndicators(.hidden)
                        .padding(.top, 10)
                        .onChange(of: store.state.selectedCompanyName) { oldValue, newValue in
                            // selectedCompanySymbol이 변경되면 최상단으로 스크롤
                            withAnimation {
                                proxy.scrollTo("scrollTop", anchor: .top)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func retrospectItemView(retrospection: Retrospection) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // 금액 • 주수
            Text("\(formatPrice(retrospection.price))원 • \(retrospection.volume)주")
                .font(FontModel.h2Semibold)
                .foregroundStyle(Color.hedgeUI.textTitle)
            
            // 매수/매도 + 날짜
            HStack(spacing: 5) {
                Text(retrospection.orderType == "BUY" ? "매수" : "매도")
                    .font(FontModel.label2Medium)
                    .foregroundStyle(
                        retrospection.orderType == "BUY"
                        ? Color.hedgeUI.tradeBuy
                        : Color.hedgeUI.tradeSell
                    )
                
                Text(formatOrderDate(retrospection.orderCreatedAt))
                    .font(FontModel.label2Regular)
                    .foregroundStyle(Color.hedgeUI.textAlternative)
            }
            .padding(.top, 2)
        }
    }
    
    private func formatPrice(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: price)) ?? "\(price)"
    }
    
    private func formatOrderDate(_ dateString: String) -> String {
        // orderCreatedAt은 "2025-11-06" 형식
        let components = dateString.split(separator: "-")
        if components.count == 3 {
            return "\(components[0]).\(components[1]).\(components[2])"
        }
        return dateString
    }
    
    private var startArea: some View {
        ZStack {
            if isActive {
                (Color.init(hex: "#242424") ?? Color.clear)
                    .opacity(0.5)
                    .ignoresSafeArea()
            }
            
            VStack(spacing: 0) {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    VStack(spacing: 0) {
                        Button {
                            send(.retrospectTapped(.buy))
                        } label: {
                            Text("매수 회고하기".colorText(target: "매수", color: Color.hedgeUI.tradeBuy))
                                .font(FontModel.body2Semibold)
                        }
                        .padding(.top, 16)
                        .padding(.bottom, 12)
                        .padding(.horizontal, 24)
                        
                        HedgeSpacer(height: 1)
                            .color(Color.hedgeUI.neutralBgSecondary)
                        
                        Button {
                            send(.retrospectTapped(.sell))
                        } label: {
                            Text("매도 회고하기".colorText(target: "매도", color: Color.hedgeUI.tradeSell))
                                .font(FontModel.body2Semibold)
                        }
                        .padding(.top, 12)
                        .padding(.bottom, 16)
                        .padding(.horizontal, 24)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(.white)
                    )
                    .cornerRadius(18)
                    .frame(width: 136)
                    .opacity(isActive ? 1 : 0)
                    
                    
                    Rectangle()
                        .frame(width: 20, height: 0)
                }
                
                Rectangle()
                    .foregroundStyle(.clear)
                    .frame(height: 12)
                
                HStack {
                    Spacer()
                    
                    Group {
                        if isActive {
                            Image.hedgeUI.cancelDemo
                                .transition(.scale.combined(with: .opacity))
                        } else {
                            Image.hedgeUI.plusDemo
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .rotationEffect(.degrees(rotationAngle))
                    .animation(.easeInOut(duration: 0.3), value: isActive)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isActive.toggle()
                            rotationAngle += 180
                        }
                    }
                }
                .padding(.bottom, 58)
                .padding(.trailing, 20)
            }
        }
    }
}

// MARK: - ScrollOffsetPreferenceKey
private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

extension HomeView {
    func badge(image: Image, count: Int) -> some View {
        VStack(alignment: .center, spacing: 6) {
            image
                .resizable()
                .frame(width: 32, height: 38)
            
            Text("\(count)개")
                .font(FontModel.label2Medium)
                .foregroundStyle(Color.hedgeUI.textAlternative)
                .padding(.vertical, 1)
        }
    }
    
    private var badgePopup: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 24) {
                badgePopupRow(
                    image: Image.hedgeUI.emerald,
                    title: "감각의 전성기",
                    description: "시장의 흐름을 넓고 깊게 이해하며, 스스로의 기준으로 움직였어요"
                )
                
                badgePopupRow(
                    image: Image.hedgeUI.gold,
                    title: "안정의 흐름",
                    description: "근거 있는 판단으로 흔들림 없이 결정했어요"
                )
                
                badgePopupRow(
                    image: Image.hedgeUI.silver,
                    title: "유연의 구간",
                    description: "계획과는 조금 달랐지만 상황에 맞게 판단을 잘 조정했어요"
                )
                
                badgePopupRow(
                    image: Image.hedgeUI.bronze,
                    title: "성찰의 시간기",
                    description: "기대와 다른 결과였지만, 이번 회고로 배움을 쌓고 있어요"
                )
            }
            
            HedgeActionButton("확인") {
                withAnimation(.easeInOut(duration: 0.2)) {
                    _ = send(.badgePopupTapped(false))
                }
            }
            .color(.secondary)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 28)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Color.hedgeUI.backgroundWhite)
        )
    }
    
    private func badgePopupRow(image: Image, title: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            image
                .resizable()
                .frame(width: 32, height: 38)
            
            HedgeSpacer(height: 8)
            
            Text(title)
                .font(FontModel.body1Semibold)
                .foregroundStyle(Color.hedgeUI.textTitle)
            
            Text(description)
                .font(FontModel.body3Medium)
                .foregroundStyle(Color.hedgeUI.textPrimary)
        }
    }
}
