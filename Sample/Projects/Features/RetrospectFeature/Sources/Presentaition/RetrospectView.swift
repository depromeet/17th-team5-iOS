//
//  RetrospectView.swift
//  RetrospectFeature
//
//  Created by Junyoung on 9/14/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

@ViewAction(for: RetrospectFeature.self)
public struct RetrospectView: View {
    public var store: StoreOf<RetrospectFeature>
    
    public init(store: StoreOf<RetrospectFeature>) {
        self.store = store
    }
    
    public var body: some View {
        Text("Hello, World!")
    }
}
