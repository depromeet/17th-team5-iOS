//
//  TabBarView.swift
//  RootFeature
//
//  Created by Junyoung on 9/14/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import HomeFeature

@ViewAction(for: TabBarFeature.self)
struct TabBarView: View {
    var store: StoreOf<TabBarFeature>
    
    var body: some View {
        TabView {
            IfLetStore(store.scope(state: \.homeState, action: \.delegate.homeAction)) { store in
                HomeView(store: store)
            }
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
        }
        .onAppear {
            send(.onAppear)
        }
    }
}
struct SearchView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Search View")
                    .font(.largeTitle)
                    .padding()
            }
            .navigationTitle("Search")
        }
    }
}
