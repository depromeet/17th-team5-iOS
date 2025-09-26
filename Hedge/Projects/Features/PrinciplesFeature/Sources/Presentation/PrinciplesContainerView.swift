import SwiftUI
import ComposableArchitecture
import DesignKit
import PrinciplesFeatureInterface
import StockDomainInterface

@ViewAction(for: PrinciplesFeature.self)
public struct PrinciplesContainerView: View {
    @Bindable public var store: StoreOf<PrinciplesFeature>
    
    public init(store: StoreOf<PrinciplesFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HedgeNavigationBar(buttonText: "건너뛰기", color: .secondary)
            
            Text("\(store.state.selectedPrinciples.count)개의 원칙에 따라\n투자한 \(store.state.tradeType == .buy ? "매수" : "매도")였어요")
                .font(FontModel.h1Semibold)
                .foregroundStyle(Color.hedgeUI.grey900)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            
            PrinciplesView(
                selectedPrinciples: $store.selectedPrinciples,
                principles: $store.principles,
                onPrincipleTapped: { principleId in
                    send(.principleToggled(principleId))
                },
                onCompleteTapped: {
                    send(.completeTapped)
                }
            )
        }
        .onAppear {
            send(.onAppear)
        }
    }
}

// #Preview {
//     PrinciplesContainerView(
//         store: .init(
//             initialState: PrinciplesFeature.State(tradeType: .buy, stock: StockSearch(symbol: "", title: "123", market: ""), tradingPrice: "", tradingQuantity: "", tradingDate: "", yield: "", reasonText: ""),
//             reducer: {
//                 PrinciplesFeature(coordinator: DefaultPrinciplesCoordinator(navigationController: UINavigationController(), tradeType: .buy, stock: .init(symbol: "", title: "", market: ""), tradingPrice: "", tradingQuantity: "", tradingDate: "", yield: "", reasonText: ""))
//             }
//         )
//     )
// }
