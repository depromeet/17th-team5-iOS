//
//  DefaultAuthDataSource.swift
//  RemoteDataSourceInterface
//
//  Created by Junyoung on 10/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import Alamofire

import Networker
import RemoteDataSourceInterface

public struct DefaultAuthDataSource: AuthDataSource {
    private let provider: Provider
    private let authProvider: Provider
    
    public init() {
        self.provider = Provider.plain
        self.authProvider = Provider.authorized
    }
    
    public func social(_ request: SocialLoginRequestDTO) async throws -> SocialLoginResponseDTO {
        try await provider.request(AuthTarget.social(request))
    }
    
    public func withdraw(_ request: AuthCodeRequestDTO?) async throws {
        try await provider.request(AuthTarget.withdraw(request))
    }
}


enum AuthTarget {
    case social(_ request: SocialLoginRequestDTO)
    case withdraw(_ request: AuthCodeRequestDTO?)
}

extension AuthTarget: TargetType {
    var baseURL: String {
        return Configuration.baseURL + "/api/v1"
    }
    
    var header: Alamofire.HTTPHeaders {
        return [:]
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .social:
            .post
        case .withdraw:
            .delete
        }
    }
    
    var path: String {
        switch self {
        case .social:
            "/auth/social-login"
        case .withdraw:
            "/user"
        }
    }
    
    var parameters: Networker.RequestParams? {
        switch self {
        case .social(let request):
            return .body(request)
        case .withdraw(let request):
            return .query(request)
        }
    }
    
    var encoding: any Alamofire.ParameterEncoding {
        return makeEncoder(contentType: .json)
    }
}
