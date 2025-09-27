//
//  DefaultRetrospectRepository.swift
//  Repository
//
//  Created by Junyoung on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import RetrospectDomainInterface
import RemoteDataSourceInterface

public struct DefaultRetrospectRepository: RetrospectRepository {
    private let dataSource: RetrospectDataSource
    
    public init(
        dataSource: RetrospectDataSource
    ) {
        self.dataSource = dataSource
    }
    
    public func generate(request: GenerateRetrospectRequest) async throws -> Int {
        let request = GenerateRetrospectRequestDTO(
            symbol: request.symbol,
            market: request.market,
            orderType: request.orderType.rawValue,
            price: request.price,
            currency: request.currency,
            volume: request.volume,
            orderDate: request.orderDate,
            returnRate: request.returnRate,
            content: request.content,
            principleChecks: request.principleChecks.map {
                PrincipleCheckRequestDTO(principleId: $0.principleId, isFollowed: $0.isFollowed)
            },
            emotion: request.emotion.rawValue
        )
        return try await dataSource.generate(request).data.id
    }
}
