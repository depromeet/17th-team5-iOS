import Foundation

public protocol FetchSystemPrinciplesUseCase {
    func execute(_ tradeType: String?) async throws -> [PrincipleGroup]
}

