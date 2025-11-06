import SwiftUI

import DesignKit
import HomeFeatureInterface

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
            
            HStack(spacing: 2) {
                // 주식 종목
                ScrollView {
                    VStack(alignment: .center, spacing: 12) {
                        ForEach(sampleStockSymbols, id: \.self) { symbol in
                            HStack(spacing: 8) {
                                Image.hedgeUI.stockThumbnailDemo
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                
                                Text(symbol)
                                    .font(FontModel.body3Medium)
                                    .foregroundStyle(Color.hedgeUI.textSecondary)
                                    .lineLimit(2)
                                    .truncationMode(.tail)
                            }
                            .frame(width: 98, alignment: .leading)
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                .fill(Color.hedgeUI.neutralBgSecondary)
                            )
                        }
                    }
                    .padding(.horizontal, 12)
                }
                
                // 종목에 해당하는 회고 리스트 (날짜별 섹션)
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(groupedRetrospects.keys.sorted(by: >), id: \.self) { date in
                            VStack(alignment: .leading, spacing: 8) {
                                // 날짜 헤더
                                Text(formatDate(date))
                                    .font(FontModel.body2Semibold)
                                    .foregroundStyle(Color.hedgeUI.textTitle)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 8)
                                
                                // 해당 날짜의 회고 항목들
                                ForEach(groupedRetrospects[date] ?? []) { item in
                                    retrospectItemView(item)
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    // 날짜별로 그룹화된 회고 데이터
    private var groupedRetrospects: [String: [RetrospectItem]] {
        Dictionary(grouping: sampleRetrospects) { $0.date }
    }
    
    // 회고 항목 뷰
    @ViewBuilder
    private func retrospectItemView(_ item: RetrospectItem) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.stockSymbol)
                .font(FontModel.label2Semibold)
                .foregroundStyle(Color.hedgeUI.textPrimary)
            
            Text(item.content)
                .font(FontModel.body3Regular)
                .foregroundStyle(Color.hedgeUI.textSecondary)
                .lineLimit(2)
            
            Text("매수")
                .font(FontModel.caption2Semibold)
                .foregroundStyle(
                    Color.hedgeUI.tradeBuy
                )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.hedgeUI.backgroundWhite)
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
    
    // 날짜 포맷팅
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "yyyy년 MM월 dd일"
            return formatter.string(from: date)
        }
        return dateString
    }
}

extension HomeView {
    // 더미 데이터 - 실제 데이터로 교체 필요
    private var sampleStockSymbols: [String] {
        ["삼성전자", "종목명이최대두줄이상일때", "NAVER"]
    }
    
    // 더미 회고 데이터 - 실제 데이터로 교체 필요
    private var sampleRetrospects: [RetrospectItem] {
        [
            RetrospectItem(id: 1, stockSymbol: "삼성전자", date: "2025-01-15", content: "매수 회고 내용 1"),
            RetrospectItem(id: 2, stockSymbol: "삼성전자", date: "2025-01-15", content: "매수 회고 내용 2"),
            RetrospectItem(id: 3, stockSymbol: "종목명이최대10자이상", date: "2025-01-14", content: "매도 회고 내용 1"),
            RetrospectItem(id: 4, stockSymbol: "NAVER", date: "2025-01-13", content: "매수 회고 내용 3")
        ]
    }
    
    // 회고 항목 모델
    private struct RetrospectItem: Identifiable {
        let id: Int
        let stockSymbol: String
        let date: String
        let content: String
    }
}

#Preview {
    HomeView(store: .init(initialState: HomeFeature.State(),
                          reducer: { HomeFeature() } )
    )
}
