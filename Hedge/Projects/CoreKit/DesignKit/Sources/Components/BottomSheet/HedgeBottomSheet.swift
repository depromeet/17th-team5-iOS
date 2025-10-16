//
//  HedgeBottomSheet.swift
//  DesignKit
//
//  Created by Junyoung on 10/11/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

/// 바텀시트 배경 딤
struct BottomSheetDimBackground: View {
    let onTap: () -> Void
    
    var body: some View {
        Color.black
            .opacity(0.18)
            .onTapGesture(perform: onTap)
            .transition(.opacity)
    }
}

/// 바텀시트 컨테이너
struct BottomSheetContainer<Content: View>: View {
    let title: String
    let maxHeight: CGFloat
    let cornerRadius: CGFloat
    let onDragEnded: (DragGesture.Value) -> Void
    let minDismissOffset: CGFloat
    let content: Content
    let headerHeight: CGFloat = 62
    
    @State private var contentHeight: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    @State private var offset: CGFloat = 0
    @State private var isScrollable: Bool = false
    @Environment(\.safeAreaInsets) private var safeAreaInset
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .font(.h2Semibold)
                    .foregroundStyle(Color.hedgeUI.grey900)
                    .padding(.horizontal, 20)
                    .padding(.top, 26)
                Spacer()
            }
            .frame(height: headerHeight)
            ScrollView {
                content
                    .padding(.bottom, safeAreaInset.bottom)
                    .background(
                        GeometryReader { proxy in
                            Color.clear.onAppear {
                                contentHeight = proxy.size.height + headerHeight
                                isScrollable = contentHeight > maxHeight
                            }
                        }
                    )
            }
            .scrollIndicators(.hidden)
            .scrollDisabled(!isScrollable)
        }
        .frame(height: maxMainContentHeight())
        .frame(maxWidth: .infinity)
        .background(Color.hedgeUI.backgroundWhite)
        .clipShape(RoundedCorner(radius: cornerRadius, corners: [.topLeft, .topRight]))
        .offset(y: offset + dragOffset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = max(value.translation.height, 0)
                }
                .onEnded { value in
                    let dragDistance = value.translation.height
                    
                    if dragDistance > minDismissOffset {
                        onDragEnded(value)
                    } else {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            offset = 0
                            dragOffset = 0
                        }
                    }
                }
        )
        .transition(.move(edge: .bottom))
    }
    
    private func maxMainContentHeight() -> CGFloat? {
        return contentHeight > 0 ? min(contentHeight, maxHeight) : nil
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // 상단만 둥글게, 하단은 직각으로
        path.move(to: CGPoint(x: rect.minX + radius, y: rect.minY))
        
        // 상단 왼쪽 둥글기
        path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                   radius: radius,
                   startAngle: .degrees(180),
                   endAngle: .degrees(270),
                   clockwise: false)
        
        // 상단 오른쪽 둥글기
        path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
                   radius: radius,
                   startAngle: .degrees(270),
                   endAngle: .degrees(0),
                   clockwise: false)
        
        // 오른쪽, 아래, 왼쪽은 직각
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        
        return path
    }
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        let keyWindow = UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first { $0.isKeyWindow }
        return (keyWindow?.safeAreaInsets ?? .zero).insets
    }
}

public extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private extension UIEdgeInsets {
    var insets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}
