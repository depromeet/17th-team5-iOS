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
    // MARK: Header
    func defaultHeader() -> HTTPHeaders {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        let currentTimeZone = TimeZone.current.identifier
        
        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: "application/json")
        headers.add(name: "App-Platform", value: "iOS")
        headers.add(name: "App-Version", value: version)
        headers.add(name: "App-Build", value: buildVersion)
        headers.add(name: "Time-Zone", value: currentTimeZone)
        
        return headers
    }
    
    // MARK: Encoder
    func makeEncoder(contentType: ContentType) -> ParameterEncoding {
        switch contentType {
        case .json:
            return JSONEncoding.default
        }
    }
}
