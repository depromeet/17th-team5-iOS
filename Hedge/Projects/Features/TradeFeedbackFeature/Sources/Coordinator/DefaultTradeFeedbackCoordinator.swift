import UIKit
import SwiftUI

import Core
import Shared
import StockDomainInterface
import TradeFeedbackFeatureInterface
import FeedbackDomainInterface

public final class DefaultTradeFeedbackCoordinator: TradeFeedbackCoordinator {
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType = .tradeFeedback
    public weak var parentCoordinator: RootCoordinator?
    public weak var finishDelegate: CoordinatorFinishDelegate?
    
    public let feedback: FeedbackData
    public let stock: StockSearch
    public let tradeHistory: TradeHistory
    private let fetchFeedbackUseCase = DIContainer.resolve(FetchFeedbackUseCase.self)
    
    public init(
        navigationController: UINavigationController,
        stock: StockSearch,
        tradeHistory: TradeHistory,
        feedback: FeedbackData
    ) {
        self.navigationController = navigationController
        self.stock = stock
        self.tradeHistory = tradeHistory
        self.feedback = feedback
    }
    
    public func start() {
        let viewController = UIHostingController(
            rootView: TradeFeedbackResultView(
                store: .init(
                    initialState: TradeFeedbackFeature.State(
                        stock: stock,
                        tradeHistory: tradeHistory,
                        feedback: feedback
                    ),
                    reducer: {
                        TradeFeedbackFeature(
                            coordinator: self,
                            fetchFeedbackUseCase: fetchFeedbackUseCase
                        )
                    }
                )
            )
        )
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    public func popToPrev() {
        finish()
    }
    
    public func popToHome(selectingStock stockSymbol: String) {
        if let rootCoordinator = parentCoordinator {
            rootCoordinator.popToHome(selectingStock: stockSymbol)
        } else {
            finish()
        }
    }
}
