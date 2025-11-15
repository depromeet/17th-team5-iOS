import Foundation
import SwiftUI

import ComposableArchitecture

import PrincipleDetailFeatureInterface
import PrinciplesDomainInterface
import DesignKit
import Core
import Kingfisher

@ViewAction(for: PrincipleDetailFeature.self)
public struct PrincipleDetailView: View {
    
    @Bindable public var store: StoreOf<PrincipleDetailFeature>
    @State private var imageLoadFailed: Bool = false
    
    public init(store: StoreOf<PrincipleDetailFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            Color.hedgeUI.backgroundWhite
                .background(Color.hedgeUI.brandSecondary)
            
            VStack(spacing: 0) {
                HedgeNavigationBar(buttonText: "", onLeftButtonTap: {
                    send(.backButtonTapped)
                })
                .background(Color.hedgeUI.brandSecondary)
                
                headerSection
                
                HedgeSpacer(height: 10)
                    .color(Color.hedgeUI.neutralBgDefault)
                
                principleListSection
                    .background(Color.hedgeUI.neutralBgDefault)
            }
        }
        .safeAreaInset(edge: .bottom) {
            if store.isRecommended {
                HedgeBottomCTAButton()
                    .state(.active)
                    .style(.oneButton(
                        title: "내 회고 템플릿에 추가하기",
                        onTapped: {
                            send(.addButtonTapped)
                        }))
            }
        }
        .onAppear {
            send(.onAppear)
        }
        .hedgeBottomSheet(
            isPresented: $store.state.isBottomModdalShown,
            title: "어떤 카테고리에 추가할까요?",
            maxHeight: 299) {
                VStack(spacing: 0) {
                    Button {
                        send(.buyButtonTapped)
                    } label: {
                        HStack {
                            Text("매수")
                                .font(FontModel.body3Semibold)
                                .foregroundStyle(Color.hedgeUI.textPrimary)
                            Spacer()
                            Image.hedgeUI.check
                                .renderingMode(.template)
                                .foregroundStyle(
                                    store.state.selectedTradeType == .buy
                                        ? Color.hedgeUI.brandDarken
                                        : Color.hedgeUI.textPrimary
                                )
                        }
                        .padding(.vertical, 12)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                    }

                    Button {
                        send(.sellButtonTapped)
                    } label: {
                        HStack {
                            Text("매도")
                                .font(FontModel.body3Semibold)
                                .foregroundStyle(Color.hedgeUI.textPrimary)
                            Spacer()
                            Image.hedgeUI.check
                                .renderingMode(.template)
                                .foregroundStyle(
                                    store.state.selectedTradeType == .sell
                                        ? Color.hedgeUI.brandDarken
                                        : Color.hedgeUI.textPrimary
                                )
                        }
                        .padding(.vertical, 12)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                    }
                    
                    HedgeBottomCTAButton()
                        .state(store.state.selectedTradeType != nil ? .active : .disabled)
                        .style(
                            .oneButton(
                                title: "선택",
                                onTapped: {
                                    send(.selectButtonTapped)
                                }))
                }
            }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 썸네일
            Circle()
                .fill(Color.hedgeUI.neutralBgSecondary)
                .frame(width: 56, height: 56)
                .overlay {
                    if imageLoadFailed || URL(string: store.state.principleGroup.thumbnail) == nil {
                        Text(store.state.principleGroup.thumbnail)
                            .font(FontModel.h1Semibold)
                    } else {
                        KFImage(URL(string: store.state.principleGroup.thumbnail))
                            .onFailure { _ in
                                imageLoadFailed = true
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: 56, height: 56)
                            .clipShape(Circle())
                    }
                }
            
            // 그룹 이름
            Text(store.state.principleGroup.groupName)
                .font(FontModel.h1Semibold)
                .foregroundStyle(Color.hedgeUI.textTitle)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 44)
        .padding(.bottom, 30)
        .background(Color.hedgeUI.brandSecondary)
    }
    
    // MARK: - Principle List Section
    private var principleListSection: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(Array(store.state.principleGroup.principles.enumerated()), id: \.element.id) { index, principle in
                    principleItemView(
                        index: index + 1,
                        principle: principle
                    )
                    
                    if index < store.state.principleGroup.principles.count - 1 {
                        Rectangle()
                            .fill(Color.hedgeUI.neutralBgSecondary)
                            .frame(height: 1)
                            .padding(.leading, 20)
                    }
                }
            }
        }
    }
    
    // MARK: - Principle Item View
    private func principleItemView(index: Int, principle: Principle) -> some View {
        HStack(alignment: .top, spacing: 8) {
            // 번호
            Text("\(index)")
                .font(FontModel.body3Semibold)
                .foregroundStyle(Color.hedgeUI.brandPrimary)
            
            // 원칙 내용
            VStack(alignment: .leading, spacing: 6) {
                // 제목
                Text(principle.principle)
                    .font(FontModel.body2Semibold)
                    .foregroundStyle(Color.hedgeUI.textPrimary)
                
                // 설명
                Text(principle.description)
                    .font(FontModel.body3Regular)
                    .foregroundStyle(Color.hedgeUI.textPrimary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(Color.hedgeUI.backgroundWhite)
    }
}
