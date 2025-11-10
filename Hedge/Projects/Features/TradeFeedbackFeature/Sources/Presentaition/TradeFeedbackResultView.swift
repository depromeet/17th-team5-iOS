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
        // Badge grade logic based on yield
        // Implementation pending based on business requirements
        switch yield {
        default: return .silver
        }
    }
}

// MARK: - Figma-style color wash (two ellipses)
// Note: Using Color(hex:) from DesignKit module
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
                                .init(color: Color(hex: "#29F980", fallback: .green).opacity(0.25), location: 0.0),
                                .init(color: Color(hex: "#29F980", fallback: .green).opacity(0.0), location: 1)
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
                                .init(color: Color(hex: "#1CCAFF", fallback: .cyan).opacity(0.25), location: 0.0),
                                .init(color: Color(hex: "#1CCAFF", fallback: .cyan).opacity(0.0), location: 1.0)
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
                Color(hex: "#FFFFFF", fallback: .white),
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
        store.feedback?.badge ?? "원칙을 잘 지키지는 않았지만, 시장 상황에 잘 대처한 투자였어요"
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
                onRightButtonTap: { store.send(.view(.completeButtonTapped)) }
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
                
                if let feedback = store.feedback {
                    HStack(spacing: 12) {
                        countChip(title: "지켰어요", count: feedback.keptCount, color: Color.hedgeUI.brandPrimary)
                        countChip(title: "보통이에요", count: feedback.neutralCount, color: Color.hedgeUI.textAlternative)
                        countChip(title: "안지켰어요", count: feedback.notKeptCount, color: Color.hedgeUI.tradeSell)
                    }
                }
            }
        }
    }
    
    // MARK: - Common gradient for titles
    private var titleGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color(hex: "#07BC70", fallback: .green), location: 0.0),
                .init(color: Color(hex: "#07BC70", fallback: .green), location: 0.3),
                .init(color: Color(hex: "#0696BE", fallback: .blue), location: 0.7),
                .init(color: Color(hex: "#0696BE", fallback: .blue), location: 1.0)
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
                    ForEach(Array(keepItUpRecommendations.enumerated()), id: \.offset) { _, recommendation in
                        bullet(recommendation)
                    }
                }
            }
        }
    }
    
    private var keepItUpRecommendations: [String] {
        store.feedback?.keep ?? []
    }
    
    private var improveCard: some View {
        HedgeCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("고쳐보면 좋아요")
                    .font(FontModel.body1Semibold)
                    .foregroundStyle(titleGradient)
                VStack(alignment: .leading, spacing: 7) {
                    ForEach(Array(improveRecommendations.enumerated()), id: \.offset) { _, recommendation in
                        bullet(recommendation)
                    }
                }
            }
        }
    }
    
    private var improveRecommendations: [String] {
        store.feedback?.fix ?? []
    }
    
    // MARK: - Next time (with CTA inside)
    private var nextTimeCardWithCTA: some View {
        HedgeCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("다음 투자엔 이렇게 해보세요")
                    .font(FontModel.body1Semibold)
                    .foregroundStyle(titleGradient)
                VStack(alignment: .leading, spacing: 7) {
                    ForEach(Array(nextTimeRecommendations.enumerated()), id: \.offset) { _, recommendation in
                        bullet(recommendation)
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
    
    private var nextTimeRecommendations: [String] {
        store.feedback?.next ?? []
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
    
    private func countChip(title: String, count: Int, color: Color) -> some View {
        VStack(spacing: 6) {
            Text("\(count)")
                .font(FontModel.h2Semibold)
                .foregroundStyle(color)
            Text(title)
                .font(FontModel.label2Regular)
                .foregroundColor(Color.hedgeUI.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.hedgeUI.neutralBgDefault)
        )
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
