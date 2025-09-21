//
//  TradeReasonInputView.swift
//  TradeReasonFeature
//
//  Created by 이중엽 on 9/21/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI
import DesignKit

struct TradeReasonInputView: View {
    
    @State var text: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        
        VStack(spacing: 0) {
            HedgeNavigationBar(buttonText: "완료")
            
            ScrollView {
                VStack(spacing: 0) {
                    // TODO: 탑뷰 들어갈 자리
                    Rectangle()
                        .frame(height: 98)
                        .foregroundStyle(Color.hedgeUI.backgroundGrey)
                        .overlay {
                            Text("대충 탑뷰 들어갈 자리")
                        }
                    
                    Image.hedgeUI.tmpChart
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .overlay {
                            Color.secondary
                        }
                    
                    Rectangle()
                        .frame(height: 16)
                        .foregroundStyle(.clear)
                    
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $text)
                            .focused($isFocused)
                            .tint(.black)
                            .font(FontModel.body3Medium)
                            .foregroundStyle(Color.hedgeUI.textTitle)
                            .padding(.zero)
                        
                        if text.isEmpty && !isFocused {
                            Text("매매 근거를 작성해보세요")
                                .font(FontModel.body3Medium)
                                .foregroundStyle(Color.hedgeUI.textAssistive)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .allowsHitTesting(false)
                                .offset(x: 8, y: 8) // UITextView 기본 textContainerInset 값
                        }
                    }
                    .onTapGesture {
                        isFocused = true
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, -8)
                }
            }
        }
        .padding(.zero)
        .onTapGesture {
            isFocused = false
        }
    }
}

#Preview {
    TradeReasonInputView()
}
