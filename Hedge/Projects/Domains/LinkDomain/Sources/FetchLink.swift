import Foundation

import LinkDomainInterface

public struct FetchLink: FetchLinkUseCase {
    private let repository: LinkRepository
    
    public init(repository: LinkRepository) {
        self.repository = repository
    }
    
    public func execute(urlString: String) async throws -> LinkMeta {
        return try await repository.fetch(urlString: urlString)
    }
}

public struct MockFetchLink: FetchLinkUseCase {
    
    public init() {}
    
    public func execute(urlString: String) async throws -> LinkMeta {
        LinkMeta(title: "ㅅㅂ", imageURL: nil, newsSource: "")
    }
}
