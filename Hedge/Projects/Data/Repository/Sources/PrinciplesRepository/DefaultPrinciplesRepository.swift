//
//  DefaultPrinciplesRepository.swift
//  Repository
//
//  Created by 이중엽 on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import PrinciplesDomainInterface
import RemoteDataSourceInterface

public struct DefaultPrinciplesRepository: PrinciplesRepository {
    private let dataSource: PrinciplesDataSource
    
    public init(dataSource: PrinciplesDataSource) {
        self.dataSource = dataSource
    }
    
    public func fetch() async throws -> [PrincipleGroup] {
        return try await dataSource.fetch().data.map { $0.toDomain(.custom) }
    }
    
    public func fetchSystemPrincipleGroups() async throws -> [PrincipleGroup] {
        let response = try await dataSource.fetchSystemGroups()
        let defaults = response.data.defaults
        guard !defaults.isEmpty else { return [] }
        
        return try await withThrowingTaskGroup(of: PrincipleGroup.self) { group in
            for systemGroup in defaults {
                group.addTask {
                    let detail = try await dataSource.fetchGroupDetail(groupId: systemGroup.id)
                    return detail.toDomain(groupType: .system)
                }
            }
            
            var results: [PrincipleGroup] = []
            for try await detail in group {
                results.append(detail)
            }
            
            return results.sorted { lhs, rhs in
                (lhs.displayOrder ?? Int.max) < (rhs.displayOrder ?? Int.max)
            }
        }
    }
}
