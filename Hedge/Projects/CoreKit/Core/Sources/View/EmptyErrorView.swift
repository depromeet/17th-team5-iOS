//
//  EmptyErrorView.swift
//  Core
//
//  Created by Junyoung on 9/21/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

import DesignKit

public struct EmptyErrorView: View {
    public init() {}
    
    public var body: some View {
        ZStack(alignment: .center) {
            VStack(alignment: .center, spacing: 12) {
                Image.hedgeUI.error
                    .resizable()
                    .frame(width: 30, height: 30)
                
                VStack(alignment: .center, spacing: 4) {
                    Text("검색 결과가 없어요")
                        .font(.body1Medium)
                        .foregroundStyle(Color.hedgeUI.textSecondary)
                    
                    Text("검색어를 다시 확인해보세요")
                        .font(.body3Medium)
                        .foregroundStyle(Color.hedgeUI.textAssistive)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
