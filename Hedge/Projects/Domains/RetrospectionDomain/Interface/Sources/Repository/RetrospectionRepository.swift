//
//  RetrospectionRepository.swift
//  RetrospectionDomain
//
//  Created by 이중엽 on 11/6/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//
import Foundation

public protocol RetrospectionRepository {
    func fetch() async throws -> [Retrospection]
    func fetchCompanies() async throws -> [RetrospectionCompany]
    func uploadImage(
        domain: String,
        fileData: Data,
        fileName: String,
        mimeType: String
    ) async throws -> UploadedImage
}
