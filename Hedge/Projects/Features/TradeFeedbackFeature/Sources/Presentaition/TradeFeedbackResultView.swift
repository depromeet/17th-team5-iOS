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
import Kingfisher

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
            
            HStack {
                Spacer()
                
                Button {
                    store.send(.view(.completeButtonTapped))
                } label: {
                    Text("완료")
                        .font(FontModel.body1Semibold)
                        .foregroundStyle(Color.hedgeUI.brandDarken)
                        .padding(4)
                }
            }
            .padding(.horizontal, 16)
        }
        .onAppear { store.send(.view(.onAppear)) }
    }
    
    // MARK: - Hero (floating)
    private var heroSection: some View {
        VStack(spacing: 5) {
            ZStack {
                store.state.badgeGrade.image
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 111, height: 130)
            }
            VStack(spacing: 5) {
                Text(store.state.badgeGrade.title)
                    .font(FontModel.h1Semibold)
                    .foregroundStyle(titleGradient)
                    .multilineTextAlignment(.center)
                    .frame(height: 30)
                Text(store.state.badgeGrade.content)
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
                HStack(spacing: 12) {
                    if let logo = store.state.stock.logo {
                        KFImage(URL(string: logo)!)
                            .resizable()
                            .frame(width: 28, height: 28)
                    } else {
                        Image.hedgeUI.stockThumbnailDemo
                            .resizable()
                            .frame(width: 28, height: 28)
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text(store.stock.companyName)
                            .font(FontModel.label2Medium)
                            .foregroundColor(Color.hedgeUI.textAlternative)
                        Text("\(store.tradeHistory.tradingPrice) • \(store.tradeHistory.tradingQuantity) \(store.tradeType.rawValue)")
                            .font(FontModel.body2Semibold)
                            .foregroundColor(Color.hedgeUI.textPrimary)
                    }
                    Spacer()
                }
                .padding(.top, 16)
                .padding(.bottom, 10)
                
                HStack(alignment: .center) {
                    countChip(image: .hedgeUI.keep, count: store.feedback.keptCount)
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 2)
                        .frame(width: 1, height: 32)
                        .foregroundStyle(Color.hedgeUI.neutralBgSecondary)
                    
                    Spacer()
                    
                    countChip(image: .hedgeUI.normal, count: store.feedback.neutralCount)
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 2)
                        .frame(width: 1, height: 32)
                        .foregroundStyle(Color.hedgeUI.neutralBgSecondary)
                    
                    Spacer()
                    
                    countChip(image: .hedgeUI.notKeep, count: store.feedback.notKeptCount)
                }
                .padding(.top, 12)
                .padding(.bottom, 28)
                .padding(.horizontal, 48)
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
            .padding(.vertical, 18)
        }
    }
    
    private var keepItUpRecommendations: [String] {
        store.feedback.keep
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
            .padding(.vertical, 18)
        }
    }
    
    private var improveRecommendations: [String] {
        store.feedback.fix
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
            }
            .padding(.vertical, 18)
        }
    }
    
    private var nextTimeRecommendations: [String] {
        store.feedback.next
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
    
    private func countChip(image: Image, count: Int) -> some View {
        VStack(spacing: 6) {
            image
                .resizable()
                .frame(width: 28, height: 28, alignment: .center)
                .padding(.horizontal, 0.5)
            
            Text("\(count)개")
                .font(FontModel.label2Semibold)
                .foregroundStyle(Color.hedgeUI.textSecondary)
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
