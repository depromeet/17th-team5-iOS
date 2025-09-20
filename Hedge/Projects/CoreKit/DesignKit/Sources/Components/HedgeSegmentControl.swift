//
//  HedgeSegmentControl.swift
//  DesignKit
//
//  Created by Junyoung on 9/13/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import SwiftUI

/// 세그먼트 컨트롤 컴포넌트
/// 
/// 여러 옵션 중 하나를 선택할 수 있는 세그먼트 컨트롤입니다.
public struct HedgeSegmentControl: View {
    @Binding private var selectedIndex: Int
    private let items: [String]
    
    public init(
        selectedIndex: Binding<Int>,
        items: [String]
    ) {
        self._selectedIndex = selectedIndex
        self.items = items
    }
    
    public var body: some View {
        ZStack {
            Picker("HedgeSegmentControl", selection: $selectedIndex) {
                ForEach(0..<items.count, id: \.self) { index in
                    Text(items[index])
                        .font(.caption1Semibold)
                }
            }
            .pickerStyle(.segmented)
            .tint(Color.hedgeUI.backgroundGrey)
            .frame(height: 34)
            .onAppear {
                UISegmentedControl.appearance().setTitleTextAttributes(
                    [.foregroundColor: UIColor(Color.hedgeUI.grey900)],
                    for: .selected
                )
                UISegmentedControl.appearance().setTitleTextAttributes(
                    [.foregroundColor: UIColor(Color.hedgeUI.grey500)],
                    for: .normal
                )
            }
        }
        .fixedSize()
    }
}

#Preview {
    HedgeSegmentControl(selectedIndex: .constant(0), items: ["",""])
}
