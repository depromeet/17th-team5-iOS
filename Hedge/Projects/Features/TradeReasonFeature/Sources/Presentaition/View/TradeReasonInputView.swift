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
import Core

import PrinciplesFeatureInterface

struct TradeReasonInputView: View {
    
    @StateObject var container: MVIContainer<TradeReasonIntentProtocol, TradeReasonModelProtocol>
    
    private var intent: TradeReasonIntentProtocol { container.intent }
    private var state: TradeReasonModelProtocol { container.model }
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 0) {
                HedgeNavigationBar(buttonText: "완료", onLeftButtonTap: {
                    intent.backButtonTapped()
                }, onRightButtonTap:  {
                    intent.nextTapped()
                })
                
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 0) {
                            HedgeTopView(
                                symbolImage: Image.hedgeUI.stockThumbnailDemo,
                                title: state.stock.title,
                                description: "\(state.tradeHistory.tradingPrice)・\(state.tradeHistory.tradingQuantity) \(state.tradeType == .buy ? "매수" : "매도")",
                                footnote: state.tradeHistory.tradingDate,
                                buttonImage: Image.hedgeUI.pencil,
                                buttonImageOnTapped: nil
                            )
                            
                            Image.hedgeUI.tmpChart
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity)
                            
                            
                            if !state.checkedItems.isEmpty || state.emotion != nil {
                                Rectangle()
                                    .frame(height: 16)
                                    .foregroundStyle(.clear)
                                
                                HStack(spacing: 8) {
                                    if let emotion = state.emotion {
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
                                    
                                    if !state.checkedItems.isEmpty {
                                        HStack(spacing: 4) {
                                            Image.hedgeUI.principleSimple
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                            
                                            Text("지킨 원칙 \(state.checkedItems.count)개")
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
                                TextEditor(text: $container.model.text)
                                    .focused($isFocused)
                                    .tint(.black)
                                    .font(FontModel.body3Medium)
                                    .foregroundStyle(Color.hedgeUI.textTitle)
                                    .scrollContentBackground(.hidden)
                                
                                if state.text.isEmpty && !isFocused {
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
                    .onChange(of: state.text) { _, newValue in
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
                
                FloatingToolbar(selectedButton: $container.model.selectedButton) { selectedType in
                    switch selectedType {
                    case .generate:
                        break
                    case .emotion:
                        intent.emotionShowTapped()
                    case .checklist:
                        intent.checklistShowTapped()
                    }
                }
            }
            
            VStack(spacing: 0) {
                if !isFocused {
                    Spacer()
                }
                
                if let selectedButton = state.selectedButton {
                    switch selectedButton {
                    case .generate:
                        AIGenerateView(date: state.tradeHistory.tradingDate, contents: $container.model.contents) {
                            intent.aiGenerateCloseTapped()
                        }
                        .padding(.horizontal, 10)
                    default:
                        EmptyView()
                    }
                }
                
                if isFocused {
                    Spacer()
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: isFocused)
        .onAppear {
            intent.onAppear()
        }
        .hedgeBottomSheet(isPresented: $container.model.isEmotionShow) {
            EmotionBottomSheet(selection: $container.model.emotionSelection) // middle-only
        }
        .hedgeBottomSheet(isPresented: $container.model.isChecklistShow, ratio: 0.8) {
            AnyView(
                state.principleBuilder.buildView(
                    principles: $container.model.principles,
                    selectedPrinciples: $container.model.checkedItems
                )
            )
        }
    }
}
