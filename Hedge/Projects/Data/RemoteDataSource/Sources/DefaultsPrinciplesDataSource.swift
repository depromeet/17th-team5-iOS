//
//  DefaultsPrinciplesDataSource.swift
//  RemoteDataSourceInterface
//
//  Created by 이중엽 on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import Alamofire

import Networker
import RemoteDataSourceInterface

public struct DefaultsPrinciplesDataSource: PrinciplesDataSource {
    
    private let provider: Provider
    
    public init() {
        self.provider = Provider.authorized
    }
    
    public func fetch() async throws -> RemoteDataSourceInterface.PrinciplesResponseDTO {
        try await provider.request(PrinciplesFetchTarget.fetch)
    }
}

enum PrinciplesFetchTarget {
    case fetch
}

extension PrinciplesFetchTarget: TargetType {
    var baseURL: String {
        return Configuration.baseURL + "/api/v1/principle-groups"
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
