//
//  ColorView.swift
//  DesignKit
//
//  Created by Junyoung on 9/13/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import SwiftUI
import DesignKit

struct ColorView: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Grey Colors
                ColorSection(title: "Grey Colors") {
                    ColorRow(name: "grey100", color: Color.hedgeUI.grey100)
                    ColorRow(name: "grey200", color: Color.hedgeUI.grey200)
                    ColorRow(name: "grey300", color: Color.hedgeUI.grey300)
                    ColorRow(name: "grey400", color: Color.hedgeUI.grey400)
                    ColorRow(name: "grey500", color: Color.hedgeUI.grey500)
                    ColorRow(name: "grey600", color: Color.hedgeUI.grey600)
                    ColorRow(name: "grey700", color: Color.hedgeUI.grey700)
                    ColorRow(name: "grey800", color: Color.hedgeUI.grey800)
                    ColorRow(name: "grey900", color: Color.hedgeUI.grey900)
                }
                
                // Grey Opacity Colors
                ColorSection(title: "Grey Opacity Colors") {
                    ColorRow(name: "greyOpacity200", color: Color.hedgeUI.greyOpacity200)
                    ColorRow(name: "greyOpacity300", color: Color.hedgeUI.greyOpacity300)
                    ColorRow(name: "greyOpacity600", color: Color.hedgeUI.greyOpacity600)
                }
                
                // Brand & Accent Colors
                ColorSection(title: "Brand & Accent Colors") {
                    ColorRow(name: "brand500", color: Color.hedgeUI.brand500)
                    ColorRow(name: "blue500", color: Color.hedgeUI.blue500)
                    ColorRow(name: "red500", color: Color.hedgeUI.red500)
                    ColorRow(name: "red700", color: Color.hedgeUI.red700)
                }
                
                // Background Colors
                ColorSection(title: "Background Colors") {
                    ColorRow(name: "backgroundGrey", color: Color.hedgeUI.backgroundGrey)
                    ColorRow(name: "backgroundWhite", color: Color.hedgeUI.backgroundWhite)
                }
            }
            .padding()
        }
        .navigationTitle("Colors")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ColorSection<Content: View>: View {
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

struct ColorRow: View {
    let name: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            // Color Preview
            RoundedRectangle(cornerRadius: 12)
                .fill(color)
                .frame(width: 60, height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.separator), lineWidth: 0.5)
                )
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            
            // Color Info
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            
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
        ColorView()
    }
}
