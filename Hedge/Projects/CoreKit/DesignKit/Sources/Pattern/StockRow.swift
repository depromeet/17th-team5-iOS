//
//  StockRow.swift
//  DesignKit
//
//  Created by Junyoung on 9/20/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

import Kingfisher

public struct StockRow: View {
    private let symbol: String
    private let title: String
    
    public init(
        symbol: String,
        title: String
    ) {
        self.symbol = symbol
        self.title = title
    }
    
    public var body: some View {
        HStack(spacing: 16) {
            KFImage(URL(string: symbol))
                .resizable()
                .frame(width: 32, height: 32)
                .clipShape(Circle())
            
            Text(title)
                .font(.body1Semibold)
                .foregroundStyle(Color.hedgeUI.grey900)
            
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .background(Color.clear)
    }
}

#Preview {
    StockRow(
        symbol: "https://plchldr.co/i/50x50",
        title: "삼성전자"
    )
}
