//
//  FontView.swift
//  DesignKit
//
//  Created by Junyoung on 9/13/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import SwiftUI
import DesignKit

struct FontView: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // H1 Fonts
                FontSection(title: "H1 (22pt)") {
                    FontRow(name: "h1Semibold", fontModel: .h1Semibold)
                    FontRow(name: "h1Medium", fontModel: .h1Medium)
                    FontRow(name: "h1Regular", fontModel: .h1Regular)
                }
                
                // H2 Fonts
                FontSection(title: "H2 (18pt)") {
                    FontRow(name: "h2Semibold", fontModel: .h2Semibold)
                    FontRow(name: "h2Medium", fontModel: .h2Medium)
                    FontRow(name: "h2Regular", fontModel: .h2Regular)
                }
                
                // Body1 Fonts
                FontSection(title: "Body1 (17pt)") {
                    FontRow(name: "body1Semibold", fontModel: .body1Semibold)
                    FontRow(name: "body1Medium", fontModel: .body1Medium)
                    FontRow(name: "body1Regular", fontModel: .body1Regular)
                }
                
                // Body2 Fonts
                FontSection(title: "Body2 (16pt)") {
                    FontRow(name: "body2Semibold", fontModel: .body2Semibold)
                    FontRow(name: "body2Medium", fontModel: .body2Medium)
                    FontRow(name: "body2Regular", fontModel: .body2Regular)
                }
                
                // Body3 Fonts
                FontSection(title: "Body3 (15pt)") {
                    FontRow(name: "body3Semibold", fontModel: .body3Semibold)
                    FontRow(name: "body3Medium", fontModel: .body3Medium)
                    FontRow(name: "body3Regular", fontModel: .body3Regular)
                }
                
                // Label1 Fonts
                FontSection(title: "Label1 (14pt)") {
                    FontRow(name: "label1Semibold", fontModel: .label1Semibold)
                    FontRow(name: "label1Medium", fontModel: .label1Medium)
                    FontRow(name: "label1Regular", fontModel: .label1Regular)
                }
                
                // Label2 Fonts
                FontSection(title: "Label2 (13pt)") {
                    FontRow(name: "label2Medium", fontModel: .label2Medium)
                    FontRow(name: "label2Regular", fontModel: .label2Regular)
                }
                
                // Caption1 Fonts
                FontSection(title: "Caption1 (12pt)") {
                    FontRow(name: "caption1Semibold", fontModel: .caption1Semibold)
                    FontRow(name: "caption1Medium", fontModel: .caption1Medium)
                    FontRow(name: "caption1Regular", fontModel: .caption1Regular)
                }
                
                // Caption2 Fonts
                FontSection(title: "Caption2 (11pt)") {
                    FontRow(name: "caption2Semibold", fontModel: .caption2Semibold)
                    FontRow(name: "caption2Medium", fontModel: .caption2Medium)
                    FontRow(name: "caption2Regular", fontModel: .caption2Regular)
                }
            }
            .padding()
        }
        .navigationTitle("Fonts")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct FontSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            VStack(spacing: 8) {
                content
            }
        }
    }
}

struct FontRow: View {
    let name: String
    let fontModel: FontModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Text(name)
                .font(fontModel)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationView {
        FontView()
    }
}
