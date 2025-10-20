import Foundation

import LinkDomainInterface

public struct LinkMetaDTO: Codable, Equatable {
    public let title: String
    public let imageURL: String?
    public let newsSource: String
    
    public init(title: String, imageURL: String?, newsSource: String) {
        self.title = title
        self.imageURL = imageURL
        self.newsSource = newsSource
    }
}

extension LinkMetaDTO {
    public func toDomain() -> LinkMeta {
        return LinkMeta(title: title,
                        imageURL: imageURL,
                        newsSource: newsSource)
    }
}
