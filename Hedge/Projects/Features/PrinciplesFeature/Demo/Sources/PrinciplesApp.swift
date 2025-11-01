import SwiftUI
import ComposableArchitecture

import Core
import DesignKit
import PrinciplesFeatureInterface
import PrinciplesFeature
import PrinciplesDomainInterface
import PrinciplesDomain
import StockDomain
import StockDomainInterface
// import StockSearchFeatureInterface

@main
struct PrinciplesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            let fetchPrinciplesUseCase = MockFetchPrinciples()
            
            PrinciplesView(
                store: Store(
                    initialState: PrinciplesFeature.State()
                ) {
                    PrinciplesFeature(
                        fetchPrinciplesUseCase: fetchPrinciplesUseCase,
                        tradeType: TradeType.buy,
                        stock: StockSearch(symbol: "005930", title: "삼성전자", market: "KOSPI"),
                        tradeHistory: TradeHistory(
                            tradingPrice: "97,700",
                            tradingQuantity: "10",
                            tradingDate: "2025-01-01",
                            yield: nil,
                            concurrency: "KRW"
                        )
                    )
                }
            )
        }
    }
}
