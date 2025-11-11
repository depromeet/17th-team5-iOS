import Foundation

public struct RetrospectionBadgeReport: Equatable {
    public let hedge: Int
    public let bronze: Int
    public let silver: Int
    public let gold: Int
    public let percentage: Double
    
    public init(
        hedge: Int,
        bronze: Int,
        silver: Int,
        gold: Int,
        percentage: Double
    ) {
        self.hedge = hedge
        self.bronze = bronze
        self.silver = silver
        self.gold = gold
        self.percentage = percentage
    }
    
    public static var mock: Self {
        .init(hedge: 0, bronze: 0, silver: 0, gold: 0, percentage: 0)
    }
}

