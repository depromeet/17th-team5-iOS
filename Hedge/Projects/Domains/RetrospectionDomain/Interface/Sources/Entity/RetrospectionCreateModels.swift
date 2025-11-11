import Foundation

public struct RetrospectionCreateRequest: Equatable {
    public let symbol: String
    public let market: String
    public let orderType: String
    public let price: Int
    public let currency: String
    public let volume: Int
    public let orderDate: String
    public let returnRate: Double?
    public let principleChecks: [RetrospectionPrincipleCheckRequest]
    
    public init(
        symbol: String,
        market: String,
        orderType: String,
        price: Int,
        currency: String,
        volume: Int,
        orderDate: String,
        returnRate: Double?,
        principleChecks: [RetrospectionPrincipleCheckRequest]
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

public struct RetrospectionPrincipleCheckRequest: Equatable {
    public let principleId: Int
    public let status: RetrospectionPrincipleStatus
    public let reason: String
    public let imageIds: [Int]
    public let links: [String]
    
    public init(
        principleId: Int,
        status: RetrospectionPrincipleStatus,
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

public enum RetrospectionPrincipleStatus: String, Equatable {
    case kept = "KEPT"
    case neutral = "NEUTRAL"
    case notKept = "NOT_KEPT"
}

public struct RetrospectionCreateResult: Equatable {
    public let id: Int
    public let userId: Int
    public let symbol: String
    public let market: String
    public let orderType: String
    public let price: Int
    public let currency: String
    public let volume: Int
    public let orderDate: String
    public let returnRate: Double?
    public let createdAt: String
    public let updatedAt: String
    
    public init(
        id: Int,
        userId: Int,
        symbol: String,
        market: String,
        orderType: String,
        price: Int,
        currency: String,
        volume: Int,
        orderDate: String,
        returnRate: Double?,
        createdAt: String,
        updatedAt: String
    ) {
        self.id = id
        self.userId = userId
        self.symbol = symbol
        self.market = market
        self.orderType = orderType
        self.price = price
        self.currency = currency
        self.volume = volume
        self.orderDate = orderDate
        self.returnRate = returnRate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

