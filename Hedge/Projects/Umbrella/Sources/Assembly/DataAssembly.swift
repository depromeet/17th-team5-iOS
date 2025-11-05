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
import LocalDataSourceInterface
import LocalDataSource
import Persistence
import Repository
import LocalDataSourceInterface
import LocalDataSource
import StockDomainInterface
import PrinciplesDomainInterface
import RetrospectDomainInterface
import FeedbackDomainInterface
import AnalysisDomainInterface
import AuthDomain
import AuthDomainInterface
import LinkDomainInterface
import TradeDomainInterface

public struct DataAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        // StockRepository
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
        
        // AnalysisRepository
        container.register(AnalysisRepository.self) { _ in
            DefaultAnalysisRepository(
                dataSource: DefaultAnalysisDataSource()
            )
        }
        
        // Auth
        container.register(AuthDataSource.self) { _ in
            DefaultAuthDataSource()
        }
        
        container.register(TokenDataSource.self) { _ in
            DefaultTokenDataSource(tokenPersistence: TokenPersistence())
        }
        
        container.register(AuthRepository.self) { resolver in
            DefaultAuthRepository(
                tokenDataSource: resolver.resolve(TokenDataSource.self)!,
                authDataSource: resolver.resolve(AuthDataSource.self)!
                )
        }
                
        container.register(LinkRepository.self) { _ in
            DefaultLinkRepository(
                dataSource: DefaultLinkDataSource()
            )
        }
    }
}
