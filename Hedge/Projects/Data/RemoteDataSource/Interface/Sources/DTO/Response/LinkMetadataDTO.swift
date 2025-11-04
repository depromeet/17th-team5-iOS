import Foundation

import LinkDomainInterface

public struct LinkMetadataDTO: Codable, Equatable {
    public let title: String
    public let imageURL: String?
    public let newsSource: String

    public init(title: String, imageURL: String?, newsSource: String) {
        self.title = title
        self.imageURL = imageURL
        self.newsSource = newsSource
    }
}

extension LinkMetadataDTO {
    public func toDomain() -> LinkMetadata {
        return LinkMetadata(title: title,
                        imageURL: imageURL,
                        newsSource: newsSource)
    }
}
