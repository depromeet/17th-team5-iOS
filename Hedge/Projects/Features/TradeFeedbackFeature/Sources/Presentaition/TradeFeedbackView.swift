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
    
    @State private var selectedTab = 0
    
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
                    HStack(spacing: 0) {
                        Text("나의 회고")
                            .font(FontModel.body2Medium)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text("AI 피드백")
                            .font(FontModel.body2Medium)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.vertical, 12)
                    
                    Rectangle()
                        .frame(width: geometry.size.width / 2, height: 2)
                    
                    Rectangle()
                        .frame(width: .infinity, height: 1)
                        .foregroundStyle(Color.hedgeUI.neutralBgSecondary)
                }
                
                // 커스텀 탭 UI with 애니메이션
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: 0) {
                        retrospectTab
                            .frame(width: geometry.size.width, alignment: .leading)
                        
                        feedbackTab
                            .frame(width: geometry.size.width, alignment: .leading)
                    }
                    
                }
                .scrollTargetBehavior(.paging)
                
            }
        }
        
    }
}

// MARK: Subviews
extension TradeFeedbackView {
    @ViewBuilder
    private var retrospectTab: some View {
        ScrollView(.vertical) {
            Text("2025년 8월 25일")
                .font(.body)
                .foregroundColor(.primary)
                .padding(.top, 16)
                .padding(.horizontal, 16)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private var feedbackTab: some View {
        ScrollView(.vertical) {
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

#Preview {
    TradeFeedbackView(symbolImage: HedgeUI.trash, title: "종목명", description: "65,000원・3주 매도", footnote: "2025년 8월 25일")
}
