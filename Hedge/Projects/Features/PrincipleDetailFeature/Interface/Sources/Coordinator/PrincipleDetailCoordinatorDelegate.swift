//
//  PrincipleDetailCoordinatorDelegate.swift
//  PrincipleDetailFeature
//
//  Created by Auto on 1/15/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol PrincipleDetailCoordinatorDelegate: AnyObject {
    func switchToPrincipleTab()
    func switchToPrincipleTabAndShowToast()
}

