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
    
    public let tradeData: TradeData
    private let fetchFeedbackUseCase = DIContainer.resolve(FetchFeedbackUseCase.self)
    
    public init(
        navigationController: UINavigationController,
        tradeData: TradeData
    ) {
        self.navigationController = navigationController
        self.tradeData = tradeData
    }
    
    public func start() {
        let viewController = UIHostingController(
            rootView: TradeFeedbackResultView(
                store: .init(
                    initialState: TradeFeedbackFeature.State(tradeData: tradeData),
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
