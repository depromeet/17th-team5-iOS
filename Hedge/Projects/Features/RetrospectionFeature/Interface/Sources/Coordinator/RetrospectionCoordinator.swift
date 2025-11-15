//
//  RetrospectionCoordinator.swift
//  RetrospectionFeature
//
//  Created by 이중엽 on 11/13/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import FeedbackDomainInterface
import Core

public protocol RetrospectionCoordinator: Coordinator {
    func popToPrev()
    
    func pushToTradeFeedback(feedback: FeedbackData)
}
