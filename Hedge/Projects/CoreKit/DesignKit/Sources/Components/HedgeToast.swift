//
//  Toast.swift
//  DesignKit
//
//  Created by Dongjoo Lee on 9/20/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

public struct HedgeToast: View {
    private var message: String
    private var type: HedgeToastType
    private var showIcon: Bool

    public init(
        _ message: String,
        type: HedgeToastType = .normal,
        showIcon: Bool = true
    ) {
        self.message = message
        self.type = type
        self.showIcon = showIcon
    }
    
    public var body: some View {
        HStack(spacing: 9) {
            if showIcon {
                type.icon
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 32, height: 32)
            }

            Text(message)
                .font(.body3Regular)
                .foregroundStyle(type.textColor)

        }
        .padding(.vertical, 15)
        .padding(.leading, showIcon ? 11 : 20)
        .padding(.trailing, 20)
        .background(
            RoundedRectangle(cornerRadius: 62, style: .continuous)
                .fill(type.backgroundColor)
                .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 8)
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
        )
    }
}

// MARK: - Style tokens for the three types shown in the design
public enum HedgeToastType {
    case normal
    case positive
    case cautionary

    var backgroundColor: Color {
        Color.hedgeUI.textSecondary
    }

    var textColor: Color {
        Color.hedgeUI.brandSecondary
    }

    var icon: Image {
        switch self {
        case .normal:     return Image.hedgeUI.toastCheck
        case .positive:   return Image.hedgeUI.toastCheck
        case .cautionary: return Image.hedgeUI.toastWarn
        }
    }
}

private struct HedgeToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let type: HedgeToastType
    let duration: TimeInterval
    let debounce: TimeInterval

    @State private var lastKey: String?
    @State private var lastShownAt: Date?

    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                VStack {
                    HedgeToast(message, type: type)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 52) // fixed distance from top
                    Spacer()
                }
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.2), value: isPresented)
                .onAppear { scheduleAutoDismissIfNeeded() }
            }
        }
        .onChange(of: isPresented) { newValue in
            guard newValue else { return }
            // dedup: ignore same toast within debounce window
            let key = "\(type)|\(message)"
            let now = Date()
            if let last = lastShownAt, lastKey == key, now.timeIntervalSince(last) < debounce {
                // immediately cancel this re-show
                isPresented = true // remain visible; no timer reset
                return
            }
            lastKey = key
            lastShownAt = now
        }
    }

    private func scheduleAutoDismissIfNeeded() {
        guard duration > 0 else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation { isPresented = false }
        }
    }
}

public extension View {
    /// Easy API
    func hedgeToast(
        isPresented: Binding<Bool>,
        message: String,
        type: HedgeToastType = .normal,
        duration: TimeInterval = 2.0,
        debounce: TimeInterval = 1.0
    ) -> some View {
        modifier(HedgeToastModifier(
            isPresented: isPresented,
            message: message,
            type: type,
            duration: duration,
            debounce: debounce
        ))
    }
}

private struct DemoView: View {
    @State private var show = false
    var body: some View {
        VStack {
            HedgeActionButton("Show Toast") { show = true }
        }
        .hedgeToast(isPresented: $show, message: "매도 기록을 입력해주세요", type: .normal)
    }
}

#Preview("Toast Overlay Demo") {
    DemoView()
}

// MARK: - HedgeToast visual previews (static component)
#Preview("Toast – Types") {
    VStack(spacing: 16) {
        HedgeToast("기본 안내 메시지", type: .normal)
        HedgeToast("성공적으로 저장되었습니다", type: .positive)
        HedgeToast("입력값을 확인해 주세요", type: .cautionary)
        HedgeToast("아이콘 없이 보여주기", type: .normal, showIcon: false)
    }
    .padding()
    .background(Color.hedgeUI.neutralBgSecondary)
}

#Preview("Toast – Dark") {
    VStack(spacing: 16) {
        HedgeToast("다크 모드 확인", type: .normal)
        HedgeToast("완료!", type: .positive)
        HedgeToast("주의가 필요합니다", type: .cautionary)
    }
    .padding()
    .background(Color.black)
    .preferredColorScheme(.dark)
}

