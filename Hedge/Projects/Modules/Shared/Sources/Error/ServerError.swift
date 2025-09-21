//
//  ServerError.swift
//  Shared
//
//  Created by Junyoung on 9/21/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public struct ServerError: Error, Decodable {
    public let code: String
    public let message: String
    public let data: [String: Value]?
    
    public init(
        code: String,
        message: String,
        data: [String: Value]?
    ) {
        self.code = code
        self.message = message
        self.data = data
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(String.self, forKey: .code)
        message = try container.decode(String.self, forKey: .message)
        data = try container.decodeIfPresent([String: Value].self, forKey: .data)
    }
    
    public static let unknown: ServerError = .init(
        code: "UNKNOWN",
        message: "Unknown error",
        data: nil
    )
    
    enum CodingKeys: String, CodingKey {
        case code
        case message
        case data
    }

    public enum Value: Decodable {
        case string(String)
        case bool(Bool)
        case integer(Int)
        case double(Double)
        case object([String: Value])
        case array([Value])
        case null

        public init(from decoder: Decoder) throws {
            if let objectContainer = try? decoder.container(keyedBy: DynamicCodingKeys.self) {
                var object: [String: Value] = [:]
                for key in objectContainer.allKeys {
                    object[key.stringValue] = try objectContainer.decode(Value.self, forKey: key)
                }
                self = .object(object)
                return
            }

            if var arrayContainer = try? decoder.unkeyedContainer() {
                var values: [Value] = []
                while !arrayContainer.isAtEnd {
                    values.append(try arrayContainer.decode(Value.self))
                }
                self = .array(values)
                return
            }

            let singleValue = try decoder.singleValueContainer()
            if singleValue.decodeNil() {
                self = .null
            } else if let bool = try? singleValue.decode(Bool.self) {
                self = .bool(bool)
            } else if let int = try? singleValue.decode(Int.self) {
                self = .integer(int)
            } else if let double = try? singleValue.decode(Double.self) {
                self = .double(double)
            } else if let string = try? singleValue.decode(String.self) {
                self = .string(string)
            } else {
                throw DecodingError.typeMismatch(
                    Value.self,
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Unsupported server error payload value"
                    )
                )
            }
        }
    }

    struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?

        init?(stringValue: String) {
            self.stringValue = stringValue
            intValue = nil
        }

        init?(intValue: Int) {
            stringValue = "\(intValue)"
            self.intValue = intValue
        }
    }
}
