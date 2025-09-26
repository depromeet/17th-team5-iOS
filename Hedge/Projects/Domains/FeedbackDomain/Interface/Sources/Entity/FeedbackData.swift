//
//  FeedbackData.swift
//  FeedbackDomain
//
//  Created by Junyoung on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public struct FeedbackData {
    public let summary: String
    public let marketCondition: String
    public let aiRecommendedPrinciples: [String: String]
    
    public init(
        summary: String,
        marketCondition: String,
        aiRecommendedPrinciples: [String : String]
    ) {
        self.summary = summary
        self.marketCondition = marketCondition
        self.aiRecommendedPrinciples = aiRecommendedPrinciples
    }
}
