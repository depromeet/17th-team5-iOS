//
//  DefaultRetrospectionRepository.swift
//  Repository
//
//  Created by 이중엽 on 9/27/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import RemoteDataSourceInterface
import RetrospectionDomainInterface
import RetrospectDomain

public struct DefaultRetrospectionRepository: RetrospectionRepository {
    
    private let dataSource: AnalysisDataSource
    
    public init(dataSource: AnalysisDataSource) {
        self.dataSource = dataSource
    }
    
    public func fetch() async throws -> [Retrospection] {
        
    }
}
