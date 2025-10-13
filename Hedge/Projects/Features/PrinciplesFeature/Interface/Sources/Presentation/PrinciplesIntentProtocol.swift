//
//  PrinciplesIntentProtocol.swift
//  PrinciplesFeature
//
//  Created by Junyoung on 10/9/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol PrinciplesIntentProtocol {
    func onAppear()
    func backButtonTapped()
    func principleToggled(index: Int)
    func completeTapped()
    func skipTapped()
}
