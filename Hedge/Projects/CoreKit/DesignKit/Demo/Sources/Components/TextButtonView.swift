//
//  TextButtonView.swift
//  DesignKit
//
//  Created by 이중엽 on 9/17/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

import DesignKit

struct TextButtonView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Size별 버튼들
                VStack(alignment: .leading, spacing: 12) {
                    Text("Size별 버튼들")
                        .font(.headline)
                    
                    VStack(spacing: 8) {
                        HedgeTextButton("Large 버튼") { }
                            .size(.large)
                            .icon(.on)
                            .state(.active)
                        
                        HedgeTextButton("Medium 버튼") { }
                            .size(.medium)
                            .icon(.on)
                            .state(.active)
                        
                        HedgeTextButton("Small 버튼") { }
                            .size(.small)
                            .icon(.on)
                            .state(.active)
                    }
                }
                
                // Icon별 버튼들
                VStack(alignment: .leading, spacing: 12) {
                    Text("Icon별 버튼들")
                        .font(.headline)
                    
                    VStack(spacing: 8) {
                        HedgeTextButton("아이콘 있음") { }
                            .size(.medium)
                            .icon(.on)
                            .state(.active)
                        
                        HedgeTextButton("아이콘 없음") { }
                            .size(.medium)
                            .icon(.off)
                            .state(.active)
                    }
                }
                
                // State별 버튼들
                VStack(alignment: .leading, spacing: 12) {
                    Text("State별 버튼들")
                        .font(.headline)
                    
                    VStack(spacing: 8) {
                        HedgeTextButton("Active 상태") { }
                            .size(.medium)
                            .icon(.on)
                            .state(.active)
                        
                        HedgeTextButton("Disabled 상태") { }
                            .size(.medium)
                            .icon(.on)
                            .state(.disabled)
                    }
                }
                
                // 모든 조합 테스트
                VStack(alignment: .leading, spacing: 12) {
                    Text("모든 조합 테스트")
                        .font(.headline)
                    
                    VStack(spacing: 8) {
                        HedgeTextButton("Large + Icon + Active") { }
                            .size(.large)
                            .icon(.on)
                            .state(.active)
                        
                        HedgeTextButton("Medium + No Icon + Disabled") { }
                            .size(.medium)
                            .icon(.off)
                            .state(.disabled)
                        
                        HedgeTextButton("Small + Icon + Disabled") { }
                            .size(.small)
                            .icon(.on)
                            .state(.disabled)
                        
                        HedgeTextButton("Large + No Icon + Active") { }
                            .size(.large)
                            .icon(.off)
                            .state(.active)
                    }
                }
            }
            .padding(16)
        }
    }
}

#Preview {
    TextButtonView()
}
