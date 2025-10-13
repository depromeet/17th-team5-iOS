//
//  HedgeBottomSheet.swift
//  DesignKit
//
//  Created by Junyoung on 10/11/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

/// 바텀시트 높이 설정 타입
public enum BottomSheetHeight {
    /// 화면 비율 기반 높이 (0.0 ~ 1.0)
    case ratio(CGFloat)
    /// 고정 높이 (pt)
    case fixed(CGFloat)
    
    /// 컨텐츠 크기에 맞춰 자동 조절
    case contentSize
    
    func calculate(screenHeight: CGFloat) -> CGFloat? {
        switch self {
        case .ratio(let ratio):
            return screenHeight * min(max(ratio, 0), 1)
        case .fixed(let height):
            return min(height, screenHeight)
        case .contentSize:
            return nil
        }
    }
}

// MARK: - Components

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
    let height: CGFloat?
    let cornerRadius: CGFloat
    let topPadding: CGFloat
    let onDragEnded: (DragGesture.Value) -> Void
    let minDismissOffset: CGFloat
    let content: Content
    
    @State private var dragOffset: CGFloat = 0
    @State private var offset: CGFloat = 0
    @Environment(\.safeAreaInsets) private var safeAreaInset
    
    var body: some View {
        ZStack {
            if let height = height {
                ScrollView(showsIndicators: false) {
                    content
                        .frame(maxWidth: .infinity)
                }
                .padding(.top, topPadding)
                .frame(height: height + safeAreaInset.bottom)
                
            } else {
                content
                    .padding(.top, topPadding)
                    .padding(.bottom, safeAreaInset.bottom)
            }
        }
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
