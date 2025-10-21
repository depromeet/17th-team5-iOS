import Foundation

public protocol FetchLinkUseCase {
    func execute(urlString: String) async throws -> LinkMetadata
}
