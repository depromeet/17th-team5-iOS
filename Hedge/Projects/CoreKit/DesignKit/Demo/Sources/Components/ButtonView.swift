//
//  ButtonView.swift
//  DesignKit
//
//  Created by 이중엽 on 9/17/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

import DesignKit

struct ButtonView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Size별 버튼들
                VStack(alignment: .leading, spacing: 12) {
                    Text("Size별 버튼들")
                        .font(.headline)
                    
                    VStack(spacing: 8) {
                        HedgeButton("Large 버튼") { }
                            .size(.large)
                            .icon(Image.hedgeUI.chevronRightSmall)
                            .state(.active)
                        
                        HedgeButton("Medium 버튼") { }
                            .size(.medium)
                            .icon(Image.hedgeUI.chevronRightSmall)
                            .state(.active)
                        
                        HedgeButton("Small 버튼") { }
                            .size(.small)
                            .icon(Image.hedgeUI.chevronRightSmall)
                            .state(.active)
                    }
                }
                
                // Icon별 버튼들
                VStack(alignment: .leading, spacing: 12) {
                    Text("Icon별 버튼들")
                        .font(.headline)
                    
                    VStack(spacing: 8) {
                        HedgeButton("아이콘 있음") { }
                            .size(.medium)
                            .icon(Image.hedgeUI.chevronRightSmall)
                            .state(.active)
                        
                        HedgeButton("아이콘 없음") { }
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
                        HedgeButton("Active 상태") { }
                            .size(.medium)
                            .icon(Image.hedgeUI.chevronRightSmall)
                            .state(.active)
                        
                        HedgeButton("Disabled 상태") { }
                            .size(.medium)
                            .icon(Image.hedgeUI.chevronRightSmall)
                            .state(.disabled)
                    }
                }
                
                // 모든 조합 테스트
                VStack(alignment: .leading, spacing: 12) {
                    Text("모든 조합 테스트")
                        .font(.headline)
                    
                    VStack(spacing: 8) {
                        HedgeButton("Large + Icon + Active") { }
                            .size(.large)
                            .icon(Image.hedgeUI.chevronRightSmall)
                            .state(.active)
                        
                        HedgeButton("Medium + No Icon + Disabled") { }
                            .size(.medium)
                            .icon(.off)
                            .state(.disabled)
                        
                        HedgeButton("Small + Icon + Disabled") { }
                            .size(.small)
                            .icon(Image.hedgeUI.chevronRightSmall)
                            .state(.disabled)
                        
                        HedgeButton("Large + No Icon + Active") { }
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
    ButtonView()
}
