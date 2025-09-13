//
//  Log.swift
//  Shared
//
//  Created by 이중엽 on 9/7/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation
import OSLog

public enum Log {
    private static var loggers: [LogCategory: Logger] = [:]
    private static let loggerQueue = DispatchQueue(label: "logger.queue", attributes: .concurrent)
    
    private static func getLogger(for category: LogCategory) -> Logger {
        return loggerQueue.sync {
            if let existingLogger = loggers[category] {
                return existingLogger
            }
            
            let subsystem = Bundle.main.bundleIdentifier ?? "com.ogeodungs.app"
            let osLog = OSLog(subsystem: subsystem, category: category.categoryName)
            let logger = Logger(osLog)
            loggers[category] = logger
            return logger
        }
    }
    
    private static func log(_ category: LogCategory, _ message: String,
                           function: String = #function,
                           file: String = #file,
                           line: Int = #line) {
        let filename = URL(fileURLWithPath: file).lastPathComponent
        
        getLogger(for: category).log(level: category.logType,
                                   "\(category.decorated) [\(filename):\(line) \(function)] - \(message)")
    }
    
    // 편의 함수들
    public static func ui(_ msg: String, file: String = #file, line: Int = #line, function: String = #function) {
        log(.ui, msg, function: function, file: file, line: line)
    }
    
    public static func error(_ msg: String, file: String = #file, line: Int = #line, function: String = #function) {
        log(.error, msg, function: function, file: file, line: line)
    }
    
    public static func debug(_ msg: String, file: String = #file, line: Int = #line, function: String = #function) {
        log(.debug, msg, function: function, file: file, line: line)
    }
}

public enum LogCategory: String, CaseIterable {
    case ui
    case error
    case debug
    
    /// 실제 Console 에 출력되는 Category 이름
    public var categoryName: String {
        switch self {
        case .ui: return "UI"
        case .error: return "Error"
        case .debug: return "Debug"
        }
    }
    
    /// 가독성용 이모지 + 텍스트
    public var decorated: String {
        switch self {
        case .ui: return "🚀 UI"
        case .error: return "☠️ ERROR"
        case .debug: return "🛠️ DEBUG"
        }
    }
    
    /// OSLogType 매핑
    public var logType: OSLogType {
        switch self {
        case .error: return .error
        case .debug: return .debug
        case .ui:    return .default
        }
    }
}
