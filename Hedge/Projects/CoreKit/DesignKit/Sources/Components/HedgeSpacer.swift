//
//  HedgeSpace.swift
//  DesignKit
//
//  Created by 이중엽 on 10/19/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

public struct HedgeSpacer: View {
    
    private var height: CGFloat
    private var color: Color
    
    public init(height: CGFloat) {
        self.height = height
        self.color = .clear
    }
    
    public var body: some View {
        Rectangle()
            .frame(height: height)
            .foregroundStyle(color)
    }
    
    public func color(_ color: Color) -> HedgeSpacer {
        var spacer = self
        spacer.color = color
        return spacer
    }
}

#Preview {
    HedgeSpacer(height: 1)
}
