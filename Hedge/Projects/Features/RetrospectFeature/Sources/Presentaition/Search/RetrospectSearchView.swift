//
//  RetrospectSearchView.swift
//  RetrospectFeature
//
//  Created by Junyoung on 9/14/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

import RetrospectFeatureInterface
import DesignKit

@ViewAction(for: RetrospectSearchFeature.self)
public struct RetrospectSearchView: View {
    @Bindable public var store: StoreOf<RetrospectSearchFeature>
    
    public init(store: StoreOf<RetrospectSearchFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            navigationBar
            guideText
            searchTextField
            retrospectTitle
            Spacer()
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
}
