//
//  TradeFeedbackCoordinator.swift
//  TradeFeedbackFeatureInterface
//
//  Created by 이중엽 on 9/22/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import Core

public protocol TradeFeedbackCoordinator: Coordinator {
    func popToPrev()
    func popToHome()
}
