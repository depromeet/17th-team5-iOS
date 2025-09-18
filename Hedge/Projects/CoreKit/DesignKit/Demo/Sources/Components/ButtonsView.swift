//
//  ButtonsView.swift
//  DesignKit
//
//  Created by Junyoung on 9/13/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import SwiftUI
import DesignKit

struct ButtonsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Size별 버튼들
                VStack(alignment: .leading, spacing: 12) {
                    Text("Size별 버튼들")
                        .font(.headline)
                    
                    VStack(spacing: 8) {
                        HedgeActionButton("Large Primary") { }
                            .size(.large)
                            .color(.primary)
                        
                        HedgeActionButton("Medium Primary") { }
                            .size(.medium)
                            .color(.primary)
                        
                        HedgeActionButton("Small Primary") { }
                            .size(.small)
                            .color(.primary)
                        
                        HedgeActionButton("Tiny Primary") { }
                            .size(.tiny)
                            .color(.primary)
                    }
                }
                
                // Color별 버튼들
                VStack(alignment: .leading, spacing: 12) {
                    Text("Color별 버튼들")
                        .font(.headline)
                    
                    VStack(spacing: 8) {
                        HedgeActionButton("Primary") { }
                            .size(.large)
                            .color(.primary)
                        
                        HedgeActionButton("Secondary") { }
                            .size(.large)
                            .color(.secondary)
                    }
                }
                
                // Disabled 상태
                VStack(alignment: .leading, spacing: 12) {
                    Text("Disabled 상태")
                        .font(.headline)
                    
                    VStack(spacing: 8) {
                        HedgeActionButton("Disabled Primary") { }
                            .size(.large)
                            .color(.primary)
                            .disabled(true)
                        
                        HedgeActionButton("Disabled Secondary") { }
                            .size(.large)
                            .color(.secondary)
                            .disabled(true)
                    }
                }
                
                // 전체 너비 버튼들
                VStack(alignment: .leading, spacing: 12) {
                    Text("전체 너비 버튼들")
                        .font(.headline)
                    
                    VStack(spacing: 8) {
                        HedgeActionButton("전체 너비 Primary") { }
                            .size(.large)
                            .color(.primary)
                            .frame(maxWidth: .infinity)
                        
                        HedgeActionButton("전체 너비 Secondary") { }
                            .size(.medium)
                            .color(.secondary)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                // 좌우 패딩이 있는 버튼들
                VStack(alignment: .leading, spacing: 12) {
                    Text("좌우 패딩 버튼들")
                        .font(.headline)
                    
                    VStack(spacing: 8) {
                        HedgeActionButton("좌우 20 패딩") { }
                            .size(.large)
                            .color(.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 20)
                        
                        HedgeActionButton("좌우 40 패딩") { }
                            .size(.medium)
                            .color(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 40)
                    }
                }
                
                // 모든 조합 테스트
                VStack(alignment: .leading, spacing: 12) {
                    Text("모든 조합 테스트")
                        .font(.headline)
                    
                    VStack(spacing: 8) {
                        HedgeActionButton("Large + Secondary + Disabled") { }
                            .size(.large)
                            .color(.secondary)
                            .disabled(true)
                        
                        HedgeActionButton("Small + Primary + Full Width") { }
                            .size(.small)
                            .color(.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 20)
                        
                        HedgeActionButton("Tiny + Secondary + Full Width") { }
                            .size(.tiny)
                            .color(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 40)
                    }
                }
            }
            .padding(16)
        }
    }
}

#Preview {
    ButtonsView()
}
