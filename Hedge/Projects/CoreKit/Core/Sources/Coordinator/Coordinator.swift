//
//  Coordinator.swift
//  Core
//
//  Created by Junyoung on 9/7/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation
import UIKit

public protocol Coordinator: AnyObject {
    /// BaseNavigationController
    var navigationController: UINavigationController { get set }
    
    /// 자식 코디네이터 배열
    var childCoordinators: [any Coordinator] { get set }
    
    /// 종료 Delegate
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    
    /// 코디네이터 타입
    var type: CoordinatorType { get }
    
    /// 코디네이터 시작
    func start()
    
    /// 코디네이터 종료
    func finish()
}

public extension Coordinator {
    /// 자식 코디네이터 전부 제거 및 상위 코디네이터에게 종료 Delegate 전달
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

public protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}
