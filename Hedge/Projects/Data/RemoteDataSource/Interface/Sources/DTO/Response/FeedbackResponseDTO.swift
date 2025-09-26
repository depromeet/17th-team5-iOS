//
//  FeedbackResponseDTO.swift
//  RemoteDataSourceInterface
//
//  Created by Junyoung on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import FeedbackDomainInterface

// MARK: - FeedbackResponseDTO
public struct FeedbackResponseDTO: Decodable {
    public let code: String
    public let message: String
    public let data: FeedbackDataResponseDTO
    
    private enum CodingKeys: String, CodingKey {
        case code
        case message
        case data
    }
}

// MARK: - FeedbackDataDTO
public struct FeedbackDataResponseDTO: Decodable {
    public let summary: String
    public let marketCondition: String
    public let aiRecommendedPrinciples: [String: String]
    
    private enum CodingKeys: String, CodingKey {
        case summary = "요약 한 마디"
        case marketCondition = "당시 시장 현황"
        case aiRecommendedPrinciples = "AI 추천 원칙"
    }
}

extension FeedbackDataResponseDTO {
    public func toDomain() -> FeedbackData {
        return FeedbackData(
            summary: summary,
            marketCondition: marketCondition,
            aiRecommendedPrinciples: aiRecommendedPrinciples
        )
    }
}
