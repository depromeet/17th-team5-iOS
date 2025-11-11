import Foundation

public protocol FetchPrinciplesUseCase {
    func execute(_ tradeType: String?) async throws -> [PrincipleGroup]
}
