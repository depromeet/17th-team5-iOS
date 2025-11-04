//
//  DefaultFeedbackDataSource.swift
//  RemoteDataSourceInterface
//
//  Created by Junyoung on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Alamofire

import Networker
import RemoteDataSourceInterface

public struct DefaultFeedbackDataSource: FeedbackDataSource {
    private let provider: Provider
    
    public init() {
        self.provider = Provider.authorized
    }
    
    public func fetch(id: Int) async throws -> FeedbackResponseDTO {
        try await provider.request(FeedbackTarget.fetch(id))
    }
}

enum FeedbackTarget {
    case fetch(_ id: Int)
}

extension FeedbackTarget: TargetType {
    var baseURL: String {
        return Configuration.baseURL + "/api/v1/reports"
    }
    
    var header: Alamofire.HTTPHeaders {
        return [:]
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetch:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .fetch(let id):
            return "/\(id)/feedback"
        }
    }
    
    var parameters: Networker.RequestParams? {
        switch self {
        case .fetch:
            return .none
        }
    }
    
    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .fetch:
            return makeEncoder(contentType: .json)
        }
    }
}
