//
//  TargetType+.swift
//  Networker
//
//  Created by Junyoung on 9/18/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import Alamofire

public enum ContentType: String {
    case json = "application/json"
}

public extension TargetType {
    func makeEncoder(contentType: ContentType) -> ParameterEncoding {
        switch contentType {
        case .json:
            return JSONEncoding.default
        }
    }
}
