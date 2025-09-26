//
//  DataAssembly.swift
//  Umbrella
//
//  Created by Junyoung on 9/7/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation

import Swinject

import RemoteDataSourceInterface
import RemoteDataSource
import Repository
import StockDomainInterface
import RetrospectDomainInterface

public struct DataAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        // StockRespository
        container.register(StockRepository.self) { _ in
            DefaultStockRepository(
                dataSource: DefaultStockSearchDataSource()
            )
        }
        
        container.register(RetrospectRepository.self) { _ in
            DefaultRetrospectRepository(
                dataSource: DefaultRetrospectDataSource()
            )
        }
    }
}
