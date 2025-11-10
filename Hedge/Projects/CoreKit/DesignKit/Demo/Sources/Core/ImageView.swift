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
                // Close Images
                ImageSection(title: "Close") {
                    ImageRow(name: "closeThin", image: Image.hedgeUI.closeThin)
                    ImageRow(name: "closeThick", image: Image.hedgeUI.closeThick)
                    ImageRow(name: "closeFill", image: Image.hedgeUI.closeFill)
                }
                
                // Arrow Images
                ImageSection(title: "Arrow") {
                    ImageRow(name: "arrowLeftThin", image: Image.hedgeUI.arrowLeftThin)
                    ImageRow(name: "arrowLeftThick", image: Image.hedgeUI.arrowLeftThick)
                    ImageRow(name: "arrowRightThin", image: Image.hedgeUI.arrowRightThin)
                    ImageRow(name: "arrowRightThick", image: Image.hedgeUI.arrowRightThick)
                    ImageRow(name: "arrowDown", image: Image.hedgeUI.arrowDown)
                }
                
                // Action Images
                ImageSection(title: "Actions") {
                    ImageRow(name: "search", image: Image.hedgeUI.search)
                    ImageRow(name: "edit", image: Image.hedgeUI.edit)
                    ImageRow(name: "pencil", image: Image.hedgeUI.pencil)
                    ImageRow(name: "copy", image: Image.hedgeUI.copy)
                    ImageRow(name: "trash", image: Image.hedgeUI.trash)
                }
                
                // Status Images
                ImageSection(title: "Status") {
                    ImageRow(name: "error", image: Image.hedgeUI.error)
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
