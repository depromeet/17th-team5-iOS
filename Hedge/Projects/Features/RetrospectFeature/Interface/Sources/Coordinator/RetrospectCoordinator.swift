//
//  RetrospectCoordinator.swift
//  RetrospectFeature
//
//  Created by Junyoung on 9/14/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation

import Core

public protocol RetrospectCoordinator: Coordinator {
    func popToPrev()
}
