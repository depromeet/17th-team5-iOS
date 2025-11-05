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
            Color.hedgeUI.backgroundWhite
                .ignoresSafeArea()
            
            if isActive {
                Color.hedgeUI.grey500
                    .ignoresSafeArea()
            }
            
            VStack(spacing: 0) {
                topNavigationBar
                
                HStack(spacing: 16) {
                    Button {
                        send(.homeTabTapped)
                    } label: {
                        Text("홈")
                            .font(FontModel.h1Semibold)
                            .foregroundStyle(store.state.selectedType == .home ? Color.hedgeUI.textTitle : Color.hedgeUI.textAssistive)
                    }
                    
                    Button {
                        send(.principleTabTapped)
                    } label: {
                        Text("원칙")
                            .font(FontModel.h1Semibold)
                            .foregroundStyle(store.state.selectedType == .principle ? Color.hedgeUI.textTitle : Color.hedgeUI.textAssistive)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                ZStack {
                    // 배경 레이어
                     RoundedRectangle(cornerRadius: 22)
                         .fill(Color.hedgeUI.backgroundWhite)
                         .overlay {
                             Capsule()
                                 .fill(
                                     RadialGradient(
                                        colors: [Color.hedgeUI.shadowGreen.opacity(0.16 / 0.7),
                                                 Color.clear],
                                         center: .center,
                                         startRadius: 0,
                                        endRadius: 137.5
                                     )
                                 )
                                 .frame(width: 355, height: 274)
                                 .opacity(0.7)
                                 .blur(radius: 84.6)
                                 .offset(x: -124, y: -117)
                             
                             Capsule()
                                 .fill(
                                     RadialGradient(
                                        colors: [
                                            Color.hedgeUI.shadowBlue.opacity(0.16 / 0.7), Color.clear],
                                         center: .center,
                                         startRadius: 0,
                                         endRadius: 137.5
                                     )
                                 )
                                 .frame(width: 355, height: 274)
                                 .opacity(0.7)
                                 .blur(radius: 84.6)
                                 .offset(x: 90, y: -117)
                         }
                         .clipShape(RoundedRectangle(cornerRadius: 22)) // overlay 내부의 Circle만 clip
                     
                     // Stroke는 별도 레이어
                     RoundedRectangle(cornerRadius: 22)
                         .stroke(Color.hedgeUI.neutralBgSecondary, lineWidth: 1)
                    
                    // 내부 콘텐츠
                    VStack(spacing: 0) {
                        HStack {
                            Text("아직 모은 뱃지가 없어요")
                                .font(.body2Semibold)
                                .foregroundStyle(Color.hedgeUI.textPrimary)
                                .padding(.horizontal, 20)
                                .padding(.top, 20)
                            
                            Spacer()
                        }
                        
                        HStack(alignment: .center, spacing: 20) {
                            badge(image: HedgeUI.emerald, count: 0)
                            
                            RoundedRectangle(cornerRadius: 2)
                                .frame(width: 1)
                                .foregroundStyle(Color.hedgeUI.neutralBgSecondary)
                                .padding(.vertical, 6)
                            
                            badge(image: HedgeUI.gold, count: 0)
                            
                            RoundedRectangle(cornerRadius: 2)
                                .frame(width: 1)
                                .foregroundStyle(Color.hedgeUI.neutralBgSecondary)
                                .padding(.vertical, 6)
                            
                            badge(image: HedgeUI.silver, count: 0)
                            
                            RoundedRectangle(cornerRadius: 2)
                                .frame(width: 1)
                                .foregroundStyle(Color.hedgeUI.neutralBgSecondary)
                                .padding(.vertical, 6)
                            
                            badge(image: HedgeUI.bronze, count: 0)
                        }
                        .padding(.vertical, 20)
                        
                        Spacer()
                    }
                }
                .shadow(
                    color: Color.black.opacity(0.08),
                    radius: 20,
                    x: 0,
                    y: 6
                )
                .frame(height: 148)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                Spacer()
            }
            
            startArea
        }
    }
}

extension HomeView {
    private var topNavigationBar: some View {
        HStack(spacing: 0) {
            Spacer()
            
            Image.hedgeUI.setting
                .renderingMode(.template)
                .foregroundStyle(Color.hedgeUI.textAssistive)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 11)
    }
    
    private var startArea: some View {
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

extension HomeView {
    func badge(image: Image, count: Int) -> some View {
        VStack(alignment: .center, spacing: 6) {
            image
                .resizable()
                .frame(width: 32, height: 38)
            
            Text("\(count)개")
                .font(FontModel.label2Medium)
                .foregroundStyle(Color.hedgeUI.textAlternative)
                .padding(.vertical, 1)
        }
    }
}

#Preview {
    HomeView(store: .init(initialState: HomeFeature.State(),
                          reducer: { HomeFeature() } )
    )
}
