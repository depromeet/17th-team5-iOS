//
//  TradeReasonIntent.swift
//  TradeReasonFeatureInterface
//
//  Created by Junyoung on 10/11/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import TradeReasonFeatureInterface

public struct TradeReasonIntent: TradeReasonIntentProtocol {
    private weak var modelAction: TradeReasonModelActionProtocol?
    
    init(modelAction: TradeReasonModelActionProtocol) {
        self.modelAction = modelAction
    }
    
    public func onAppear() {
        modelAction?.onAppear()
    }
    
    public func backButtonTapped() {
        modelAction?.backButtonTapped()
    }
    
    public func nextTapped() {
        modelAction?.nextTapped()
    }
    
    public func aiGenerateCloseTapped() {
        modelAction?.aiGenerateCloseTapped()
    }
    
    public func emotionShowTapped() {
        modelAction?.emotionShowTapped()
    }
    
    public func emotionSelected(for index: Int) {
        modelAction?.emotionSelected(for: index)
    }
    
    public func emotionCloseTapped() {
        modelAction?.emotionCloseTapped()
    }
    
    public func checklistShowTapped() {
        modelAction?.checklistShowTapped()
    }
    
    public func checkListApproveTapped() {
        modelAction?.checkListApproveTapped()
    }
    
    public func checklistCloseTapped() {
        modelAction?.checklistCloseTapped()
    }
    
    public func checklistTapped(for id: Int) {
        modelAction?.checklistTapped(for: id)
    }
}
