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
    private let logo: String?
    private let companyName: String
    
    public init(
        logo: String?,
        companyName: String
    ) {
        self.logo = logo
        self.companyName = companyName
    }
    
    public var body: some View {
        HStack(spacing: 16) {
            if let logo {
                Text(logo)
            } else {
                Image.hedgeUI.stockThumbnailDemo
                    .resizable()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
            }
            
            Text(companyName)
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
        logo: "https://plchldr.co/i/50x50",
        companyName: "삼성전자"
    )
}
