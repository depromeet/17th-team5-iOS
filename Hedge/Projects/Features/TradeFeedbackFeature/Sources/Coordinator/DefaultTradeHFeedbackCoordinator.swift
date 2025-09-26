import UIKit
import SwiftUI

import Core
import Shared
import StockDomainInterface
import TradeFeedbackFeatureInterface
import FeedbackDomainInterface

public final class DefaultTradeHFeedbackCoordinator: TradeFeedbackCoordinator {
    public var navigationController: UINavigationController
    
    public var childCoordinators: [Coordinator] = []
    public var parentCoordinator: RootCoordinator?
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
            rootView: TradeFeedbackView(
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
        navigationController.popViewController(animated: true)
    }
}
