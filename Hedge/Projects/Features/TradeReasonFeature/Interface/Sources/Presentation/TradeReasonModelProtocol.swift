//
//  TradeReasonModelProtocol.swift
//  TradeReasonFeatureInterface
//
//  Created by Junyoung on 10/11/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

import Core
import DesignKit
import PrinciplesFeatureInterface
import StockDomainInterface
import PrinciplesDomainInterface

// MARK: - View State

public protocol TradeReasonModelProtocol {
    var tradeType: TradeType { get }
    var stock: StockSearch { get }
    var tradeHistory: TradeHistory { get }
    var principles: [Principle] { get set }
    var selectedButton: FloatingButtonSelectType? { get set }
    var emotionSelection: Int { get set }
    var isEmotionShow: Bool { get set }
    var isChecklistShow: Bool { get set }
    var checkedItems: Set<Int> { get set }
    var text: String { get set }
    var contents: String? { get set }
    var emotion: TradeEmotion? { get }
    var principlesView: any View { get }
    var principleBuilder: PrinciplesViewBuilderProtocol { get }
}

// MARK: - Intent Action

public protocol TradeReasonModelActionProtocol: AnyObject {
    func onAppear()
    func backButtonTapped()
    func nextTapped()
    
    func aiGenerateCloseTapped()
    
    func emotionShowTapped()
    func emotionSelected(for index: Int)
    func emotionCloseTapped()
    
    func checklistShowTapped()
    func checkListApproveTapped()
    func checklistCloseTapped()
    func checklistTapped(for id: Int)
}
