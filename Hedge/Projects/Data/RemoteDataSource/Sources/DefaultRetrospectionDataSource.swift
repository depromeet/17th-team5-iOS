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
        let dto: RetrospectionResponseDTO = try await provider.request(RetrospectionTarget.fetch)
        return dto
    }
    
    public func fetchBadgeReport() async throws -> BadgeReportResponseDTO {
        try await provider.request(RetrospectionTarget.badgeReport)
    }
    
    public func fetchDetail(retrospectionId: Int) async throws -> RetrospectionDetailResponseDTO {
        try await provider.request(RetrospectionTarget.fetchDetail(retrospectionId: retrospectionId))
    }
    
    public func deleteRetrospection(retrospectionId: Int) async throws -> RetrospectionDeleteResponseDTO {
        try await provider.request(RetrospectionTarget.delete(retrospectionId: retrospectionId))
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
    
    public func createRetrospection(_ request: RetrospectionCreateRequestDTO) async throws -> RetrospectionCreateResponseDTO {
        try await provider.request(RetrospectionTarget.create(request))
    }
}

enum RetrospectionTarget {
    case fetch
    case badgeReport
    case fetchDetail(retrospectionId: Int)
    case delete(retrospectionId: Int)
    case upload(domain: String)
    case create(RetrospectionCreateRequestDTO)
}

extension RetrospectionTarget: TargetType {
    var baseURL: String {
        switch self {
        case .fetch:
            return Configuration.baseURL + "/api/v1/retrospections"
        case .badgeReport:
            return Configuration.baseURL + "/api/v1/reports"
        case .fetchDetail:
            return Configuration.baseURL + "/api/v1/retrospections"
        case .delete:
            return Configuration.baseURL + "/api/v1/retrospections"
        case .upload(let domain):
            return Configuration.baseURL + "/api/v1/\(domain)"
        case .create:
            return Configuration.baseURL + "/api/v1/retrospections"
        }
    }
    
    var header: Alamofire.HTTPHeaders {
        return [:]
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetch:
            return .get
        case .badgeReport:
            return .get
        case .fetchDetail:
            return .get
        case .delete:
            return .delete
        case .upload:
            return .post
        case .create:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .fetch:
            return ""
        case .badgeReport:
            return ""
        case .fetchDetail(let retrospectionId):
            return "/\(retrospectionId)"
        case .delete(let retrospectionId):
            return "/\(retrospectionId)"
        case .upload:
            return "/images/upload"
        case .create:
            return ""
        }
    }
    
    var parameters: Networker.RequestParams? {
        switch self {
        case .fetch:
            return nil
        case .badgeReport:
            return nil
        case .fetchDetail:
            return nil
        case .delete:
            return nil
        case .upload:
            return nil
        case .create(let request):
            return .body(request)
        }
    }
    
    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .fetch:
            return makeEncoder(contentType: .json)
        case .badgeReport:
            return makeEncoder(contentType: .json)
        case .fetchDetail:
            return makeEncoder(contentType: .json)
        case .delete:
            return makeEncoder(contentType: .json)
        case .upload:
            return makeEncoder(contentType: .json)
        case .create:
            return makeEncoder(contentType: .json)
        }
    }
}

