//
//  TradeHistoryCoordinator.swift
//  TradeHistoryFeature
//
//  Created by Junyoung on 9/24/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import Core

public protocol TradeHistoryCoordinator: Coordinator {
    func popToPrev()
}
