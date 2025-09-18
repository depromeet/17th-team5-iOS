//
//  DefaultStockDataSource.swift
//  RemoteDataSourceInterface
//
//  Created by Junyoung on 9/18/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import Alamofire

import Networker

public struct DefaultStockSearchDataSource: StockDataSource {
    private let provider: Provider
    
    public init() {
        self.provider = Provider.plain
    }
    
    public func search(_ request: StockSearchRequestDTO) async throws -> StockSearchResponseDTO {
        try await provider.request(StockSearchTarget.search(request))
    }
}

enum StockSearchTarget {
    case search(_ request: StockSearchRequestDTO)
}

extension StockSearchTarget: TargetType {
    var baseURL: String {
        return Configuration.baseURL
    }
    
    var header: Alamofire.HTTPHeaders {
        return .defaultHeader
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .search:
            return ""
        }
    }
    
    var parameters: Networker.RequestParams? {
        switch self {
        case .search(let request):
            return .query(request)
        }
    }
    
    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .search:
            return makeEncoder(contentType: .json)
        }
    }
}
