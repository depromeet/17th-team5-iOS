import SwiftUI

import Core
import PrinciplesFeatureInterface
import PrinciplesDomain
import PrinciplesFeature
import StockDomainInterface

@main
struct PrinciplesApp: App {
    let builder: PrinciplesViewBuilderProtocol = PrinciplesViewBuilder()
    
    var body: some Scene {
        WindowGroup {
            AnyView(builder.build(
                coordinator: nil,
                tradeType: .buy,
                stock: StockSearch(symbol: "", title: "하이욤", market: "마켓"),
                tradeHistory: TradeHistory(tradingPrice: "10100", tradingQuantity: "10", tradingDate: "100010101", concurrency: "120010101"),
                fetchPrinciplesUseCase: MockFetchPrinciples()
            ))
        }
    }
}
