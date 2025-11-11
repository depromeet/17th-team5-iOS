//
//  SelectPrincipleCoordinator.swift
//  SelectPrincipleFeature
//
//  Created by 이중엽 on 11/11/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import Core

public protocol SelectPrincipleCoordinator: Coordinator {
    func dismiss()
    func finishSelectPrinciple(groupId: Int, selectedPrinciples: [String])
}
