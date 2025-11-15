import Foundation

import PrinciplesDomainInterface

public struct FetchRecommendedPrinciples: FetchRecommendedPrinciplesUseCase {
    private let repository: PrinciplesRepository
    
    public init(repository: PrinciplesRepository) {
        self.repository = repository
    }
    
    public func execute(_ tradeType: String?) async throws -> [PrincipleGroup] {
        var groups = try await repository.fetchRecommendedPrincipleGroups()
        
        if let tradeType {
            groups = groups.filter { $0.principleType == tradeType }
        }
        
        return groups
    }
}

