//
//  TradeFeedbackView.swift
//  TradeFeedbackFeature
//
//  Created by 이중엽 on 9/22/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

import DesignKit
import TradeFeedbackFeatureInterface
import ComposableArchitecture
import Core

struct TradeFeedbackView: View {
    
    @Bindable public var store: StoreOf<TradeFeedbackFeature>
    
    @State private var selectedTab: Int = 1
    @State private var isImageHidden: Bool = false
    @State private var isPrincipleExpanded: Bool = false
    @State private var feedback: Feedback? = nil
    @State private var rotationAngle: Double = 0
    @State private var timer: Timer?
    
    private let threshold: CGFloat = 150
    
    // 이미지 높이 계산
    private var imageHeight: CGFloat {
        let baseWidth: CGFloat = 375
        let adjust = UIScreen.main.bounds.width / baseWidth
        let adjustHeight = 192 * adjust
        
        // 이미지가 숨겨진 상태면 높이 0, 아니면 원래 높이
        return isImageHidden ? 0 : adjustHeight
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HedgeNavigationBar(buttonText: "삭제", color: .secondary, onLeftButtonTap: {
                    store.send(.view(.backButtonTapped))
                }, onRightButtonTap: {
                    
                })
                
                HedgeTopView(
                    symbolImage: Image.hedgeUI.generate,
                    title: store.state.tradeData.stockTitle,
                    description: "\(store.state.tradeData.tradingPrice)・\(store.state.tradeData.tradingQuantity) \(store.state.tradeData.tradeType.rawValue)",
                    footnote: store.state.tradeData.tradingDate
                )
                
                Image.hedgeUI.tmpChart
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: imageHeight, alignment: .top)
                    .clipped()
                    .animation(.easeInOut(duration: 0.3), value: imageHeight)
                
                Rectangle()
                    .frame(height: 10)
                    .foregroundStyle(.clear)
                
                VStack(spacing: 0) {
                    // 탭 헤더
                    HStack(spacing: 0) {
                        Text("나의 회고")
                            .font(FontModel.body2Medium)
                            .foregroundColor(selectedTab == 0 ? Color.hedgeUI.textPrimary : Color.hedgeUI.textAlternative)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedTab = 0
                                }
                            }
                        
                        Text("AI 피드백")
                            .font(FontModel.body2Medium)
                            .foregroundColor(selectedTab == 1 ? Color.hedgeUI.textPrimary : Color.hedgeUI.textAlternative)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedTab = 1
                                }
                            }
                    }
                    .padding(.vertical, 12)
                    
                    // 선택된 탭의 밑줄
                    Rectangle()
                        .foregroundColor(.primary)
                        .offset(x: selectedTab == 0 ? -(geometry.size.width / 4) : (geometry.size.width / 4))
                        .frame(width: geometry.size.width / 2, height: 2, alignment: .leading)
                        .animation(.easeInOut(duration: 0.3), value: selectedTab)
                    
                    // 전체 밑줄
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(Color.hedgeUI.neutralBgSecondary)
                }
                
                // TabView로 페이지네이션
                TabView(selection: $selectedTab) {
                    retrospectTab
                        .tag(0)
                    
                    feedbackTab
                        .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .onAppear {
                UIScrollView.appearance().bounces = false
                store.send(.view(.onAppear))
            }
            .onDisappear {
                UIScrollView.appearance().bounces = true
            }
        }
    }
}


// MARK: Timer Functions
extension TradeFeedbackView {
    private func startRotationTimer() {
        rotationAngle = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            withAnimation(.linear(duration: 1)) {
                rotationAngle += 360
            }
        }
    }
    
    private func stopRotationTimer() {
        timer?.invalidate()
        timer = nil
        rotationAngle = 0
    }
}

// MARK: Subviews
extension TradeFeedbackView {
    
    @ViewBuilder
    private var retrospectTab: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                Text(store.state.tradeData.tradingDate)
                    .font(FontModel.label2Regular)
                    .foregroundColor(Color.hedgeUI.textAlternative)
                
                Rectangle()
                    .frame(height: 12)
                    .foregroundStyle(.clear)
                
                Text(store.state.tradeData.retrospection)
                    .font(FontModel.body3Regular)
                
                Rectangle()
                    .frame(height: 24)
                    .foregroundStyle(.clear)
                
                if let emotion = store.state.tradeData.emotion {
                    HStack(spacing: 9) {
                        emotion.normalImage
                            .resizable()
                            .frame(width: 24, height: 24)
                        
                        Text("\(emotion.rawValue) \(store.state.tradeData.tradeType == .buy ? "매도" : "매수")")
                            .font(FontModel.label1Semibold)
                    }
                }
                
                Rectangle()
                    .frame(height: 12)
                    .foregroundStyle(.clear)
                
                if !store.state.tradeData.tradePrinciple.isEmpty {
                    VStack(alignment: .leading, spacing: 0) {
                        // 헤더 (클릭 가능)
                        HStack(spacing: 9) {
                            Image.hedgeUI.principle
                                .resizable()
                                .frame(width: 24, height: 24)
                            
                            Text("적용한 원칙")
                                .font(FontModel.label1Semibold)
                            
                            Spacer()
                            
                            Image.hedgeUI.arrowDown
                                .foregroundColor(Color.hedgeUI.textAlternative)
                                .font(.system(size: 14, weight: .medium))
                                .rotationEffect(.degrees(isPrincipleExpanded ? 180 : 0))
                                .animation(.easeInOut(duration: 0.3), value: isPrincipleExpanded)
                            
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isPrincipleExpanded.toggle()
                                
                                // 원칙 리스트가 펼쳐질 때 해당 위치로 스크롤
                                if isPrincipleExpanded {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            proxy.scrollTo("principleList", anchor: .bottom)
                                        }
                                    }
                                }
                            }
                        }
                        
                        Rectangle()
                            .frame(height: 12)
                            .foregroundStyle(.clear)
                        
                        // 원칙 목록 (항상 렌더링하되 높이로 애니메이션)
                        HStack(spacing: 4) {
                            
                            Rectangle()
                                .frame(width: 3)
                                .foregroundStyle(Color.hedgeUI.neutralBgSecondary)
                                .padding(.horizontal, 8)
                                .frame(maxHeight: isPrincipleExpanded ? .infinity : 0)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(store.state.tradeData.tradePrinciple, id: \.self) { principle in
                                    HStack(spacing: 8) {
                                        Image.hedgeUI.checkDemo
                                            .resizable()
                                            .frame(width: 16, height: 16)
                                        
                                        Text(principle.principle)
                                            .font(FontModel.body3Regular)
                                            .foregroundColor(Color.hedgeUI.textPrimary)
                                    }
                                }
                            }
                            .frame(maxHeight: isPrincipleExpanded ? .infinity : 0)
                        }
                        .clipped()
                        .opacity(isPrincipleExpanded ? 1 : 0)
                        .id("principleList")
                    }
                }
                
                Spacer()
                }
            }
            .scrollBounceBehavior(.basedOnSize)
        }
        .imageDragGesture(isImageHidden: $isImageHidden, threshold: threshold)
        .simultaneousGesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < 0, threshold < abs(value.translation.width) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab += 1
                        }
                    }
                }
        )
        .padding(20)
    }
    
    @ViewBuilder
    private var feedbackTab: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if let _ = store.state.feedback {
                feedbackView
            } else {
                loadingView
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .imageDragGesture(isImageHidden: $isImageHidden, threshold: threshold)
        .simultaneousGesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width > 0, threshold < abs(value.translation.width) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab -= 1
                        }
                    }
                }
        )
    }
    
    @ViewBuilder
    private var feedbackView: some View {
        VStack(spacing: 0) {
            warningView
            
            summaryView
            marketStatusView
            principleView
        }
    }
    
    @ViewBuilder
    private var warningView: some View {
        HStack(spacing: 10) {
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.hedgeUI.feedbackAI)
                    
                    
                    Image.hedgeUI.error
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                
                Spacer()
            }
            .padding(.top, 2)
            
            Text("본 서비스에서 제공하는 AI 피드백은 투자 참고용 정보이며, 실제 투자 판단에 대한 책임은 사용자 본인에게 있습니다.")
                .font(FontModel.label2Medium)
                .foregroundStyle(Color.hedgeUI.feedbackAI)
            
            Spacer()
        }
        .padding(.vertical, 22)
        .padding(.horizontal, 20)
        .background(Color.hedgeUI.feedbackAI.opacity(0.05))
    }
    
    @ViewBuilder
    private var summaryView: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 8) {
                Image.hedgeUI.generateIcon
                    .resizable()
                    .frame(width: 22, height: 22)
                
                Text("요약")
                    .font(FontModel.body2Semibold)
                    .foregroundStyle(Color.hedgeUI.feedbackAI)
                
                Spacer()
            }
            
            Rectangle()
                .frame(height: 16)
                .foregroundStyle(.clear)
            
            Text("요약 한마디")
                .font(FontModel.h2Semibold)
                .foregroundStyle(Color.hedgeUI.textTitle)
            
            Rectangle()
                .frame(height: 8)
                .foregroundStyle(.clear)
            
            Text(store.state.feedback?.summary ?? "")
                .font(FontModel.body3Medium)
                .foregroundStyle(Color.hedgeUI.textSecondary)
        }
        .padding(.vertical, 22)
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private var marketStatusView: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 8) {
                Rectangle()
                    .frame(width: 22, height: 22)
                    .foregroundStyle(Color.hedgeUI.textDisabled)
                
                Text("당시 시장 현황")
                    .font(FontModel.h2Semibold)
                    .foregroundStyle(Color.hedgeUI.textTitle)
                
                Spacer()
            }
            
            Rectangle()
                .frame(height: 16)
                .foregroundStyle(.clear)
            
            Rectangle()
                .frame(height: 8)
                .foregroundStyle(.clear)
            
            Text(store.state.feedback?.marketStatus ?? "")
                .font(FontModel.body3Medium)
                .foregroundStyle(Color.hedgeUI.textSecondary)
                .padding(.vertical, 32)
                .padding(.horizontal, 20)
                .background(Color.hedgeUI.neutralBgSecondary)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(.vertical, 22)
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private var principleView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Rectangle()
                    .frame(width: 22, height: 22)
                    .foregroundStyle(Color.hedgeUI.textDisabled)
                
                Text("AI 추천 원칙")
                    .font(FontModel.h2Semibold)
                    .foregroundStyle(Color.hedgeUI.textTitle)
                
                Spacer()
            }
            
            ForEach(Array((store.state.feedback?.principle ?? []).enumerated()), id: \.offset) { index, principle in
                VStack(spacing: 0) {
                    
                    HStack(spacing: 0) {
                        Text(store.state.feedback?.principle[index].0 ?? "")
                            .font(FontModel.body2Semibold)
                            .foregroundStyle(Color.hedgeUI.textTitle)
                            .lineLimit(2)
                        
                        Spacer(minLength: 40)
                        
                        HedgeActionButton("추가", Image.hedgeUI.plus, Color.hedgeUI.neutralBgDefault) {
                            
                        }
                        .size(.icon)
                        .color(.primary)
                        .font(.label2Semibold)
                    }
                    
                    Rectangle()
                        .frame(height: 8)
                        .foregroundStyle(.clear)
                    
                    Text(store.state.feedback?.principle[index].1 ?? "")
                        .font(FontModel.label1Regular)
                        .foregroundStyle(Color.hedgeUI.textSecondary)
                        .lineLimit(3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Rectangle()
                        .frame(height: 22)
                        .foregroundStyle(.clear)
                    
                    if index < (store.state.feedback?.principle.count ?? 0) - 1 {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(Color.hedgeUI.neutralBgSecondary)
                    }
                }
            }
        }
        .padding(.vertical, 22)
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private var loadingView: some View {
        HStack(spacing: 12) {
            Image.hedgeUI.indicator
                .resizable()
                .frame(width: 20, height: 20)
                .rotationEffect(.degrees(rotationAngle))
                .onAppear {
                    startRotationTimer()
                }
                .onDisappear {
                    stopRotationTimer()
                }
            
            Text("AI 피드백 작성중...")
                .font(FontModel.body3Medium)
                .foregroundStyle(Color.hedgeUI.feedbackAI)
            
            Spacer()
        }
        .padding(.vertical, 22)
        .padding(.horizontal, 20)
        .background(Color.hedgeUI.feedbackAI.opacity(0.05))
    }
}

// MARK: - ViewModifier
struct ImageDragGestureModifier: ViewModifier {
    @Binding var isImageHidden: Bool
    let threshold: CGFloat
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture()
                    .onChanged { value in
                        // 드래그 중에는 아무것도 하지 않음
                    }
                    .onEnded { value in
                        let finalOffset = abs(value.translation.height)
                        let isUpwardDrag = value.translation.height < 0 // 위로 드래그 (음수)
                        
                        // 위로 드래그하고 임계값 이상이면 이미지 숨김
                        if isUpwardDrag && finalOffset >= threshold {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isImageHidden = true
                            }
                        } else {
                            // 아래로 드래그하거나 임계값 미만이면 이미지 표시
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isImageHidden = false
                            }
                        }
                    }
            )
    }
}

// MARK: - View Extension
extension View {
    func imageDragGesture(isImageHidden: Binding<Bool>, threshold: CGFloat) -> some View {
        self.modifier(ImageDragGestureModifier(isImageHidden: isImageHidden, threshold: threshold))
    }
}

//#Preview {
//    let tradeData = TradeData(id: 1, tradeType: .sell, stockSymbol: "", stockTitle: "삼성전자", stockMarket: "SAMSUNG", tradingPrice: "70,000", tradingQuantity: "10", tradingDate: "2025년 10월 25일", yield: "+10%", emotion: .impulse, tradePrinciple: ["1", "2", "3"], retrospection: "가나다라 회고 작성했습니다.가나다라 회고 작성했습니다.가나다라 회고 작성했습니다.가나다라 회고 작성했습니다.가나다라 회고 작성했습니다.가나다라 회고 작성했습니다.가나다라 회고 작성했습니다.가나다라 회고 작성했습니다.가나다라 회고 작성123했습니다.가나다라 회고 작성했습니다.가나다라 회고 작성했습니다.")
//    
//    TradeFeedbackView(store: .init(initialState: TradeFeedbackFeature.State(tradeData: tradeData),
//                                   reducer: { TradeFeedbackFeature(coordinator: DefaultTradeHFeedbackCoordinator(navigationController: UINavigationController(), tradeData: tradeData))
//    }))
//}
