//
//  PrincipleDetailCoordinator.swift
//  PrincipleDetailFeature
//
//  Created by Auto on 1/15/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import Core
import PrinciplesDomainInterface

public protocol PrincipleDetailCoordinator: Coordinator {
    var principleDetailDelegate: PrincipleDetailCoordinatorDelegate? { get set }
    func popToPrev()
    func onPrincipleGroupCreated()
}

