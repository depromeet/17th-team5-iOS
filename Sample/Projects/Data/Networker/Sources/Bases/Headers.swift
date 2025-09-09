//
//  Headers.swift
//  Networker
//
//  Created by Junyoung on 9/7/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation

import Alamofire

extension TargetType {
    func defaultHeader() -> HTTPHeaders {
        var headers = HTTPHeaders()
        
        headers.add(name: "App-Platform", value: "iOS")
        headers.add(name: "App-Device-ID", value: "")
        headers.add(name: "App-Model", value: "")
        headers.add(name: "App-Version", value: "")
        headers.add(name: "App-Build", value: "")
        
        return headers
    }
}
