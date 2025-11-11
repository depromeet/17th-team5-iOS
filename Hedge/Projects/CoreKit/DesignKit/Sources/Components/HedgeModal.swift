//
//  HedgeModal.swift
//  DesignKit
//
//  Created by Dongjoo Lee on 9/20/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

// MARK: - Visual Card
public struct HedgeModal: View {
    public struct Actions {
        public var primaryTitle: String
        public var onPrimary: () -> Void
        public var secondaryTitle: String?
        public var onSecondary: (() -> Void)?

        public init(
            primaryTitle: String,
            onPrimary: @escaping () -> Void,
            secondaryTitle: String? = nil,
            onSecondary: (() -> Void)? = nil
        ) {
            self.primaryTitle = primaryTitle
            self.onPrimary = onPrimary
            self.secondaryTitle = secondaryTitle
            self.onSecondary = onSecondary
        }
    }

    private let title: String
    private let subtitle: String?
    private let showIcon: Bool
    private let icon: Image
    private let actions: Actions

    public init(
        title: String,
        subtitle: String? = nil,
        showIcon: Bool = true,
        icon: Image = Image.hedgeUI.error,
        actions: Actions
    ) {
        self.title = title
        self.subtitle = subtitle
        self.showIcon = showIcon
        self.icon = icon
        self.actions = actions
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Header
            HStack(alignment: .top, spacing: 8) {
                if showIcon {
                    icon
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 30, height: 30)
                }
            }
            .padding(.bottom, 8)  // space to buttons
            .padding(.leading, 3)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.body1Semibold)
                    .foregroundStyle(Color.hedgeUI.textTitle)

                if let subtitle {
                    Text(subtitle)
                        .font(.body3Medium)
                        .kerning(0.14) // ≈ 0.96% of 15pt
                        .foregroundStyle(Color.hedgeUI.textSecondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 20)

            // Actions
            if let secondary = actions.secondaryTitle, let onSecondary = actions.onSecondary {
                HStack(spacing: 9) {
                    HedgeActionButton(secondary) { onSecondary() }
                        .size(.medium)
                        .color(.secondary)

                    HedgeActionButton(actions.primaryTitle) { actions.onPrimary() }
                        .size(.medium)
                        .color(.primary)
                }
            } else {
                HedgeActionButton(actions.primaryTitle) { actions.onPrimary() }
                    .size(.medium)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white)
        )
    }
}

// MARK: - Presenter / Overlay
private struct HedgeModalModifier: ViewModifier {
    @Binding var isPresented: Bool

    let title: String
    let subtitle: String?
    let showIcon: Bool
    let icon: Image
    let actions: HedgeModal.Actions

    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                // Backdrop (standard modal pattern)
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    // no tap-to-dismiss — keep interaction blocked until user acts
                
                HedgeModal(
                    title: title,
                    subtitle: subtitle,
                    showIcon: showIcon,
                    icon: icon,
                    actions: actions
                )
                .padding(.horizontal, 40)
                .transition(.opacity.combined(with: .scale(scale: 0.98)))
                .animation(.easeInOut(duration: 0.2), value: isPresented)
            }
        }
    }
}

public extension View {
    /// Present the HedgeModal over this view.
    /// - Note: Backdrop tap does **not** dismiss; wire a "취소" button to close.
    func hedgeModal(
        isPresented: Binding<Bool>,
        title: String,
        subtitle: String? = nil,
        showIcon: Bool = true,
        icon: Image = Image.hedgeUI.error,
        actions: HedgeModal.Actions
    ) -> some View {
        modifier(HedgeModalModifier(
            isPresented: isPresented,
            title: title,
            subtitle: subtitle,
            showIcon: showIcon,
            icon: icon,
            actions: actions
        ))
    }
}


// #Preview("Modal – 1 button") {
//     StatefulPreviewWrapper(false) { show in
//         ZStack {
//             Color.hedgeUI.backgroundGrey.ignoresSafeArea()
//             HedgeTextButton("Show") { show.wrappedValue = true }
//         }
//         .hedgeModal(
//             isPresented: show,
//             title: "타이틀",
//             subtitle: "보조 설명",
//             actions: .init(
//                 primaryTitle: "버튼명",
//                 onPrimary: { show.wrappedValue = false }
//             )
//         )
//     }
// }

#Preview("Modal – 2 buttons") {
    StatefulPreviewWrapper(false) { show in
        ZStack {
            Color.hedgeUI.backgroundGrey.ignoresSafeArea()
            HedgeTextButton("Show") { show.wrappedValue = true }
        }
        .hedgeModal(
            isPresented: show,
            title: "타이틀",
            subtitle: "보조 설명",
            actions: .init(
                primaryTitle: "확인",
                onPrimary: { show.wrappedValue = false },
                secondaryTitle: "취소",
                onSecondary: { show.wrappedValue = false }
            )
        )
    }
}

// Helper for previews
private struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content
    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: value)
        self.content = content
    }
    var body: some View { content($value) }
}

