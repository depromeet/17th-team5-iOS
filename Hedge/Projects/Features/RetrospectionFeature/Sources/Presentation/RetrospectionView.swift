//
//  RetrospectionView.swift
//  RetrospectionFeature
//
//  Created by 이중엽 on 11/13/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation
import SwiftUI
import PhotosUI

import ComposableArchitecture
import RetrospectionFeatureInterface
import LinkDomainInterface
import DesignKit
import Kingfisher
import Core

@ViewAction(for: RetrospectionFeature.self)
public struct RetrospectionView: View {
    
    @Bindable public var store: StoreOf<RetrospectionFeature>
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                navigationBar
                
                topSection
                
                HedgeSpacer(height: 4)
                
                aiFeedbackButton
                
                HedgeSpacer(height: 32)
                
                pageIndicatorView
                
                HedgeSpacer(height: 16)
                
                // 페이징 영역
                pagingContentSection
            }
        }
        .background(Color.hedgeUI.backgroundWhite)
        .onAppear {
            send(.onAppear)
        }
        .overlay(alignment: .bottom) {
            // 하단 페이징 인디케이터 (맨 앞 레이어)
            if store.state.totalPages > 1 {
                bottomPageIndicatorView
                    .allowsHitTesting(false) // 터치 이벤트는 TabView로 전달
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }
    
    // MARK: - Navigation Bar
    private var navigationBar: some View {
        HedgeNavigationBar(
            title: nil,
            buttonText: "삭제",
            color: .secondary,
            state: .active,
            onLeftButtonTap: {
                send(.backButtonTapped)
            },
            onRightButtonTap: {
                send(.deleteButtonTapped)
            }
        )
    }
    
    // MARK: - Top Section
    private var topSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            // 종목 정보
            HStack(spacing: 4) {
                if let logo = store.state.stockLogo,
                   let url = URL(string: logo) {
                    KFImage(url)
                        .resizable()
                        .frame(width: 22, height: 22)
                } else {
                    Image.hedgeUI.stockThumbnailDemo
                        .resizable()
                        .frame(width: 22, height: 22)
                }
                
                Rectangle()
                    .frame(width: 4)
                    .foregroundStyle(Color.clear)
                
                Text(store.state.stockName)
                    .foregroundStyle(Color.hedgeUI.textTitle)
                    .font(FontModel.body3Medium)
                
                if !store.state.returnRate.isEmpty {
                    Text(store.state.returnRate)
                        .foregroundStyle(Color.hedgeUI.tradeBuy)
                        .font(FontModel.body3Semibold)
                }
            }
            
            // 거래 정보
            Text("\(store.state.tradingPrice)・\(store.state.tradingQuantity) \(store.state.tradeType.rawValue)")
                .foregroundStyle(Color.hedgeUI.textTitle)
                .font(FontModel.h1Semibold)
            
            // 날짜
            Text(store.state.tradingDate)
                .foregroundStyle(Color.hedgeUI.textAlternative)
                .font(FontModel.label2Regular)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    // MARK: - AI 피드백 보기 버튼
    private var aiFeedbackButton: some View {
        HStack(spacing: 8) {
            // 뱃지 이미지
            badgeImage
                .resizable()
                .frame(width: 25, height: 24)
            
            Text("AI 피드백 보기")
                .foregroundStyle(Color.hedgeUI.textSecondary)
                .font(FontModel.label1Medium)
            
            Spacer()
            
            Image.hedgeUI.arrowRightThin
                .renderingMode(.template)
                .foregroundStyle(Color.hedgeUI.textAssistive)
        }
        .padding(.leading, 14)
        .padding(.trailing, 10)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.hedgeUI.neutralBgSecondary)
        )
        .padding(.horizontal, 16)
        .onTapGesture {
            send(.aiFeedbackButtonTapped)
        }
    }
    
    private var badgeImage: Image {
        switch store.state.badgeLevel {
        case .emerald: return Image.hedgeUI.emerald
        case .gold: return Image.hedgeUI.gold
        case .silver: return Image.hedgeUI.silver
        case .bronze: return Image.hedgeUI.bronze
        }
    }
    
    // MARK: - 페이지 인디케이터
    private var pageIndicatorView: some View {
        HStack(spacing: 0) {
            Text("\(store.state.currentPageIndex + 1)")
                .foregroundStyle(Color.hedgeUI.brandDarken)
                .font(FontModel.label1Semibold)
            
            Text("/\(store.state.totalPages)")
                .foregroundStyle(Color.hedgeUI.textAssistive)
                .font(FontModel.label1Medium)
            
            Rectangle()
                .frame(width: 6)
                .foregroundStyle(Color.clear)
            
            Rectangle()
                .frame(width: 1, height: 12)
                .foregroundStyle(Color.hedgeUI.textDisabled)
            
            Rectangle()
                .frame(width: 6)
                .foregroundStyle(Color.clear)
            
            Text(store.state.principleGroupTitle)
                .foregroundStyle(Color.hedgeUI.textAssistive)
                .font(FontModel.label2Medium)
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - 페이징 콘텐츠 섹션
    private var pagingContentSection: some View {
        TabView(selection: Binding(
            get: { store.state.currentPageIndex },
            set: { newValue in
                send(.pageChanged(newValue))
            }
        )) {
            ForEach(0..<store.state.totalPages, id: \.self) { index in
                ScrollView {
                    VStack(spacing: 0) {
                        principleSection(for: index)
                        
                        HedgeSpacer(height: 16)
                        
                        reasonSection(for: index)
                        
                        HedgeSpacer(height: 24)
                        
                        imageSection(for: index)
                        
                        HedgeSpacer(height: 16)
                        
                        linkSection(for: index)
                    }
                }
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: calculatePagingContentHeight())
    }
    
    // MARK: - 원칙 섹션
    private func principleSection(for index: Int) -> some View {
        guard index < store.state.principlePages.count else {
            return AnyView(EmptyView())
        }
        
        let page = store.state.principlePages[index]
        
        return AnyView(
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .top, spacing: 0) {
                    Text(page.principle)
                        .foregroundStyle(Color.hedgeUI.textTitle)
                        .font(FontModel.body1Semibold)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .layoutPriority(1)
                    
                    Spacer()
                }
                
                // 평가 상태 표시
                HStack(alignment: .center, spacing: 4) {
                    page.evaluation.selectedImage
                        .resizable()
                        .frame(width: 18, height: 18)
                    
                    Text(page.evaluation.title)
                        .foregroundStyle(Color.hedgeUI.brandDarken)
                        .font(FontModel.body3Semibold)
                }
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
        )
    }
    
    // MARK: - 이유 섹션
    private func reasonSection(for index: Int) -> some View {
        guard index < store.state.principlePages.count else {
            return AnyView(EmptyView())
        }
        
        let page = store.state.principlePages[index]
        
        return AnyView(
            Text(page.reason)
                .foregroundStyle(Color.hedgeUI.textPrimary)
                .font(FontModel.body3Regular)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
        )
    }
    
    // MARK: - 이미지 섹션
    private func imageSection(for index: Int) -> some View {
        guard index < store.state.principlePages.count else {
            return AnyView(EmptyView())
        }
        
        let page = store.state.principlePages[index]
        
        return AnyView(
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 12) {
                    ForEach(page.imageURLs, id: \.self) { imageURL in
                        if let url = URL(string: imageURL) {
                            KFImage(url)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 120)
                                .clipped()
                                .cornerRadius(18)
                        } else {
                            Rectangle()
                                .fill(Color.hedgeUI.neutralBgSecondary)
                                .frame(width: 120, height: 120)
                                .cornerRadius(18)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(lineWidth: 1)
                                        .foregroundStyle(Color.hedgeUI.neutralBgSecondary)
                                }
                        }
                    }
                }
            }
            .padding(.leading, 20)
        )
    }
    
    // MARK: - 링크 섹션
    private func linkSection(for index: Int) -> some View {
        guard index < store.state.principlePages.count else {
            return AnyView(EmptyView())
        }
        
        let page = store.state.principlePages[index]
        
        return AnyView(
            VStack(spacing: 12) {
                ForEach(Array(page.links.enumerated()), id: \.offset) { _, link in
                    linkCard(
                        imageURL: link.imageURL,
                        title: link.title,
                        source: link.newsSource
                    )
                }
            }
            .padding(.horizontal, 20)
        )
    }
    
    // MARK: - 하단 페이징 인디케이터
    private var bottomPageIndicatorView: some View {
        HStack(spacing: 8) {
            ForEach(0..<store.state.totalPages, id: \.self) { index in
                Circle()
                    .fill(index == store.state.currentPageIndex ? Color.hedgeUI.brandPrimary : Color.hedgeUI.brandDisabled)
                    .frame(width: 6, height: 6)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 22)
        .background(
            RoundedRectangle(cornerRadius: 29)
                .fill(Color.hedgeUI.textAlternative)
                .shadow(
                    color: Color.black.opacity(0.08),
                    radius: 20,
                    x: 0,
                    y: 6
                )
        )
        .padding(.bottom, 32)
    }
    
    // MARK: - 페이징 콘텐츠 높이 계산
    private func calculatePagingContentHeight() -> CGFloat {
        // 대략적인 높이 계산 (실제 콘텐츠에 맞게 조정 필요)
        return 600
    }
    
    // MARK: - 링크 카드
    private func linkCard(imageURL: String?, title: String, source: String) -> some View {
        HStack(alignment: .center, spacing: 16) {
            // 이미지
            if let imageURL = imageURL,
               let url = URL(string: imageURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.hedgeUI.neutralBgSecondary)
                }
                .frame(width: 98, height: 98)
                .clipped()
                .cornerRadius(8)
            } else {
                Rectangle()
                    .fill(Color.hedgeUI.neutralBgSecondary)
                    .frame(width: 98, height: 98)
                    .cornerRadius(8)
            }
            
            // 텍스트 정보
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(FontModel.label2Semibold)
                    .foregroundStyle(Color.hedgeUI.textPrimary)
                    .lineLimit(2)
                
                Text(source)
                    .font(FontModel.caption1Medium)
                    .foregroundStyle(Color.hedgeUI.textAlternative)
            }
            
            Spacer()
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.hedgeUI.backgroundWhite)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.hedgeUI.neutralBgSecondary, lineWidth: 1.2)
        )
    }
}

// #Preview {
//     RetrospectionView(
//         store: Store(
//             initialState: RetrospectionFeature.State(),
//             reducer: {
//                 RetrospectionFeature(coordinator: PreviewRetrospectionCoordinator())
//             }
//         )
//     )
// }
// 
// private class PreviewRetrospectionCoordinator: RetrospectionCoordinator {
//     var navigationController: UINavigationController = .init()
//     var childCoordinators: [Coordinator] = []
//     var type: CoordinatorType = .retrospection
//     weak var parentCoordinator: RootCoordinator?
//     weak var finishDelegate: CoordinatorFinishDelegate?
//     
//     func start() {}
//     func popToPrev() {}
// }
