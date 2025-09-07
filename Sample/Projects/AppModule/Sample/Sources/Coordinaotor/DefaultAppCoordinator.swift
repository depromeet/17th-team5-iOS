//
//  DefaultAppCoordinator.swift
//  Sample
//
//  Created by Junyoung on 9/7/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation
import UIKit

import Core

final class DefaultAppCoordinator: AppCoordinator {
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        // TODO: 시작
    }
    
    func showLoginFlow() {
        // TODO: 로그인 플로우 이동
    }
    
    func showMainFlow() {
        // TODO: 메인 플로우 이동
    }
}
