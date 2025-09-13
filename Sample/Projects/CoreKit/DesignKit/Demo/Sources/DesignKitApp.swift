//
//  DesignKitApp.swift
//  DesignKitDemo
//
//  Created by Junyoung on 1/9/25.
//

import SwiftUI

@main
struct DesignKitApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                Section("Design System") {
                    NavigationLink(destination: ColorView()) {
                        HStack {
                            Text("Colors")
                        }
                    }
                    
                    NavigationLink(destination: FontView()) {
                        HStack {
                            Text("Fonts")
                        }
                    }
                    
                    NavigationLink(destination: ImageView()) {
                        HStack {
                            Text("Icons")
                        }
                    }
                    
                    NavigationLink(destination: ButtonsView()) {
                        HStack {
                            Text("Buttons")
                        }
                    }
                }
            }
            .navigationTitle("DesignKit Demo")
        }
    }
}

#Preview {
    ContentView()
}
