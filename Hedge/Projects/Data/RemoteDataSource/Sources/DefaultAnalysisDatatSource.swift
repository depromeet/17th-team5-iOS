//
//  DefaultAnalysisDatatSource.swift
//  RemoteDataSource
//
//  Created by 이중엽 on 9/27/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import Alamofire

import Networker
@preconcurrency import RemoteDataSourceInterface

public struct DefaultAnalysisDataSource: AnalysisDataSource {
    private let provider: Provider
    
    public init() {
        self.provider = Provider.plain
    }
    
    public func fetch(_ request: AnalysisRequestDTO) async throws -> AnalysisResponseDTO {
        return try await provider.request(AnalysisTarget.fetch(request))
    }
}

enum AnalysisTarget {
    case fetch(_ request: AnalysisRequestDTO)
}

extension AnalysisTarget: TargetType {
    var baseURL: String {
        return Configuration.baseURL + "/api/analysis/v1"
    }
    
    var header: Alamofire.HTTPHeaders {
        return [:]
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetch:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetch:
            return ""
        }
    }
    
    var parameters: Networker.RequestParams? {
        switch self {
        case .fetch(let request):
            return .query(request)
        }
    }
    
    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .fetch:
            return URLEncoding.queryString
        }
    }
}
