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
import FeedbackDomainInterface
import FeedbackDomain

import PrinciplesDomainInterface
import PrinciplesDomain

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
        
        container.register(FetchFeedbackUseCase.self) { resolver in
            guard let repository = resolver.resolve(FeedbackRepository.self) else {
                fatalError("Could not resolve StockRepository")
            }
            
            return FetchFeedback(feedbackRepository: repository)
        }
        
        container.register(FetchPrinciplesUseCase.self) { resolver in
            guard let principlesRepository = resolver.resolve(PrinciplesRepository.self) else {
                fatalError("Could not resolve StockRepository")
            }
            
            return FetchPrinciples(repository: principlesRepository)
        }
    }
}
