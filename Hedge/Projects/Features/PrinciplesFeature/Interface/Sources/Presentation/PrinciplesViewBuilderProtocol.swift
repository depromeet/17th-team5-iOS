//
//  PrinciplesViewBuilderProtocol.swift
//  PrinciplesFeature
//
//  Created by Junyoung on 10/9/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

import Core
import StockDomainInterface
import PrinciplesDomainInterface

public protocol PrinciplesViewBuilderProtocol {
    /// 투자 원칙 화면 생성 (네비게이션 있음)
    ///
    /// - Parameters:
    ///   - coordinator: 화면 네비게이션을 관리하는 코디네이터
    ///   - tradeType: 거래 유형 (매수/매도)
    ///   - stock: 선택된 주식 정보
    ///   - tradeHistory: 거래 이력 정보
    ///   - fetchPrinciplesUseCase: 투자 원칙을 조회하는 UseCase
    /// - Returns: 구성된 SwiftUI View
    func buildContainer(
        coordinator: PrinciplesCoordinator?,
        tradeType: TradeType,
        stock: StockSearch,
        tradeHistory: TradeHistory,
        fetchPrinciplesUseCase: FetchPrinciplesUseCase
    ) -> any View
    
    /// 투자 원칙 화면 생성 (네비게이션 없음)
    ///
    /// - Parameters:
    ///   - principles: 투자 원칙
    ///   - selectedPrinciples: 선택된 투자 원칙
    /// - Returns: 구성된 SwiftUI View
    func buildView(
        principles: Binding<[Principle]>,
        selectedPrinciples: Binding<Set<Int>>
    ) -> any View
}
