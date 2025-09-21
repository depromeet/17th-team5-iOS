//
//  HedgeError.swift
//  Shared
//
//  Created by Junyoung on 9/21/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public enum HedgeError: Error {
    case client(ClientError)
    case server(ServerError)
    case unknown
}
