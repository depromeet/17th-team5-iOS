//
//  TargetType.swift
//  Networker
//
//  Created by Junyoung on 9/7/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation

import Alamofire

// MARK: - Target Type
public protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var header: HTTPHeaders { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: RequestParams? { get }
    var encoding: ParameterEncoding { get }
}

// MARK: - URLRequestConvertible
public extension TargetType {
    func asURLRequest() throws -> URLRequest {
        let url =  try baseURL.asURL()
        var urlRequest = try URLRequest(
            url: url.absoluteString + path,
            method: method
        )
        var headers = defaultHeader()
        header.forEach {
            headers.add($0)
        }
        urlRequest.headers = headers
        
        switch parameters {
        case let .query(request):
            let params = request?.toDictionary() ?? [:]
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            
            var queryItems: [URLQueryItem] = []
            
            for (key, value) in params {
                if let arrayValue = value as? [Any] {
                    for item in arrayValue {
                        queryItems.append(URLQueryItem(name: key, value: String(describing: item)))
                    }
                } else {
                    queryItems.append(URLQueryItem(name: key, value: String(describing: value)))
                }
            }
            components?.queryItems = queryItems
            urlRequest.url = components?.url
            return urlRequest
        
        case let .body(request):
            let params = request?.toDictionary() ?? [:]
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            return try encoding.encode(urlRequest, with: params)
        
        case let .arrayBody(request):
            let params = request?.toArrayDictionary() ?? [[:]]
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
            urlRequest.httpBody = jsonData
            return try encoding.encode(urlRequest, with: nil)
        
        case .none:
            return urlRequest
        }
    }
}
