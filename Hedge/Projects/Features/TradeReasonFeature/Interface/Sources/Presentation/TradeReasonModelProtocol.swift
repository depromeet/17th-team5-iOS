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
import StockDomainInterface
import PrinciplesDomainInterface

// MARK: - View State

public protocol TradeReasonModelProtocol {
    var tradeType: TradeType { get }
    var stock: StockSearch { get }
    var tradeHistory: TradeHistory { get }
    var principles: [Principle] { get set }
    var selectedButton: FloatingButtonSelectType? { get }
    var emotionSelection: Int { get }
    var isEmotionShow: Bool { get }
    var isChecklistShow: Bool { get }
    var checkedItems: Set<Int> { get }
    var text: String { get }
    var contents: String? { get }
    var emotion: TradeEmotion? { get }
    
    var principlesBinding: Binding<[Principle]> { get }
    var textBinding: Binding<String> { get }
    var selectedButtonBinding: Binding<FloatingButtonSelectType?> { get }
    var emotionSelectionBinding: Binding<Int> { get }
    var isEmotionShowBinding: Binding<Bool> { get }
    var isChecklistShowBinding: Binding<Bool> { get }
    var checkedItemsBinding: Binding<Set<Int>> { get }
    var contentsBinding: Binding<String?> { get }
}

// MARK: - Intent Action

public protocol TradeReasonModelActionProtocol: AnyObject {
    func dismissAIGenerate()
    
    func presentEmotion()
    func dismissEmotion()
    func selectEmotion(for index: Int)
    
    func presentChecklist()
    func dismissChecklist()
    func confirmCheckList()
    func selectChecklist(for id: Int)
    
    func fetchAnalysisContent(with text: String)
}
