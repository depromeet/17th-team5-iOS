//
//  TradeReasonInputView.swift
//  TradeReasonFeature
//
//  Created by 이중엽 on 9/21/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignKit
import TradeReasonFeatureInterface
import StockDomainInterface

struct TradeReasonInputView: View {
    
    @Bindable public var store: StoreOf<TradeReasonFeature>
    
    public init(store: StoreOf<TradeReasonFeature>) {
        self.store = store
    }
    
    @State var text: String = ""
    @FocusState private var isFocused: Bool
    
    let items = [
        "주가가 오르는 흐름이면 매수, 하락 흐름이면 매도하기",
        "기업의 본질 가치보다 낮게 거래되는 주식을 찾아 장기 보유하기",
        "단기 등락에 흔들리지 말고 기업의 장기 성장성에 집중하기",
        "분산 투자 원칙을 지키고 감정적 결정을 피하기",
        "리스크를 관리하며 손절 기준을 미리 정해두기"
    ]
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 0) {
                HedgeNavigationBar(buttonText: "완료", onRightButtonTap:  {
                    store.send(.view(.nextTapped))
                })
                
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 0) {
                            HedgeTopView(
                                symbolImage: Image.hedgeUI.stockThumbnailDemo,
                                title: store.state.stock.title,
                                description: "\(store.state.tradingPrice)원・\(store.state.tradingQuantity)주 \(store.state.tradeType == .buy ? "매수" : "매도")",
                                footnote: store.state.tradingDate,
                                buttonImage: Image.hedgeUI.pencil,
                                buttonImageOnTapped: nil
                            )
                            
                            Image.hedgeUI.tmpChart
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity)
                            
                            Rectangle()
                                .frame(height: 16)
                                .foregroundStyle(.clear)
                            
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $text)
                                    .focused($isFocused)
                                    .tint(.black)
                                    .font(FontModel.body3Medium)
                                    .foregroundStyle(Color.hedgeUI.textTitle)
                                    .scrollContentBackground(.hidden)
                                
                                if text.isEmpty && !isFocused {
                                    Text("매매 근거를 작성해보세요")
                                        .font(FontModel.body3Medium)
                                        .foregroundStyle(Color.hedgeUI.textAssistive)
                                        .frame(maxWidth: .infinity, minHeight: 100, alignment: .topLeading)
                                        .allowsHitTesting(false)
                                        .offset(x: 8, y: 8) // UITextView 기본 textContainerInset 값
                                }
                            }
                            .onTapGesture {
                                isFocused = true
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, -8)
                            .id("textEditorArea") // TextEditor 영역에 ID 부여
                        }
                    }
                    .onChange(of: text) { _, newValue in
                        if isFocused && !newValue.isEmpty {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                proxy.scrollTo("textEditorArea", anchor: .bottom)
                            }
                        }
                    }
                }
            }
            .padding(.zero)
            .onTapGesture {
                isFocused = false
            }
            
            VStack(spacing: 0) {
                Spacer()
                
                FloatingToolbar(selectedButton: $store.state.selectedButton) { selectedType in
                    switch selectedType {
                    case .generate:
                        break
                    case .emotion:
                        store.send(.inner(.emotionShowTapped))
                    case .checklist:
                        store.send(.inner(.checklistShowTapped))
                    }
                }
            }
            
            VStack(spacing: 0) {
                Spacer()
                
                if let selectedButton = store.state.selectedButton {
                    switch selectedButton {
                    case .generate:
                        AIGenerateView(date: store.state.tradingDate, contents: .constant("")) {
                            store.send(.inner(.aiGenerateCloseTapped))
                        }
                        .padding(.horizontal, 10)
                    case .emotion:
                        HedgeBottomSheet(
                            isPresented: $store.state.isEmotionShow,
                            title: "당시 어떤 감정이었나요?",
                            primaryTitle: "기록하기",
                            onPrimary: {
                                store.send(.inner(.emotionSelected(store.state.emotionSelection)))
                            }
                        ) {
                            EmotionBottomSheet(selection: $store.state.emotionSelection) // middle-only
                        }
                    case .checklist:
                        HedgeBottomSheet(
                            isPresented: $store.state.isChecklistShow,
                            title: "투자 원칙",
                            primaryTitle: "기록하기",
                            onPrimary: {
                                store.send(.inner(.checklistSelected(store.state.checkedItems)))
                            }
                        ) { 
                            ChecklistContent(
                                checked: $store.state.checkedItems, 
                                items: [
                                    "주가가 오르는 흐름이면 매수, 하락 흐름이면 매도하기",
                                    "기업의 본질 가치보다 낮게 거래되는 주식을 찾아 장기 보유하기",
                                    "단기 등락에 흔들리지 말고 기업의 장기 성장성에 집중하기",
                                    "분산 투자 원칙을 지키고 감정적 결정을 피하기",
                                    "리스크를 관리하며 손절 기준을 미리 정해두기"
                                ]
                            ) 
                        }
                    }
                }
            }
        }
        .onAppear {
            store.send(.view(.onAppear))
        }
    }
}

//#Preview {
//    TradeReasonInputView(store: .init(
//        initialState: TradeReasonFeature.State(
//            tradeType: .sell,
//            stock: StockSearch(symbol: "005930", title: "삼성전자", market: "KOSPI"),
//            tradingPrice: "70,000",
//            tradingQuantity: "10",
//            tradingDate: "2025년 9월 26일",
//            yield: "+10%"
//        ),
//        reducer: {
//            TradeReasonFeature(coordinator: DefaultTradeReasonCoordinator(
//                navigationController: UINavigationController(),
//                tradeType: .sell,
//                stock: StockSearch(symbol: "005930", title: "삼성전자", market: "KOSPI"),
//                tradingPrice: "70,000",
//                tradingQuantity: "10",
//                tradingDate: "2025년 9월 26일",
//                yield: "+10%"
//            ))
//        }
//    ))
//}
