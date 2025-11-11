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
    
    public func fetchSystemGroups() async throws -> PrincipleSystemGroupsResponseDTO {
        try await provider.request(PrinciplesFetchTarget.system)
    }
    
    public func fetchGroupDetail(groupId: Int) async throws -> PrincipleGroupDetailResponseDTO {
        try await provider.request(PrinciplesFetchTarget.detail(groupId: groupId))
    }
}

enum PrinciplesFetchTarget {
    case fetch
    case system
    case detail(groupId: Int)
}

extension PrinciplesFetchTarget: TargetType {
    var baseURL: String {
        switch self {
        case .fetch, .detail:
            return Configuration.baseURL + "/api/v1/principle-groups"
        case .system:
            return Configuration.baseURL + "/api/v1/principle-groups"
        }
    }
    
    var header: Alamofire.HTTPHeaders {
        return [:]
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetch, .system, .detail:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetch:
            return ""
        case .system:
            return "/systems"
        case .detail(let groupId):
            return "/\(groupId)"
        }
    }
    
    var parameters: Networker.RequestParams? {
        switch self {
        case .fetch, .system, .detail:
            return nil
        }
    }
    
    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .fetch, .system, .detail:
            return makeEncoder(contentType: .json)
        }
    }
}
