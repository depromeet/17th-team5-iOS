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
}
