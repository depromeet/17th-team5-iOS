//
//  GroupedRetrospection.swift
//  HomeFeature
//
//  Created by 이중엽 on 11/6/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation
import RetrospectionDomainInterface

// MARK: - Grouped Retrospection Models
public struct GroupedRetrospectionByCompany: Equatable, Identifiable {
    public let id: UUID
    public let symbol: String
    public let monthlyGroups: [MonthlyRetrospectionGroup]
    
    public init(id: UUID = UUID(), symbol: String, monthlyGroups: [MonthlyRetrospectionGroup]) {
        self.id = id
        self.symbol = symbol
        self.monthlyGroups = monthlyGroups
    }
}

public struct MonthlyRetrospectionGroup: Equatable, Identifiable {
    public let id: UUID
    public let month: Int // 1-12
    public let year: Int
    public let dailyGroups: [DailyRetrospectionGroup]
    public let monthTitle: String // "이번달 회고" or "지난달 회고" or "2025년 9월"
    
    public init(
        id: UUID = UUID(),
        month: Int,
        year: Int,
        dailyGroups: [DailyRetrospectionGroup],
        monthTitle: String
    ) {
        self.id = id
        self.month = month
        self.year = year
        self.dailyGroups = dailyGroups
        self.monthTitle = monthTitle
    }
}

public struct DailyRetrospectionGroup: Equatable, Identifiable {
    public let id: UUID
    public let day: Int
    public let month: Int
    public let year: Int
    public let retrospections: [Retrospection]
    public let dateString: String // "9월 15일"
    
    public init(
        id: UUID = UUID(),
        day: Int,
        month: Int,
        year: Int,
        retrospections: [Retrospection],
        dateString: String
    ) {
        self.id = id
        self.day = day
        self.month = month
        self.year = year
        self.retrospections = retrospections
        self.dateString = dateString
    }
}

