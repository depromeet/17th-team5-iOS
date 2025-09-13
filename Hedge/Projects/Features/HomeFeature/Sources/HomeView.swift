//
//  HomeView.swift
//  HomeFeature
//
//  Created by Junyoung on 9/14/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import SwiftUI

import HomeFeatureInterface

import ComposableArchitecture

@ViewAction(for: HomeFeature.self)
public struct HomeView: View {
    public var store: StoreOf<HomeFeature>
    
    public init(store: StoreOf<HomeFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            Button {
                send(.retrospectTapped)
            } label: {
                Text("회고")
            }
        }
    }
}
