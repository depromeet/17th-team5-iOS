//
//  MVIContainer.swift
//  Core
//
//  Created by Junyoung on 10/9/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Combine
import Foundation

public final class MVIContainer<Intent, Model>: ObservableObject {
    public let intent: Intent
    public var model: Model
    
    private var cancellables: Set<AnyCancellable> = []
    
    public init(
        intent: Intent,
        model: Model,
        modelChangePublisher: ObjectWillChangePublisher
    ) {
        self.intent = intent
        self.model = model
        
        modelChangePublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: objectWillChange.send)
            .store(in: &cancellables)
    }
}
