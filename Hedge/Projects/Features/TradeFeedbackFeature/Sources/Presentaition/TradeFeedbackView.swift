//
//  TradeFeedbackView.swift
//  TradeFeedbackFeature
//
//  Created by 이중엽 on 9/22/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

import DesignKit

struct TradeFeedbackView: View {
    
    @State private var selectedTab: Int = 0
    
    var symbolImage: Image
    var title: String
    var description: String
    var footnote: String
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HedgeNavigationBar(buttonText: "삭제", color: .secondary)
                
                HedgeTopView(
                    symbolImage: symbolImage,
                    title: title,
                    description: description,
                    footnote: footnote,
                    buttonImage: Image.hedgeUI.pencil,
                    buttonImageOnTapped: nil
                )
                
                Image.hedgeUI.tmpChart
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                
                Rectangle()
                    .frame(height: 10)
                    .foregroundStyle(.clear)
                
                VStack(spacing: 0) {
                    // 탭 헤더
                    HStack(spacing: 0) {
                        Text("나의 회고")
                            .font(FontModel.body2Medium)
                            .foregroundColor(selectedTab == 0 ? Color.hedgeUI.textPrimary : Color.hedgeUI.textAlternative)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedTab = 0
                                }
                            }
                        
                        Text("AI 피드백")
                            .font(FontModel.body2Medium)
                            .foregroundColor(selectedTab == 1 ? Color.hedgeUI.textPrimary : Color.hedgeUI.textAlternative)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedTab = 1
                                }
                            }
                    }
                    .padding(.vertical, 12)
                    
                    // 선택된 탭의 밑줄
                    Rectangle()
                        .foregroundColor(.primary)
                        .offset(x: selectedTab == 0 ? -(geometry.size.width / 4) : (geometry.size.width / 4))
                        .frame(width: geometry.size.width / 2, height: 2, alignment: .leading)
                        .animation(.easeInOut(duration: 0.3), value: selectedTab)
                    
                    // 전체 밑줄
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(Color.hedgeUI.neutralBgSecondary)
                }
                
                // TabView로 페이지네이션
                TabView(selection: $selectedTab) {
                    retrospectTab
                        .tag(0)
                    
                    feedbackTab
                        .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
    }
}


// MARK: Subviews
extension TradeFeedbackView {
    @ViewBuilder
    private var retrospectTab: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 0) {
                Text("2025년 8월 25일")
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private var feedbackTab: some View {
        ScrollView(.vertical) {
            VStack {
                HStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                    Text("AI 피드백 작성중...")
                        .foregroundColor(.secondary)
                }
                .padding()
            }
        }
    }
}

#Preview {
    TradeFeedbackView(symbolImage: HedgeUI.trash, title: "종목명", description: "65,000원・3주 매도", footnote: "2025년 8월 25일")
}
