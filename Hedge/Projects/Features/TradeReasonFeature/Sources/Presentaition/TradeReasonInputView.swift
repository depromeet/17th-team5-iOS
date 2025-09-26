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
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 0) {
                HedgeNavigationBar(buttonText: "완료", onLeftButtonTap: {
                    store.send(.view(.backButtonTapped))
                }, onRightButtonTap:  {
                    store.send(.view(.nextTapped))
                })
                
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 0) {
                            HedgeTopView(
                                symbolImage: Image.hedgeUI.stockThumbnailDemo,
                                title: store.state.stock.title,
                                description: "\(store.state.tradeHistory.tradingPrice)・\(store.state.tradeHistory.tradingQuantity) \(store.state.tradeType == .buy ? "매수" : "매도")",
                                footnote: store.state.tradeHistory.tradingDate,
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
                        AIGenerateView(date: store.state.tradeHistory.tradingDate, contents: .constant("")) {
                            store.send(.inner(.aiGenerateCloseTapped))
                        }
                        .padding(.horizontal, 10)
                    case .emotion:
                        Text("!23")
                    case .checklist:
                        Text("123")
                    }
                }
            }
        }
        .onAppear {
            store.send(.view(.onAppear))
        }
    }
}
