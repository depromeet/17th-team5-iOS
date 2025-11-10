//
//  Provider.swift
//  Networker
//
//  Created by Junyoung on 9/7/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation

import Alamofire

import Shared

// MARK: - Interface
public protocol ProviderProtocol {
    func request<T: Decodable>(_ urlConvertible: URLRequestConvertible) async throws -> T
    func request(_ urlConvertible: URLRequestConvertible) async throws
}

// MARK: - Impl
public struct Provider: ProviderProtocol {
    private let session: Session
    
    public init(session: Session) {
        self.session = session
    }
    
    /// Token이 없을 때 요청하는 Provider
    public static let plain: Provider = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 5
        configuration.timeoutIntervalForResource = 5
        
        let monitor = NetworkEventMonitor()
        let session = Session(configuration: configuration, eventMonitors: [monitor])
        return Provider(session: session)
    }()
    
    /// 인증 세션
    public static let authorized: Provider = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 5
        configuration.timeoutIntervalForResource = 5
        
        let monitor = NetworkEventMonitor()
        let session = Session(
            configuration: configuration,
            interceptor: HedgeInterceptor(),
            eventMonitors: [monitor]
        )
        return Provider(session: session)
    }()
    
    public func request<T: Decodable>(_ urlConvertible: URLRequestConvertible) async throws -> T {
        do {
            let response = await session.request(urlConvertible)
                .validate(statusCode: 200 ..< 300)
                .serializingDecodable(T.self)
                .response
            
            if let error = response.error {
                throw makeHedgeError(error, data: response.data)
            }
            
            guard let value = response.value else {
                throw HedgeError.client(.emptyData)
            }
            
            return value
        }
    }
    
    public func upload<T: Decodable>(
        _ urlConvertible: URLRequestConvertible,
        multipartFormData: @escaping (MultipartFormData) -> Void
    ) async throws -> T {
        let uploadRequest = session.upload(
            multipartFormData: multipartFormData,
            with: urlConvertible
        )
        
        logRequest(uploadRequest, phase: "start")
        
        let response = await uploadRequest
            .validate(statusCode: 200 ..< 300)
            .serializingDecodable(T.self)
            .response
        
        logRequest(uploadRequest, phase: "end")
        logResponse(response)
        
        if let error = response.error {
            throw makeHedgeError(error, data: response.data)
        }
        
        guard let value = response.value else {
            throw HedgeError.client(.emptyData)
        }
        
        return value
    }
    
    public func request(_ urlConvertible: URLRequestConvertible) async throws {
        do {
            let response = await session.request(urlConvertible)
                .validate(statusCode: 200 ..< 300)
                .serializingDecodable(Empty.self, emptyResponseCodes: Set(200 ..< 300))
                .response
            
            if let error =  response.error {
                throw makeHedgeError(error, data: response.data)
            }
            
            _ = response.value
        }
    }
}

extension Provider {
    private func logRequest(_ request: DataRequest, phase: String) {
        let url = request.request?.url?.absoluteString ?? "unknown url"
        let method = request.request?.httpMethod ?? "nil"
        let state = request.task?.state ?? .suspended
        print("➡️ [Network][\(phase)] \(method) \(url) | task: \(state.rawValue)")
    }
    
    private func logResponse<T>(_ response: DataResponse<T, AFError>) {
        let url = response.request?.url?.absoluteString ?? "unknown url"
        let statusCode = response.response?.statusCode ?? -1
        print("🌐 [Network] URL: \(url)")
        print("🌐 [Network] Status Code: \(statusCode)")
        if let error = response.error {
            print("❌ [Network] Error: \(error)")
        }
        if let data = response.data,
           let body = String(data: data, encoding: .utf8),
           !body.isEmpty {
            print("📄 [Network] Body: \(body)")
        }
    }
    
    private func makeHedgeError(_ error: AFError, data: Data?) -> HedgeError {
        // 네트워크 에러 (URLError)
        if case let .sessionTaskFailed(underlyingError) = error,
           let urlError = underlyingError as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                return .client(.notConnectedToInternet)
            case .timedOut:
                return .client(.timeout)
            case .networkConnectionLost:
                return .client(.networkConnectionLost)
            case .cannotFindHost:
                return .client(.cannotFindHost)
            case .cannotConnectToHost:
                return .client(.cannotConnectToHost)
            case .secureConnectionFailed:
                return .client(.secureConnectionFailed)
            case .cancelled:
                return .client(.cancelled)
            default:
                return .client(.unknown(urlError))
            }
        }
        
        // 서버 에러
        if case let .responseValidationFailed(reason) = error,
           case .unacceptableStatusCode(_) = reason,
           let data = data {
            do {
                let decodedErrorData = try JSONDecoder().decode(ServerError.self, from: data)
                return .server(decodedErrorData)
            } catch {
                return .server(.unknown)
            }
        }
        
        // Decoding 에러
        if case let .responseSerializationFailed(reason) = error,
           case let .decodingFailed(decodingError) = reason,
            let error = decodingError as? DecodingError {
            return .client(.decoding(error))
        }
        
        // 알 수 없는 에러
        return .unknown
    }
}
