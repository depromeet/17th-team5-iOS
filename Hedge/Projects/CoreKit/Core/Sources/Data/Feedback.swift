//
//  Feedback.swift
//  Core
//
//  Created by 이중엽 on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public struct Feedback {
    public let summary: String
    public let marketStatus: String
    public let principle: [(String, String)]
    
    public static func mock() -> Self {
        return Feedback(summary: "사실 몇 줄까지 나올지 모르겠음 최대 4~5줄 정도가 좋지 않을까? 최대 4~5줄 정도가 좋지 않을까? 최대 4~5줄 정도가 좋지 않을까? 최대 4~5줄 정도가 좋지 않을까? 최대 4~5줄 정도가 좋지 않을까? 최대 4~5줄 정도가 좋지 않을까? 최대 4~5줄 정도가 좋지 않을까?",
                        marketStatus: "최대 3줄까지 설명 최대 3줄까지 설명 최대 3줄까지 설명 최대 3줄까지 설명 최대 3줄까지 설명 최대 3줄까지 설명 최대 3줄까지 설명 최대 3줄까지",
                        principle: [("원칙 타이틀 최대 2줄까지 원칙 타이틀 최대 2줄까지 원칙 타이틀 최대 2줄까", "최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄"),
                                    ("원칙 타이틀 1줄일 때", "최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄"),
                                    ("원칙 타이틀 최대 2줄까지 원칙 타이틀최대 2줄까지 원칙 타이틀 최대 2줄까", "최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄까지 최대 3줄")])
    }
}
