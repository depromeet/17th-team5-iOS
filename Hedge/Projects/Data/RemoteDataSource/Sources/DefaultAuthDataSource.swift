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
    
    public init() {
        self.provider = Provider.plain
    }
    
    public func social(_ request: SocialLoginRequestDTO) async throws -> SocialLoginResponseDTO {
        try await provider.request(AuthTarget.social(request))
    }
}


enum AuthTarget {
    case social(_ request: SocialLoginRequestDTO)
}

extension AuthTarget: TargetType {
    var baseURL: String {
        return Configuration.baseURL + "/api/v1/auth"
    }
    
    var header: Alamofire.HTTPHeaders {
        return [:]
    }
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var path: String {
        return "/social-login"
    }
    
    var parameters: Networker.RequestParams? {
        switch self {
        case .social(let request):
            return .body(request)
        }
    }
    
    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .social:
            return makeEncoder(contentType: .json)
        }
    }
}
