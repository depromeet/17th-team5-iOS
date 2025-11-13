//
//  TempStorage.swift
//  Core
//
//  Created by 이중엽 on 11/13/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public enum TempStorage {
    
    private static var lastRetrospectionID: Int? = nil
    
    public static func getLastRetrospectionID() -> Int? {
        return lastRetrospectionID
    }
    
    public static func setLastRetrospectionID(_ id: Int?) {
        self.lastRetrospectionID = id
    }
}
