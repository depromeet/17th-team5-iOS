import Foundation

import PrinciplesDomainInterface

public struct FetchSystemPrinciples: FetchSystemPrinciplesUseCase {
    private let repository: PrinciplesRepository
    
    public init(repository: PrinciplesRepository) {
        self.repository = repository
    }
    
    public func execute(_ tradeType: String?) async throws -> [PrincipleGroup] {
        var groups = try await repository.fetchSystemPrincipleGroups()
        
        if let tradeType {
            groups = groups.filter { $0.principleType == tradeType }
        }
        
        groups.filter { $0.groupType == .system }
        
        return groups
    }
}

