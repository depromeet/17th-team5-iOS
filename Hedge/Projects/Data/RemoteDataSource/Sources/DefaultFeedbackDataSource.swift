//
//  DefaultFeedbackDataSource.swift
//  RemoteDataSource
//
//  Created by ChatGPT on 11/9/25.
//

import Foundation

import Alamofire

import Networker
import RemoteDataSourceInterface

public struct DefaultFeedbackDataSource: FeedbackDataSource {
    private let provider: Provider
    
    public init() {
        self.provider = Provider.authorized
    }
    
    public func fetchFeedback(retrospectionId: Int) async throws -> FeedbackResponseDTO {
        try await provider.request(FeedbackTarget.fetch(retrospectionId: retrospectionId))
    }
    
    public func createFeedback(retrospectionId: Int) async throws -> FeedbackResponseDTO {
        try await provider.request(FeedbackTarget.create(retrospectionId: retrospectionId))
    }
}

enum FeedbackTarget {
    case fetch(retrospectionId: Int)
    case create(retrospectionId: Int)
}

extension FeedbackTarget: TargetType {
    var baseURL: String {
        return Configuration.baseURL + "/api/v1/reports"
    }
    
    var header: HTTPHeaders {
        return [:]
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetch:
            return .get
        case .create:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .fetch(let retrospectionId), .create(let retrospectionId):
            return "/\(retrospectionId)/feedback"
        }
    }
    
    var parameters: Networker.RequestParams? {
        switch self {
        case .fetch:
            return nil
        case .create:
            return nil
        }
    }
    
    var encoding: any ParameterEncoding {
        return makeEncoder(contentType: .json)
    }
}

