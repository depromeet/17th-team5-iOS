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
    
    @State private var selectedTab: Int = 0
    @State private var isImageHidden: Bool = false
    
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
                HedgeNavigationBar(buttonText: "삭제", color: .secondary)
                
                HedgeTopView(
                    symbolImage: Image.hedgeUI.generate,
                    title: store.state.tradeData.stockTitle,
                    description: "\(store.state.tradeData.tradingPrice)・\(store.state.tradeData.tradingQuantity)주 \(store.state.tradeData.tradeType.rawValue)",
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
        }
    }
}


// MARK: Subviews
extension TradeFeedbackView {
    
    private var tradeData: TradeData {
        return store.state.tradeData
    }
    
    @ViewBuilder
    private var retrospectTab: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 0) {
                Text(tradeData.tradingDate)
                    .font(FontModel.label2Regular)
                    .foregroundColor(Color.hedgeUI.textAlternative)
                
                Rectangle()
                    .frame(height: 12)
                    .foregroundStyle(.clear)
                
                Text(tradeData.retrospection)
                    .font(FontModel.body3Regular)
                
                Rectangle()
                    .frame(height: 24)
                    .foregroundStyle(.clear)
                
                if let emotion = tradeData.emotion {
                    HStack(spacing: 9) {
                        emotion.normalImage
                            .resizable()
                            .frame(width: 24, height: 24)
                        
                        Text("\(emotion.rawValue) \(tradeData.tradeType == .buy ? "매도" : "매수")")
                            .font(FontModel.label1Semibold)
                    }
                }
                
                Rectangle()
                    .frame(height: 12)
                    .foregroundStyle(.clear)
                
                if !tradeData.tradePrinciple.isEmpty {
                    HStack(spacing: 9) {
                        Image.hedgeUI.principle
                            .resizable()
                            .frame(width: 24, height: 24)
                        
                        Text("적용한 원칙")
                            .font(FontModel.label1Semibold)
                    }
                }
                
                Spacer()
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .imageDragGesture(isImageHidden: $isImageHidden, threshold: threshold)
        .padding(20)
    }
    
    @ViewBuilder
    private var feedbackTab: some View {
        ScrollView(.vertical) {
            VStack {
                HStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                    Text("AI 피드백 작성중...")
                        .foregroundColor(.secondary)
                }
                .padding()
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .imageDragGesture(isImageHidden: $isImageHidden, threshold: threshold)
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

#Preview {
    
    let tradeData = TradeData(tradeType: .sell, stockSymbol: "", stockTitle: "삼성전자", stockMarket: "SAMSUNG", tradingPrice: "70,000", tradingQuantity: "10", tradingDate: "2025년 10월 25일", yield: "+10%", emotion: .impulse, tradePrinciple: ["1", "2", "3"], retrospection: "가나다라 회고 작성했습니다.가나다라 회고 작성했습니다.가나다라 회고 작성했습니다.가나다라 회고 작성했습니다.가나다라 회고 작성했습니다.가나다라 회고 작성했습니다.가나다라 회고 작성했습니다.가나다라 회고 작성했습니다.가나다라 회고 작성123했습니다.가나다라 회고 작성했습니다.가나다라 회고 작성했습니다.")
    
    TradeFeedbackView(store: .init(initialState: TradeFeedbackFeature.State(tradeData: tradeData),
                                   reducer: { TradeFeedbackFeature(coordinator: DefaultTradeHFeedbackCoordinator(navigationController: UINavigationController(), tradeData: tradeData))
    }))
}
