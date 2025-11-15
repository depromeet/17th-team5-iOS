//
//  DefaultPrinciplesCoordinator.swift
//  PrinciplesFeature
//
//  Created by Dongjoo Lee on 9/23/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import UIKit
import SwiftUI

import ComposableArchitecture

import Core
import PrincipleReviewFeatureInterface
import PrinciplesDomainInterface
import PrinciplesDomain
import StockDomainInterface
import LinkDomainInterface
import RetrospectionDomainInterface
import FeedbackDomainInterface
import UserDefaultsDomainInterface
import Shared

public final class DefaultPrincipleReviewCoordinator: PrincipleReviewCoordinator {
    
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType = .principleReview
    public weak var parentCoordinator: RootCoordinator?
    public weak var finishDelegate: CoordinatorFinishDelegate?
    
    public var tradeType: TradeType
    public var stock: StockSearch
    public var tradeHistory: TradeHistory
    public var principleGroup: PrincipleGroup
    
    public init(navigationController: UINavigationController, tradeType: TradeType, stock: StockSearch, tradeHistory: TradeHistory, principleGroup: PrincipleGroup) {
        self.navigationController = navigationController
        self.tradeType = tradeType
        self.stock = stock
        self.tradeHistory = tradeHistory
        self.principleGroup = principleGroup
    }
    
    public func start() {
        let principleReviewView = PrincipleReviewView(
            store:
                Store(
                    initialState: PrincipleReviewFeature.State(
                        tradeType: tradeType,
                        stock: stock,
                        tradeHistory: tradeHistory,
                        principleGroup: principleGroup),
                    reducer: {
                        PrincipleReviewFeature(
                            coordinator: self,
                            fetchLinkUseCase: DIContainer.resolve(FetchLinkUseCase.self),
                            uploadImageUseCase: DIContainer.resolve(UploadRetrospectionImageUseCase.self),
                            createRetrospectionUseCase: DIContainer.resolve(CreateRetrospectionUseCase.self),
                            createFeedbackUseCase: DIContainer.resolve(CreateFeedbackUseCase.self),
                            saveUserDefaultsUseCase: DIContainer.resolve(SaveUserDefaultsUseCase.self)
                        )
                    }
                )
        )
        
        let principleReviewViewController = UIHostingController(rootView: principleReviewView)
        navigationController.pushViewController(principleReviewViewController, animated: true)
    }
    
    public func pushToTradeFeedback(feedback: FeedbackData) {
        parentCoordinator?.pushToFeedback(feedback: feedback)
    }
    
    public func popToProv() {
        finish()
    }
}
