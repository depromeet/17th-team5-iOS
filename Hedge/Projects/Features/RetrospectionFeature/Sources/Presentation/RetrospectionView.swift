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
import LinkDomainInterface
import DesignKit
import Kingfisher
import Core

public struct RetrospectionView: View {
    
    @State private var currentPageIndex: Int = 0
    
    // TODO: 실제 데이터로 교체 필요
    private let mockStockName = "삼성전자"
    private let mockReturnRate = "+32%"
    private let mockTradingPrice = "85,000원"
    private let mockTradingQuantity = "8주"
    private let mockTradeType = "매도"
    private let mockTradingDate = "2025년 9월 14일"
    private let mockBadgeLevel = "실버"
    private let totalPages = 5
    private let mockPrinciple = "종목 선택 시 최근 매출액 확인하기"
    private let mockEvaluation = "지켰어요"
    private let mockReason = "눌림목 나올 때 분할 매수했다가 트럼프 말 때문에 지금장 나락가서.. 참으로 불안하네... \n\n눌림목 나올때 분할 매수하는게 맞을까?"
    
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
    }
    
    // MARK: - Navigation Bar
    private var navigationBar: some View {
        HedgeNavigationBar(
            title: nil,
            buttonText: "삭제",
            state: .disabled,
            onLeftButtonTap: {
            // 뒤로가기
            },
            onRightButtonTap: {
            // 삭제
        }
        )
    }
    
    // MARK: - Top Section
    private var topSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            // 종목 정보
            HStack(spacing: 4) {
                Image.hedgeUI.stockThumbnailDemo
                    .resizable()
                    .frame(width: 22, height: 22)
                
                Rectangle()
                    .frame(width: 4)
                    .foregroundStyle(Color.clear)
                
                Text(mockStockName)
                    .foregroundStyle(Color.hedgeUI.textTitle)
                    .font(FontModel.body3Medium)
                
                Text(mockReturnRate)
                    .foregroundStyle(Color.hedgeUI.tradeBuy)
                    .font(FontModel.body3Semibold)
            }
            
            // 거래 정보
            Text("\(mockTradingPrice)・\(mockTradingQuantity) \(mockTradeType)")
                .foregroundStyle(Color.hedgeUI.textTitle)
                .font(FontModel.h1Semibold)
            
            // 날짜
            Text(mockTradingDate)
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
            Image.hedgeUI.silverBadge
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
            // TODO: AI 피드백 화면으로 이동
        }
    }
    
    // MARK: - 페이지 인디케이터
    private var pageIndicatorView: some View {
        HStack(spacing: 0) {
            Text("\(currentPageIndex + 1)")
                .foregroundStyle(Color.hedgeUI.brandDarken)
                .font(FontModel.label1Semibold)
            
            Text("/\(totalPages)")
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
            
            Text("여기에 원칙 그룹 타이틀이 들어가요")
                .foregroundStyle(Color.hedgeUI.textAssistive)
                .font(FontModel.label2Medium)
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - 페이징 콘텐츠 섹션
    private var pagingContentSection: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(0..<totalPages, id: \.self) { index in
                            VStack(spacing: 0) {
                                principleSection(for: index)
                                
                                HedgeSpacer(height: 16)
                                
                                reasonSection(for: index)
                                
                                HedgeSpacer(height: 24)
                                
                                imageSection(for: index)
                                
                                HedgeSpacer(height: 16)
                                
                                linkSection(for: index)
                            }
                            .frame(width: geometry.size.width)
                            .id(index)
                        }
                    }
                    .background(
                        GeometryReader { scrollGeometry in
                            Color.clear
                                .preference(
                                    key: ScrollOffsetPreferenceKey.self,
                                    value: scrollGeometry.frame(in: .named("scroll")).minX
                                )
                        }
                    )
                }
                .coordinateSpace(name: "scroll")
                .scrollTargetBehavior(.paging)
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
                    let pageWidth = geometry.size.width
                    let newPageIndex = Int(round(-offset / pageWidth))
                    let clampedIndex = max(0, min(newPageIndex, totalPages - 1))
                    if clampedIndex != currentPageIndex {
                        currentPageIndex = clampedIndex
                    }
                }
                .onChange(of: currentPageIndex) { _, newValue in
                    withAnimation {
                        proxy.scrollTo(newValue, anchor: .leading)
                    }
                }
            }
        }
        .frame(height: calculatePagingContentHeight())
    }
    
    // MARK: - Scroll Offset Preference Key
    private struct ScrollOffsetPreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
    
    // MARK: - 원칙 섹션
    private func principleSection(for index: Int) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top, spacing: 0) {
                Text(mockPrinciple)
                    .foregroundStyle(Color.hedgeUI.textTitle)
                    .font(FontModel.body1Semibold)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .layoutPriority(1)
                
                Spacer()
            }
            
            // 평가 상태 표시
            HStack(alignment: .center, spacing: 4) {
                Image.hedgeUI.keep
                    .resizable()
                    .frame(width: 18, height: 18)
                
                Text(mockEvaluation)
                    .foregroundStyle(Color.hedgeUI.brandDarken)
                    .font(FontModel.body3Semibold)
            }
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - 이유 섹션
    private func reasonSection(for index: Int) -> some View {
        Text(mockReason)
            .foregroundStyle(Color.hedgeUI.textPrimary)
            .font(FontModel.body3Regular)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - 이미지 섹션
    private func imageSection(for index: Int) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 12) {
                Rectangle()
                    .fill(Color.hedgeUI.neutralBgSecondary)
                    .frame(width: 120, height: 120)
                    .cornerRadius(18)
                    .overlay {
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(lineWidth: 1)
                            .foregroundStyle(Color.hedgeUI.neutralBgSecondary)
                    }
                
                Rectangle()
                    .fill(Color.hedgeUI.neutralBgSecondary)
                    .frame(width: 120, height: 120)
                    .cornerRadius(18)
                    .overlay {
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(lineWidth: 1)
                            .foregroundStyle(Color.hedgeUI.neutralBgSecondary)
                    }
                
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
        .padding(.leading, 20)
    }
    
    // MARK: - 링크 섹션
    private func linkSection(for index: Int) -> some View {
        VStack(spacing: 12) {
            // 링크 카드 1
            linkCard(
                imageURL: nil,
                title: "다시 고개 든 미중 무역 전쟁 우려 나스닥 3.6% 폭락",
                source: "naver.com"
            )
            
            // 링크 카드 2
            linkCard(
                imageURL: nil,
                title: "9만 전자 돌파한 삼성전자, 10만 전자 찍을 수 있을까",
                source: "naver.com"
            )
        }
        .padding(.horizontal, 20)
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

#Preview {
    RetrospectionView()
}
