//
//  TradeReasonIntentProtocol.swift
//  TradeReasonFeatureInterface
//
//  Created by Junyoung on 10/11/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol TradeReasonIntentProtocol {
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
