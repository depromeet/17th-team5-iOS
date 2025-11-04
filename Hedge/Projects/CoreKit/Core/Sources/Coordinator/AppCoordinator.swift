//
//  AppCoordinator.swift
//  Core
//
//  Created by Junyoung on 9/7/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation

public protocol AppCoordinator: Coordinator {
    func loginFlow()
    func mainFlow()
}
