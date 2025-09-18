//
//  Headers.swift
//  Networker
//
//  Created by Junyoung on 9/7/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation

import Alamofire

extension HTTPHeaders {
    public static var defaultHeader: HTTPHeaders {
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
}
