//
//  DefaultRetrospectDataSource.swift
//  RemoteDataSourceInterface
//
//  Created by Junyoung on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import Alamofire

import Networker
import RemoteDataSourceInterface

public struct DefaultRetrospectDataSource: RetrospectDataSource {
    private let provider: Provider
    
    public init() {
        self.provider = Provider.plain
    }
    
    public func generate(_ request: GenerateRetrospectRequestDTO) async throws -> GenerateRetrospectResponseDTO {
        try await provider.request(RetrospectTarget.generate(request))
    }
}

enum RetrospectTarget {
    case generate(_ request: GenerateRetrospectRequestDTO)
}

extension RetrospectTarget: TargetType {
    var baseURL: String {
        return Configuration.baseURL + "/api/v1/retrospections"
    }
    
    var header: Alamofire.HTTPHeaders {
        return [:]
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .generate:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .generate:
            return ""
        }
    }
    
    var parameters: Networker.RequestParams? {
        switch self {
        case .generate(let request):
            return .body(request)
        }
    }
    
    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .generate:
            return makeEncoder(contentType: .json)
        }
    }
}

