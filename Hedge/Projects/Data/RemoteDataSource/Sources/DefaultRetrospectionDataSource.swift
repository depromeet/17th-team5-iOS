//
//  DefaultRetrospectionDataSource.swift
//  RemoteDataSourceInterface
//
//  Created by 이중엽 on 11/6/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import Alamofire

import Networker
import RemoteDataSourceInterface

public struct DefaultRetrospectionDataSource: RetrospectionDataSource {
    
    private let provider: Provider
    
    public init() {
        self.provider = Provider.authorized
    }
    
    public func fetch() async throws -> RetrospectionResponseDTO {
        try await provider.request(RetrospectionFetchTarget.fetch)
    }
}

enum RetrospectionFetchTarget {
    case fetch
}

extension RetrospectionFetchTarget: TargetType {
    var baseURL: String {
        return Configuration.baseURL + "/api/v1/retrospections"
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
        case .fetch:
            return nil
        }
    }
    
    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .fetch:
            return makeEncoder(contentType: .json)
        }
    }
}

