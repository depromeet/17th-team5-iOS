import SwiftUI

import Core
import ComposableArchitecture
import DesignKit
import PrinciplesFeatureInterface
import StockDomainInterface

public struct PrinciplesContainerView: View {
    @StateObject var container: MVIContainer<PrinciplesIntentProtocol, PrinciplesModelProtocol>
    
    private var intent: PrinciplesIntentProtocol { container.intent }
    private var state: PrinciplesModelProtocol { container.model }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HedgeNavigationBar(buttonText: "건너뛰기", color: .secondary, onLeftButtonTap: {
                intent.backButtonTapped()
            }, onRightButtonTap: {
                intent.skipTapped()
            })
            
            Text("\(state.selectedPrinciples.count)개의 원칙에 따라\n투자한 \(state.tradeType == .buy ? "매수" : "매도")였어요")
                .font(FontModel.h1Semibold)
                .foregroundStyle(Color.hedgeUI.grey900)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            
            PrinciplesView(
                selectedPrinciples: $container.model.selectedPrinciples,
                principles: $container.model.principles,
                onPrincipleTapped: { principleId in
                    intent.principleToggled(index: principleId)
                }
            )
            
            HedgeBottomCTAButton()
                .style(.oneButton(title: "기록하기", onTapped: {
                    intent.completeTapped()
                }))
        }
        .onAppear {
            intent.onAppear()
        }
    }
}
