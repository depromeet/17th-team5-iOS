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
import FeedbackDomainInterface
import FeedbackDomain

import PrinciplesDomainInterface
import PrinciplesDomain
import AnalysisDomainInterface
import AnalysisDomain
import LinkDomainInterface
import LinkDomain
import RetrospectionDomainInterface
import RetrospectionDomain
import UserDefaultsDomainInterface
import UserDefaultsDomain

public struct DomainAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        container.register(FetchStockSearchUseCase.self) { resolver in
            guard let repository = resolver.resolve(StockRepository.self) else {
                fatalError("Could not resolve StockRepository")
            }
            
            return FetchStockSearch(repository: repository)
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
        
        container.register(FetchSystemPrinciplesUseCase.self) { resolver in
            guard let principlesRepository = resolver.resolve(PrinciplesRepository.self) else {
                fatalError("Could not resolve StockRepository")
            }
            
            return FetchSystemPrinciples(repository: principlesRepository)
        }
        
        container.register(FetchRecommendedPrinciplesUseCase.self) { resolver in
            guard let principlesRepository = resolver.resolve(PrinciplesRepository.self) else {
                fatalError("Could not resolve PrinciplesRepository")
            }
            
            return FetchRecommendedPrinciples(repository: principlesRepository)
        }
        
        container.register(FetchDefaultPrinciplesUseCase.self) { resolver in
            guard let principlesRepository = resolver.resolve(PrinciplesRepository.self) else {
                fatalError("Could not resolve PrinciplesRepository")
            }
            
            return FetchDefaultPrinciples(repository: principlesRepository)
        }
        
        container.register(AnalysisUseCase.self) { resolver in
            guard let repository = resolver.resolve(AnalysisRepository.self) else {
                fatalError("Could not resolve AnalysisRepository")
            }
            
            return Analysis(repository: repository)
        }
        
        container.register(FetchLinkUseCase.self) { resolver in
            guard let repository = resolver.resolve(LinkRepository.self) else {
                fatalError("Could not resolve AnalysisRepository")
            }
            
            return FetchLink(repository: repository)
        }
        
        container.register(RetrospectionUseCase.self) { resolver in
            guard let repository = resolver.resolve(RetrospectionRepository.self) else {
                fatalError("Could not resolve RetrospectionRepository")
            }
            
            return FetchRetrospection(repository: repository)
        }
        
        container.register(UploadRetrospectionImageUseCase.self) { resolver in
            guard let repository = resolver.resolve(RetrospectionRepository.self) else {
                fatalError("Could not resolve RetrospectionRepository")
            }
            
            return UploadRetrospectionImage(repository: repository)
        }
        
        container.register(CreateRetrospectionUseCase.self) { resolver in
            guard let repository = resolver.resolve(RetrospectionRepository.self) else {
                fatalError("Could not resolve RetrospectionRepository")
            }
            
            return CreateRetrospection(repository: repository)
        }
        
        container.register(FetchBadgeReportUseCase.self) { resolver in
            guard let repository = resolver.resolve(RetrospectionRepository.self) else {
                fatalError("Could not resolve RetrospectionRepository")
            }
            
            return FetchBadgeReport(repository: repository)
        }
        
        container.register(FetchRetrospectionDetailUseCase.self) { resolver in
            guard let repository = resolver.resolve(RetrospectionRepository.self) else {
                fatalError("Could not resolve RetrospectionRepository")
            }
            
            return FetchRetrospectionDetail(repository: repository)
        }
        
        container.register(DeleteRetrospectionUseCase.self) { resolver in
            guard let repository = resolver.resolve(RetrospectionRepository.self) else {
                fatalError("Could not resolve RetrospectionRepository")
            }
            
            return DeleteRetrospection(repository: repository)
        }
        
        container.register(SaveUserDefaultsUseCase.self) { _ in
            SaveUserDefaults()
        }
        
        container.register(GetUserDefaultsUseCase.self) { _ in
            GetUserDefaults()
        }
        
        container.register(DeleteUserDefaultsUseCase.self) { _ in
            DeleteUserDefaults()
        }
    }
}
