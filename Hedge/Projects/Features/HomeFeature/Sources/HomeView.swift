import SwiftUI

import DesignKit
import HomeFeatureInterface
import RetrospectionDomainInterface

import ComposableArchitecture

@ViewAction(for: HomeFeature.self)
public struct HomeView: View {
    
    @State var isActive: Bool = false
    @State private var rotationAngle: Double = 0
    
    public var store: StoreOf<HomeFeature>
    
    public init(store: StoreOf<HomeFeature>) {
        self.store = store
    }
    
    public var body: some View {
        
        ZStack {
            Color.hedgeUI.backgroundWhite
                .ignoresSafeArea()
            
            if isActive {
                Color.hedgeUI.grey500
                    .ignoresSafeArea()
            }
            
            VStack(spacing: 0) {
                topNavigationBar
                tabArea
                badgeArea
                retrospectArea
                
                Spacer()
            }
            
            startArea
        }
        .onAppear {
            send(.onAppear)
        }
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
        ZStack {
            // 배경 레이어
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.hedgeUI.backgroundWhite)
                .overlay {
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
                }
                .clipShape(RoundedRectangle(cornerRadius: 22)) // overlay 내부의 Circle만 clip
            
            // Stroke는 별도 레이어
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.hedgeUI.neutralBgSecondary, lineWidth: 1)
            
            // 내부 콘텐츠
            VStack(spacing: 0) {
                HStack {
                    Text("아직 모은 뱃지가 없어요")
                        .font(.body2Semibold)
                        .foregroundStyle(Color.hedgeUI.textPrimary)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    Spacer()
                }
                
                HStack(alignment: .center, spacing: 20) {
                    badge(image: HedgeUI.emerald, count: 0)
                    
                    RoundedRectangle(cornerRadius: 2)
                        .frame(width: 1)
                        .foregroundStyle(Color.hedgeUI.neutralBgSecondary)
                        .padding(.vertical, 6)
                    
                    badge(image: HedgeUI.gold, count: 0)
                    
                    RoundedRectangle(cornerRadius: 2)
                        .frame(width: 1)
                        .foregroundStyle(Color.hedgeUI.neutralBgSecondary)
                        .padding(.vertical, 6)
                    
                    badge(image: HedgeUI.silver, count: 0)
                    
                    RoundedRectangle(cornerRadius: 2)
                        .frame(width: 1)
                        .foregroundStyle(Color.hedgeUI.neutralBgSecondary)
                        .padding(.vertical, 6)
                    
                    badge(image: HedgeUI.bronze, count: 0)
                }
                .padding(.vertical, 20)
                
                Spacer()
            }
        }
        .shadow(
            color: Color.black.opacity(0.08),
            radius: 20,
            x: 0,
            y: 6
        )
        .frame(height: 148)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
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
                        VStack(alignment: .center, spacing: 12) {
                            ForEach(store.state.companySymbols, id: \.self) { symbol in
                                let isSelected = store.state.selectedCompanySymbol == symbol
                                
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
                    .overlay {
                        VStack {
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: Color.white.opacity(1.0), location: 0.0),
                                    .init(color: Color.white.opacity(0.0), location: 0.85),
                                ]
                                ),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(height: 70)
                            .allowsHitTesting(false)
                            
                            Spacer()
                        }
                    }
                    
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
                        .onChange(of: store.state.selectedCompanySymbol) { oldValue, newValue in
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
        VStack(spacing: 0) {
            Spacer()
            
            HStack {
                Spacer()
                
                VStack(spacing: 16) {
                    HStack(spacing: 8) {
                        Image.hedgeUI.buyDemo
                        
                        Text("매수 회고하기")
                            .font(FontModel.body2Semibold)
                            .foregroundStyle(Color.hedgeUI.textPrimary)
                    }
                    .onTapGesture {
                        send(.retrospectTapped(.buy))
                    }
                    
                    HStack(spacing: 8) {
                        Image.hedgeUI.sellDemo
                        
                        Text("매수 회고하기")
                            .font(FontModel.body2Semibold)
                            .foregroundStyle(Color.hedgeUI.textPrimary)
                    }
                    .onTapGesture {
                        send(.retrospectTapped(.sell))
                    }
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.white)
                )
                .cornerRadius(12)
                .opacity(isActive ? 1 : 0)
                
                
                Rectangle()
                    .frame(width: 20, height: 0)
            }
            
            Rectangle()
                .frame(height: 12)
                .foregroundStyle(.clear)
            
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
            .padding(.bottom, 100)
            .padding(.trailing, 20)
        }
    }
}

// MARK: - ScrollOffsetPreferenceKey
private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
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
}

// #Preview {
//     HomeView(store: .init(initialState: HomeFeature.State(),
//                           reducer: { HomeFeature() } )
//     )
// }
