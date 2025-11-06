import Foundation

public protocol RetrospectionUseCase {
    func execute() async throws -> [RetrospectionCompany]
}
