//
//  DateKit.swift
//  Core
//
//  Created by Dongjoo on 11/1/25.
//  Copyright © 2025 depromeet. All rights reserved.
//

import Foundation

/// Utility for date parsing and formatting with cached formatters
/// Uses en_US_POSIX locale for reliable date parsing
public enum DateKit {
    private static let posix = Locale(identifier: "en_US_POSIX")
    private static let korean = Locale(identifier: "ko_KR")
    
    /// Formatter for "yyyy.MM.dd" format
    public static let yyyyMMdd: DateFormatter = {
        let f = DateFormatter()
        f.locale = posix
        f.calendar = Calendar(identifier: .gregorian)
        f.dateFormat = "yyyy.MM.dd"
        return f
    }()
    
    /// Formatter for "yyyy년 M월 d일" format (Korean)
    public static let yyyyKorean: DateFormatter = {
        let f = DateFormatter()
        f.locale = korean
        f.calendar = Calendar(identifier: .gregorian)
        f.dateFormat = "yyyy년 M월 d일"
        return f
    }()
    
    /// Formatter for "M월 d일" format (Korean date header)
    public static let monthDayKorean: DateFormatter = {
        let f = DateFormatter()
        f.locale = korean
        f.calendar = Calendar(identifier: .gregorian)
        f.dateFormat = "M월 d일"
        return f
    }()
    
    /// Parse a date string in either "yyyy.MM.dd" or "yyyy년 M월 d일" format
    /// - Parameter dateString: Date string to parse
    /// - Returns: Parsed Date, or nil if parsing fails
    public static func parse(_ dateString: String) -> Date? {
        if dateString.contains("년") {
            return yyyyKorean.date(from: dateString)
        }
        return yyyyMMdd.date(from: dateString)
    }
    
    /// Format a Date to "M월 d일" format for date headers
    /// - Parameter date: Date to format
    /// - Returns: Formatted string (e.g., "11월 1일")
    public static func formatMonthDay(_ date: Date) -> String {
        return monthDayKorean.string(from: date)
    }
    
    /// Format a Date to "yy년 M월 회고" format for month section headers
    /// - Parameter date: Date to format
    /// - Returns: Formatted string (e.g., "25년 11월 회고")
    public static func formatYearMonth(_ date: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date) % 100
        let month = calendar.component(.month, from: date)
        return "\(String(format: "%02d", year))년 \(month)월 회고"
    }
}

/// Represents a month section for grouping trade records
/// Supports proper chronological sorting (newest first)
public enum MonthSection: Comparable, Hashable {
    case thisMonth
    case lastMonth
    case absolute(year: Int, month: Int)
    
    /// Create a MonthSection from a Date
    public static func from(_ date: Date, calendar: Calendar = .current) -> MonthSection {
        let now = Date()
        let dateComponents = calendar.dateComponents([.year, .month], from: date)
        let nowComponents = calendar.dateComponents([.year, .month], from: now)
        
        // Check if it's this month
        if dateComponents.year == nowComponents.year && dateComponents.month == nowComponents.month {
            return .thisMonth
        }
        
        // Check if it's last month
        if let lastMonth = calendar.date(byAdding: .month, value: -1, to: now) {
            let lastMonthComponents = calendar.dateComponents([.year, .month], from: lastMonth)
            if dateComponents.year == lastMonthComponents.year && dateComponents.month == lastMonthComponents.month {
                return .lastMonth
            }
        }
        
        // Otherwise, it's an absolute month
        if let year = dateComponents.year, let month = dateComponents.month {
            return .absolute(year: year, month: month)
        }
        
        // Fallback
        return .absolute(year: 0, month: 0)
    }
    
    /// Compare two MonthSections (newest first)
    /// Returns true if lhs should come after rhs (i.e., lhs is newer)
    public static func <(lhs: MonthSection, rhs: MonthSection) -> Bool {
        // thisMonth is always first (not less than anything)
        if case .thisMonth = lhs { return false }
        if case .thisMonth = rhs { return true } // rhs is thisMonth, so lhs < rhs is false
        
        // lastMonth comes after thisMonth but before others
        if case .lastMonth = lhs { return false }
        if case .lastMonth = rhs { return true } // rhs is lastMonth, lhs is absolute, so lhs < rhs
        
        // Compare absolute dates (newer dates come first, so reverse the comparison)
        if case let .absolute(y1, m1) = lhs, case let .absolute(y2, m2) = rhs {
            // For newest first: if lhs is newer, it should NOT be less than rhs
            // So return true only if lhs is older (less than) rhs
            if y1 != y2 {
                return y1 < y2
            }
            return m1 < m2
        }
        
        return false
    }
    
    /// Get the display title for this month section
    public var title: String {
        switch self {
        case .thisMonth:
            return "이번달 회고"
        case .lastMonth:
            return "지난달 회고"
        case let .absolute(year, month):
            let yearShort = year % 100
            return "\(String(format: "%02d", yearShort))년 \(month)월 회고"
        }
    }
}


