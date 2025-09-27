//
//  HedgeBottomSheet.swift
//  DesignKit
//
//  Created by Dongjoo Lee on 9/23/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation
import SwiftUI

public struct HedgeBottomSheet<Content: View>: View {
    @Binding var isPresented: Bool
    let title: String
    let primaryTitle: String
    let onPrimary: () -> Void
    let content: () -> Content
    let onClose: (() -> Void)?
    
    public init(
        isPresented: Binding<Bool>,
        title: String,
        primaryTitle: String,
        onPrimary: @escaping () -> Void,
        onClose: (() -> Void)? = nil,          // ← new
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isPresented = isPresented
        self.title = title
        self.primaryTitle = primaryTitle
        self.onPrimary = onPrimary
        self.onClose = onClose
        self.content = content
    }
    
    public var body: some View {
        ZStack {
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { isPresented = false }
                
                VStack {
                    Spacer()
                    VStack(spacing: 0) {
                        Capsule()
                            .fill(Color.black.opacity(0.15))
                            .frame(width: 40, height: 5)
                            .padding(.top, 8)
                            .padding(.bottom, 12)
                        
                        // Header
                        HStack {
                            Text(title)
                                .font(.body1Semibold)
                                .foregroundStyle(Color.hedgeUI.textTitle)
                            Spacer()
                            Button {
                                onClose?()
                                isPresented = false
                            } label: {
                                Image.hedgeUI.closeBottomSheet
                                    .resizable()
                                    .frame(width: 28, height: 28)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Content
                        content()
                            .padding(.horizontal, 20)
                            .padding(.bottom, 24)
                        
                        // Footer
                        HedgeBottomCTAButton()
                            .style(.oneButton(title: "기록하기", onTapped: {
                                onPrimary()
                                isPresented = false
                            }))
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.white)
                    )
                    .transition(.move(edge: .bottom))
                }
                .animation(.easeInOut(duration: 0.25), value: isPresented)
            }
        }
    }
}

// MARK: - Preview helper
private struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content
    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: value)
        self.content = content
    }
    var body: some View { content($value) }
}


// MARK: - Checklist content (middle-only)
public struct ChecklistContent: View {
    @Binding var checked: Set<Int>
    
    let items: [String]
    
    public init(checked: Binding<Set<Int>>, items: [String]) {
        self._checked = checked
        self.items = items
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(items.indices, id: \.self) { i in
                HStack(spacing: 12) {
                    // Leading emoji
                    Text("😊")
                        .font(.system(size: 24))
                        .frame(width: 35, height: 35)

                    // Text
                    Text(items[i])
                        .font(.body3Medium)
                        .foregroundStyle(Color.hedgeUI.textTitle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)

                    // Trailing check control
                    Button {
                        if checked.contains(i) { checked.remove(i) } else { checked.insert(i) }
                    } label: {
                        Circle()
                            .fill(checked.contains(i) ? Color.hedgeUI.brandPrimary : Color.hedgeUI.neutralBgSecondary)
                            .frame(width: 24, height: 24)
                            .overlay(
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundStyle(.white)
                                    .opacity(checked.contains(i) ? 1 : 0)
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.vertical, 14)

                if i < items.count - 1 {
                    Divider()
                }
            }
            .padding(.bottom, 4) // breathing room above footer
        }
    }
}


private struct TwoStatePreview<A, B, Content: View>: View {
    @State var a: A
    @State var b: B
    let content: (Binding<A>, Binding<B>) -> Content
    init(_ a: A, _ b: B, @ViewBuilder content: @escaping (Binding<A>, Binding<B>) -> Content) {
        _a = State(initialValue: a); _b = State(initialValue: b); self.content = content
    }
    var body: some View { content($a, $b) }
}

#Preview("BottomSheet – Checklist (DesignKit Scaffold)") {
    TwoStatePreview(false, Set<Int>()) { show, checked in
        let items = [
            "주가가 오르는 흐름이면 매수, 하락 흐름이면 매도하기",
            "기업의 본질 가치보다 낮게 거래되는 주식을 찾아 장기 보유하기",
            "단기 등락에 흔들리지 말고 기업의 장기 성장성에 집중하기",
            "분산 투자 원칙을 지키고 감정적 결정을 피하기",
            "리스크를 관리하며 손절 기준을 미리 정해두기"
        ]
        ZStack {
            Color.hedgeUI.backgroundGrey.ignoresSafeArea()
            HedgeTextButton("Show Checklist") { show.wrappedValue = true }
        }
        .overlay(
            HedgeBottomSheet(
                isPresented: show,
                title: "투자 원칙",
                primaryTitle: "기록하기",
                onPrimary: {
                    let picked = checked.wrappedValue.sorted().map { items[$0] }
                    print("picked:", picked)
                }
            ) { ChecklistContent(checked: checked, items: items) }
        )
    }
}
