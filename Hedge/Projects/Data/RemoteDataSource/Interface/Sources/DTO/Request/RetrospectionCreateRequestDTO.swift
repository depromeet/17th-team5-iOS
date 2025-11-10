import Foundation

import RetrospectionDomainInterface

public struct RetrospectionCreateRequestDTO: Encodable {
    public let symbol: String
    public let market: String
    public let orderType: String
    public let price: Int
    public let currency: String
    public let volume: Int
    public let orderDate: String
    public let returnRate: Double?
    public let principleChecks: [RetrospectionPrincipleCheckRequestDTO]
    
    public init(
        symbol: String,
        market: String,
        orderType: String,
        price: Int,
        currency: String,
        volume: Int,
        orderDate: String,
        returnRate: Double?,
        principleChecks: [RetrospectionPrincipleCheckRequestDTO]
    ) {
        self.symbol = symbol
        self.market = market
        self.orderType = orderType
        self.price = price
        self.currency = currency
        self.volume = volume
        self.orderDate = orderDate
        self.returnRate = returnRate
        self.principleChecks = principleChecks
    }
}

public struct RetrospectionPrincipleCheckRequestDTO: Encodable {
    public let principleId: Int
    public let status: String
    public let reason: String
    public let imageIds: [Int]
    public let links: [String]
    
    public init(
        principleId: Int,
        status: String,
        reason: String,
        imageIds: [Int],
        links: [String]
    ) {
        self.principleId = principleId
        self.status = status
        self.reason = reason
        self.imageIds = imageIds
        self.links = links
    }
}

public extension RetrospectionCreateRequestDTO {
    init(_ request: RetrospectionCreateRequest) {
        self.init(
            symbol: request.symbol,
            market: request.market,
            orderType: request.orderType,
            price: request.price,
            currency: request.currency,
            volume: request.volume,
            orderDate: request.orderDate,
            returnRate: request.returnRate,
            principleChecks: request.principleChecks.map { RetrospectionPrincipleCheckRequestDTO($0) }
        )
    }
}

public extension RetrospectionPrincipleCheckRequestDTO {
    init(_ request: RetrospectionPrincipleCheckRequest) {
        self.init(
            principleId: request.principleId,
            status: request.status.rawValue,
            reason: request.reason,
            imageIds: request.imageIds,
            links: request.links
        )
    }
}

