import UIKit
import SwiftUI

import ComposableArchitecture

import Core
import SelectPrincipleFeatureInterface

public final class DefaultSelectPrincipleCoordinator: SelectPrincipleCoordinator {
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public var finishDelegate: CoordinatorFinishDelegate?
    public var type: CoordinatorType = .selectPrinciple
    public weak var parentCoordinator: RootCoordinator?
    
    private let groupTitle: String
    private let groupId: Int
    private let recommendedPrinciples: [String]
    
    public init(
        navigationController: UINavigationController,
        groupTitle: String,
        groupId: Int,
        recommendedPrinciples: [String]
    ) {
        self.navigationController = navigationController
        self.groupTitle = groupTitle
        self.groupId = groupId
        self.recommendedPrinciples = recommendedPrinciples
    }
    
    public func start() {
        let principles = recommendedPrinciples.enumerated().map { index, detail in
            SelectPrincipleFeature.PrincipleItem(
                id: index,
                title: detail,
                detail: detail
            )
        }
        
        let hostingController = UIHostingController(
            rootView: SelectPrincipleView(
                store: Store(
                    initialState: SelectPrincipleFeature.State(
                        groupId: groupId,
                        groupTitle: groupTitle,
                        principles: principles
                    ),
                    reducer: {
                        SelectPrincipleFeature(coordinator: self)
                    }
                )
            )
        )
        navigationController.pushViewController(hostingController, animated: true)
    }
    
    public func dismiss() {
        finish()
    }
    
    public func finishSelectPrinciple(groupId: Int, selectedPrinciples: [String]) {
        parentCoordinator?.pushToPrinciples(selectedPrinciples)
        finish()
    }
}
