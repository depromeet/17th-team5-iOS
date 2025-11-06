import Foundation

import RetrospectionDomainInterface

public struct FetchRetrospection: RetrospectionUseCase {
    private let repository: RetrospectionRepository
    
    public init(repository: RetrospectionRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> [RetrospectionCompany] {
        
    }
}
