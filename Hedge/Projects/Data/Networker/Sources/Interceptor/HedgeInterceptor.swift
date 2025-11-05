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
    private let maxRetryCount: Int = 3
    
    // 모든 인스턴스가 공유하는 정적 변수
    private static let sharedRefreshLock = NSLock()
    private static var sharedIsRefreshing = false
    private static var sharedRefreshCompletionHandlers: [(Result<Void, Error>) -> Void] = []
    
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

extension HedgeInterceptor {
    private func enqueueRefreshTask(
        for request: Alamofire.Request,
        completion: @escaping (RetryResult) -> Void
    ) {
        // lock 획득
        Self.sharedRefreshLock.lock()
        
        // 작업이 리프레시중이라면 핸들러에 api 추가
        if Self.sharedIsRefreshing {
            Self.sharedRefreshCompletionHandlers.append { result in
                switch result {
                case .success():
                    completion(.retry)
                case .failure(let error):
                    completion(.doNotRetryWithError(error))
                }
            }
            Self.sharedRefreshLock.unlock()
            return
        }
        
        // 첫 번째 요청 → Refresh 시작
        Self.sharedIsRefreshing = true
        Self.sharedRefreshLock.unlock()
        
        refreshAccessToken { response in
            Self.sharedRefreshLock.lock()
            Self.sharedIsRefreshing = false
            
            // 대기 중인 모든 요청에 결과 전파
            let handlers = Self.sharedRefreshCompletionHandlers
            Self.sharedRefreshCompletionHandlers.removeAll()
            
            switch response {
            case .success():
                completion(.retry)
                
            case .failure(let error):
                completion(.doNotRetryWithError(error))
            }
            
            // 대기 중이던 모든 요청 처리
            handlers.forEach { $0(response) }
            Self.sharedRefreshLock.unlock()
        }
    }
    
    private func refreshAccessToken(
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        AF.request(
            "\(Configuration.baseURL)/api/v1/auth/refresh",
            method: .post,
            parameters: ["refreshToken": UserDefaults.standard.string(forKey: "refreshToken")],
            encoding: JSONEncoding.default
        )
        .validate(statusCode: 200...299)
        .responseData { response in
            switch response.result {
            case .success(let result):
                guard let data = try? JSONSerialization.jsonObject(with: result) as? [String: Any],
                      let refreshToken = data["refreshToken"] as? String,
                      let accessToken = data["accessToken"] as? String else {
                    return
                }
                
                UserDefaults.standard.set(accessToken, forKey: "accessToken")
                UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
                completion(.success(()))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
