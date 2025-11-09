//
//  HedgeTopView.swift
//  DesignKit
//
//  Created by 이중엽 on 9/20/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import SwiftUI

import Kingfisher

/// 상단 정보를 표시하는 컴포넌트
/// 
/// 종목 정보나 상단 헤더 정보를 표시할 때 사용합니다.
public struct HedgeTopView: View {
    
    let logo: String?
    let companyName: String
    let description: String
    let footnote: String?
    let buttonImage: Image?
    let buttonImageOnTapped: (() -> Void)?
    
    public init(
        logo: String?,
        companyName: String,
        description: String,
        footnote: String? = nil,
        buttonImage: Image? = nil,
        buttonImageOnTapped: (() -> Void)? = nil
    ) {
        self.logo = logo
        self.companyName = companyName
        self.description = description
        self.footnote = footnote
        self.buttonImage = buttonImage
        self.buttonImageOnTapped = buttonImageOnTapped
    }
    
    public var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 7) {
                
                if let logo {
                    KFImage(URL(string: logo)!)
                        .resizable()
                        .frame(width: 22, height: 22)
                } else {
                    Image.hedgeUI.stockThumbnailDemo
                        .resizable()
                        .frame(width: 22, height: 22)
                }
                
                Text(companyName)
                    .font(FontModel.body3Medium)
                    .foregroundStyle(Color.hedgeUI.grey900)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            HStack(spacing: 4) {
                Text(description)
                    .font(FontModel.h1Semibold)
                    .foregroundStyle(Color.hedgeUI.grey900)
                    .fixedSize(horizontal: false, vertical: true)
                
                if let buttonImage {
                    Button {
                        buttonImageOnTapped?()
                    } label: {
                        buttonImage
                    }
                    .frame(width: 30, height: 30)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if let footnote {
                Text(footnote)
                    .font(FontModel.label2Regular)
                    .foregroundStyle(Color.hedgeUI.textAlternative)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

#Preview {
    HedgeTopView(
        logo: nil,
        companyName: "삼성전자",
        description: "얼마에 매도하셨나요?",
        footnote: "얼마에 매도하셨나요?",
        buttonImage: HedgeUI.closeFill) {
            print("button Image tapped")
        }
}
