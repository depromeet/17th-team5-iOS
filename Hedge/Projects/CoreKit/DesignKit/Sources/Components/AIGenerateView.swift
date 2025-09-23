//
//  AIGenerateView.swift
//  DesignKitDemo
//
//  Created by Junyoung on 9/23/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

struct AIGenerateView: View {
    private let date: String
    @Binding private var content: String
    
    private let shadowColor = Color.init(red: 19/255, green: 26/255, blue: 43/255).opacity(0.32)
    
    public init(
        date: String,
        content: Binding<String>
    ) {
        self.date = date
        self._content = content
    }
    
    var body: some View {
        ZStack {
            Image.hedgeUI.aiGenerateBackground
                .resizable()
            
            VStack(alignment: .center, spacing: 23) {
                HStack(spacing: 12) {
                    Image.hedgeUI.generateIcon
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("당시 시장 상황")
                            .font(.body3Semibold)
                            .foregroundStyle(Color.hedgeUI.backgroundGrey)
                        Text("\(date) 분석")
                            .font(.caption1Regular)
                            .foregroundStyle(Color.hedgeUI.textAssistive)
                    }
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image.hedgeUI.generateCloseIcon
                            .frame(width: 28, height: 28)
                    }
                }
                
                ScrollView(showsIndicators: false) {
                    Text(content)
                        .font(.label1Medium)
                        .foregroundStyle(Color.hedgeUI.textDisabled)
                }
            }
            .padding(.vertical, 18)
            .padding(.horizontal, 20)
        }
        .frame(height: 220)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(
                    Color.init(
                        red: 13/255,
                        green: 17/255,
                        blue: 25/255
                    )
                )
        )
        .shadow(
            color: shadowColor,
            radius: 30,
            x: 0,
            y: 12
        )
    }
}

#Preview {
    ZStack {
        AIGenerateView(
            date: "8월 25일",
            content: .constant("거래량이 평소보다 2.5배 늘었어서 단기 급등락 가능성에 영향을 주어서 확인했어야 해요.")
        )
        .padding(.horizontal, 10)
    }
}
