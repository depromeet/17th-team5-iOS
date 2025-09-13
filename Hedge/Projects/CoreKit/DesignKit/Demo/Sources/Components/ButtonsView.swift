//
//  ButtonsView.swift
//  DesignKit
//
//  Created by Junyoung on 9/13/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import SwiftUI
import DesignKit

struct ButtonsView: View {
    var body: some View {
        VStack {
            HStack {
                HedgeCTAButton("다음") {
                    
                }
                .style(.fill)
                
                HedgeCTAButton("다음") {
                    
                }
                .style(.fill)
                .disabled(true)
            }
            
            HStack {
                HedgeCTAButton("건너뛰기") {
                    
                }
                .style(.ghost)
                
                HedgeCTAButton("건너뛰기") {
                    
                }
                .style(.ghost)
                .disabled(true)
            }
        }
        .padding(16)
    }
}

#Preview {
    ButtonsView()
}
