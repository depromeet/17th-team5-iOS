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
    
    public func createPrincipleGroup(_ request: CreatePrincipleGroupRequestDTO) async throws -> CreatePrincipleGroupResponseDTO {
        try await provider.request(PrinciplesFetchTarget.create(request))
    }
}

enum PrinciplesFetchTarget {
    case fetch
    case system
    case detail(groupId: Int)
    case create(CreatePrincipleGroupRequestDTO)
}

extension PrinciplesFetchTarget: TargetType {
    var baseURL: String {
        switch self {
        case .fetch, .detail, .system, .create:
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
        case .create:
            return .post
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
        case .create:
            return ""
        }
    }
    
    var parameters: Networker.RequestParams? {
        switch self {
        case .fetch, .system, .detail:
            return nil
        case .create(let request):
            return .body(request)
        }
    }
    
    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .fetch, .system, .detail, .create:
            return makeEncoder(contentType: .json)
        }
    }
}
