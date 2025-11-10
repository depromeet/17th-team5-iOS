//
//  DefaultRetrospectionRepository.swift
//  Repository
//
//  Created by 이중엽 on 11/6/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import RemoteDataSourceInterface
import RetrospectionDomainInterface

public struct DefaultRetrospectionRepository: RetrospectionRepository {
    private let dataSource: RetrospectionDataSource
    
    public init(dataSource: RetrospectionDataSource) {
        self.dataSource = dataSource
    }
    
    public func fetch() async throws -> [Retrospection] {
        let response = try await dataSource.fetch()
        // 모든 회사(symbol)의 retrospections를 평탄화하여 반환
        return response.data.flatMap { company in
            company.toDomain().retrospections
        }
    }
    
    public func fetchCompanies() async throws -> [RetrospectionCompany] {
        let response = try await dataSource.fetch()
        return response.data.map { $0.toDomain() }
    }
    
    public func fetchBadgeReport() async throws -> RetrospectionBadgeReport {
        let response = try await dataSource.fetchBadgeReport()
        return response.data.toDomain()
    }
    
    public func uploadImage(
        domain: String,
        fileData: Data,
        fileName: String,
        mimeType: String
    ) async throws -> UploadedImage {
        let response = try await dataSource.uploadImage(
            domain: domain,
            fileData: fileData,
            fileName: fileName,
            mimeType: mimeType
        )
        return response.data.toDomain()
    }
    
    public func createRetrospection(_ request: RetrospectionCreateRequest) async throws -> RetrospectionCreateResult {
        let dto = RetrospectionCreateRequestDTO(request)
        do {
            let response = try await dataSource.createRetrospection(dto)
            return response.data.toDomain()
        } catch {
            throw error
        }
    }
}
