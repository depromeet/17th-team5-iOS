//
//  HedgeInterceptor.swift
//  Networker
//
//  Created by Junyoung on 10/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import Alamofire

public final class HedgeInterceptor: RequestInterceptor {
    private let accessToken = UserDefaults.standard.string(forKey: "accessToken")
    
    public func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, any Error>) -> Void
    ) {
        var urlRequest = urlRequest
        if let accessToken {
            urlRequest.headers["Authorization"] = "Bearer " + accessToken
        }
        completion(.success(urlRequest))
    }
    
    public func retry(
        _ request: Request,
        for session: Session,
        dueTo error: any Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        
    }
}
