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
import PrinciplesDomainInterface
import RetrospectDomainInterface
import FeedbackDomainInterface
import AnalysisDomainInterface
import LinkDomainInterface

public struct DataAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        // StockRespository
        container.register(StockRepository.self) { _ in
            DefaultStockRepository(
                dataSource: DefaultStockSearchDataSource()
            )
        }
        
        // PrinciplesRepository
        container.register(PrinciplesRepository.self) { _ in
            DefaultPrinciplesRepository(
                dataSource: DefaultsPrinciplesDataSource()
            )
        }
              
        container.register(RetrospectRepository.self) { _ in
            DefaultRetrospectRepository(
                dataSource: DefaultRetrospectDataSource()
            )
        }
        
        container.register(FeedbackRepository.self) { _ in
            DefaultFeedbackRepository(
                dataSource: DefaultFeedbackDataSource()
            )
        }
        
        // AnalysisRepository
        container.register(AnalysisRepository.self) { _ in
            DefaultAnalysisRepository(
                dataSource: DefaultAnalysisDataSource()
            )
        }
        
        container.register(LinkRepository.self) { _ in
            DefaultLinkRepository(
                dataSource: DefaultLinkDataSource()
            )
        }
    }
}
