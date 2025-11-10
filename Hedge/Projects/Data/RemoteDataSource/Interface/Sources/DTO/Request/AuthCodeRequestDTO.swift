//
//  AuthCodeRequestDTO.swift
//  RemoteDataSourceInterface
//
//  Created by Junyoung on 11/10/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public struct AuthCodeRequestDTO: Encodable, Sendable {
    let authCode: String
    
    public init?(authCode: String?) {
        if let authCode {
            self.authCode = authCode
        } else {
            return nil
        }
    }
}
