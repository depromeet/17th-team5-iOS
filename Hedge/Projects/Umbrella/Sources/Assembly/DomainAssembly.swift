//
//  DomainAssembly.swift
//  Umbrella
//
//  Created by Junyoung on 9/7/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation

import Swinject

import StockDomainInterface
import StockDomain
import RetrospectDomainInterface
import RetrospectDomain

public struct DomainAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        container.register(FetchStockSearchUseCase.self) { resolver in
            guard let repository = resolver.resolve(StockRepository.self) else {
                fatalError("Could not resolve StockRepository")
            }
            
            return FetchStockSearch(repository: repository)
        }
        
        container.register(GenerateRetrospectUseCase.self) { resolver in
            guard let repository = resolver.resolve(RetrospectRepository.self) else {
                fatalError("Could not resolve StockRepository")
            }
            
            return GenerateRetrospect(retrospectRepository: repository)
        }
    }
}
