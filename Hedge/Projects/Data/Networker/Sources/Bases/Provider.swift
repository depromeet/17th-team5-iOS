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
        let session = Session(configuration: configuration)
        return Provider(session: session)
    }()
    
    public func request<T: Decodable>(_ urlConvertible: URLRequestConvertible) async throws -> T {
        do {
            let response = await session.request(urlConvertible)
                .validate(statusCode: 200 ..< 300)
                .serializingDecodable(T.self)
                .response
            
            guard let value = response.value, response.error == nil else {
                throw SampleError.unknown
            }
            
            return value
        }
    }
    
    public func request(_ urlConvertible: URLRequestConvertible) async throws {
        do {
            let response = await session.request(urlConvertible)
                .validate(statusCode: 200 ..< 300)
                .serializingDecodable(Empty.self, emptyResponseCodes: Set(200 ..< 300))
                .response
            
            guard response.error == nil else {
                throw SampleError.unknown
            }
            
            _ = response.value
        }
    }
}
