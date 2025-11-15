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
        let recommended = try await fetchRecommendedPrincipleGroups()
        let defaults = try await fetchDefaultPrincipleGroups()
        return recommended + defaults
    }
    
    public func fetchRecommendedPrincipleGroups() async throws -> [PrincipleGroup] {
        let response = try await dataSource.fetchSystemGroups()
        let recommended = response.data.recommended
        guard !recommended.isEmpty else { return [] }
        
        // systemGroup 정보를 딕셔너리로 저장하여 imageId와 investorName 보존
        let systemGroupMap: [Int: (imageId: Int?, investorName: String?)] = Dictionary(
            uniqueKeysWithValues: recommended.map { ($0.id, ($0.imageId, $0.investorName)) }
        )
        
        return try await withThrowingTaskGroup(of: PrincipleGroup.self) { group in
            for systemGroup in recommended {
                group.addTask {
                    let detail = try await dataSource.fetchGroupDetail(groupId: systemGroup.id)
                    let metadata = systemGroupMap[systemGroup.id]
                    return detail.toDomain(
                        groupType: .system,
                        imageId: metadata?.imageId,
                        investorName: metadata?.investorName
                    )
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
    
    public func fetchDefaultPrincipleGroups() async throws -> [PrincipleGroup] {
        let response = try await dataSource.fetchSystemGroups()
        let defaults = response.data.defaults
        guard !defaults.isEmpty else { return [] }
        
        // systemGroup 정보를 딕셔너리로 저장하여 imageId와 investorName 보존
        let systemGroupMap: [Int: (imageId: Int?, investorName: String?)] = Dictionary(
            uniqueKeysWithValues: defaults.map { ($0.id, ($0.imageId, $0.investorName)) }
        )
        
        return try await withThrowingTaskGroup(of: PrincipleGroup.self) { group in
            for systemGroup in defaults {
                group.addTask {
                    let detail = try await dataSource.fetchGroupDetail(groupId: systemGroup.id)
                    let metadata = systemGroupMap[systemGroup.id]
                    return detail.toDomain(
                        groupType: .system,
                        imageId: metadata?.imageId,
                        investorName: metadata?.investorName
                    )
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
    
    public func createPrincipleGroup(
        groupName: String,
        displayOrder: Int,
        principleType: String,
        thumbnail: String,
        principles: [(principle: String, description: String)]
    ) async throws -> PrincipleGroup {
        let request = CreatePrincipleGroupRequestDTO(
            groupName: groupName,
            displayOrder: displayOrder,
            principleType: principleType,
            thumbnail: thumbnail,
            principles: principles.map { PrincipleItemDTO(principle: $0.principle, description: $0.description) }
        )
        let response = try await dataSource.createPrincipleGroup(request)
        return response.data.toDomain(.custom)
    }
}
