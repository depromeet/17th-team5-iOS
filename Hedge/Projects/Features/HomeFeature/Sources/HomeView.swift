import SwiftUI

import DesignKit
import HomeFeatureInterface

import ComposableArchitecture

@ViewAction(for: HomeFeature.self)
public struct HomeView: View {
    
    @State var isActive: Bool = false
    @State private var rotationAngle: Double = 0
    
    public var store: StoreOf<HomeFeature>
    
    public init(store: StoreOf<HomeFeature>) {
        self.store = store
    }
    
    public var body: some View {
        
        ZStack {
            
            Group {
                if isActive {
                    Color.hedgeUI.grey500
                } else {
                    Color.hedgeUI.backgroundWhite
                }
            }
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    VStack(spacing: 16) {
                        HStack(spacing: 8) {
                            Image.hedgeUI.buyDemo
                            
                            Text("매수 회고하기")
                                .font(FontModel.body2Semibold)
                                .foregroundStyle(Color.hedgeUI.textPrimary)
                        }
                        .onTapGesture {
                            send(.retrospectTapped(.buy))
                        }
                        
                        HStack(spacing: 8) {
                            Image.hedgeUI.sellDemo
                            
                            Text("매수 회고하기")
                                .font(FontModel.body2Semibold)
                                .foregroundStyle(Color.hedgeUI.textPrimary)
                        }
                        .onTapGesture {
                            send(.retrospectTapped(.sell))
                        }
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white)
                    )
                    .cornerRadius(12)
                    .opacity(isActive ? 1 : 0)
                    
                    
                    Rectangle()
                        .frame(width: 20, height: 0)
                }
                
                Rectangle()
                    .frame(height: 12)
                    .foregroundStyle(.clear)
                
                HStack {
                    Spacer()
                    
                    Group {
                        if isActive {
                            Image.hedgeUI.cancelDemo
                                .transition(.scale.combined(with: .opacity))
                        } else {
                            Image.hedgeUI.plusDemo
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .rotationEffect(.degrees(rotationAngle))
                    .animation(.easeInOut(duration: 0.3), value: isActive)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isActive.toggle()
                            rotationAngle += 180
                        }
                    }
                }
                .padding(.bottom, 100)
                .padding(.trailing, 20)
            }
        }
    }
}

#Preview {
    HomeView(store: .init(initialState: HomeFeature.State(),
                          reducer: { HomeFeature() } )
    )
}
