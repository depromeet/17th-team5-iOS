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
    private let fetchFeedbackUseCase = DIContainer.resolve(FetchFeedbackUseCase.self)
    
    public init(
        navigationController: UINavigationController,
        feedback: FeedbackData
    ) {
        self.navigationController = navigationController
        self.feedback = feedback
    }
    
    public func start() {
        let viewController = UIHostingController(
            rootView: TradeFeedbackResultView(
                store: .init(
                    initialState: TradeFeedbackFeature.State(
                        feedback: feedback
                    ),
                    reducer: {
                        TradeFeedbackFeature(
                            coordinator: self
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
    
    public func popToHome() {
        parentCoordinator?.popToHome()
    }
}
