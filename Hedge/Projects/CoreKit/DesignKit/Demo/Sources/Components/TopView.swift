//
//  TopView.swift
//  DesignKit
//
//  Created by 이중엽 on 9/20/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import SwiftUI
import DesignKit

struct TopView: View {
    
    var body: some View {
        NavigationView {
            List {
                Section("기본 케이스") {
                    NavigationLink("기본 TopView") {
                        BasicTopViewDemo()
                    }
                    
                    NavigationLink("버튼이 있는 TopView") {
                        ButtonTopViewDemo()
                    }
                    
                    NavigationLink("Footnote가 있는 TopView") {
                        FootnoteTopViewDemo()
                    }
                }
                
                Section("복합 케이스") {
                    NavigationLink("모든 요소가 있는 TopView") {
                        CompleteTopViewDemo()
                    }
                    
                    NavigationLink("다양한 케이스 모음") {
                        VariousCasesDemo()
                    }
                }
            }
            .navigationTitle("HedgeTopView")
        }
    }
}

// MARK: - Basic Cases
struct BasicTopViewDemo: View {
    var body: some View {
        VStack(spacing: 20) {
            HedgeTopView(
                symbolImage: HedgeUI.search,
                title: "삼성전자",
                description: "얼마에 매도하셨나요?"
            )
            
            HedgeTopView(
                symbolImage: HedgeUI.search,
                title: "애플",
                description: "얼마에 매수하셨나요?"
            )
            
            Spacer()
        }
        .padding()
    }
}

struct ButtonTopViewDemo: View {
    var body: some View {
        VStack(spacing: 20) {
            HedgeTopView(
                symbolImage: HedgeUI.search,
                title: "삼성전자",
                description: "얼마에 매도하셨나요?",
                buttonImage: HedgeUI.close
            ) {
                print("닫기 버튼 탭")
            }
            
            HedgeTopView(
                symbolImage: HedgeUI.search,
                title: "애플",
                description: "얼마에 매수하셨나요?",
                buttonImage: HedgeUI.search
            ) {
                print("검색 버튼 탭")
            }
            
            Spacer()
        }
        .padding()
    }
}

struct FootnoteTopViewDemo: View {
    var body: some View {
        VStack(spacing: 20) {
            HedgeTopView(
                symbolImage: HedgeUI.search,
                title: "삼성전자",
                description: "얼마에 매도하셨나요?",
                footnote: "최근 거래 내역을 확인해보세요"
            )
            
            HedgeTopView(
                symbolImage: HedgeUI.search,
                title: "애플",
                description: "얼마에 매수하셨나요?",
                footnote: "AI 분석을 통해 더 정확한 정보를 제공합니다"
            )
            
            Spacer()
        }
        .padding()
    }
}

// MARK: - Complex Cases
struct CompleteTopViewDemo: View {
    var body: some View {
        VStack(spacing: 20) {
            HedgeTopView(
                symbolImage: HedgeUI.search,
                title: "삼성전자",
                description: "얼마에 매도하셨나요?",
                footnote: "최근 거래 내역을 확인해보세요",
                buttonImage: HedgeUI.close
            ) {
                print("완전한 TopView 닫기")
            }
            
            HedgeTopView(
                symbolImage: HedgeUI.search,
                title: "애플",
                description: "얼마에 매수하셨나요?",
                footnote: "AI 분석을 통해 더 정확한 정보를 제공합니다",
                buttonImage: HedgeUI.search
            ) {
                print("완전한 TopView 검색")
            }
            
            Spacer()
        }
        .padding()
    }
}

struct VariousCasesDemo: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 케이스 1: 기본
                VStack(alignment: .leading, spacing: 8) {
                    Text("케이스 1: 기본")
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    HedgeTopView(
                        symbolImage: HedgeUI.search,
                        title: "기본 TopView",
                        description: "이것은 기본적인 TopView입니다"
                    )
                }
                
                // 케이스 2: 버튼만
                VStack(alignment: .leading, spacing: 8) {
                    Text("케이스 2: 버튼 포함")
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    HedgeTopView(
                        symbolImage: HedgeUI.search,
                        title: "버튼 TopView",
                        description: "버튼이 있는 TopView입니다",
                        buttonImage: HedgeUI.close
                    ) {
                        print("버튼 탭됨")
                    }
                }
                
                // 케이스 3: Footnote만
                VStack(alignment: .leading, spacing: 8) {
                    Text("케이스 3: Footnote 포함")
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    HedgeTopView(
                        symbolImage: HedgeUI.search,
                        title: "Footnote TopView",
                        description: "Footnote가 있는 TopView입니다",
                        footnote: "추가 정보를 제공하는 footnote입니다"
                    )
                }
                
                // 케이스 4: 모든 요소
                VStack(alignment: .leading, spacing: 8) {
                    Text("케이스 4: 모든 요소 포함")
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    HedgeTopView(
                        symbolImage: HedgeUI.search,
                        title: "완전한 TopView",
                        description: "모든 요소가 포함된 TopView입니다",
                        footnote: "추가 정보를 제공하는 footnote입니다",
                        buttonImage: HedgeUI.close
                    ) {
                        print("완전한 TopView 버튼 탭됨")
                    }
                }
                
                // 케이스 5: 긴 텍스트
                VStack(alignment: .leading, spacing: 8) {
                    Text("케이스 5: 긴 텍스트")
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    HedgeTopView(
                        symbolImage: HedgeUI.search,
                        title: "매우 긴 종목명이 있는 경우의 TopView",
                        description: "이것은 매우 긴 설명이 있는 TopView입니다. 여러 줄로 표시될 수 있습니다.",
                        footnote: "이것은 매우 긴 footnote 텍스트입니다. 여러 줄로 표시될 수 있습니다.",
                        buttonImage: HedgeUI.search
                    ) {
                        print("긴 텍스트 TopView 버튼 탭됨")
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    TopViewDemo()
}
