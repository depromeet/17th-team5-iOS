//
//  TopViewComponent.swift
//  TradeHistoryFeature
//
//  Created by 이중엽 on 9/20/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI
import DesignKit

public struct TopViewComponent: View {
    
    let image: Image
    let StockTitle: String
    let description: String
    
    public var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 7) {
                image
                    .resizable()
                    .frame(width: 22, height: 22)
                
                Text(StockTitle)
                    .font(FontModel.body3Medium)
                    .foregroundStyle(Color.hedgeUI.grey900)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Text(description)
                .font(FontModel.h1Semibold)
                .foregroundStyle(Color.hedgeUI.grey900)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

#Preview {
    TopViewComponent(image: HedgeUI.search, StockTitle: "종목명", description: "얼마에 매도하셨나요?")
}
