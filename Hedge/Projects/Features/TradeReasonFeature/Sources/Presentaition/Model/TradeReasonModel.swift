//
//  TradeReasonModel.swift
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
import TradeReasonFeatureInterface
import AnalysisDomainInterface
import RetrospectDomainInterface
import Shared

public final class TradeReasonModel: ObservableObject, TradeReasonModelProtocol {
    @Published public var tradeType: TradeType
    @Published public var stock: StockSearch
    @Published public var tradeHistory: Core.TradeHistory
    @Published public var principles: [Principle]
    @Published public var selectedButton: FloatingButtonSelectType? = .generate
    @Published public var emotionSelection: Int = 0
    @Published public var isEmotionShow: Bool = false
    @Published public var isChecklistShow: Bool = false
    @Published public var checkedItems: Set<Int> = []
    @Published public var contents: String? = nil
    @Published public var emotion: TradeEmotion? = nil
    @Published public var text: String = ""
    
    public let principleBuilder: PrinciplesViewBuilderProtocol
    private var checkedItemsTmp: Set<Int> = []
    
    public init(
        tradeType: TradeType,
        stock: StockSearch,
        tradeHistory: TradeHistory,
        principles: [Principle],
        selectedPrinciples: Set<Int>,
        principleBuilder: PrinciplesViewBuilderProtocol
    ) {
        self.tradeType = tradeType
        self.stock = stock
        self.tradeHistory = tradeHistory
        self.principles = principles
        self.checkedItems = selectedPrinciples
        self.checkedItemsTmp = selectedPrinciples
        self.principleBuilder = principleBuilder
    }
}

// MARK: - Binding Properties

extension TradeReasonModel {
    public var textBinding: Binding<String> {
        Binding (
            get: { self.text },
            set: { self.text = $0 }
        )
    }
    
    public var selectedButtonBinding: Binding<FloatingButtonSelectType?> {
        Binding (
            get: { self.selectedButton },
            set: { self.selectedButton = $0 }
        )
    }

    public var emotionSelectionBinding: Binding<Int> {
        Binding (
            get: { self.emotionSelection },
            set: { self.emotionSelection = $0 }
        )
    }

    public var isEmotionShowBinding: Binding<Bool> {
        Binding (
            get: { self.isEmotionShow },
            set: { self.isEmotionShow = $0 }
        )
    }
    
    public var principlesBinding: Binding<[Principle]> {
        Binding (
            get: { self.principles },
            set: { self.principles = $0 }
        )
    }
    
    public var isChecklistShowBinding: Binding<Bool> {
        Binding (
            get: { self.isChecklistShow },
            set: { self.isChecklistShow = $0 }
        )
    }
    
    public var checkedItemsBinding: Binding<Set<Int>> {
        Binding (
            get: { self.checkedItems },
            set: { self.checkedItems = $0 }
        )
    }
    
    public var contentsBinding: Binding<String?> {
        Binding (
            get: { self.contents },
            set: { self.contents = $0 }
        )
    }
}

// MARK: - Model Actions

extension TradeReasonModel: TradeReasonModelActionProtocol {
    public func dismissAIGenerate() {
        selectedButton = nil
    }
    
    public func presentEmotion() {
        isEmotionShow = true
    }
    
    public func dismissEmotion() {
        isEmotionShow = false
        selectedButton = nil
    }
    
    public func selectEmotion(for index: Int) {
        emotion = TradeEmotion(rawValue: index)
        isEmotionShow = false
        selectedButton = nil
    }
    
    public func presentChecklist() {
        isChecklistShow = true
    }
    
    public func confirmCheckList() {
        checkedItemsTmp = checkedItems
        isChecklistShow = false
        selectedButton = nil
    }
    
    public func dismissChecklist() {
        checkedItems = checkedItemsTmp
        isChecklistShow = false
        selectedButton = nil
    }
    
    public func selectChecklist(for id: Int) {
        if checkedItems.contains(id) {
            checkedItems.remove(id)
        } else {
            checkedItems.insert(id)
        }
    }
    
    public func fetchAnalysisContent(with text: String) {
        contents = text
    }
}
