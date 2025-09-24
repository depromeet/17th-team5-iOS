//
//  RootCoordinator.swift
//  Core
//
//  Created by Junyoung on 9/14/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation

public protocol RootCoordinator: Coordinator {
    func pushToRetrospect(with tradeDataBuilder: TradeDataBuilder)
}
