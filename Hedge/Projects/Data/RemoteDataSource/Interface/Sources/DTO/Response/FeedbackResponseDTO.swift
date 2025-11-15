import Foundation

import FeedbackDomainInterface

public struct FeedbackResponseDTO: Decodable {
    public let code: String
    public let message: String
    public let data: FeedbackDataDTO
}

public struct FeedbackDataDTO: Decodable {
    public let companyName: String
    public let companyLogo: String
    public let symbol: String
    public let price: Int
    public let volume: Int
    public let orderType: String
    public let keptCount: Int
    public let neutralCount: Int
    public let notKeptCount: Int
    public let badge: String
    public let keep: [String]
    public let fix: [String]
    public let next: [String]
}

public extension FeedbackDataDTO {
    func toDomain() -> FeedbackData {
        FeedbackData(
            companyName: companyName,
            companyLogo: companyLogo,
            symbol: symbol,
            price: price,
            volume: volume,
            orderType: orderType,
            keptCount: keptCount,
            neutralCount: neutralCount,
            notKeptCount: notKeptCount,
            badge: badge,
            keep: keep,
            fix: fix,
            next: next
        )
    }
}

