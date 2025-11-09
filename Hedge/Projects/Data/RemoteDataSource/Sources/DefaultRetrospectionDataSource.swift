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
        try await provider.request(RetrospectionTarget.fetch)
    }
    
    public func uploadImage(
        domain: String,
        fileData: Data,
        fileName: String,
        mimeType: String
    ) async throws -> UploadImageResponseDTO {
        try await provider.upload(RetrospectionTarget.upload(domain: domain)) { multipart in
            multipart.append(
                fileData,
                withName: "file",
                fileName: fileName,
                mimeType: mimeType
            )
        }
    }
}

enum RetrospectionTarget {
    case fetch
    case upload(domain: String)
}

extension RetrospectionTarget: TargetType {
    var baseURL: String {
        switch self {
        case .fetch:
            return Configuration.baseURL + "/api/v1/retrospections"
        case .upload(let domain):
            return Configuration.baseURL + "/api/v1/\(domain)"
        }
    }
    
    var header: Alamofire.HTTPHeaders {
        return [:]
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetch:
            return .get
        case .upload:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .fetch:
            return ""
        case .upload:
            return "/images/upload"
        }
    }
    
    var parameters: Networker.RequestParams? {
        switch self {
        case .fetch:
            return nil
        case .upload:
            return nil
        }
    }
    
    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .fetch:
            return makeEncoder(contentType: .json)
        case .upload:
            return makeEncoder(contentType: .json)
        }
    }
}

