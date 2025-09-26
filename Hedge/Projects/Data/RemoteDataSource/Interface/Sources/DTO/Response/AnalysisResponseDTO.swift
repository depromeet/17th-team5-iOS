//
//  AnalysisResponseDTO.swift
//  RemoteDataSourceInterface
//
//  Created by 이중엽 on 9/27/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import AnalysisDomainInterface

// MARK: - AnalysisResponse
public struct AnalysisResponseDTO: Decodable {
    public let code: String
    public let message: String
    public let data: AnalysisDataResponseDTO
}

// MARK: - AnalysisData
public struct AnalysisDataResponseDTO: Decodable {
    public let text: String
}

extension AnalysisDataResponseDTO {
    public func toDomain() -> Analysis {
        return Analysis(text: text)
    }
}
