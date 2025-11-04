//
//  TradeFeedbackResultView.swift
//  TradeFeedbackFeature
//

import SwiftUI
import DesignKit
import TradeFeedbackFeatureInterface
import ComposableArchitecture
import Core
import Shared
import FeedbackDomainInterface
import PrinciplesDomainInterface


// MARK: Badge Enum:
enum BadgeGrade { case emerald, gold, silver, bronze }

extension TradeData {
    var grade: BadgeGrade {
        switch yield {//TODO: do this
        default: return .silver
        }
    }
}

// MARK: - Color Extension for Hex Support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a,r,g,b) = (255,(int>>8)*17,(int>>4&0xF)*17,(int&0xF)*17)
        case 6: (a,r,g,b) = (255,int>>16,int>>8&0xFF,int&0xFF)
        case 8: (a,r,g,b) = (int>>24,int>>16&0xFF,int>>8&0xFF,int&0xFF)
        default:(a,r,g,b) = (1,1,1,0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}

// MARK: - Figma-style color wash (two ellipses)
private struct BackgroundWash: View {
    var body: some View {
        GeometryReader { geo in
            let W: CGFloat = 446
            let H: CGFloat = 462
            let D = max(W, H)
            
            ZStack {
                Ellipse()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color(hex: "#29F980").opacity(0.25), location: 0.0),
                                .init(color: Color(hex: "#29F980").opacity(0.0), location: 1)
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: D * 0.8
                        )
                    )
                    .frame(width: 1.55 * D, height: 1.55 * D)
                
                Ellipse()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color(hex: "#1CCAFF").opacity(0.25), location: 0.0),
                                .init(color: Color(hex: "#1CCAFF").opacity(0.0), location: 1.0)
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: D * 0.7
                        )
                    )
                    .frame(width: 1.55 * D, height: 1.55 * D)
                    .position(x: -W * 0.2, y: H * 0.8)
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)
        }
    }
}

// MARK: - Top white overlay (white → clear), pinned to device top
private struct TopWhiteOverlay: View {
    var height: CGFloat = 422
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "#FFFFFF"),
                Color.hedgeUI.backgroundGrey
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(height: height)
        .ignoresSafeArea(edges: .top)
        .allowsHitTesting(false)
    }
}

// MARK: - Card Wrapper
private struct HedgeCard<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }
    var body: some View {
        VStack(alignment: .leading, spacing: 0) { content }
            .padding(.vertical, 18)
            .padding(.horizontal, 18)
            .frame(maxWidth: .infinity)
            .background(Color.hedgeUI.backgroundWhite)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: the main screen
struct TradeFeedbackResultView: View {
    @Bindable public var store: StoreOf<TradeFeedbackFeature>
    
    private var badgeImage: Image {
        let grade: BadgeGrade = store.tradeData.grade
        switch grade {
        case .emerald: return Image.hedgeUI.emerald
        case .gold:    return Image.hedgeUI.gold
        case .silver:  return Image.hedgeUI.silver
        case .bronze:  return Image.hedgeUI.bronze
        }
    }
    
    // MARK: - Hero text from data
    private var heroTitle: String {
        // This should be tied to the badge grade
        let grade: BadgeGrade = store.tradeData.grade
        switch grade {
        case .emerald: return "완벽한 매매"
        case .gold:    return "훌륭한 매매"
        case .silver:  return "아쉬운 매매"
        case .bronze:  return "아쉬운 매매"
        }
    }
    
    private var heroSubtitle: String {
        store.feedback?.summary ?? "원칙을 잘 지키지는 않았지만, 시장 상황에 잘 대처한 투자였어요"
    }
    
    
    var body: some View {
        ZStack(alignment: .top) {
            // 1) Neutral base
            Color.hedgeUI.backgroundGrey.ignoresSafeArea()
            TopWhiteOverlay(height: 300)
                .frame(maxWidth: .infinity, alignment: .top)
                .ignoresSafeArea(edges: .top)
            BackgroundWash()
            
            // 2) Scrollable content
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    // Add top padding to account for navigation bar
                    Spacer()
                        .frame(height: 44)
                    
                    heroSection
                    tradeDetailsCard
                    keepItUpCard
                    improveCard
                    nextTimeCardWithCTA
                    disclaimerCard
                        .padding(.top, 20)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
            
            // 3) Navigation bar overlaid on top
            HedgeNavigationBar(
                buttonText: "완료",
                color: .primary,
                onLeftButtonTap: { store.send(.view(.backButtonTapped)) },
                onRightButtonTap: { /* finish */ }
            )
            // .background(.ultraThinMaterial.opacity(0.3))
        }
        .onAppear { store.send(.view(.onAppear)) }
    }
    
    // MARK: - Hero (floating)
    private var heroSection: some View {
        VStack(spacing: 5) {
            ZStack {
                badgeImage
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 111, height: 130)
            }
            VStack(spacing: 5) {
                Text(heroTitle)
                    .font(FontModel.h1Semibold)
                    .foregroundStyle(titleGradient)
                    .multilineTextAlignment(.center)
                    .frame(height: 30)
                Text(heroSubtitle)
                    .font(FontModel.label1Medium)
                    .foregroundColor(Color.hedgeUI.textSecondary)
                    .multilineTextAlignment(.center)
            }.frame(maxWidth: 187)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Trade details card
    private var tradeDetailsCard: some View {
        HedgeCard {
            VStack(spacing: 16) {
                HStack(spacing: 8) {
                    Circle().fill(Color.blue).frame(width: 28, height: 28)
                        .overlay(Text(store.tradeData.stockSymbol.prefix(1)).font(.system(size: 12, weight: .bold)).foregroundColor(.white))
                    VStack(alignment: .leading, spacing: 0) {
                        Text(store.tradeData.stockTitle)
                            .font(FontModel.label2Medium)
                            .foregroundColor(Color.hedgeUI.textAlternative)
                        Text("\(store.tradeData.tradingPrice)원 • \(store.tradeData.tradingQuantity)주 \(store.tradeData.tradeType.rawValue)")
                            .font(FontModel.body2Semibold)
                            .foregroundColor(Color.hedgeUI.textPrimary)
                    }
                    Spacer()
                }
                .frame(height: 42)
                
                HStack(spacing: 0) {
                    indicator(
                        icon: AnyView(
                            Image.hedgeUI.circle
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .foregroundColor(Color.hedgeUI.brandPrimary)
                        ),
                        label: "4개"
                    )
                    divider()
                    indicator(
                        icon: AnyView(
                            Image.hedgeUI.triangle
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .foregroundColor(Color.hedgeUI.brandPrimary)
                        ),
                        label: "1개"
                    )
                    divider()
                    indicator(
                        icon: AnyView(
                            Image.hedgeUI.cross
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .foregroundColor(Color.hedgeUI.brandPrimary)
                        ),
                        label: "0개"
                    )
                }
                .padding(.vertical, 8)
            }
        }
    }
    
    private func indicator(icon: AnyView, label: String) -> some View {
        VStack(spacing: 6) {
            icon
            Text(label)
                .font(FontModel.label2Regular)
                .foregroundColor(Color.hedgeUI.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func divider() -> some View {
        Rectangle().fill(Color.hedgeUI.grey300).frame(width: 1, height: 44)
    }
    
    // MARK: - Common gradient for titles
    private var titleGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color(hex: "#07BC70"), location: 0.0),
                .init(color: Color(hex: "#07BC70"), location: 0.3),
                .init(color: Color(hex: "#0696BE"), location: 0.7),
                .init(color: Color(hex: "#0696BE"), location: 1.0)
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    // MARK: - Advice cards
    private var keepItUpCard: some View {
        HedgeCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("앞으로도 유지해보세요")
                    .font(FontModel.body1Semibold)
                    .foregroundStyle(titleGradient)
                VStack(alignment: .leading, spacing: 7) {
                    ForEach(Array(keepItUpRecommendations.enumerated()), id: \.offset) { index, recommendation in
                        bullet(recommendation.1)
                    }
                }
            }
        }
    }
    
    private var keepItUpRecommendations: [(String, String)] {
        store.feedback?.principle.filter { $0.0.contains("유지") || $0.0.contains("앞으로") } ?? []
    }
    
    private var improveCard: some View {
        HedgeCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("고쳐보면 좋아요")
                    .font(FontModel.body1Semibold)
                    .foregroundStyle(titleGradient)
                VStack(alignment: .leading, spacing: 7) {
                    ForEach(Array(improveRecommendations.enumerated()), id: \.offset) { index, recommendation in
                        bullet(recommendation.1)
                    }
                }
            }
        }
    }
    
    private var improveRecommendations: [(String, String)] {
        store.feedback?.principle.filter { $0.0.contains("고쳐") || $0.0.contains("개선") } ?? []
    }
    
    // MARK: - Next time (with CTA inside)
    private var nextTimeCardWithCTA: some View {
        HedgeCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("다음 투자엔 이렇게 해보세요")
                    .font(FontModel.body1Semibold)
                    .foregroundStyle(titleGradient)
                VStack(alignment: .leading, spacing: 7) {
                    ForEach(Array(nextTimeRecommendations.enumerated()), id: \.offset) { index, recommendation in
                        bullet(recommendation.1)
                    }
                }
                
                Button(action: { /* action */ }) {
                    Text("원칙 추가해보기")
                        .font(FontModel.body1Semibold)
                        .foregroundColor(.white)
                        .frame(height: 42)
                        .frame(minWidth: 67, maxWidth: .infinity)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.hedgeUI.brandPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.top, 20)
            }
        }
    }
    
    private var nextTimeRecommendations: [(String, String)] {
        store.feedback?.principle.filter { $0.0.contains("다음") || $0.0.contains("투자") } ?? []
    }
    
    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Circle().fill(Color.hedgeUI.textSecondary).frame(width: 4, height: 4).padding(.top, 6)
            Text(text)
                .font(FontModel.body3Regular)
                .foregroundColor(Color.hedgeUI.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    // MARK: - Disclaimer (simple row)
    private var disclaimerCard: some View {
        HStack(alignment: .top, spacing: 10) {
            Image.hedgeUI.feedbackWarn
                .frame(maxWidth: 24, maxHeight: 24)
                .foregroundColor(Color.hedgeUI.textAlternative)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("AI 피드백은 투자 습관을 돌아보기 위한 도우미일 뿐,")
                Text("투자 판단이나 매매를 권유하는 내용은 아니에요.")
                Text("점수는 회고한 투자 원칙을 바탕으로 산출된 결과예요.")
            }
            .font(FontModel.label2Regular)
            .foregroundColor(Color.hedgeUI.textSecondary)
            Spacer()
        }
    }
}

// MARK: - Preview & Mocks
#Preview {
    let tradeData = TradeData(
        id: 1, tradeType: .sell,
        stockSymbol: "005930", stockTitle: "삼성전자", stockMarket: "KOSPI",
        tradingPrice: "160,000", tradingQuantity: "8", tradingDate: "2025년 1월 9일",
        yield: "+5%", emotion: .conviction,
        tradePrinciple: [Principle(id: 1, principle: "매매전략1")],
        retrospection: "삼성전자 매도 회고입니다."
    )
    
    return TradeFeedbackResultView(
        store: .init(
            initialState: TradeFeedbackFeature.State(tradeData: tradeData),
            reducer: {
                TradeFeedbackFeature(
                    coordinator: MockCoordinator(),
                    fetchFeedbackUseCase: MockFetchFeedbackUseCase()
                )
            }
        )
    )
}

class MockCoordinator: TradeFeedbackCoordinator {
    var navigationController: UINavigationController = UINavigationController()
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .tradeFeedback
    weak var parentCoordinator: RootCoordinator?
    weak var finishDelegate: CoordinatorFinishDelegate?
    func start() {}
    func popToPrev() {}
}

class MockFetchFeedbackUseCase: FetchFeedbackUseCase {
    func execute(id: Int) async throws -> FeedbackData {
        FeedbackData(
            summary: "원칙을 잘 지키지는 않았지만, 시장 상황에 잘 대처한 투자였어요",
            marketCondition: "당시 시장은 상승 추세였으며, 거래량이 증가하는 상황이었습니다.",
            aiRecommendedPrinciples: [
                ["앞으로도 유지해보세요": "실적 개선과 거래량 증가를 근거로 진입한 판단은 근거가 명확했습니다."],
                ["앞으로도 유지해보세요": "매수 시점은 상승 초입 구간으로, 흐름 인식이 정확했어요."],
                ["고쳐보면 좋아요": "매도 시점은 단기 저점 부근으로, 불안한 감정이 의사 결정을 앞당긴 것으로 보입니다."],
                ["고쳐보면 좋아요": "손절 기준이 불명확해 타이밍을 놓쳤어요."],
                ["다음 투자엔 이렇게 해보세요": "다음엔 거래량 감소 구간을 명시적으로 기록해보세요."],
                ["다음 투자엔 이렇게 해보세요": "감정 로그를 활용해 '불안 시점 vs 실제 하락률'을 비교하면 정확도가 높아집니다."]
            ]
        )
    }
}
