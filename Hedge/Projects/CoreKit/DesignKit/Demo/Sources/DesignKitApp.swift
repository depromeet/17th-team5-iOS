//
//  DesignKitApp.swift
//  DesignKitDemo
//
//  Created by Junyoung on 1/9/25.
//

import SwiftUI

import DesignKit

@main
struct DesignKitApp: App {
    
    init() {
        HedgeFont.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HedgeNavigationBar(
                    buttonText: "다음",
                    onLeftButtonTap: {
                        print("뒤로가기 버튼 클릭")
                    },
                    onRightButtonTap: {
                        print("다음 버튼 클릭")
                    }
                )
                
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
                        
                        
                    }
                    
                    Section("Components") {
                        NavigationLink(destination: ActionButtonView()) {
                            HStack {
                                Text("ActionButtons")
                            }
                        }
                        
                        NavigationLink(destination: SegmentView()) {
                            HStack {
                                Text("Segments")
                            }
                        }
                        
                        NavigationLink(destination: TradeTextFieldView()) {
                            HStack {
                                Text("TradeTextFieldViews")
                            }
                        }
                        
                        NavigationLink(destination: SearchTextFieldView()) {
                            HStack {
                                Text("SearchTextField")
                            }
                        }
                        
                        NavigationLink(destination: BottomCTAButtonView()) {
                            HStack {
                                Text("Bottom CTA Button")
                            }
                        }
                        
                        NavigationLink(destination: TextButtonView()) {
                            HStack {
                                Text("TextButtons")
                            }
                        }
                        
                        NavigationLink(destination: TopView()) {
                            HStack {
                                Text("TopView")
                            }
                        }
                        
                        NavigationLink(destination: FloatingToolbar{_ in}) {
                            HStack {
                                Text("FloatingToolbar")
                            }
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.all)
    }
}

#Preview {
    ContentView()
}
