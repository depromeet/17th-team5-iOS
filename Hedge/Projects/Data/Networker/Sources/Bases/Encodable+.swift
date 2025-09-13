//
//  Encodable+.swift
//  Networker
//
//  Created by Junyoung on 9/7/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation

extension Encodable {
    func toDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
              let jsonData = try? JSONSerialization.jsonObject(with: data),
              let dictionaryData = jsonData as? [String: Any] else { return [:] }
        return dictionaryData
    }
    
    func toArrayDictionary() -> [[String: Any]] {
        guard let data = try? JSONEncoder().encode(self),
              let jsonData = try? JSONSerialization.jsonObject(with: data),
              let dictionaryData = jsonData as? [[String: Any]] else { return [[:]] }
        return dictionaryData
    }
}
