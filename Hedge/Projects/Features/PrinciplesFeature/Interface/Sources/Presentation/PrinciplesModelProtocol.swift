//
//  PrinciplesModelProtocol.swift
//  PrinciplesFeature
//
//  Created by Junyoung on 10/9/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Core
import StockDomainInterface
import PrinciplesDomainInterface

// MARK: - View State

public protocol PrinciplesModelProtocol {
    var selectedPrinciples: Set<Int> { get set }
    var tradeType: TradeType { get }
    var stock: StockSearch { get }
    var tradeHistory: TradeHistory { get }
    var principles: [Principle] { get set }
}

// MARK: - Intent Action
public protocol PrinciplesModelActionProtocol: AnyObject {
    func onAppear() async throws
    func backButtonTapped()
    func principleToggled(index: Int)
    func completeTapped()
    func skipTapped()
}
