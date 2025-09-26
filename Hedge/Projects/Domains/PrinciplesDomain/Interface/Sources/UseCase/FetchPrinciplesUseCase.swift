import Foundation

public protocol FetchPrinciplesUseCase {
    func execute() async throws -> [Principle]
}
