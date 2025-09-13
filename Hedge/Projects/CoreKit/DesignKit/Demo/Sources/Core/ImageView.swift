//
//  ImageView.swift
//  DesignKit
//
//  Created by Junyoung on 9/13/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import SwiftUI

struct ImageView: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Chevron Left Images
                ImageSection(title: "Chevron Left") {
                    ImageRow(name: "chevronLeftSmall", image: Image.hedgeUI.chevronLeftSmall)
                    ImageRow(name: "chevronLeftThickSmall", image: Image.hedgeUI.chevronLeftThickSmall)
                    ImageRow(name: "chevronLeftTightSmall", image: Image.hedgeUI.chevronLeftTightSmall)
                    ImageRow(name: "chevronLeftTightThickSmall", image: Image.hedgeUI.chevronLeftTightThickSmall)
                }
                
                // Chevron Right Images
                ImageSection(title: "Chevron Right") {
                    ImageRow(name: "chevronRightSmall", image: Image.hedgeUI.chevronRightSmall)
                    ImageRow(name: "chevronRightThickSmall", image: Image.hedgeUI.chevronRightThickSmall)
                    ImageRow(name: "chevronRightTightSmall", image: Image.hedgeUI.chevronRightTightSmall)
                    ImageRow(name: "chevronRightTightThickSmall", image: Image.hedgeUI.chevronRightTightThickSmall)
                }
                
                // Close Images
                ImageSection(title: "Close") {
                    ImageRow(name: "close", image: Image.hedgeUI.close)
                    ImageRow(name: "closeThick", image: Image.hedgeUI.closeThick)
                }
            }
            .padding()
        }
        .navigationTitle("Images")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ImageSection<Content: View>: View {
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

struct ImageRow: View {
    let name: String
    let image: Image
    
    var body: some View {
        HStack(spacing: 16) {
            // Image Preview
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
                .frame(width: 60, height: 50)
                .overlay(
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundColor(.primary)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.separator), lineWidth: 0.5)
                )
            
            // Image Info
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
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationView {
        ImageView()
    }
}
