import Foundation
import SwiftUI

import DesignKit

public struct SplashView: View {
    
    public init() { }
    
    public var body: some View {
        ZStack(alignment: .center) {
            
            LinearGradient(gradient: Gradient(stops: [
                .init(color: Color.init(hex: "#29F980").opacity(0.16), location: 0.0),
                .init(color: Color.init(hex: "#29F980").opacity(0.0), location: 0.7),
            ]
            ),
                           startPoint: .top,
                           endPoint: .bottom)
            
            VStack(spacing: 20) {
                
                Image.hedgeUI.logoLarge
                
                Text("AI 피드백을 통해 나만의\n투자 원칙을 만드는 투자 회고 서비스")
                    .multilineTextAlignment(.center)
                    .font(.body1Semibold)
                    .foregroundStyle(Color.hedgeUI.textPrimary)
            }
        }
        .ignoresSafeArea()
    }
}
