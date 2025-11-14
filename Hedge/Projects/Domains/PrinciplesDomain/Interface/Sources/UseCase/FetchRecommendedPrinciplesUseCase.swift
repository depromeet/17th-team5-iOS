import Foundation

public protocol FetchRecommendedPrinciplesUseCase {
    func execute(_ tradeType: String?) async throws -> [PrincipleGroup]
}

