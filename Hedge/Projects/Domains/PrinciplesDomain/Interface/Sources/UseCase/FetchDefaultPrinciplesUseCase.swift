import Foundation

public protocol FetchDefaultPrinciplesUseCase {
    func execute(_ tradeType: String?) async throws -> [PrincipleGroup]
}

