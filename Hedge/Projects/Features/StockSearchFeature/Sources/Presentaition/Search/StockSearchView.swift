//
//  StockSearchView.swift
//  StockSearchFeature
//
//  Created by Junyoung on 9/14/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

import StockSearchFeatureInterface
import DesignKit
import Core

@ViewAction(for: StockSearchFeature.self)
public struct StockSearchView: View {
    @Bindable public var store: StoreOf<StockSearchFeature>
    
    public init(store: StoreOf<StockSearchFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            navigationBar
            guideText
            searchTextField
            if store.stocks.isEmpty {
                emptyErrorView
            } else {
                retrospectTitle
                stockListView
            }
            Spacer()
        }
        .onAppear {
            send(.onAppear)
        }
    }
    
    private var navigationBar: some View {
        HedgeNavigationBar(buttonText: "", onLeftButtonTap: {
            send(.backButtonTapped)
        })
    }
    
    private var guideText: some View {
        HStack {
            Text("어떤 종목을 회고할까요?")
                .font(.h1Semibold)
                .foregroundStyle(Color.hedgeUI.grey900)
            
            Spacer()
        }
        .padding(.top, 16)
        .padding(.bottom, 10)
        .padding(.horizontal, 20)
        .frame(height: 56)
    }
    
    private var searchTextField: some View {
        HedgeSearchTextField(
            placeholder: "종목 검색",
            text: $store.searchText
        )
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 16)
    }
    
    private var retrospectTitle: some View {
        HStack {
            Text("회고한 종목")
                .font(.body3Medium)
                .foregroundStyle(Color.hedgeUI.grey500)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var stockListView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(store.stocks, id: \.self) { stock in
                    StockRow(
                        logo: stock.logo,
                        companyName: stock.companyName
                    )
                    .onTapGesture {
                        send(.stockTapped(stock))
                    }
                }
            }
        }
    }
    
    private var emptyErrorView: some View {
        EmptyErrorView()
    }
}
