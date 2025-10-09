//
//  PrinciplesIntent.swift
//  PrinciplesFeature
//
//  Created by Junyoung on 10/9/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import PrinciplesFeatureInterface

public final class PrinciplesIntent: PrinciplesIntentProtocol {
    private weak var modelAction: PrinciplesModelActionProtocol?
    
    init(modelAction: PrinciplesModelActionProtocol) {
        self.modelAction = modelAction
    }
    
    public func onAppear() {
        Task {
            try await modelAction?.onAppear()
        }
    }
    
    public func backButtonTapped() {
        modelAction?.backButtonTapped()
    }
    
    public func principleToggled(index: Int) {
        modelAction?.principleToggled(index: index)
    }
    
    public func completeTapped() {
        modelAction?.completeTapped()
    }
    
    public func skipTapped() {
        modelAction?.skipTapped()
    }
}
