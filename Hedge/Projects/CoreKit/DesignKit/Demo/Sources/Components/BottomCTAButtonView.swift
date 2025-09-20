//
//  BottomCTAButtonView.swift
//  DesignKit
//
//  Created by Junyoung on 1/9/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import SwiftUI
import DesignKit

struct BottomCTAButtonView: View {
    @State private var selectedStyle: Int = 0
    @State private var selectedBackground: Int = 0
    
    var body: some View {
        ZStack {
            // 배경색 (그라디언트 효과 확인용)
            Color.hedgeUI.grey500
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // 스타일 선택
                    VStack(alignment: .leading, spacing: 12) {
                        Text("스타일 선택")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Picker("Style", selection: $selectedStyle) {
                            Text("One Button").tag(0)
                            Text("Two Button").tag(1)
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    // 배경 선택
                    VStack(alignment: .leading, spacing: 12) {
                        Text("배경 선택")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Picker("Background", selection: $selectedBackground) {
                            Text("White Gradient").tag(0)
                            Text("Transparent").tag(1)
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    // 미리보기 영역
                    VStack(alignment: .leading, spacing: 12) {
                        Text("미리보기")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Rectangle()
                            .fill(Color.hedgeUI.grey300)
                            .frame(height: 200)
                            .overlay(
                                VStack {
                                    Text("미리보기 영역")
                                        .foregroundColor(.white)
                                    Text("하단 CTA 버튼이 여기에 표시됩니다")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            )
                            .cornerRadius(12)
                    }
                    
                    // 다양한 조합 테스트
                    VStack(alignment: .leading, spacing: 12) {
                        Text("다양한 조합 테스트")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        VStack(spacing: 16) {
                            // One Button + White Gradient
                            HedgeBottomCTAButton("텍스트 없음")
                                .bg(.whiteGradient)
                                .style(.oneButton(
                                    title: "확인",
                                    onTapped: { print("One Button - 확인") }
                                ))
                            
                            // One Button + Transparent
                            HedgeBottomCTAButton("텍스트 없음")
                                .bg(.transparent)
                                .style(.oneButton(
                                    title: "취소",
                                    onTapped: { print("One Button - 취소") }
                                ))
                            
                            // Two Button + White Gradient
                            HedgeBottomCTAButton("텍스트 없음")
                                .bg(.whiteGradient)
                                .style(.twoButton(
                                    leftTitle: "취소",
                                    rightTitle: "확인",
                                    leftOnTapped: { print("Two Button - 취소") },
                                    rightOnTapped: { print("Two Button - 확인") }
                                ))
                            
                            // Two Button + Transparent
                            HedgeBottomCTAButton("텍스트 없음")
                                .bg(.transparent)
                                .style(.twoButton(
                                    leftTitle: "이전",
                                    rightTitle: "다음",
                                    leftOnTapped: { print("Two Button - 이전") },
                                    rightOnTapped: { print("Two Button - 다음") }
                                ))
                            
                            // 텍스트가 있는 경우
                            HedgeBottomCTAButton("추가 정보")
                                .bg(.whiteGradient)
                                .style(.oneButton(
                                    title: "완료",
                                    onTapped: { print("One Button with Text - 완료") }
                                ))
                            
                            // 텍스트가 있는 Two Button
                            HedgeBottomCTAButton("주의사항")
                                .bg(.transparent)
                                .style(.twoButton(
                                    leftTitle: "나중에",
                                    rightTitle: "지금",
                                    leftOnTapped: { print("Two Button with Text - 나중에") },
                                    rightOnTapped: { print("Two Button with Text - 지금") }
                                ))
                        }
                    }
                }
                .padding(16)
                .padding(.bottom, 100) // 하단 CTA 버튼을 위한 여백
            }
            
            // 하단 고정 CTA 버튼
            VStack {
                Spacer()
                
                if selectedStyle == 0 {
                    // One Button
                    HedgeBottomCTAButton("텍스트 없음")
                        .bg(selectedBackground == 0 ? .whiteGradient : .transparent)
                        .style(.oneButton(
                            title: "확인",
                            onTapped: { print("하단 One Button - 확인") }
                        ))
                } else {
                    // Two Button
                    HedgeBottomCTAButton("텍스트 없음")
                        .bg(selectedBackground == 0 ? .whiteGradient : .transparent)
                        .style(.twoButton(
                            leftTitle: "취소",
                            rightTitle: "확인",
                            leftOnTapped: { print("하단 Two Button - 취소") },
                            rightOnTapped: { print("하단 Two Button - 확인") }
                        ))
                }
            }
        }
        .navigationTitle("Bottom CTA Button")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        BottomCTAButtonView()
    }
}
