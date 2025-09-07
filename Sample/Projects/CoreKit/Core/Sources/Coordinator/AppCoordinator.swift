//
//  AppCoordinator.swift
//  Core
//
//  Created by Junyoung on 9/7/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation

public protocol AppCoordinator: Coordinator {
    /// LoginFlow로 이동
    func showLoginFlow()
    
    /// MainFlow로 이동
    func showMainFlow()
}
