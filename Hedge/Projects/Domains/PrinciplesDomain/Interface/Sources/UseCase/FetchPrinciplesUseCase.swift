import Foundation

import Core

public protocol FetchPrinciplesUseCase {
    func execute(_ tradeType: TradeType) async throws -> [PrincipleGroup]
}
