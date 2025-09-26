//
//  String+.swift
//  Shared
//
//  Created by 이중엽 on 9/27/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation
import UIKit

public extension String {
    /// 문자열에서 숫자만 추출하여 Int로 반환
    func extractNumbers() -> Int {
        let numbers = self.filter { $0.isNumber }
        return Int(numbers) ?? 0
    }
    
    /// 문자열에서 숫자만 추출하여 Double로 반환 (소수점 포함)
    func extractDecimalNumber() -> Double {
        let numbers = self.filter { $0.isNumber || $0 == "." }
        return Double(numbers) ?? 0.0
    }
    
    /// 숫자로 이루어진 문자열을 decimal 형태로 변환 (예: 1234 -> 1,234)
    func toDecimalString() -> String {
        let numbers = self.filter { $0.isNumber }
        guard !numbers.isEmpty else { return "0" }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: Int(numbers) ?? 0)) ?? numbers
    }
    
    /// 숫자로 이루어진 문자열을 decimal 형태로 변환 (소수점 포함)
    func toDecimalStringWithDecimal() -> String {
        let numbers = self.filter { $0.isNumber || $0 == "." }
        guard !numbers.isEmpty else { return "0" }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: Double(numbers) ?? 0.0)) ?? numbers
    }
    
    func toDateString() -> String {
        // 정규표현식을 사용하여 년, 월, 일 추출
        let pattern = #"(\d{4})년\s*(\d{1,2})월\s*(\d{1,2})일"#
        
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return self
        }
        
        let range = NSRange(location: 0, length: self.utf16.count)
        guard let match = regex.firstMatch(in: self, options: [], range: range) else {
            return self
        }
        
        // 년, 월, 일 추출
        guard let yearRange = Range(match.range(at: 1), in: self),
              let monthRange = Range(match.range(at: 2), in: self),
              let dayRange = Range(match.range(at: 3), in: self) else {
            return self
        }
        
        let year = String(self[yearRange])
        let month = String(self[monthRange])
        let day = String(self[dayRange])
        
        // 월과 일이 한 자리 수인 경우 앞에 0을 붙임
        let formattedMonth = month.count == 1 ? "0\(month)" : month
        let formattedDay = day.count == 1 ? "0\(day)" : day
        
        return "\(year)-\(formattedMonth)-\(formattedDay)"
    }
}
