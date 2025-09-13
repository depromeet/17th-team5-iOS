//
//  SegmentView.swift
//  DesignKit
//
//  Created by Junyoung on 9/13/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import SwiftUI
import DesignKit

struct SegmentView: View {
    @State var selectedIndex: Int = 0
    var body: some View {
        VStack {
            HedgeSegmentControl(selectedIndex: $selectedIndex, items: ["KRW", "$"])
                .frame(width: 96)
            
            HedgeSegmentControl(selectedIndex: $selectedIndex, items: ["원", "$"])
                .frame(width: 80)
        }
    }
}

#Preview {
    SegmentView()
}
