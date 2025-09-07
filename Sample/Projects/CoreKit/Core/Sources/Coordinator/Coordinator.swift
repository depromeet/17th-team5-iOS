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
    
    /// Coordinator Child Array
    var childCoordinators: [Coordinator] { get set }
    
    /// Coordinator Start
    func start()
    
    /// Coordinator Finish
    func finish()
}

public extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
    }
}
