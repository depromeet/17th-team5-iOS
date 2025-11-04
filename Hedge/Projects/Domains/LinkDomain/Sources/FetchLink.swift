import Foundation

import LinkDomainInterface

public struct FetchLink: FetchLinkUseCase {
    private let repository: LinkRepository
    
    public init(repository: LinkRepository) {
        self.repository = repository
    }
    
    public func execute(urlString: String) async throws -> LinkMetadata {
        return try await repository.fetch(urlString: urlString)
    }
}

public struct MockFetchLink: FetchLinkUseCase {
    
    public init() {}
    
    public func execute(urlString: String) async throws -> LinkMetadata {
        LinkMetadata(title: "李대통령 수사·기소분리 거대한 변화…警, 응답할 수 있어야(종합)", imageURL: "https://imgnews.pstatic.net/image/001/2025/10/21/PYH2025102106480001300_P4_20251021113530677.jpg?type=w860", newsSource: "naver.com")
    }
}
