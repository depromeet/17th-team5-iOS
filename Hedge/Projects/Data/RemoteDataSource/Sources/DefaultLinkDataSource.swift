//
//  DefaultLinkDataSource.swift
//  RemoteDataSource
//
//  Created by 이중엽 on 10/21/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import Networker
@preconcurrency import RemoteDataSourceInterface

public struct DefaultLinkDataSource: LinkDataSource {
    
    private let provider: LinkMetadataServiceProtocol
    
    public init() {
        self.provider = LinkMetadataService(provider: Provider.plain)
    }
    
    public func fetch(urlString: String) async throws -> LinkMetaDTO {
        let (title, imageURL, newResource) = try await provider.fetchLinkMetadata(from: urlString)
        
        return .init(title: title, imageURL: imageURL, newsSource: newResource)
    }
}
