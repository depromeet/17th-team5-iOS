//
//  RetrospectionDataSource.swift
//  RemoteDataSourceInterface
//
//  Created by 이중엽 on 11/6/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol RetrospectionDataSource {
    func fetch() async throws -> RetrospectionResponseDTO
    
    func fetchBadgeReport() async throws -> BadgeReportResponseDTO
    
    func fetchDetail(retrospectionId: Int) async throws -> RetrospectionDetailResponseDTO
    
    func uploadImage(
        domain: String,
        fileData: Data,
        fileName: String,
        mimeType: String
    ) async throws -> UploadImageResponseDTO
    func createRetrospection(_ request: RetrospectionCreateRequestDTO) async throws -> RetrospectionCreateResponseDTO
}

