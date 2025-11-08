//
//  NetworkEventMonitor.swift
//  Networker
//
//  Created by ChatGPT on 11/8/25.
//

import Foundation
import Alamofire

final class NetworkEventMonitor: EventMonitor {
    let queue = DispatchQueue(label: "network.event.monitor")
    
    func requestDidResume(_ request: Request) {
        print("➡️ [EventMonitor] Request Did Resume: \(request.description)")
    }
    
    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        let url = request.request?.url?.absoluteString ?? "unknown url"
        let statusCode = response.response?.statusCode ?? -1
        print("🌐 [EventMonitor] Parsed Response for URL: \(url) | status: \(statusCode)")
        if let error = response.error {
            print("❌ [EventMonitor] Error: \(error)")
        }
    }
    
    func requestDidFinish(_ request: Request) {
        print("🏁 [EventMonitor] Request Did Finish: \(request.description)")
    }
    
    func request(_ request: DataRequest, didFailTask task: URLSessionTask, earlyWithError error: Error) {
        print("⚠️ [EventMonitor] Request Failed Early: \(request.description) | error: \(error)")
    }
}

