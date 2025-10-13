//
//  FontDebugView.swift
//  PrinciplesFeature
//
//  Created by Assistant on 1/9/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI
import DesignKit

struct FontDebugView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("🔤 사용 가능한 폰트 목록")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom)
                
                ForEach(HedgeFont.Pretendard.allCases, id: \.self) { font in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("폰트명: \(font.rawValue)")
                            .font(.headline)
                            .foregroundColor(.blue)
                        
                        Text("이 폰트로 작성된 텍스트입니다")
                            .font(.custom(font.rawValue, size: 16))
                            .foregroundColor(.primary)
                        
                        Text("크기별 미리보기:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 16) {
                            VStack(alignment: .leading) {
                                Text("12pt")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                Text("Aa")
                                    .font(.custom(font.rawValue, size: 12))
                            }
                            
                            VStack(alignment: .leading) {
                                Text("16pt")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                Text("Aa")
                                    .font(.custom(font.rawValue, size: 16))
                            }
                            
                            VStack(alignment: .leading) {
                                Text("20pt")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                Text("Aa")
                                    .font(.custom(font.rawValue, size: 20))
                            }
                        }
                        
                        Divider()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                
                // FontModel 정보
                VStack(alignment: .leading, spacing: 12) {
                    Text("📏 FontModel 정보")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    let fontModels = [
                        ("h1Semibold", FontModel.h1Semibold),
                        ("h2Semibold", FontModel.h2Semibold),
                        ("body1Semibold", FontModel.body1Semibold),
                        ("body2Semibold", FontModel.body2Semibold),
                        ("body3Semibold", FontModel.body3Semibold),
                        ("label1Semibold", FontModel.label1Semibold),
                        ("caption1Semibold", FontModel.caption1Semibold)
                    ]
                    
                    ForEach(fontModels, id: \.0) { name, model in
                        HStack {
                            Text(name)
                                .font(.caption)
                                .foregroundColor(.blue)
                            
                            Spacer()
                            
                            Text("\(model.font.rawValue) \(model.size)pt")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Text("미리보기 텍스트")
                            .font(model)
                            .foregroundColor(.primary)
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
            .padding()
        }
        .navigationTitle("폰트 디버그")
    }
}

#Preview {
    NavigationView {
        FontDebugView()
    }
}
