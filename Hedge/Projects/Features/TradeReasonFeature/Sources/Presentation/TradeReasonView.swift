//
//  TradeReasonView.swift
//  TradeReasonFeature
//
//  Created by Dongjoo Lee on 9/23/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignKit
import TradeReasonFeatureInterface
import StockDomainInterface

@ViewAction(for: TradeReasonFeature.self)
public struct TradeReasonView: View {
    @Bindable public var store: StoreOf<TradeReasonFeature>
    
    public init(store: StoreOf<TradeReasonFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HedgeNavigationBar(
                buttonText: "완료",
                onLeftButtonTap: {
                    send(.backButtonTapped)
                }
            )
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 0) {
                        HedgeTopView(
                            symbolImage: Image.hedgeUI.buyDemo,
                            title: store.stock.title,
                            description: "65,000원・3주 \(store.tradeType.rawValue)",
                            footnote: "2025년 8월 25일",
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
                            TextEditor(text: $store.reasonText)
                                .tint(.black)
                                .font(FontModel.body3Medium)
                                .foregroundStyle(Color.hedgeUI.textTitle)
                                .scrollContentBackground(.hidden)
                            
                            if store.reasonText.isEmpty {
                                Text("매매 근거를 작성해보세요")
                                    .font(FontModel.body3Medium)
                                    .foregroundStyle(Color.hedgeUI.textAssistive)
                                    .frame(maxWidth: .infinity, minHeight: 100, alignment: .topLeading)
                                    .allowsHitTesting(false)
                                    .offset(x: 8, y: 8)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, -8)
                        .id("textEditorArea")
                    }
                }
            }
            
            HedgeBottomCTAButton()
                .style(
                    .oneButton(
                        title: "다음",
                        onTapped: {
                            send(.nextTapped)
                        }
                    )
                )
                .bg(.transparent)
        }
        .onAppear {
            send(.onAppear)
        }
    }
}

#Preview {
    TradeReasonView(store: .init(
        initialState: TradeReasonFeature.State(
            tradeType: .sell,
            stock: StockSearch(symbol: "005930", title: "삼성전자", market: "KOSPI"),
            tradingPrice: "70,000",
            tradingQuantity: "10",
            tradingDate: "2025년 9월 26일",
            yield: "+10%"
        ),
        reducer: {
            TradeReasonFeature(coordinator: DefaultTradeReasonCoordinator(
                navigationController: UINavigationController(),
                tradeType: .sell,
                stock: StockSearch(symbol: "005930", title: "삼성전자", market: "KOSPI"),
                tradingPrice: "70,000",
                tradingQuantity: "10",
                tradingDate: "2025년 9월 26일",
                yield: "+10%"
            ))
        }
    ))
}
