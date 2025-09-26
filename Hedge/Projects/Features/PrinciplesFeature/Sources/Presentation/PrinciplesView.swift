//
//  PrinciplesView.swift
//  PrinciplesFeature
//
//  Created by 이중엽 on 9/27/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

import DesignKit
import PrinciplesDomainInterface

public struct PrinciplesView: View {
    
    @Binding var selectedPrinciples: Set<Int>
    @Binding var principles: [Principle]
    var onPrincipleTapped: ((Int) -> Void)? = nil
    var onCompleteTapped: (() -> Void)? = nil
    
    public var body: some View {
        
        VStack(spacing: 0) {
            ScrollView {
                ForEach(Array(principles.enumerated()), id: \.element) { index, principle in
                    VStack(spacing: 0) {
                        
                        HStack(spacing: 0) {
                            
                            Image.hedgeUI.idleDemo
                                .resizable()
                                .frame(width: 32, height: 32)
                            
                            Rectangle()
                                .frame(width: 16, height: 32)
                                .foregroundStyle(.clear)
                            
                            Text(principles[index].principle)
                                .font(FontModel.body3Semibold)
                                .foregroundStyle(Color.hedgeUI.grey900)
                                .lineLimit(2)
                            
                            Spacer(minLength: 24)
                            
                            Group {
                                if selectedPrinciples.contains(principle.id) {
                                    Image.hedgeUI.check
                                } else {
                                    Image.hedgeUI.uncheck
                                }
                            }
                            .onTapGesture {
                                onPrincipleTapped?(principle.id)
                            }
                        }
                        .padding(.vertical, 22)
                        .padding(.horizontal, 24)
                        
                        if index < (principles.count) - 1 {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(Color.hedgeUI.neutralBgSecondary)
                                .padding(.leading, 24)
                        }
                    }
                }
            }
            
            HedgeBottomCTAButton()
                .style(.oneButton(title: "기록하기", onTapped: {
                    onCompleteTapped?()
                }))
        }
    }
}

#Preview {
    
    @Previewable @State var selectedPrinciples: Set<Int> = []
    
    VStack(spacing: 20) {
        // 폰트 정보 표시
        VStack(alignment: .leading, spacing: 8) {
            Text("현재 사용 중인 폰트 정보")
                .font(.headline)
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        
        // 실제 PrinciplesView
        PrinciplesView(
            selectedPrinciples: $selectedPrinciples,
            principles: .constant([
                .init(id: 1, principle: "주가가 오르는 흐름이면 매수, 하락 흐름이면 매도하기"),
                .init(id: 2, principle: "기업의 본질 가치보다 낮게 거래되는 주식을 찾아 장기 보유하기"),
                .init(id: 3, principle: "단기 등락에 흔들리지 말고 기업의 장기 성장성에 집중하기"),
                .init(id: 4, principle: "분산 투자 원칙을 지키고 감정적 결정을 피하기"),
                .init(id: 5, principle: "리스크를 관리하며 손절 기준을 미리 정해두기")
            ]),
            onPrincipleTapped: { principleId in
                if selectedPrinciples.contains(principleId) {
                    selectedPrinciples.remove(principleId)
                } else {
                    selectedPrinciples.insert(principleId)
                }
            },
            onCompleteTapped: {
                print("Complete tapped")
            }
        )
    }
}
