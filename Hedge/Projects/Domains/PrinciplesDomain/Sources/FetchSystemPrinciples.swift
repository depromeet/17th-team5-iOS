import Foundation

import PrinciplesDomainInterface

public struct FetchSystemPrinciples: FetchSystemPrinciplesUseCase {
    private let repository: PrinciplesRepository
    
    public init(repository: PrinciplesRepository) {
        self.repository = repository
    }
    
    public func execute(_ tradeType: String) async throws -> [PrincipleGroup] {
        let groups = try await repository.fetchSystemPrincipleGroups()
        return groups.filter { $0.principleType == tradeType }
    }
}

