//
//  DefaultRetrospectCoordinator.swift
//  RetrospectFeature
//
//  Created by Junyoung on 9/14/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

import ComposableArchitecture

import Core
import RetrospectFeatureInterface

public final class DefaultRetrospectCoordinator: RetrospectCoordinator {
    public var navigationController: UINavigationController
    
    public var childCoordinators: [Coordinator] = []
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let retrospectView = RetrospectView(
            store: .init(
                initialState: RetrospectFeature.State(),
                reducer: { RetrospectFeature() }
            )
        )
        
        let retrospectViewController = UIHostingController(rootView: retrospectView)
        
        navigationController.pushViewController(
            retrospectViewController,
            animated: true
        )
    }
}
