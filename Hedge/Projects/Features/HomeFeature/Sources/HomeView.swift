//
//  HomeView.swift
//  HomeFeature
//
//  Created by Dongjoo on 9/14/25.
//  Copyright © 2025 depromeet. All rights reserved.
//

import SwiftUI

import DesignKit
import HomeFeatureInterface
import Core
import Shared
import TradeDomainInterface

import ComposableArchitecture

// MARK: - Color Extension for Hex Support
// Using Color(hex:) from DesignKit module

// MARK: - Stock List with Gradient
private struct StockListWithGradient<Content: View>: View {
    let stocks: [HomeFeature.StockInfo]
    @ViewBuilder let content: (HomeFeature.StockInfo) -> Content
    
    @State private var contentHeight: CGFloat = 0
    @State private var scrollOffset: CGFloat = 0
    
    private let scrollViewHeight: CGFloat = 548 // Fixed height from Figma
    
    private var isScrollable: Bool {
        contentHeight > scrollViewHeight
    }
    
    private var showTopGradient: Bool {
        // Show gradient when list is scrollable (indicates more items above)
        // Only show when scrolled down from top
        isScrollable && scrollOffset > 5 // Small threshold to avoid flicker
    }
    
    private var showBottomGradient: Bool {
        // Show gradient when list is scrollable (indicates more items below)
        // Only hide when at the very bottom
        guard isScrollable else { return false }
        let maxScrollOffset = contentHeight - scrollViewHeight
        return scrollOffset < maxScrollOffset - 5 // Small threshold to avoid flicker
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(spacing: 12) { // gap: 12px
                        ForEach(stocks) { stock in
                            content(stock)
                        }
                    }
                    .padding(.vertical, 12)
                    .background(
                        GeometryReader { contentGeo in
                            Color.clear
                                .preference(
                                    key: ScrollOffsetPreferenceKey.self,
                                    value: -contentGeo.frame(in: .named("scroll")).minY
                                )
                                .preference(
                                    key: ContentHeightPreferenceKey.self,
                                    value: contentGeo.size.height
                                )
                        }
                    )
                }
                .scrollBounceBehavior(.basedOnSize) // Don't scroll past content
                .coordinateSpace(name: "scroll")
                .background(Color.hedgeUI.backgroundWhite)
                .frame(width: 118) // width: 118px
                .clipped()
                .onPreferenceChange(ContentHeightPreferenceKey.self) { height in
                    contentHeight = height
                }
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
                    scrollOffset = max(0, offset) // Clamp to 0 or positive
                }
                
                // Gradient overlays - only shows when content is scrollable
                VStack(spacing: 0) {
                    // Top gradient: at the very top edge, only shows when scrolled
                    if showTopGradient {
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color.white.opacity(0), location: 0.0), // Transparent at top edge
                                .init(color: Color.white.opacity(0), location: 0.269), // -26.89% still transparent
                                .init(color: Color.white, location: 0.8786), // 87.86% - becomes white
                                .init(color: Color.white, location: 1.0) // Fully white
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 120)
                    }
                    
                    Spacer()
                    
                    // Bottom gradient: only shows when not scrolled to bottom
                    if showBottomGradient {
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color.white, location: 0.0), // White
                                .init(color: Color.white, location: 0.1214), // Still white
                                .init(color: Color.white.opacity(0), location: 0.7301), // Fade starts
                                .init(color: Color.white.opacity(0), location: 1.0) // Transparent at bottom edge
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 120)
                    }
                }
                .allowsHitTesting(false) // Allow taps to pass through
            }
        }
        .frame(width: 118, height: 548) // Fixed dimensions from Figma
    }
}

// PreferenceKey for tracking scroll offset
// Single emitter - intentional overwrite
private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue() // Single emitter per scroll view - overwrite is intentional
    }
}

// PreferenceKey for tracking content height
// Single emitter - intentional overwrite
private struct ContentHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue() // Single emitter per scroll view - overwrite is intentional
    }
}

@ViewAction(for: HomeFeature.self)
public struct HomeView: View {
    
    @Bindable public var store: StoreOf<HomeFeature>
    
    public init(store: StoreOf<HomeFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            // Background - consistent white throughout
            Color.hedgeUI.backgroundWhite
                .ignoresSafeArea()
                .onAppear {
                    send(.onAppear)
                }
            
            // Main content - restructured to allow shadow spill-over
            ZStack(alignment: .top) {
                // Header with tabs and settings - positioned first so shadow can spill over
                VStack(spacing: 0) {
                    headerView
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 16)
                        .background(Color.hedgeUI.backgroundWhite) // Ensure same background
                    
                    // Fixed badges section - not scrollable
                    badgesSection
                        .padding(.horizontal, 20)
                        .padding(.top, 24) // Gap between header and badge section
                        .background(Color.hedgeUI.backgroundWhite) // Ensure same background
                    
                    // Retrospection records section - fixed height container with scrollable content
                    retrospectionRecordsSection
                        .padding(.horizontal, 20)
                        .background(Color.hedgeUI.backgroundWhite) // Ensure same background
                }
            }
            
            // Dark overlay only when FAB is open (dims everything)
            if store.isFABOpen {
                Color.black.opacity(0.7)
            .ignoresSafeArea()
                    .onTapGesture {
                        send(.fabTapped)
                    }
                    .animation(.easeInOut(duration: 0.3), value: store.isFABOpen)
            }
            
            // FAB and menu overlay (always on top)
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 10) {
                        // Help bubble (shown only when FAB is closed and help bubble should be shown)
                        if !store.isFABOpen && store.showHelpBubble {
                            helpBubble
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                        }
                        
                        // FAB menu (shown when FAB is open)
                        if store.isFABOpen {
                            fabMenu
                                .transition(.scale.combined(with: .opacity))
                        }
                        
                        // FAB button
                        fabButton
                    }
                }
                .padding(.trailing, 20)
                .padding(.bottom, 34)
            }
            
            // Badge detail modal overlay
            if store.showBadgeModal {
                badgeDetailModal
            }
        }
    }
    
    // MARK: - Badge Detail Modal
    private var badgeDetailModal: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                        .onTapGesture {
                    send(.badgeModalDismissed)
                }
            
            // Modal content
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Emerald badge
                        badgeDetailItem(
                            icon: Image.hedgeUI.emerald,
                            title: "감각의 전성기",
                            description: "시장의 흐름을 넓고 깊게 이해하며, 스스로의 기준으로 움직였어요"
                        )
                        
                        // Gold badge
                        badgeDetailItem(
                            icon: Image.hedgeUI.gold,
                            title: "안정의 흐름",
                            description: "근거 있는 판단으로 흔들림 없이 결정했어요"
                        )
                        
                        // Silver badge
                        badgeDetailItem(
                            icon: Image.hedgeUI.silver,
                            title: "유연의 구간",
                            description: "계획과는 조금 달랐지만 상황에 맞게 판단을 잘 조정했어요"
                        )
                        
                        // Bronze badge
                        badgeDetailItem(
                            icon: Image.hedgeUI.bronze,
                            title: "성찰의 시간",
                            description: "기대와 다른 결과였지만, 이번 회고로 배움을 쌓고 있어요"
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 32)
                    .padding(.bottom, 24)
                }
                
                // Confirm button
                Button {
                    send(.badgeModalDismissed)
                } label: {
                    Text("확인")
                        .font(FontModel.body2Semibold)
                        .foregroundStyle(Color.hedgeUI.textWhite)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.hedgeUI.grey900)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.hedgeUI.backgroundWhite)
            )
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: 500) // Constrain height to prevent full-screen expansion
            .transition(.scale.combined(with: .opacity))
        }
        .animation(.easeInOut(duration: 0.2), value: store.showBadgeModal)
    }
    
    private func badgeDetailItem(icon: Image, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 16) {
            // Badge icon (hexagonal)
            icon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 64, height: 64)
            
            VStack(alignment: .leading, spacing: 8) {
                // Title
                Text(title)
                    .font(FontModel.body1Semibold)
                    .foregroundStyle(Color.hedgeUI.textTitle)
                
                // Description
                Text(description)
                    .font(FontModel.body3Regular)
                    .foregroundStyle(Color.hedgeUI.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack(spacing: 24) {
            // Tab navigation
            HStack(spacing: 24) {
                tabButton(.home)
                tabButton(.principles)
            }
            
            Spacer()
            
            // Settings icon
            Button {
                send(.settingsTapped)
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(Color.hedgeUI.textSecondary)
            }
            .frame(width: 24, height: 24)
        }
        .frame(height: 44)
    }
    
    private func tabButton(_ tab: HomeFeature.HomeTab) -> some View {
        Button {
            send(.tabSelected(tab))
        } label: {
            Text(tab.rawValue)
                .font(store.selectedTab == tab ? FontModel.h2Semibold : FontModel.h2Regular)
                .foregroundStyle(
                    store.selectedTab == tab
                    ? Color.hedgeUI.textTitle
                    : Color.hedgeUI.textSecondary
                )
        }
    }
    
    // MARK: - Badges Section
    private var badgesSection: some View {
        Button {
            send(.badgeContainerTapped)
        } label: {
            badgeSectionContent
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var badgeSectionContent: some View {
        ZStack {
            // Background with gradients - must be clipped to rounded rectangle
            badgeSectionBackground
                .clipShape(RoundedRectangle(cornerRadius: 22))
            
            // Content - using ZStack for absolute positioning
            ZStack(alignment: .topLeading) {
                // Title - positioned at top-left with padding (dynamic message)
                Text(store.badgeSectionMessage)
                    .font(FontModel.body1Semibold)
                    .foregroundStyle(Color.hedgeUI.textTitle)
                    .padding(.top, 20)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                
                // Badge container: width 271, height 64
                // Positioned at top: 64px, left: 32px from card edge
                // Dividers are 1px wide, 52px height, 2px border-radius
                let badgeCounts = store.badgeCountsTuple
                HStack(spacing: 0) {
                    badgeItem(image: Image.hedgeUI.emerald, count: badgeCounts.emerald)
                    
                    divider
                    
                    badgeItem(image: Image.hedgeUI.gold, count: badgeCounts.gold)
                    
                    divider
                    
                    badgeItem(image: Image.hedgeUI.silver, count: badgeCounts.silver)
                    
                    divider
                    
                    badgeItem(image: Image.hedgeUI.bronze, count: badgeCounts.bronze)
                }
                .frame(width: 271, height: 64)
                .padding(.top, 64) // Exactly 64px from card top
                .padding(.leading, 32) // Exactly 32px from card left
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .frame(width: 335, height: 148)
                    .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.hedgeUI.backgroundWhite)
        )
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color(hex: "#F1F2F4", fallback: Color.hedgeUI.textSecondary), lineWidth: 1)
                )
        .shadow(
            color: Color(hex: "#0D0F26", fallback: Color.black).opacity(0.06), // Reduced opacity for less severe shadow
            radius: 12, // Smaller radius for less severe shadow
            x: 0,
            y: 4 // Slightly less offset
        )
        .zIndex(1) // Ensure shadow appears above header background
    }
    
    private var badgeSectionBackground: some View {
        GeometryReader { geo in
            let width = geo.size.width
            
            ZStack {
                // Base white background
                Color.hedgeUI.backgroundWhite
                
                // Left circular gradient (blue) - positioned outside box at top-left
                // Origin point: top: -180px, left: 102px (relative to badge section)
                // Slightly more blue at top, fades quickly to white at bottom
                Ellipse()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color(hex: "#1CCAFF", fallback: .cyan).opacity(0.24), location: 0.0), // Slightly more blue at top
                                .init(color: Color(hex: "#1CCAFF", fallback: .cyan).opacity(0.08), location: 0.25), // Fade starts earlier
                                .init(color: Color(hex: "#1CCAFF", fallback: .cyan).opacity(0.0), location: 0.5), // Quick fade to white
                                .init(color: Color.white.opacity(0.0), location: 1.0) // Fully transparent (white)
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 450 // Good spread
                        )
                    )
                    .frame(width: 900, height: 900)
                    .position(x: 102, y: -180)
                    .blur(radius: 100) // Softer blur
                
                // Right circular gradient (green) - positioned outside box at top-right
                // Positioned on the right side, slightly above
                // Slightly more green at top, fades quickly to white at bottom
                Ellipse()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color(hex: "#29F980", fallback: .green).opacity(0.24), location: 0.0), // Slightly more green at top
                                .init(color: Color(hex: "#29F980", fallback: .green).opacity(0.08), location: 0.25), // Fade starts earlier
                                .init(color: Color(hex: "#29F980", fallback: .green).opacity(0.0), location: 0.5), // Quick fade to white
                                .init(color: Color.white.opacity(0.0), location: 1.0) // Fully transparent (white)
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 450 // Good spread
                        )
                    )
                    .frame(width: 900, height: 900)
                    .position(x: width - 100, y: -180)
                    .blur(radius: 100) // Softer blur
            }
        }
        .allowsHitTesting(false)
    }
    
    // MARK: - Badge Divider
    private var divider: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(Color(hex: "#F3F4F6", fallback: Color.hedgeUI.textAlternative))
            .frame(width: 1, height: 52)
    }
    
    private func badgeItem(image: Image, count: Int) -> some View {
        VStack(spacing: 8) {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 64, height: 64)
                .background(Color.clear) // Ensure no background on badge image
            
            Text("\(count)개")
                .font(FontModel.caption1Regular)
                .foregroundStyle(Color.hedgeUI.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Retrospection Records Section
    private var retrospectionRecordsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("회고 기록")
                .font(FontModel.h2Semibold)
                .foregroundStyle(Color.hedgeUI.textTitle)
            
            if store.tradeRecords.isEmpty {
                // Empty state
                VStack(spacing: 8) {
                    Text("아직 내 회고 기록이 없어요")
                        .font(.custom("Pretendard-SemiBold", size: 18))
                        .foregroundStyle(Color(hex: "#1F2937", fallback: Color.hedgeUI.textTitle))
                        .tracking(18 * -0.0002) // -0.02%
                        .lineSpacing(18 * 1.44 - 18) // line-height 144%
                        .multilineTextAlignment(.center)
                    
                    Text("회고를 시작해볼까요?")
                        .font(FontModel.body2Regular)
                        .foregroundStyle(Color.hedgeUI.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 60)
            } else {
                // Records view with stock list and transactions
                HStack(alignment: .top, spacing: 0) {
                    // Left: Stock list (width: 118px from Figma spec, but scrollable height)
                    stockList
                        .frame(width: 118)
                        .padding(.leading, 10) // left: 10px
                    
                    // Right: Transaction list
                    transactionList
                        .frame(maxWidth: .infinity)
                }
                .frame(height: 548) // height: 548px from Figma spec
            }
        }
    }
    
    // MARK: - Stock List
    private var stockList: some View {
        StockListWithGradient(stocks: store.availableStocks) { stock in
            stockRow(for: stock)
        }
    }
    
    private func stockRow(for stock: HomeFeature.StockInfo) -> some View {
        Button {
            send(.stockSelected(stock.symbol))
        } label: {
            VStack(spacing: 8) {
                // Stock logo (circular with first letter or demo image)
                ZStack {
                    Circle()
                        .fill(stockColor(for: stock.symbol))
                        .frame(width: 40, height: 40)
                    
                    Text(String(stock.title.prefix(1)))
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.hedgeUI.textWhite)
                }
                
                Text(stock.title)
                    .font(FontModel.caption1Medium)
                    .foregroundStyle(
                        store.selectedStockSymbol == stock.symbol
                        ? Color.hedgeUI.textTitle
                        : Color.hedgeUI.textSecondary
                    )
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .background(
                store.selectedStockSymbol == stock.symbol
                ? Color.hedgeUI.backgroundSecondary
                : Color.clear
            )
        }
    }
    
    private func stockColor(for symbol: String) -> Color {
        // Different colors for different stocks (keyed by symbol for locale-independence)
        switch symbol {
        case "005930": // 삼성전자
            return Color(hex: "#0066FF", fallback: Color.hedgeUI.brandPrimary) // Blue
        case "TSLA": // 테슬라
            return Color(hex: "#E31937", fallback: Color.hedgeUI.brandPrimary) // Red
        case "AAPL": // 애플
            return Color(hex: "#A8A8A8", fallback: Color.hedgeUI.brandPrimary) // Gray
        case "NVDA": // 엔비디아
            return Color(hex: "#76B900", fallback: Color.hedgeUI.brandPrimary) // Green
        case "000660": // SK하이닉스
            return Color(hex: "#E60012", fallback: Color.hedgeUI.brandPrimary) // Red
        case "035420": // 네이버
            return Color(hex: "#03C75A", fallback: Color.hedgeUI.brandPrimary) // Green
        case "035720": // 카카오
            return Color(hex: "#FEE500", fallback: Color.hedgeUI.brandPrimary) // Yellow
        case "005380": // 현대차
            return Color(hex: "#002C5F", fallback: Color.hedgeUI.brandPrimary) // Dark Blue
        default:
            return Color.hedgeUI.brandPrimary
        }
    }
    
    // MARK: - Transaction List
    private var transactionList: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Group by month sections using MonthSection enum for proper sorting (newest first)
                // Use reversed comparison since Comparable's < gives oldest first, but we want newest first
                let sortedMonthSections = monthSections.keys.sorted(by: >)
                ForEach(Array(sortedMonthSections.enumerated()), id: \.element) { index, monthSection in
                    VStack(alignment: .leading, spacing: 16) {
                        // Month header (like "이번달 회고")
                        Text(monthSection.title)
                            .font(FontModel.body2Semibold)
                            .foregroundStyle(Color.hedgeUI.textTitle)
                        
                        // Divider after month header (width: 231px, height: 1px, border: 1px solid #F3F4F6)
                Rectangle()
                            .fill(Color(hex: "#F3F4F6", fallback: Color.hedgeUI.textAlternative))
                            .frame(width: 231, height: 1)
                            .padding(.bottom, 16)
                        
                        // Group transactions by date within month
                        let dateGroups = monthSections[monthSection] ?? [:]
                        ForEach(Array(dateGroups.keys.sorted(by: >)), id: \.self) { dateKey in
                            VStack(alignment: .leading, spacing: 12) {
                                // Date header (like "9월 15일")
                                Text(dateKey)
                                    .font(FontModel.label2Regular)
                                    .foregroundStyle(Color.hedgeUI.textAlternative)
                                
                                // Transactions for this date (already sorted by creation time within same date)
                                ForEach((dateGroups[dateKey] ?? []), id: \.id) { tradeData in
                                    transactionRow(for: tradeData)
                                }
                            }
                        }
                    }
                    .padding(.bottom, index < sortedMonthSections.count - 1 ? 24 : 0) // Spacing between month sections
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 8) // Small padding at bottom to prevent cut-off
        }
        .scrollBounceBehavior(.basedOnSize) // Don't scroll past content
        .background(Color.hedgeUI.backgroundWhite)
    }
    
    private var monthSections: [MonthSection: [String: [TradeData]]] {
        let filtered = store.filteredRecords
        
        // Group by month using MonthSection enum for proper sorting
        let byMonth = Dictionary(grouping: filtered) { tradeData -> MonthSection in
            guard let date = DateKit.parse(tradeData.tradingDate) else {
                return .absolute(year: 0, month: 0)
            }
            return MonthSection.from(date)
        }
        
        // Then group by date within each month, keeping sorted order (newest first by ID)
        return byMonth.mapValues { records in
            // Reuse the sorting logic from State - sort by date (newest first), then by ID
            let sortedRecords = records.sorted { record1, record2 in
                let date1 = DateKit.parse(record1.tradingDate) ?? Date.distantPast
                let date2 = DateKit.parse(record2.tradingDate) ?? Date.distantPast
                if date1 != date2 {
                    return date1 > date2 // Newer dates first
                }
                // Same date: sort by ID (higher ID = newer, created later)
                return record1.id > record2.id
            }
            return Dictionary(grouping: sortedRecords) { tradeData in
                guard let date = DateKit.parse(tradeData.tradingDate) else {
                    return tradeData.tradingDate
                }
                return DateKit.formatMonthDay(date)
            }
        }
    }
    
    private func transactionRow(for tradeData: TradeData) -> some View {
        Button {
            send(.tradeRecordTapped(tradeData))
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                // Price and quantity with badge dot (if applicable)
                HStack(spacing: 4) {
                        // Badge dot - green circle, shown only if:
                        // 1. Record has completed feedback
                        // 2. Badge dot hasn't been shown yet for this record
                        if store.recordsWithCompletedFeedback.contains(tradeData.id) &&
                           !store.recordsWithBadgeDots.contains(tradeData.id) {
                            Circle()
                                .fill(Color(hex: "#29F980", fallback: Color.green)) // Green badge dot
                                .frame(width: 6, height: 6)
                                .onAppear {
                                    // Mark as shown when it appears
                                    send(.badgeDotShown(tradeData.id))
                                }
                        } else {
                            // Regular indicator dot (use brand color or make it invisible?)
                            Circle()
                                .fill(Color.hedgeUI.brandPrimary)
                                .frame(width: 6, height: 6)
                        }
                    
                    Text("\(tradeData.tradingPrice)원 • \(tradeData.tradingQuantity)주")
                        .font(FontModel.body2Semibold)
                        .foregroundStyle(Color.hedgeUI.textTitle)
                }
                
                // Trade type and date (format: "매도 2025.09.14")
                HStack(spacing: 4) {
                    Text(tradeData.tradeType.rawValue)
                        .font(FontModel.caption1Regular)
                        .foregroundStyle(
                            tradeData.tradeType == .buy
                            ? Color.hedgeUI.tradeBuy
                            : Color.hedgeUI.tradeSell
                        )
                    
                    Text(tradeData.tradingDate)
                        .font(FontModel.caption1Regular)
                        .foregroundStyle(
                            tradeData.tradeType == .buy
                            ? Color.hedgeUI.tradeBuy
                            : Color.hedgeUI.tradeSell
                        )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain) // Use plain style to avoid default button styling
    }
    
    // MARK: - Date Helpers
    // Using DateKit from Core module for all date parsing and formatting
    
    // MARK: - Help Bubble
    private var helpBubble: some View {
        HStack(spacing: 12) {
            Text("회고 시작하기")
                .font(FontModel.body2Semibold)
                .foregroundStyle(Color.hedgeUI.textWhite)
            
            Button {
                send(.helpBubbleDismissed)
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.hedgeUI.textWhite.opacity(0.8))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.hedgeUI.grey900.opacity(0.9))
        )
    }
    
    // MARK: - FAB Menu
    private var fabMenu: some View {
        VStack(spacing: 0) {
            // Buy option
            menuItem(
                image: Image.hedgeUI.buyDemo,
                text: "매수 회고하기",
                textColor: Color.hedgeUI.tradeBuy
            ) {
                send(.retrospectTapped(.buy))
            }
            
            // Divider
            Rectangle()
                .fill(Color(hex: "#F3F4F6", fallback: Color.hedgeUI.textSecondary))
                .frame(height: 1)
            
            // Sell option
            menuItem(
                image: Image.hedgeUI.sellDemo,
                text: "매도 회고하기",
                textColor: Color.hedgeUI.tradeSell
            ) {
                send(.retrospectTapped(.sell))
            }
        }
        .padding(.horizontal, 24) // 24px horizontal padding: container wraps content
        .padding(.vertical, 16) // 16px vertical padding: container wraps content
        .fixedSize(horizontal: true, vertical: false) // Size to content, don't expand
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.hedgeUI.backgroundWhite)
        )
    }
    
    private func menuItem(
        image: Image,
        text: String,
        textColor: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            // Content row: icon + text with natural sizing
            HStack(spacing: 8) {
                image
                    .resizable()
                    .frame(width: 20, height: 20)
                
                // Build text with colored trade type
                // Font: Pretendard SemiBold 16px, line-height 148%, letter-spacing 0.57%
                let fontSize: CGFloat = 16
                let letterSpacing = fontSize * 0.0057 // 0.57%
                let lineHeight = fontSize * 1.48 // 148%
                let lineSpacing = lineHeight - fontSize
                
                if text.contains("매수") {
                    HStack(spacing: 0) {
                        Text("매수")
                            .font(.custom("Pretendard-SemiBold", size: fontSize))
                            .foregroundStyle(textColor)
                            .tracking(letterSpacing)
                        Text(" 회고하기")
                            .font(.custom("Pretendard-SemiBold", size: fontSize))
                            .foregroundStyle(Color(hex: "#1F2937", fallback: Color.hedgeUI.textTitle))
                            .tracking(letterSpacing)
                    }
                    .lineSpacing(lineSpacing)
                } else if text.contains("매도") {
                    HStack(spacing: 0) {
                        Text("매도")
                            .font(.custom("Pretendard-SemiBold", size: fontSize))
                            .foregroundStyle(textColor)
                            .tracking(letterSpacing)
                        Text(" 회고하기")
                            .font(.custom("Pretendard-SemiBold", size: fontSize))
                            .foregroundStyle(Color(hex: "#1F2937", fallback: Color.hedgeUI.textTitle))
                            .tracking(letterSpacing)
                    }
                    .lineSpacing(lineSpacing)
                } else {
                    Text(text)
                        .font(.custom("Pretendard-SemiBold", size: fontSize))
                        .foregroundStyle(Color(hex: "#1F2937", fallback: Color.hedgeUI.textTitle))
                        .tracking(letterSpacing)
                        .lineSpacing(lineSpacing)
                }
            }
            .frame(height: 24, alignment: .leading) // Fixed height for text row
            .contentShape(Rectangle()) // Make entire area tappable
        }
    }
    
    // MARK: - FAB Button
    private var fabButton: some View {
        Button {
            send(.fabTapped)
        } label: {
                    Group {
                if store.isFABOpen {
                            Image.hedgeUI.cancelDemo
                                .transition(.scale.combined(with: .opacity))
                        } else {
                            Image.hedgeUI.plusDemo
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
            .foregroundStyle(Color.hedgeUI.textWhite)
        }
        .frame(width: 56, height: 56)
        .background(
            Circle()
                .fill(Color.hedgeUI.brandPrimary)
        )
        .shadow(
            color: Color.hedgeUI.brandPrimary.opacity(0.3),
            radius: 8,
            x: 0,
            y: 4
        )
        .animation(.easeInOut(duration: 0.3), value: store.isFABOpen)
    }
}

// MARK: - Preview Mock UseCases
private struct MockFetchTradeRecordsUseCase: FetchTradeRecordsUseCase {
    func execute() async throws -> [TradeData] {
        // Return empty array for preview - can be customized if needed
        return []
    }
}

#Preview {
    // Use mock UseCases for preview (DI container not initialized in preview context)
    return HomeView(store: .init(
        initialState: HomeFeature.State(),
        reducer: {
            HomeFeature(
                fetchTradeRecordsUseCase: MockFetchTradeRecordsUseCase(),
                persistenceService: HomePersistenceService()
            )
        }
    ))
}
