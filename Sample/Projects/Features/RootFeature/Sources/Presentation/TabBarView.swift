//
//  TabBarView.swift
//  RootFeature
//
//  Created by Junyoung on 9/14/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            HomeView()
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
    }
}

// 각 탭의 View들
struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Home View")
                    .font(.largeTitle)
                    .padding()
            }
            .navigationTitle("Home")
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

struct FavoritesView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Favorites View")
                    .font(.largeTitle)
                    .padding()
            }
            .navigationTitle("Favorites")
        }
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Profile View")
                    .font(.largeTitle)
                    .padding()
            }
            .navigationTitle("Profile")
        }
    }
}
