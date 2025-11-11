//
//  PrinciplesCoordinator.swift
//  PrinciplesFeatureInterface
//
//  Created by Dongjoo Lee on 9/23/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation
import Core
import StockDomainInterface
import PrinciplesDomainInterface

public protocol PrincipleDelegate: AnyObject {
    func choosePrincipleGroup(tradeType: TradeType,
                              stock: StockSearch,
                              tradeHistory: TradeHistory,
                              group: PrincipleGroup)
    
    func pushSelectPrinciple(title: String, id: Int, recommendedPrinciples: [String])
}

public protocol PrinciplesCoordinator: Coordinator {
    
    var principleDelegate: PrincipleDelegate? { get set }
    
    func dismiss(animated: Bool)
}
