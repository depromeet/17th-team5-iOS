//
//  EmotionBottomSheet.swift
//  DesignKit
//
//  Created by Dongjoo Lee on 9/27/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

// MARK: - Emotion content (middle-only)
public struct EmotionBottomSheet: View {
    @Binding var selection: Int   // 0...4

    private let labels = ["불안", "충동", "무념무상", "자신감", "확신"]
    private let facesOn:  [Image] = [.hedgeUI.anxiousOn, .hedgeUI.impulseOn, .hedgeUI.neutralOn, .hedgeUI.confidenceOn, .hedgeUI.convictionOn]
    private let facesOff: [Image] = [.hedgeUI.anxiousOff, .hedgeUI.impulseOff, .hedgeUI.neutralOff, .hedgeUI.confidenceOff, .hedgeUI.convictionOff]

    private let horizontalPadding: CGFloat = 8

    public init(selection: Binding<Int>) {
        self._selection = selection
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Faces row (equal-width columns; centers align with dots/labels)
            EqualColumnsRow(labels.count) { i in
                ZStack {
                    if selection == i {
                        facesOn[i]
                            .resizable()
                            .frame(width: 48, height: 48)
                            .shadow(color: .black.opacity(0.08), radius: 10, y: 2)
                    } else {
                        facesOff[i]
                            .resizable()
                            .frame(width: 35, height: 35)
                            .opacity(0.35)
                    }
                }
                .frame(height: 48)
                .contentShape(Rectangle())
                .onTapGesture { selection = i }
                .animation(.easeInOut(duration: 0.15), value: selection)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 30)
            .padding(.bottom, 18)

            // Slider (pill track, progressive fill, five guide dots)
            StepSlider(
                selection: $selection,
                steps: labels.count,
                horizontalPadding: horizontalPadding
            )
            .frame(height: 48)
            .padding(.bottom, 8)

            // Labels row (centers under dots)
            EqualColumnsRow(labels.count) { i in
                Text(labels[i])
                    .font(.caption2)
                    .foregroundStyle(i == selection ? Color.hedgeUI.textTitle : Color.hedgeUI.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 4)
        }
        .padding(.horizontal, horizontalPadding)
    }
}

// MARK: - StepSlider (pill track, masked progressive fill, dots, draggable thumb)
private struct StepSlider: View {
    @Binding var selection: Int
    let steps: Int
    let horizontalPadding: CGFloat

    @GestureState private var dragX: CGFloat = .zero

    var body: some View {
        GeometryReader { geo in
            let W = geo.size.width
            let H = geo.size.height
            let thumb: CGFloat = 40
            let trackH: CGFloat = 36
            let epsilon: CGFloat = 1.0 // small gap to avoid any peek-under

            // Compute in the same padded region as faces/labels
            let count = max(steps, 2)
            let trackWidth = W - 2 * horizontalPadding
            let usable = max(trackWidth - thumb, 1)
            let stepSpacing = usable / CGFloat(count - 1)
            let leftCenter = horizontalPadding + thumb / 2
            let cx = leftCenter + CGFloat(selection) * stepSpacing

            // Fill width measured from track's left edge (flat right edge, clamped)
            let fillWidth = max(0, min(cx - horizontalPadding - thumb / 2, trackWidth))

            ZStack {
                // Build once
                let trackShape = Capsule()
                    .frame(height: trackH)
                    .padding(.horizontal, horizontalPadding)

                // 1) Base track
                trackShape
                    .foregroundStyle(Color.hedgeUI.neutralBgSecondary)

                // 2) Dots UNDER the fill
                    .overlay {
                        EqualColumnsRow(count) { _ in
                            Circle()
                                .fill(Color.hedgeUI.greyOpacity300)
                                .frame(width: 8, height: 8)
                        }
                        .padding(.horizontal, horizontalPadding)
                    }

                // 3) Green fill OVER the dots (leading anchored)
                //    includes the left inset & “meet” so it kisses the knob
                    .overlay(alignment: .leading) {
                        let leftInset = trackH / 2
                        let meet: CGFloat = 6
                        let fillWidth = max(
                            0,
                            min(cx - horizontalPadding - thumb / 2 + meet + leftInset,
                                trackWidth + leftInset)
                        )

                        Capsule()
                            .fill(Color.hedgeUI.brandPrimary)
                            .frame(width: fillWidth, height: trackH)
                            .offset(x: leftInset/2)
                    }

                // Thumb (white circle with "pause" bars)
                Circle()
                    .fill(Color.hedgeUI.backgroundWhite)
                    .frame(width: thumb, height: thumb)
                    .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
                    .overlay(
                        HStack(spacing: 4) {
                            Capsule().fill(Color.hedgeUI.textSecondary).frame(width: 4, height: 14)
                            Capsule().fill(Color.hedgeUI.textSecondary).frame(width: 4, height: 14)
                        }
                    )
                    .position(x: cx, y: H / 2)
                    .highPriorityGesture(dragGesture(width: W, leftCenter: leftCenter, stepSpacing: stepSpacing))
            }
            // Optional: animate fill/position when selection snaps
            .animation(.easeInOut(duration: 0.15), value: selection)
        }
    }

    private func dragGesture(width W: CGFloat, leftCenter: CGFloat, stepSpacing: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .updating($dragX) { value, state, _ in state = value.location.x }
            .onChanged { value in
                let minX = leftCenter
                let maxX = W - leftCenter
                let x = max(minX, min(value.location.x, maxX))
                let raw = round((x - leftCenter) / stepSpacing)
                selection = Int(raw.clamped(to: 0...CGFloat(steps - 1)))
            }
            .onEnded { value in
                let minX = leftCenter
                let maxX = W - leftCenter
                let x = max(minX, min(value.location.x, maxX))
                let raw = round((x - leftCenter) / stepSpacing)
                selection = Int(raw.clamped(to: 0...CGFloat(steps - 1)))
            }
    }
}

// MARK: - Equal-width cell row
private struct EqualColumnsRow<Content: View>: View {
    let count: Int
    let content: (Int) -> Content
    init(_ count: Int, @ViewBuilder content: @escaping (Int) -> Content) {
        self.count = count
        self.content = content
    }
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<count, id: \.self) { i in
                content(i)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

// MARK: - Helpers
private extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}

// MARK: - Bottom-sheet wrapped preview
#Preview("BottomSheet – Emotion") {
    struct SheetDemo: View {
        @State private var showSheet = true
        @State private var sel = 0

        var body: some View {
            ZStack {
                Color.hedgeUI.backgroundGrey.ignoresSafeArea()
                Button("Show Emotion Sheet") { showSheet = true }
                    .padding(.top, 40)
            }
            .overlay(
                HedgeBottomSheet(
                    isPresented: $showSheet,
                    title: "당시 어떤 감정이었나요?",
                    primaryTitle: "기록하기",
                    onPrimary: { print("selected:", sel) },
                    onClose: { print("closeing") }
                ) {
                    EmotionBottomSheet(selection: $sel) // already has the 9pt horizontal padding
                }
            )
        }
    }
    return SheetDemo()
}


// MARK: - Bottom-sheet wrapped preview
#Preview("BottomSheet – Emotion") {
    struct SheetDemo: View {
        @State private var showSheet = true
        @State private var sel = 0

        var body: some View {
            ZStack {
                Color.hedgeUI.backgroundGrey.ignoresSafeArea()
                Button("Show Emotion Sheet") { showSheet = true }
                    .padding(.top, 40)
            }
            .overlay(
                HedgeBottomSheet(
                    isPresented: $showSheet,
                    title: "당시 어떤 감정이었나요?",
                    primaryTitle: "기록하기",
                    onPrimary: { print("selected:", sel) }
                ) {
                    // Do NOT add extra horizontal padding here—component already has 20
                    EmotionBottomSheet(selection: $sel)
                }
            )
        }
    }
    return SheetDemo()
}

