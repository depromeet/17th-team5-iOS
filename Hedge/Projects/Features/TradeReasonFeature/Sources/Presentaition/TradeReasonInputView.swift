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
                            
                            
                            if !store.state.checkedItems.isEmpty || store.state.emotion != nil {
                                Rectangle()
                                    .frame(height: 16)
                                    .foregroundStyle(.clear)
                                
                                HStack(spacing: 8) {
                                    if let emotion = store.state.emotion {
                                        HStack(spacing: 4) {
                                            emotion.simpleImage
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                            
                                            Text(emotion.value)
                                                .font(FontModel.caption1Semibold)
                                                .foregroundStyle(Color.hedgeUI.textTitle)
                                        }
                                        .padding(.vertical, 8)
                                        .padding(.leading, 6)
                                        .padding(.trailing, 8)
                                        .background(Color.hedgeUI.neutralBgSecondary)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                    
                                    if !store.state.checkedItems.isEmpty {
                                        HStack(spacing: 4) {
                                            Image.hedgeUI.principleSimple
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                            
                                            Text("지킨 원칙 \(store.state.checkedItems.count)개")
                                                .font(FontModel.caption1Semibold)
                                                .foregroundStyle(Color.hedgeUI.textTitle)
                                        }
                                        .padding(.vertical, 8)
                                        .padding(.leading, 6)
                                        .padding(.trailing, 8)
                                        .background(Color.hedgeUI.neutralBgSecondary)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                
                                Rectangle()
                                    .frame(height: 12)
                                    .foregroundStyle(.clear)
                                
                            } else {
                                Rectangle()
                                    .frame(height: 16)
                                    .foregroundStyle(.clear)
                            }
                            
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $store.state.text)
                                    .focused($isFocused)
                                    .tint(.black)
                                    .font(FontModel.body3Medium)
                                    .foregroundStyle(Color.hedgeUI.textTitle)
                                    .scrollContentBackground(.hidden)
                                
                                if store.state.text.isEmpty && !isFocused {
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
                    .onChange(of: store.state.text) { _, newValue in
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
                        AIGenerateView(date: store.state.tradeHistory.tradingDate, contents: .constant(nil)) {
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
                            },
                            onClose: {
                                store.send(.inner(.emotionCloseTapped))
                            }, content: {
                                EmotionBottomSheet(selection: $store.state.emotionSelection) // middle-only
                            })
                        
                    case .checklist:
                        HedgeBottomSheet(
                            isPresented: $store.state.isChecklistShow,
                            title: "투자 원칙",
                            primaryTitle: "기록하기",
                            onPrimary: {
                                store.send(.inner(.checkListApproveTapped))
                            },
                            onClose: {
                                store.send(.inner(.checklistCloseTapped))
                            }, content: {
                                PrinciplesView(selectedPrinciples: $store.state.checkedItems,
                                               principles: $store.state.principles)
                                { selected in
                                    store.send(.inner(.checklistTapped(id: selected)))
                                }
                            })
                    }
                }
            }
        }
        .onAppear {
            store.send(.view(.onAppear))
        }
    }
}
