import Foundation

public protocol CreateRetrospectionUseCase {
    func execute(_ request: RetrospectionCreateRequest) async throws -> RetrospectionCreateResult
}

